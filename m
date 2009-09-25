Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jupiter.gibraltar.at ([80.120.3.98]:43579 "EHLO
	mail1.gibraltar.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbZIYTCD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 15:02:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.gibraltar.at (Postfix) with ESMTP id EEAEF92605
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 20:54:27 +0200 (CEST)
Received: from mail1.gibraltar.at ([127.0.0.1])
	by localhost (mail1.int.gibraltar.at [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4CMeQ9ZIiHGd for <linux-wireless@vger.kernel.org>;
	Fri, 25 Sep 2009 20:54:21 +0200 (CEST)
Received: from earth.localnet (85-127-164-247.dynamic.xdsl-line.inode.at [85.127.164.247])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail1.gibraltar.at (Postfix) with ESMTPSA
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 20:54:21 +0200 (CEST)
From: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>
To: linux-wireless@vger.kernel.org
Subject: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
Date: Fri, 25 Sep 2009 20:54:19 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909252054.19762.rene.mayrhofer@gibraltar.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everybody,

[Please CC me in replies, I am currently not subscribed to this list.]

For quite a few weeks, I have now been trying to get an AR9280 mini-PCI card 
to run as an access point, both in 802.11g and 802.11n mode. 

In 802.11g mode, it seems to work for some time with multiple clients, but 
then generally drops most packets (estimated >90%) after a period of a few 
hours of usage. Restarting the device makes it work again.

In 802.11n mode, one client (Asus eeePC 1000 with Atheros 802.11agn chipset) 
initially gets a fairly stable connection (with massive packet loss after some 
period of usage), while another client (Dell Latitude XT with Broadcom 
802.11ag chipset) only manages to connect with an absymal transfer rate (<2 
MBit/s).

This behaviour seems to be mostly independent from WPA and encryption settings 
(with the unencrypted connection being sometimes slower than the WPA2/AES 
secured one), and does not change much with driver versions. My default driver 
is the one included in the upstream 2.6.30.5/.7 kernel, but I have also tried 
compat-wireless-2.6 in multiple versions, including 2009-09-25.

The hardware is detected as:

[   25.714849] cfg80211: Calling CRDA for country: US
[   27.233246] geode-aes: GEODE AES engine enabled.
[   27.510611] AMD Geode RNG detected
[   29.955007] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   29.957464] cfg80211: Calling CRDA for country: US
[   29.965266] Registered led device: ath9k-phy0::radio
[   29.965407] Registered led device: ath9k-phy0::assoc
[   29.965540] Registered led device: ath9k-phy0::tx
[   29.965693] Registered led device: ath9k-phy0::rx
[   29.965744] phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: 
mem=0xd0b60000, irq=9

and sits in a mini-PCI slow on an Alix2d13 boards.

hostapd is version v0.6.9 from Debian testing and configured with these 
relevant options:

interface=wlan0
country_code=AT
hw_mode=g
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40]
channel=6
wpa=3
wpa_passphrase=<long string>
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
driver=nl80211
wme_enabled=1
wme_ac_bk_cwmin=4
wme_ac_bk_cwmax=10
wme_ac_bk_aifs=7
wme_ac_bk_txop_limit=0
wme_ac_bk_acm=0
wme_ac_be_aifs=3
wme_ac_be_cwmin=4
wme_ac_be_cwmax=10
wme_ac_be_txop_limit=0
wme_ac_be_acm=0
wme_ac_vi_aifs=2
wme_ac_vi_cwmin=3
wme_ac_vi_cwmax=4
wme_ac_vi_txop_limit=94
wme_ac_vi_acm=0
wme_ac_vo_aifs=2
wme_ac_vo_cwmin=2
wme_ac_vo_cwmax=3
wme_ac_vo_txop_limit=47
wme_ac_vo_acm=0

The WME settings were taken from the OpenWRT forum and indeed improved 
stability and throughput, although I can not currently quantify the 
improvement.

Unfortunately, I seem to have more questions than answers:

1. Could this be an instance of the issue with massive packet loss that has 
been documented previously with ath9k? Is this a known problem with AR9280? 
Are there any patches floating around that are not yet in compat-wireless and 
that I could try?

2. Is there anything to be done about the Broadcom client, and why is it much 
more unstable than the Atheros one?

3. Why does the ath9k driver in AP mode fail to work after a few hours and 
needs a restart?

4. How do I tell CRDA to load frequency definitions for my location (AT) 
instead of the default (US)? I might be blind, stupid, or both, but using the 
slightly conflicting documentation available on various Wikis, I was unable to 
change this. I have read that some chipsets are hard-wired for one location 
and can't be changed, but couldn't find out if mine is (it was bought in 
Europe, so shouldn't be locked to US in any case). An RTFM (with an up-to-date 
pointer, preferrably for Debian/Ubuntu) in this matter would be highly 
appreciated.

5. After having set the correct location, is hw_mode=a and channel=40 actually 
supposed to work? I have not, so far, managed to get this device into 802.11an 
mode (which might be down to locked frequencies).

Any hints, pointers, or - even better - patches are very welcome ;-)

best regards,
Rene
