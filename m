Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1359 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaKPIz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Nov 2014 03:55:27 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] wil6210: atomic I/O for the card memory
Date: Sun, 16 Nov 2014 10:55:18 +0200
Message-ID: <14023293.uyEUzBpN2E@lx-wigig-72> (sfid-20141116_095535_407678_33593F9C)
In-Reply-To: <87fvdlsyen.fsf@kamboji.qca.qualcomm.com>
References: <1412165125-30435-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1412165125-30435-3-git-send-email-qca_vkondrat@qca.qualcomm.com> <87fvdlsyen.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, November 14, 2014 03:29:52 PM Kalle Valo wrote:
> Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:
> 
> > Introduce netdev IOCTLs, to be used by the debug tools.
> >
> > Allows to read/write single dword value or
> > memory block, aligned to dword
> > Different address modes supported:
> > - BAR offset
> > - Firmware "linker" address
> > - target's AHB bus
> >
> > Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> 
> An ioctl interface for a wireless driver? IMHO that would have been ok
> in 2004, but not in 2014. Isn't there really better way to implement
> this?

Functionality implemented through ioctl is hardware access used for
debug/monitoring purposes. I did not found any alternative way to do this.

Any ideas? I need to implement read/write that takes address,
value (for write) and few options like address interpretation flavor
(hardware has several types of addresses)

> 
> > +/* Numbers SIOCDEVPRIVATE and SIOCDEVPRIVATE + 1
> > + * are used by Android devices to implement PNO (preferred network offload).
> > + * Albeit it is temporary solution, use different numbers to avoid conflicts
> > + */
> 
> Comments like this make me even more worried that that this is just yet
> another way to implement wext iwpriv interface.
It just happens wifi drivers used for android, already use these 2 ioctls
for PNO. And, this (PNO) is clearly something that should be done
with nl80211 instead of ioctl.

