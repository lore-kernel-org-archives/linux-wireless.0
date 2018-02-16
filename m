Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38516 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757541AbeBPJGx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 04:06:53 -0500
Received: by mail-wm0-f50.google.com with SMTP id 141so1809040wme.3
        for <linux-wireless@vger.kernel.org>; Fri, 16 Feb 2018 01:06:52 -0800 (PST)
Date: Fri, 16 Feb 2018 10:06:49 +0100
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: make write with mask access atomic
Message-ID: <20180216090648.GA2580@localhost.localdomain> (sfid-20180216_100657_521711_DF7A8D44)
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
 <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
 <20180215151445.52e08b03@cakuba.netronome.com>
 <CAJ0CqmVG4rNO=MSxaNF6s9vS3QueBVv0aFddETPaMpPQsYJh4Q@mail.gmail.com>
 <20180215163533.3c3a6ebb@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180215163533.3c3a6ebb@cakuba.netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 15, Jakub Kicinski wrote:
> On Fri, 16 Feb 2018 01:02:31 +0100, Lorenzo Bianconi wrote:
> > > On Thu, 15 Feb 2018 23:59:24 +0100, Lorenzo Bianconi wrote:  
> > >> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
> > >> to make mt7601u_rmw and mt7601u_rmc atomic since it is possible that
> > >> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved
> > >> with a different write operation on the same register.
> > >> Moreover move write trace point in __mt7601u_vendor_single_wr
> > >>
> > >> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>  
> > >
> > > Could you provide an example of which accesses make it problematic?
> > > Is this fixing an actual bug?  
> > 
> > Hi Jakub,
> > 
> > it is not an issue I had experimented, I noticed a theoretical race
> > reviewing the code.
> > AFAIU, based on the current implementation it is possible that mt7601u_rmw
> > (with mt7601u_rr) loads data from given register but its store access
> > (mt7601u_wr) is
> > preceded by another mt7601u_wr on the same register. In this case the
> > value configured by
> > the first mt7601u_wr executed is overwritten by the second one (the
> > store from mt7601u_rmw)
> > even if the first write is setting a different subfield respect to
> > mt7601u_rmw.
> 
> Hm.. There should be no path in the driver where that could cause
> problems AFAIR.  We have reg_atomic_mutex and hw_atomic_mutex to
> protect from concurrent access to the HW where they are possible.
> RMW operations are non-atomic by definition, it's supposed to work 
> like PCIe register accesses would - 32bit reads/writes are atomic, 
> but RMW is not.

Yes, RMW accesses are non-atomic by default but since vendor_req_mutex mutex
is already there (and grabbed for RMW operations), why not use it to make write
with mask access atomic without adding complexity? Moreover it would be a
micro-optimisation since vendor_req_mutex would be grabbed just once instead of
twice

> 
> So I'm not sure what to do with this patch.  Doesn't seem necessary...

It is just a trivial rework of locking in usb read/write accesses, not
mandatory, so if you prefer we can just drop it

Regards,
Lorenzo
