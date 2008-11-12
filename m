Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nexus.dynaweb.hu ([195.70.37.87]:47134 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYKLV73 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 16:59:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by nexus.dynaweb.hu (Postfix) with ESMTP id E812960597
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 22:48:10 +0100 (CET)
Received: from nexus.dynaweb.hu ([127.0.0.1])
	by localhost (nexus.dynaweb.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ExP-0o+cliBk for <linux-wireless@vger.kernel.org>;
	Wed, 12 Nov 2008 22:48:10 +0100 (CET)
Received: from raketa.ipn.dynaweb.hu (catv-80-98-178-15.catv.broadband.hu [80.98.178.15])
	by nexus.dynaweb.hu (Postfix) with ESMTPSA id 6A62461310
	for <linux-wireless@vger.kernel.org>; Wed, 12 Nov 2008 22:48:10 +0100 (CET)
Date: Wed, 12 Nov 2008 22:48:10 +0100
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: linux-wireless@vger.kernel.org
Subject: ath5k master (AP) mode
Message-Id: <20081112224810.8d4ca179.rumi_ml@rtfm.hu> (sfid-20081112_225933_817506_3D668660)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I've been trying to set an Atheros NIC to AP mode using the ath5k
driver but it fails:

# iwconfig wlan0 mode master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan0 ; Invalid argument.

lspci:

03:03.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC (rev 01)

dmesg (with compat-wireless-2008-11-12):
 
ath5k_pci 0000:03:03.0: PCI INT A disabled
cfg80211: Using static regulatory domain info
cfg80211: Regulatory domain: EU
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2482000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
ath5k_pci 0000:03:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
ath5k_pci 0000:03:03.0: registered as 'phy0'
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR2414 chip found (MAC: 0x79, PHY: 0x45)
__ratelimit: 6 callbacks suppressed
ath5k phy0: gain calibration timeout (2412MHz)
ath5k phy0: can't reset hardware (-11)
ath5k phy0: gain calibration timeout (2412MHz)
ath5k phy0: can't reset hardware (-11)
ath5k phy0: gain calibration timeout (2412MHz)
ath5k phy0: can't reset hardware (-11)
ath5k phy0: gain calibration timeout (2452MHz)
ath5k phy0: can't reset hardware (-11)
ath5k phy0: gain calibration timeout (2452MHz)
ath5k phy0: can't reset hardware (-11)
__ratelimit: 6 callbacks suppressed
ath5k phy0: gain calibration timeout (2452MHz)
ath5k phy0: can't reset hardware (-11)

First I've tried this with the driver version that is included with 2.6.27
but when I saw that it doesn't work I have installed the compat-wireless
tarball from today (2008-11-12) but it still doesn't work.

Is this how it supposed to be (eg. not supported yet) or am I just doing
something wrong?

Thanks,

Sab
