Return-Path: <SRS0=XxQ9=OE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78EFBC43441
	for <linux-wireless@archiver.kernel.org>; Sun, 25 Nov 2018 13:14:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F4C720868
	for <linux-wireless@archiver.kernel.org>; Sun, 25 Nov 2018 13:14:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F4C720868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=i2se.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbeKZAFV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 25 Nov 2018 19:05:21 -0500
Received: from mout.kundenserver.de ([212.227.126.187]:40811 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbeKZAFV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Nov 2018 19:05:21 -0500
Received: from oxbaltgw01.schlund.de ([172.19.246.7]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MIbzB-1gF4Ok0LSP-00Ehna; Sun, 25 Nov 2018 14:14:11 +0100
Date:   Sun, 25 Nov 2018 14:14:10 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Message-ID: <355192050.233466.1543151650720@email.ionos.de>
In-Reply-To: <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
References: <142675996.139583.1543082320719@email.ionos.de>
 <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
Subject: Re: brcmfmac: regression using AP mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev46
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:uJuKa/oN9+4ZAN1/iqgQQPO6nYKeKfuKClS88zn7p5Niv8Gg49i
 PdduBeMeRLW2XIKMKatXRsTlkewHkt+tvhN2taroieFWsBBsliB7l7Qcyyc0dQAbs3+rY7i
 oSHLX8xMOBa3fIYzRWfJTUb7K/HeYnNcSbdNvyv/L5nSzbEr/1+G4HUr/NGj2RcWnPi/jwa
 VOKgmgQDl0sWx2iA/6h7w==
X-UI-Out-Filterresults: notjunk:1;V03:K0:shIBQqA3zbA=:OaClauOV30i/9QOAePe8yD
 pX0A1/xQFKTVhFF0/pHcPtOyXVvoz1kN1BtEwThzulbGbdpMZzSVRxDltD3Ms6qCg+DR8w9Xg
 1HNvdN58UBmBffscZQfJ3uGOdYUnNd/Z/qBWBh3nKupymnak1e+hXr0iqT93E2JgK2slu9HW9
 Z2axRD0iGEUrgeb9E+gKSNrjiJH/4fDKD8Z5lRW4qhpBqvDKJgpONVtYSF1fs5a507MhVUqY/
 ecMHxzHOudszBrZPAkhrwHdVmR/qaW21VF2jaanNLRvssBK7O8jWDQCJ9WauY+QaVpWe1Xm9M
 j0po2qtm7FCd3rGTIaRXghzekCWgPNe73UUF00PGSzbAl/jhmRAu9r4U/VkCx3HmM/WrHhvRW
 ad+0d9V0hf8Xeic5bqK52JML2QJqCmIe7NB2ixhgSnZdimcY+5vFtQ8g9K3P4FTHlhH9PphRM
 cxSXU1vSCAp7pTnno7sRJrT0VMqmuv3qW/UlBF38y4zrzd9PEUMZW4UxW4laKXi0KaQnzNxAo
 PMh7SrJQblIOAKBBIuqgKhJqURIHS1fsW7RSggxc0EqwbsWPXdvl2gllgbXGVdP1ZY5o3kl43
 d+N2OmWFJ441ZO9PoEViFmhspqovEke2y4c1oC32CCIhQyp7sH9qzAoUmkyCZmgkGAz/35SB4
 BBgvrbT13ay+2uo9VhVFFZBMGkuoOGGeoPQFlCjHGzdsv8U+a59cePuZotBzx84VLJLJirZMf
 Lf9K1i8NA0TMtjDRGV0mE+M67+17BAhGHh/6MiBKK/jhK1vx5OlwhSZxsN8UqwUrqyHyNTwPS
 xelD6eSYIzl8w9BYCwPDAolsR387A==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Rafał,

> Rafał Miłecki <rafal@milecki.pl> hat am 24. November 2018 um 22:23 geschrieben:
> 
> 
> Possibly you can just update hostapd to anything more recent? I'm afraid
> the version you're using may suffer from a lot of security issues anyway

thanks for your quick reply. I updated hostapd to 2.6.18 from Debian Buster. This makes hostapd work better, but AP mode still does work (kernel output):

[    6.085594] cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[    6.085772] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[    6.085781] cfg80211: failed to load regulatory.db
[    6.148788] Console: switching to colour frame buffer device 240x67
[    6.170518] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
[    6.197752] vc4-drm soc:gpu: fb0: DRM emulated frame buffer device
[    6.324425] random: crng init done
[    6.324438] random: 7 urandom warning(s) missed due to ratelimiting
[    6.365083] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac43455-sdio for chip BCM4345/6
[    6.398502] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4345/6 wl0: Feb 27 2018 03:15:32 version 7.45.154 (r684107 CY) FWID 01-4fbe0b04
[    6.800404] Bluetooth: hci0: BCM4345C0 (003.001.025) build 0252
[    9.961790] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   10.026130] Adding 102396k swap on /var/swap.  Priority:-2 extents:1 across:102396k SS
[   10.272507] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   13.627905] brcmfmac: brcmf_cfg80211_stop_ap: setting AP mode failed -52
[  146.411501] brcmfmac: brcmf_escan_timeout: timer expired
[  146.862393] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
[  257.130466] brcmfmac: brcmf_escan_timeout: timer expired
[  257.581463] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52

Hostapd output:

random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd/hostapd.conf
nl80211: Using driver-based roaming
nl80211: TDLS supported
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Supported cipher 00-0f-ac:6
nl80211: Using driver-based off-channel TX
nl80211: Supported vendor command: vendor_id=0x1018 subcmd=1
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Enable multi-channel concurrent (driver advertised support)
nl80211: use P2P_DEVICE support
nl80211: interface wlan0 in phy phy0
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Setup AP(wlan0) - device_ap_sme=1 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x543340 (device SME)
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=04
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 04
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=0501
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=2): 05 01
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=0504
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=2): 05 04
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=06
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 06
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=08
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 08
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=09
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 09
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=0a
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 0a
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=11
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 11
nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x543340 match=7f
nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=1): 7f
nl80211: Failed to subscribe for mgmt frames from SME driver - trying to run without it
nl80211: Enable Probe Request reporting nl_preq=0x543340
nl80211: Register frame type=0x40 (WLAN_FC_STYPE_PROBE_REQ) nl_handle=0x543340 match=
nl80211: Register frame command failed (type=64): ret=-22 (Invalid argument)
nl80211: Register frame match - hexdump(len=0): [NULL]
nl80211: Failed to enable Probe Request frame reporting in AP mode
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Add own interface ifindex 3 (ifidx_reason -1)
nl80211: if_indices[16]: 3(-1)
phy: phy0
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz 20 mBm
nl80211: 2457-2482 @ 20 MHz 20 mBm (no IR)
nl80211: 2474-2494 @ 20 MHz 20 mBm (no OFDM) (no IR)
nl80211: 5170-5250 @ 80 MHz 20 mBm (no IR)
nl80211: 5250-5330 @ 80 MHz 20 mBm (DFS) (no IR)
nl80211: 5490-5730 @ 160 MHz 20 mBm (DFS) (no IR)
nl80211: 5735-5835 @ 80 MHz 20 mBm (no IR)
nl80211: 57240-63720 @ 2160 MHz 0 mBm
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=14 freq=2484 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=34 freq=5170 MHz max_tx_power=8 dBm
Allowed channel: mode=2 chan=36 freq=5180 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=38 freq=5190 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=40 freq=5200 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=42 freq=5210 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=44 freq=5220 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=46 freq=5230 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=48 freq=5240 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=52 freq=5260 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=56 freq=5280 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=60 freq=5300 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=64 freq=5320 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=100 freq=5500 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=104 freq=5520 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=108 freq=5540 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=112 freq=5560 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=116 freq=5580 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=120 freq=5600 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=124 freq=5620 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=128 freq=5640 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=132 freq=5660 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=136 freq=5680 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=140 freq=5700 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=144 freq=5720 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=149 freq=5745 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=153 freq=5765 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=157 freq=5785 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=161 freq=5805 MHz max_tx_power=20 dBm
Allowed channel: mode=2 chan=165 freq=5825 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=14 freq=2484 MHz max_tx_power=20 dBm
Completing interface initialization
Mode: IEEE 802.11a  Channel: 36  Frequency: 5180 MHz
DFS 0 channels required radar detection
nl80211: Set freq 5180 (ht_enabled=0, vht_enabled=0, bandwidth=20 MHz, cf1=5180 MHz, cf2=0 MHz)
  * freq=5180
  * vht_enabled=0
  * ht_enabled=0
  * channel_type=0
RATE[0] rate=60 flags=0x1
RATE[1] rate=90 flags=0x0
RATE[2] rate=120 flags=0x1
RATE[3] rate=180 flags=0x0
RATE[4] rate=240 flags=0x1
RATE[5] rate=360 flags=0x0
RATE[6] rate=480 flags=0x0
RATE[7] rate=540 flags=0x0
hostapd_setup_bss(hapd=0x5448a8 (wlan0), first=1)
wlan0: Flushing old station entries
nl80211: flush -> DEL_STATION wlan0 (all)
nl80211: Station flush failed: ret=-14 (Bad address)
wlan0: Could not connect to kernel driver
wlan0: Deauthenticate all stations

Stefan
