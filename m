Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:55895 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023AbYHISL4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2008 14:11:56 -0400
Message-ID: <489DDDEA.2030604@lwfinger.net> (sfid-20080809_201212_606813_4E588D9D)
Date: Sat, 09 Aug 2008 13:11:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808082038.48840.chunkeey@web.de> <489DBFA9.80608@lwfinger.net> <200808091843.41985.chunkeey@web.de>
In-Reply-To: <200808091843.41985.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> hmm? there are lots of new & old firmwares. 
> what chip do you have? a ISL3886 + net2280 or a ISL3887?
> you can get the firmware version from dmesg, just load the
> driver and grep for "p54: FW rev"
> 
> my devices: 
> isl3880 minipci: 2.7.0.0 (best supported) & 2.13.1.0 (unstable)
> isl3887 usb: 2.5.8.0(bugs), 2.6.16.0(DELL bugs) and 2.13.2.0 (WIP) 
>

 From dmesg:

firmware: requesting isl3887usb_bare
p54: LM86 firmware
p54: FW rev 2.5.8.0 - Softmac protocol 3.0

I think this shows that I have an ISL3887. As further confirmation, it 
uses routine p54u_tx_3887() to transmit.  Are the bugs in 2.5.8.0 and 
2.6.16.0 described on the Web? My device is a Dell DW1450.

The 2-3 hour disconnect is still present with the sequence number 
patch reverted and the MTU at 1300. Still testing.

Larry

