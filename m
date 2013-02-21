Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:53560 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224Ab3BUAA5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 19:00:57 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 Feb 2013 16:00:15 -0800
Subject: RE: mwifiex crash when removing interface while scanning
Message-ID: <477F20668A386D41ADCC57781B1F70430D9D6CE95B@SC-VEXCH1.marvell.com> (sfid-20130221_010103_504431_99B0464D)
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
 <CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
In-Reply-To: <CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> >> >     mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
> >> >     eth0      Failed to read scan data : No such device
> >
> > After this error message, do you see the sd8787 card is removed from the bus?
> >
> > "mmc0: card 0001 removed"
> 
> No.

That's strange.
"mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1" is from 
mwifiex_remove_card().

> 
> > My card works fine with a Ricoh controller on x86_64 machine. Of course the power is not cut when I
> remove the mwifiex_sdio module.
> 
> Under this kernel, I'm not sure if the power is or isn't being cut at
> this point. I don't think this is relevant though; regular

"we quite regularly will power down the wireless card when it is not
being actively used..."

I interpreted this statement as "the power to the card is being cut while inactive".
mwifiex_remove_card() is called seems agrees with it. Perhaps I'm missing something here.

> insmod/rmmod cycles work fine, the problem only appears when tearing
> down the interface while a scan is in progress.

Could you add some debug logs in the tear-down path to show where exactly it gets stuck?

> 
> > I can upgrade my XO-4 to kernel 3.8 if feasible. Please let me know if a HOW-TO doc is available.
> 
> You will need a serial console connected, as there is no output on the
> LCD at this time when running the upstream kernel.
> 
> http://wiki.laptop.org/go/User:DanielDrake/Run_upstream_kernel_on_XO-4

Will do.

Thanks,
Bing

> 
> Daniel
