Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:51957 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496AbYBDQJc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 11:09:32 -0500
Received: by nf-out-0910.google.com with SMTP id g13so350506nfb.21
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 08:09:31 -0800 (PST)
To: Adam Turk <bofh1234@hotmail.com>
Subject: Re: rt73 driver doesn't work in 2.6.24
Date: Mon, 4 Feb 2008 17:09:00 +0100
Cc: linux-wireless@vger.kernel.org
References: <BAY101-W12F4D19DA27A5DA9F177E1C8310@phx.gbl> <200802021536.50534.IvDoorn@gmail.com> <BAY101-W312BC257905062044A782AC8330@phx.gbl>
In-Reply-To: <BAY101-W312BC257905062044A782AC8330@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200802041709.00950.IvDoorn@gmail.com> (sfid-20080204_160938_163553_4FB8AA41)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> phy0: Failed to initialize wep
> phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
> rt73usb: probe of 1-1:1.0 failed with error -12
> usbcore: registered new interface driver rt73usb
> 
> Despite the statement about registering the new interface driver rt73usb, the interface is not created.  Can someone please tell me what is wrong and get a fix into 2.6.24.1?

This is a mac80211 bug and not a rt73usb bug.
Apparatently the crypto_alloc_blkcipher("ecb(arc4)") call is failing,
more then that I have no idea what can cause this.
Any mac80211 developer with more information?

Ivo
