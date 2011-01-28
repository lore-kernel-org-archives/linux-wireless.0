Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout02.t-online.de ([194.25.134.17]:32771 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1A1NTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 08:19:47 -0500
Message-ID: <4D42C27A.70509@t-online.de>
Date: Fri, 28 Jan 2011 14:19:54 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k: scanning kills unicast
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I receive data with the highest possible speed in my 802.11g 
network and simultaneously scan for available networks (NetworkManager 
does this all the time in the background) ath9k enters a strange state: 
unicast data transfer is stalled, but broadcast is still working. This 
state lasts for a while. Then it ends after deauthentication (Reason: 6) 
and reauthentication. ATH_DEBUG_FATAL logs nothing.


$ lspci -nn|grep Atheros
05:00.0 Network controller [0280]: Atheros Communications Inc. AR9285 
Wireless Network Adapter (PCI-Express) [168c:002b] (rev 01)

$ dmesg|grep -i ath
ath9k 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ath9k 0000:05:00.0: setting latency timer to 64
ath: EEPROM regdomain: 0x65
ath: EEPROM indicates we should expect a direct regpair map
ath: Country alpha2 being used: 00
ath: Regpair used: 0x65
ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc90012260000, irq=16

$ uname -r
2.6.37-ARCH
