Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:46331 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027Ab2ADIkj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 03:40:39 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RiMOj-0004Dl-Dq
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 09:40:37 +0100
Received: from localhost ([::1]:38888 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RiMOj-0007XM-A9
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 09:40:37 +0100
Received: from [195.4.92.10] (port=51527 helo=0.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RiMML-0006kO-4p
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 09:38:09 +0100
Received: from p4fde00d8.dip0.t-ipconnect.de ([79.222.0.216]:57267 helo=mail.maya.org)
	by 0.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RiMMK-0006wS-ON
	for linux-wireless@vger.kernel.org; Wed, 04 Jan 2012 09:38:09 +0100
Message-ID: <4F040FEA.3080703@01019freenet.de> (sfid-20120104_094043_310700_DB6A3C02)
Date: Wed, 04 Jan 2012 09:38:02 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
References: <4EFF12D9.3010602@01019freenet.de> <4EFF71F8.6070208@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site>
In-Reply-To: <2766356.70ylY68Gqi@helmutmobil.site>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

happy new year for you, too!

Helmut Schaa schrieb:
> Hi Andreas,
> 
> Am Samstag, 31. Dezember 2011, 21:35:04 schrieb Andreas Hartmann:
>> Andreas Hartmann schrieb:
>>> Hello,
>>>
>>> I tested compat-wireless-3.2-rc6-3 with kernel 3.1 and a rt2860 device
>>> running in AP mode (80211.n - 40 MHz). During
>>>
>>> netperf -t TCP_STREAM -H ap
>>>
>>> the data stream mostly stalls (-> the device receives data) after a few
>>> seconds and never comes up any more. The connection is completely death.
>>> I have to restart wpa_supplicant to get it working again.
>>>
>>>
>>>
>>> I tried to isolate the problem the following way:
>>>
>>> 1. Running compat-wireless-3.2-rc6-3 with the rt2x00 level from
>>> compat-wireless-3.1.1-1. The problem didn't gone.
>>>
>>> 2. Running compat-wireless-3.1.1-1 with the rt2x00 based changes in
>>> compat-wireless-3.2-rc6-3. I can't see the problem any more.
>>>
>>>
>>> That's why I think, that the problem must be outside the rt2x00 changes.
>>> But there are many changes outside :-).
>>
>>
>> Removing this patch
>>
>> mac80211: retry sending failed BAR frames later instead of tearing down
>> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
>> it working again.
>>
>> Device is: RaLink RT2800 802.11n PCI
> 
> What's the client device connected to the rt2x00 AP?

It's a rt3572 usb chip (Linksys WUSB600N v2), driven with the rt3572sta
module.

> Mind to send a
> 802.11 capture wen this stall happens?

I would try to scan the traffic with a third device in monitor mode
(airmon-ng). But: 802.11n uses more than one channel. How can I get
them? airmon-ng can't be told to listen to more than one channel at a
time (or better: I probably don't know how to do it :-)).

Do you have an idea, how to completely trace 802.11n?


Thanks,
Andreas
