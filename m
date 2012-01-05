Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:47428 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179Ab2AEIqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 03:46:37 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout6.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Riiy3-0005rD-FT
	for linux-wireless@vger.kernel.org; Thu, 05 Jan 2012 09:46:35 +0100
Received: from localhost ([::1]:34676 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Riiy3-00020p-Bt
	for linux-wireless@vger.kernel.org; Thu, 05 Jan 2012 09:46:35 +0100
Received: from [195.4.92.12] (port=60321 helo=2.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Riivu-0000xH-OK
	for linux-wireless@vger.kernel.org; Thu, 05 Jan 2012 09:44:22 +0100
Received: from p4fde162a.dip0.t-ipconnect.de ([79.222.22.42]:36443 helo=mail.maya.org)
	by 2.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Riivu-000321-BO
	for linux-wireless@vger.kernel.org; Thu, 05 Jan 2012 09:44:22 +0100
Message-ID: <4F0562DF.3000200@dualc.maya.org> (sfid-20120105_094641_302801_8BBDE105)
Date: Thu, 05 Jan 2012 09:44:15 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de> <1408490.qSFZVkU7fA@helmutmobil.site>
In-Reply-To: <1408490.qSFZVkU7fA@helmutmobil.site>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> Hi,
> 
> Am Mittwoch, 4. Januar 2012, 09:38:02 schrieb Andreas Hartmann:
>> Helmut Schaa schrieb:
>>>> Removing this patch
>>>>
>>>> mac80211: retry sending failed BAR frames later instead of tearing down
>>>> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
>>>> it working again.
>>>>
>>>> Device is: RaLink RT2800 802.11n PCI
>>>
>>> What's the client device connected to the rt2x00 AP?
>>
>> It's a rt3572 usb chip (Linksys WUSB600N v2), driven with the rt3572sta
>> module.
>>
>>> Mind to send a
>>> 802.11 capture wen this stall happens?
> 
> Andreas provided me with a capture now. The interesting part is that
> the rt2x00 AP sends bursts of BARs with the same sequence number when
> the stall happens. I only had a quick look at the code in question but
> couldn't see anything wrong at a first glance.


Some additional information:

- The AP initiates BARs for 6 different, successive sequence numbers.
- The first 5 sequence numbers are finished after sending of about 8 (!)
BAR's.
Important: each BAR is responded *instantly* by the STA.
- The BAR for the next sequence number is sent "endless" though the STA
responses to each BAR instantly again.


Another thing: it is striking, that the performance from STA -> AP is at
max 8,5 MBit/s, whereas the performance from AP -> STA can be 15 MBit/s
(all measured with netperf).


Could it be, that somewhere in the stack of the AP the response packet
from STA -> AP get's lost or ignored or blocked?



Kind regards,
Andreas
