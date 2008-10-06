Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:50363 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbYJFNBN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:01:13 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223296783.15196.13.camel@johannes.berg>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
	 <1223296592.11272.163.camel@violet.holtmann.net>
	 <1223296783.15196.13.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 06 Oct 2008 15:01:30 +0200
Message-Id: <1223298090.11272.167.camel@violet.holtmann.net> (sfid-20081006_150119_794981_847911AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > I take this back. It took a couple of hours, but it crashed again.
> > > 
> > > Do you have 64k pages enabled? My issue goes away entirely when I
> > > disable 64k pages.
> > 
> > so the initial issue was a BUG_ON when the ucode reports back an
> > unsupported event. That should have been fixed by now since we just
> > can't crash the whole kernel, because some piece of firmware acts bogus
> > now and then. 
> 
> I have a different interpretation of the original issue, since afaik the
> value it was doing a BUG_ON on is a value that is only passed in by the
> driver and copied by the ucode to the response, hence it shouldn't
> actually crash unless the driver is passing bogus stuff in or, as it
> seems to be the case here, the DMA programming is completely fucked and
> the ucode just goes to write to random memory locations.

that patch wasn't enough, but neverless we shouldn't crash the whole
kernel based on this.

In addition they were working on some IOMMU stuff and that explains what
you are seeing. I never got that far at all. My machine just dies on me.

> > However there seems to be some other issues with me
> > running a 64-bit OS and connecting to an N-capable access point.
> 
> Strange. My test AP isn't N capable though.

We had some discussion about the fact the different firmware versions
might be causing this. Don't have my X61 handy at the moment.

Regards

Marcel


