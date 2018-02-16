Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.11]:39738 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbeBPVIV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 16:08:21 -0500
Date: Fri, 16 Feb 2018 13:08:10 -0800
From: Jakub Kicinski <kubakici@wp.pl>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt7601u: make write with mask access atomic
Message-ID: <20180216130810.7f40da40@cakuba.netronome.com> (sfid-20180216_220849_815271_0D24AA10)
In-Reply-To: <20180216090648.GA2580@localhost.localdomain>
References: <cover.1518734856.git.lorenzo.bianconi@redhat.com>
        <5bb3bb069bdd4663b69b60b782432c2faddc1efc.1518734856.git.lorenzo.bianconi@redhat.com>
        <20180215151445.52e08b03@cakuba.netronome.com>
        <CAJ0CqmVG4rNO=MSxaNF6s9vS3QueBVv0aFddETPaMpPQsYJh4Q@mail.gmail.com>
        <20180215163533.3c3a6ebb@cakuba.netronome.com>
        <20180216090648.GA2580@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2018 10:06:49 +0100, Lorenzo Bianconi wrote:
> > Hm.. There should be no path in the driver where that could cause
> > problems AFAIR.  We have reg_atomic_mutex and hw_atomic_mutex to
> > protect from concurrent access to the HW where they are possible.
> > RMW operations are non-atomic by definition, it's supposed to work 
> > like PCIe register accesses would - 32bit reads/writes are atomic, 
> > but RMW is not.  
> 
> Yes, RMW accesses are non-atomic by default but since vendor_req_mutex mutex
> is already there (and grabbed for RMW operations), why not use it to make write
> with mask access atomic without adding complexity? Moreover it would be a
> micro-optimisation since vendor_req_mutex would be grabbed just once instead of
> twice
> 
> > 
> > So I'm not sure what to do with this patch.  Doesn't seem necessary...  
> 
> It is just a trivial rework of locking in usb read/write accesses, not
> mandatory, so if you prefer we can just drop it

You make good points :)  Could you please respin stating clearly in the
commit message that this is not a bug fix, but a micro-optimization and
may be useful in the future?
