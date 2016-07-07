Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33301 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbcGGQtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 12:49:21 -0400
Received: by mail-yw0-f194.google.com with SMTP id i12so2296020ywa.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2016 09:49:20 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Jul 2016 22:19:00 +0530
Message-ID: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com> (sfid-20160707_184930_134084_E8CE0200)
Subject: ath10k + iw set bitrates is causing FW crash
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am using ath10k driver with qca988x hw2.0 and trying to limit it to use
VHT MCS0-7 (iw set bitrates vht-mcs-5 2:0-7).

But the command it causing a FW crash, if it disable HW_HAS_RATE_CONTROL
no crash is observed but it still uses MCS9.

tree: wireless-drivers-next: commit#535633a5ba4ea2504fa6c33176633becf0e59339

1) If i disable HW_RATE_CONTROL, will ath10k honor
the mac80211 rates?

2) Please find below the dmesg after the crash.

[ 3879.419737] ath10k_pci 0000:01:00.0: device successfully recovered
[ 3941.919995] wlan0: deauthenticating from 74:d0:2b:41:e4:b4 by local
choice (Reason: 3=DEAUTH_LEAVING)
[ 3953.665725] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3955.768675] wlan0: authenticate with 74:d0:2b:41:e4:b4
[ 3955.768688] ieee80211_determine_chantype:306 enter..: cwid:3 vht_cwid:3
[ 3955.776460] wlan0: send auth to 74:d0:2b:41:e4:b4 (try 1/3)
[ 3955.777014] wlan0: authenticated
[ 3955.781060] wlan0: associate with 74:d0:2b:41:e4:b4 (try 1/3)
[ 3955.782124] wlan0: RX AssocResp from 74:d0:2b:41:e4:b4 (capab=0x11
status=0 aid=2)
[ 3955.783147] wlan0: associated
[ 3955.783213] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3959.053601] wlan0: deauthenticating from 74:d0:2b:41:e4:b4 by local
choice (Reason: 3=DEAUTH_LEAVING)
[ 3964.025669] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3967.104520] wlan0: authenticate with 74:d0:2b:41:e4:b4
[ 3967.104533] ieee80211_determine_chantype:306 enter..: cwid:3 vht_cwid:3
[ 3967.112366] wlan0: send auth to 74:d0:2b:41:e4:b4 (try 1/3)
[ 3967.112905] wlan0: authenticated
[ 3967.113166] wlan0: associate with 74:d0:2b:41:e4:b4 (try 1/3)
[ 3967.114248] wlan0: RX AssocResp from 74:d0:2b:41:e4:b4 (capab=0x11
status=0 aid=2)
[ 3967.115327] wlan0: associated
[ 3967.115357] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3976.110218] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
bfab5915-ae19-40b1-be67-544d909779ab)
[ 3976.110226] ath10k_pci 0000:01:00.0: qca988x hw2.0 target
0x4100016c chip_id 0x043222ff sub 0000:0000
[ 3976.110228] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 0 testmode 0
[ 3976.110467] ath10k_pci 0000:01:00.0: firmware ver 10.2.4.70.9-2 api
5 features no-p2p,raw-mode crc32 b8d50af5
[ 3976.110472] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A
crc32 bebc7c08
[ 3976.110475] ath10k_pci 0000:01:00.0: htt-ver 2.1 wmi-op 5 htt-op 2
cal otp max-sta 128 raw 0 hwcrypto 1
[ 3976.112483] ath10k_pci 0000:01:00.0: firmware register dump:
[ 3976.112485] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3
0x009BF931 0x00955B31
[ 3976.112487] ath10k_pci 0000:01:00.0: [04]: 0x009BF931 0x00060530
0x00000010 0xFFFFFFFF
[ 3976.112490] ath10k_pci 0000:01:00.0: [08]: 0x0044D9B8 0x0000C001
0x00000000 0x00000005
[ 3976.112492] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000000
0x00957F04 0x00957F12
[ 3976.112494] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D
0x00000000 0x00000000
[ 3976.112496] ath10k_pci 0000:01:00.0: [20]: 0x409BF931 0x0040AA44
0x00420854 0x00440198
[ 3976.112498] ath10k_pci 0000:01:00.0: [24]: 0x809BF9A1 0x0040AAA4
0x00789518 0xC09BF931
[ 3976.112500] ath10k_pci 0000:01:00.0: [28]: 0x809B837F 0x0040AAC4
0x0044D9B8 0x000005DC
[ 3976.112502] ath10k_pci 0000:01:00.0: [32]: 0x809B8555 0x0040AAE4
0x0044D9A0 0x00000100
[ 3976.112504] ath10k_pci 0000:01:00.0: [36]: 0x809A0DF5 0x0040AB04
0x0043EAA8 0x0040AD14
[ 3976.112506] ath10k_pci 0000:01:00.0: [40]: 0x809896F9 0x0040AB24
0x0043EAA8 0x0040AD14
[ 3976.112508] ath10k_pci 0000:01:00.0: [44]: 0x809B5ACC 0x0040AB44
0x009C575C 0x0043EAA8
[ 3976.112510] ath10k_pci 0000:01:00.0: [48]: 0x809B1C74 0x0040ADA4
0x00400000 0x00416DEC
[ 3976.112512] ath10k_pci 0000:01:00.0: [52]: 0x809BFB39 0x0040ADE4
0x0040AE08 0x00411F80
[ 3976.112514] ath10k_pci 0000:01:00.0: [56]: 0x809486FA 0x0040AE04
0x00000001 0x00000000
[ 3976.195917] ieee80211 phy0: Hardware restart was requested
[ 3977.561878] ath10k_pci 0000:01:00.0: device successfully recovered
[ 8494.632109] ath10k_pci 0000:01:00.0: firmware crashed! (uuid
5b6f2fe0-1a2c-4485-a7d5-64705ca051a2)
[ 8494.632116] ath10k_pci 0000:01:00.0: qca988x hw2.0 target
0x4100016c chip_id 0x043222ff sub 0000:0000
[ 8494.632119] ath10k_pci 0000:01:00.0: kconfig debug 1 debugfs 1
tracing 1 dfs 0 testmode 0
[ 8494.632357] ath10k_pci 0000:01:00.0: firmware ver 10.2.4.70.9-2 api
5 features no-p2p,raw-mode crc32 b8d50af5
[ 8494.632362] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A
crc32 bebc7c08
[ 8494.632364] ath10k_pci 0000:01:00.0: htt-ver 2.1 wmi-op 5 htt-op 2
cal otp max-sta 128 raw 0 hwcrypto 1
[ 8494.634373] ath10k_pci 0000:01:00.0: firmware register dump:
[ 8494.634376] ath10k_pci 0000:01:00.0: [00]: 0x4100016C 0x000015B3
0x009BF931 0x00955B31
[ 8494.634378] ath10k_pci 0000:01:00.0: [04]: 0x009BF931 0x00060530
0x00000010 0xFFFFFFFF
[ 8494.634380] ath10k_pci 0000:01:00.0: [08]: 0x0044D9B8 0x0000C001
0x00000000 0x00000005
[ 8494.634382] ath10k_pci 0000:01:00.0: [12]: 0x00000009 0x00000000
0x00957F04 0x00957F12
[ 8494.634384] ath10k_pci 0000:01:00.0: [16]: 0x00958080 0x0094085D
0x00000000 0x00000000
[ 8494.634386] ath10k_pci 0000:01:00.0: [20]: 0x409BF931 0x0040AA44
0x00420854 0x00440198
[ 8494.634388] ath10k_pci 0000:01:00.0: [24]: 0x809BF9A1 0x0040AAA4
0x00789518 0xC09BF931
[ 8494.634390] ath10k_pci 0000:01:00.0: [28]: 0x809B837F 0x0040AAC4
0x0044D9B8 0x000005DC
[ 8494.634392] ath10k_pci 0000:01:00.0: [32]: 0x809B8555 0x0040AAE4
0x0044D9A0 0x00000100
[ 8494.634394] ath10k_pci 0000:01:00.0: [36]: 0x809A0DF5 0x0040AB04
0x0043EAA8 0x0040AD14
[ 8494.634396] ath10k_pci 0000:01:00.0: [40]: 0x809896F9 0x0040AB24
0x0043EAA8 0x0040AD14
[ 8494.634398] ath10k_pci 0000:01:00.0: [44]: 0x809B5ACC 0x0040AB44
0x009C575C 0x0043EAA8
[ 8494.634400] ath10k_pci 0000:01:00.0: [48]: 0x809B1C74 0x0040ADA4
0x00400000 0x00416E0C
[ 8494.634402] ath10k_pci 0000:01:00.0: [52]: 0x809BFB39 0x0040ADE4
0x0040AE08 0x00411F80
[ 8494.634404] ath10k_pci 0000:01:00.0: [56]: 0x809486FA 0x0040AE04
0x00000001 0x00000000
[ 8494.724659] ieee80211 phy0: Hardware restart was requested
[ 8496.090883] ath10k_pci 0000:01:00.0: device successfully recovered



-- 
Thanks,
Regards,
Chaitanya T K.
