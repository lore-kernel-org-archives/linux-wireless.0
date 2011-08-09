Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52307 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab1HIDAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 23:00:13 -0400
Received: by pzk37 with SMTP id 37so9326986pzk.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 20:00:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 9 Aug 2011 11:00:12 +0800
Message-ID: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com> (sfid-20110809_050017_486009_E6D234FE)
Subject: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8 and compat-wireless-2.6.38.2-2
From: Dane Shih <daneshih1981@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi all

i try to setup AR9285 Wireless  ap mode on fedora 12

but it seem not stable when setup Master mode use hostapd
so ...i upgrade kernel to  2.6.38.8
it's better, no more disconnect

but ap mode in 80211n

hostapd.conf

nterface=wlan0
driver=nl80211
ssid=test
hw_mode=g
wme_enabled=1
ieee80211n=1
ht_capab=HT40+
channel=7
auth_algs=3
ignore_broadcast_ssid=0

throughput only 20Mbits

install compat-wireless-2.6.38.2-2 on linux

/etc/modprobe.d/ath9.conf
options ath9k nohwcrypt=1
modprobe -v ath9k
insmod /lib/modules/2.6.38.8/updates/net/wireless/cfg80211.ko
insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath.ko
insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath9k/ath9k_hw.ko
insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath9k/ath9k_common.ko
insmod /lib/modules/2.6.38.8/updates/net/mac80211/mac80211.ko
insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
nohwcrypt=1

i get maxinum speed is 25Mbit
my pc mac acccess another AP maxinum 50Mbit

setup AR9285 Wireless calint maxinum 30Mbit
AR9285 spec is 150Mbits

thanks for any advice
