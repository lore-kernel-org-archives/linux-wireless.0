Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42178 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab0HGPwD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Aug 2010 11:52:03 -0400
Received: by iwn33 with SMTP id 33so2306545iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Aug 2010 08:52:02 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 7 Aug 2010 17:52:02 +0200
Message-ID: <AANLkTim4ccC7pQrW0LymdZ_cAiaBhLW3VofsFj9CcpfP@mail.gmail.com>
Subject: ath9k: association lost on ap side only
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm trying out compat-wireless-2010-07-29 with openwrt/trunk@22474
patches on AR913x and quite often (a few times a day) run into a
problem where my laptop thinks it's associated but the router thinks
it's not.

Basically, on the laptop side I am still associated but on the access
point iw says there are no stas:

root@OpenWrt:/sys/kernel/debug/ieee80211/phy0# iw dev wlan0 station dump
root@OpenWrt:/sys/kernel/debug/ieee80211/phy0#

The log looks like this:

Aug  7 14:53:24 OpenWrt daemon.info dnsmasq-dhcp[1601]:
DHCPREQUEST(br-lan) 192.168.1.241 00:17:f2:51:b2:2d
Aug  7 14:53:24 OpenWrt daemon.info dnsmasq-dhcp[1601]:
DHCPACK(br-lan) 192.168.1.241 00:17:f2:51:b2:2d
Aug  7 14:56:19 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: group key handshake completed (RSN)
Aug  7 14:56:19 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: received EAPOL-Key 2/2 Group with unexpected
replay counter
Aug  7 15:06:19 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: group key handshake completed (RSN)
Aug  7 15:06:19 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: received EAPOL-Key 2/2 Group with unexpected
replay counter
Aug  7 15:16:20 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: group key handshake completed (RSN)
Aug  7 15:16:20 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: received EAPOL-Key 2/2 Group with unexpected
replay counter
Aug  7 15:16:20 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d WPA: received EAPOL-Key 2/2 Group with unexpected
replay counter
Aug  7 15:26:22 OpenWrt daemon.info hostapd: wlan0: STA
00:17:f2:51:b2:2d IEEE 802.11: deauthenticated due to local deauth
request
Aug  7 15:30:14 OpenWrt user.debug kernel: ath: DMA failed to stop in
10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020
Aug  7 15:30:14 OpenWrt user.debug kernel: ath: DMA failed to stop in
10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020

Those "unexpected replay counters" messages are quite common. What can
cause these? A lost ack and retransmission?

Apart from that I guess there are two questions here: (1) why was the
association lost on the ap side? and (2) why is there no indication
from the router that it does not expect data frames in this state?

/Björn
