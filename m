Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:35595 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbFKJfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 05:35:40 -0400
Received: by igbzc4 with SMTP id zc4so52534084igb.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 02:35:39 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 11 Jun 2015 11:35:39 +0200
Message-ID: <CACna6rwHXzGTZ+NS9PpZENJATVzRzm1Wkija0_CrveMoM05d5g@mail.gmail.com> (sfid-20150611_113544_857208_070F0480)
Subject: Exposing enum ieee80211_channel_flags to user
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Recently I spent quite some time trying to figure out why hostapd
can't start 80 MHz AP for me with following error:
radio1 (1617): nl80211: Failed to set channel (freq=5180): -22
(Invalid argument)

My config included:
hw_mode=a
channel=36
vht_oper_chwidth=1
vht_oper_centr_freq_seg0_idx=42

I added some debugging to hostapd but it didn't help much:
radio1 (1617): Allowed channel: mode=2 chan=36 freq=5180 MHz max_tx_power=20 dBm
radio1 (1617): Allowed channel: mode=2 chan=40 freq=5200 MHz max_tx_power=20 dBm
radio1 (1617): Allowed channel: mode=2 chan=44 freq=5220 MHz max_tx_power=20 dBm
radio1 (1617): Allowed channel: mode=2 chan=48 freq=5240 MHz max_tx_power=20 dBm
radio1 (1617): hw vht capab: 0x20, conf vht capab: 0x20
radio1 (1617): Completing interface initialization
radio1 (1617): Mode: IEEE 802.11a  Channel: 36  Frequency: 5180 MHz
radio1 (1617): nl80211: Set freq 5180 (ht_enabled=1, vht_enabled=1,
bandwidth=80 MHz, cf1=5210 MHz, cf2=0 MHz)
radio1 (1617):   * freq=5180
radio1 (1617):   * vht_enabled=1
radio1 (1617):   * ht_enabled=1
radio1 (1617):   * bandwidth=80
radio1 (1617):   * channel_width=3
radio1 (1617):   * center_freq1=5210
radio1 (1617):   * center_freq2=0
radio1 (1617): nl80211: Failed to set channel (freq=5180): -22
(Invalid argument)

iw also wasn't helpful:
Frequencies:
        * 5180 MHz [36] (30.0 dBm)
        * 5200 MHz [40] (30.0 dBm)
        * 5220 MHz [44] (30.0 dBm)
        * 5240 MHz [48] (30.0 dBm)

After some in-kernel debugging (nl80211_set_wiphy,
cfg80211_chandef_usable, cfg80211_secondary_chans_ok) I finally
realized it was because of:
IEEE80211_CHAN_NO_80MHZ

Do you have any idea how we could handle such cases nicely? To let
user find out what's going on (wrong)?

Should "iw" be extended to print flag names? Or should hostapd check
for channels in some smarter way? Any other ideas?

-- 
Rafał
