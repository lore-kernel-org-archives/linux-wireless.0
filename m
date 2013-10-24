Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56761 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754381Ab3JXJlR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 05:41:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1VZHPo-0004lQ-Ic
	for linux-wireless@vger.kernel.org; Thu, 24 Oct 2013 11:41:16 +0200
Received: from mail.ga.ru ([195.151.127.209])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 11:41:16 +0200
Received: from rezobezandron by mail.ga.ru with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 24 Oct 2013 11:41:16 +0200
To: linux-wireless@vger.kernel.org
From: Andrey <rezobezandron@gmail.com>
Subject: Corega WLUSB2GTST USB adapter + p54usb driver
Date: Thu, 24 Oct 2013 09:40:57 +0000 (UTC)
Message-ID: <loom.20131024T112353-881@post.gmane.org> (sfid-20131024_114121_007908_5DC23483)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This post is for people, who tried to launch Corega WLUSB2GTST USB adapter
without success. In order to get it working you should recompile p54usb.c
module with adding to source code product vendor id 07aa:0020.
Then just do modprobe prism54usb, and you'll get something like this

[ 1239.859554] usb 1-2: new full-speed USB device number 4 using ohci_hcd
[ 1240.364465] usb 1-2: New USB device found, idVendor=07aa, idProduct=0020
[ 1240.365459] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[ 1241.157609] cfg80211: Calling CRDA to update world regulatory domain
[ 1241.636004] cfg80211: World regulatory domain updated:
[ 1241.638846] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1241.639005] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[ 1241.639011] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[ 1241.639562] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300
mBi, 2000 mBm)
[ 1241.639724] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[ 1241.639730] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300
mBi, 2000 mBm)
[ 1241.984610] usb 1-2: reset full-speed USB device number 4 using ohci_hcd
[ 1242.669750] usb 1-2: firmware: agent loaded isl3887usb into memory
[ 1242.669818] ieee80211 phy0: p54 detected a LM87 firmware
[ 1242.669822] p54: rx_mtu reduced from 3240 to 2384
[ 1242.669827] ieee80211 phy0: FW rev 2.13.25.0 - Softmac protocol 5.9
[ 1242.669832] ieee80211 phy0: cryptographic accelerator WEP:YES, TKIP:YES,
CCMP:YES
[ 1243.920119] ieee80211 phy0: hwaddr 00:0a:79:6a:90:87, MAC:isl3887 RF:Frisbee
[ 1244.201927] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[ 1244.204008] Registered led device: p54-phy0::assoc
[ 1244.206429] Registered led device: p54-phy0::tx
[ 1244.206535] Registered led device: p54-phy0::rx
[ 1244.206855] Registered led device: p54-phy0::radio
[ 1244.207523] usb 1-2: is registered as 'phy0'





