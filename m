Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:41542 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbZFPVkW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 17:40:22 -0400
Received: from localhost (filter1.syneticon.net [192.168.113.83])
	by mx03.syneticon.net (Postfix) with ESMTP id B8BDB3607B
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 23:40:12 +0200 (CEST)
Received: from mx03.syneticon.net ([192.168.113.84])
	by localhost (mx03.syneticon.net [192.168.113.83]) (amavisd-new, port 10025)
	with ESMTP id TNamY3Duoa-G for <linux-wireless@vger.kernel.org>;
	Tue, 16 Jun 2009 23:40:10 +0200 (CEST)
Received: from [192.168.10.145] (koln-4db418c1.pool.einsundeins.de [77.180.24.193])
	by mx03.syneticon.net (Postfix) with ESMTPSA
	for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 23:40:10 +0200 (CEST)
Message-ID: <4A381159.70301@wpkg.org>
Date: Tue, 16 Jun 2009 23:40:41 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k AP support?
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to http://linuxwireless.org/en/users/Drivers/ath5k, AP mode is 
"reported to work, we just need some further tests on all cards to be sure".

I just tried it with 2.6.30 kernel with this card:

00:02.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 
Multiprotocol MAC/baseband processor (rev 01)

And it doesn't work:

1245188059.756414: Configuration file: /etc/hostapd/hostapd-wlan0.conf
1245188059.766698: nl80211: Add own interface ifindex 6
1245188059.768470: nl80211: Add own interface ifindex 5
1245188059.770822: nl80211: Failed to set interface 5 to mode 3: -122 
(Operation not supported)
1245188059.772627: nl80211: Failed to set interface wlan1 into AP mode
1245188059.774811: nl80211 driver initialization failed.
1245188059.776564: wlan1: Unable to setup interface.
1245188059.778342: Flushing old station entries
1245188059.780055: Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=3 eloop_data=0x47b860 user_data=0x47bda0 
handler=0x43929c


Is there anything more needed for ath5k to work (some external patches, 
git tree etc.)?

I tested it on ASUS WL-500gP (BCM47XX mips platform).

-- 
Tomasz Chmielewski
http://wpkg.org
