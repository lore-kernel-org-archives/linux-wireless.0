Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:53547 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752984AbeBPAfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 19:35:41 -0500
Date: Thu, 15 Feb 2018 16:35:33 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: make write with mask access atomic
Message-ID: <20180215163533.3c3a6ebb@cakuba.netronome.com> (sfid-20180216_013552_543169_C012ACEF)
In-Reply-To: <CAJ0CqmVG4rNO=MSxaNF6s9vS3QueBVv0aFddETPaMpPQsYJh4Q@mail.gmail.com>
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
        <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
        <20180215151445.52e08b03@cakuba.netronome.com>
        <CAJ0CqmVG4rNO=MSxaNF6s9vS3QueBVv0aFddETPaMpPQsYJh4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2018 01:02:31 +0100, Lorenzo Bianconi wrote:
> > On Thu, 15 Feb 2018 23:59:24 +0100, Lorenzo Bianconi wrote:  
> >> Introduce __mt7601u_rr and __mt7601u_vendor_single_wr routines in order
> >> to make mt7601u_rmw and mt7601u_rmc atomic since it is possible that
> >> read and write accesses of mt7601u_rmw/mt7601u_rmc can be interleaved
> >> with a different write operation on the same register.
> >> Moreover move write trace point in __mt7601u_vendor_single_wr
> >>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>  
> >
> > Could you provide an example of which accesses make it problematic?
> > Is this fixing an actual bug?  
> 
> Hi Jakub,
> 
> it is not an issue I had experimented, I noticed a theoretical race
> reviewing the code.
> AFAIU, based on the current implementation it is possible that mt7601u_rmw
> (with mt7601u_rr) loads data from given register but its store access
> (mt7601u_wr) is
> preceded by another mt7601u_wr on the same register. In this case the
> value configured by
> the first mt7601u_wr executed is overwritten by the second one (the
> store from mt7601u_rmw)
> even if the first write is setting a different subfield respect to
> mt7601u_rmw.

Hm.. There should be no path in the driver where that could cause
problems AFAIR.  We have reg_atomic_mutex and hw_atomic_mutex to
protect from concurrent access to the HW where they are possible.
RMW operations are non-atomic by definition, it's supposed to work 
like PCIe register accesses would - 32bit reads/writes are atomic, 
but RMW is not.

So I'm not sure what to do with this patch.  Doesn't seem necessary...
