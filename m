Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:34311 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab3DBTl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 15:41:57 -0400
Date: Tue, 2 Apr 2013 12:08:31 -0700
From: Jonathan McDowell <noodles@earth.li>
To: linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Problems with Intel 2230 and AP mode
Message-ID: <20130402190831.GQ31591@earth.li> (sfid-20130402_214202_531569_30A4BCD6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to build my own wifi router, cobbling together a Debian
(wheezy) box, hostapd (1.0) and an Intel 2230. I'm seeing various
problems with the 2230 and I'm wondering if I'm mad for trying to use
this card in AP mode (in which case is there an alternative Intel card I
should use, or is an ath9k my best bet), or if it's worthwhile reporting
the issues and trying fixes.

I'm using 3.8.5 (and previously 3.8.4). I tried 3.9-rc4 briefly but it
was unusable - as soon as there was any traffic I saw errors like:

Mar 27 19:33:51 ramen kernel: [ 7687.814137] iwlwifi 0000:04:00.0: Stopping AGG while state not ON or starting for 3 on 0 (4)
Mar 27 19:33:51 ramen kernel: [ 7687.818846] iwlwifi 0000:04:00.0: txq_id mismatch: 11 0
Mar 27 19:33:51 ramen kernel: [ 7687.818899] iwlwifi 0000:04:00.0: txq_id mismatch: 11 0
Mar 27 19:33:51 ramen kernel: [ 7687.818946] iwlwifi 0000:04:00.0: txq_id mismatch: 11 0
Mar 27 19:33:51 ramen kernel: [ 7687.818993] iwlwifi 0000:04:00.0: txq_id mismatch: 11 0
Mar 27 19:33:51 ramen kernel: [ 7687.819039] iwlwifi 0000:04:00.0: txq_id mismatch: 11 0
Mar 27 19:33:51 ramen kernel: [ 7687.819085] iwlwifi 0000:04:00.0: txq_id mismatch: 11 0

and eventually:

Mar 27 22:06:14 ramen kernel: [16842.154745] iwlwifi 0000:04:00.0: txq_id mismatch: 13 0
Mar 27 22:06:14 ramen kernel: [16842.154992] iwlwifi 0000:04:00.0: txq_id mismatch: 13 0
Mar 27 22:08:45 ramen kernel: [16993.615133] iwlwifi 0000:04:00.0: Stopping AGG while state not ON or starting for 3 on 0 (4)
Mar 27 22:08:45 ramen kernel: [16993.617915] iwlwifi 0000:04:00.0: update beacon failed -- keeping old
Mar 27 22:08:47 ramen kernel: [16995.641612] iwlwifi 0000:04:00.0: fail to flush all tx fifo queues Q 15
Mar 27 22:08:47 ramen kernel: [16995.642796] iwlwifi 0000:04:00.0: Current SW read_ptr 216 write_ptr 170
Mar 27 22:08:47 ramen kernel: [16995.644012] iwl data: 00000000: 00 00 00 00 00 00 00 ff 00 00 00 00 00 00 00 00  ................
Mar 27 22:08:47 ramen kernel: [16995.645276] iwlwifi 0000:04:00.0: FH TRBs(0) = 0x80004000
Mar 27 22:08:47 ramen kernel: [16995.646563] iwlwifi 0000:04:00.0: FH TRBs(1) = 0x00000000
Mar 27 22:08:47 ramen kernel: [16995.647842] iwlwifi 0000:04:00.0: FH TRBs(2) = 0x80206002
Mar 27 22:08:47 ramen kernel: [16995.649085] iwlwifi 0000:04:00.0: FH TRBs(3) = 0x00000000
Mar 27 22:08:47 ramen kernel: [16995.650319] iwlwifi 0000:04:00.0: FH TRBs(4) = 0xc040f0df
Mar 27 22:08:47 ramen kernel: [16995.651514] iwlwifi 0000:04:00.0: FH TRBs(5) = 0x805070e2
Mar 27 22:08:47 ramen kernel: [16995.652717] iwlwifi 0000:04:00.0: FH TRBs(6) = 0x00000000
Mar 27 22:08:47 ramen kernel: [16995.653939] iwlwifi 0000:04:00.0: FH TRBs(7) = 0x0070903e
Mar 27 22:08:47 ramen kernel: [16995.655204] iwlwifi 0000:04:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.656505] iwlwifi 0000:04:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.657806] iwlwifi 0000:04:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.659115] iwlwifi 0000:04:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.660380] iwlwifi 0000:04:00.0: Q 4 is active and mapped to fifo 0 ra_tid 0x0000 [1,1]
Mar 27 22:08:47 ramen kernel: [16995.661615] iwlwifi 0000:04:00.0: Q 5 is active and mapped to fifo 4 ra_tid 0x0000 [234,234]
Mar 27 22:08:47 ramen kernel: [16995.662829] iwlwifi 0000:04:00.0: Q 6 is active and mapped to fifo 2 ra_tid 0x0000 [3,3]
Mar 27 22:08:47 ramen kernel: [16995.664050] iwlwifi 0000:04:00.0: Q 7 is active and mapped to fifo 5 ra_tid 0x0000 [227,227]
Mar 27 22:08:47 ramen kernel: [16995.665290] iwlwifi 0000:04:00.0: Q 8 is active and mapped to fifo 4 ra_tid 0x0000 [77,77]
Mar 27 22:08:47 ramen kernel: [16995.666535] iwlwifi 0000:04:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [63,63]
Mar 27 22:08:47 ramen kernel: [16995.667753] iwlwifi 0000:04:00.0: Q 10 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.669003] iwlwifi 0000:04:00.0: Q 11 is active and mapped to fifo 4 ra_tid 0x0030 [125,125]
Mar 27 22:08:47 ramen kernel: [16995.670267] iwlwifi 0000:04:00.0: Q 12 is active and mapped to fifo 4 ra_tid 0x0030 [225,225]
Mar 27 22:08:47 ramen kernel: [16995.671499] iwlwifi 0000:04:00.0: Q 13 is active and mapped to fifo 4 ra_tid 0x0030 [141,141]
Mar 27 22:08:47 ramen kernel: [16995.672684] iwlwifi 0000:04:00.0: Q 14 is active and mapped to fifo 4 ra_tid 0x0030 [157,157]
Mar 27 22:08:47 ramen kernel: [16995.673836] iwlwifi 0000:04:00.0: Q 15 is active and mapped to fifo 4 ra_tid 0x0030 [216,170]
Mar 27 22:08:47 ramen kernel: [16995.674996] iwlwifi 0000:04:00.0: Q 16 is inactive and mapped to fifo 4 ra_tid 0x0020 [217,217]
Mar 27 22:08:47 ramen kernel: [16995.676186] iwlwifi 0000:04:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.677377] iwlwifi 0000:04:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
Mar 27 22:08:47 ramen kernel: [16995.678578] iwlwifi 0000:04:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [:

With 3.8.5 I'm seeing:

Mar 31 03:40:59 ramen kernel: [190603.453006] iwlwifi 0000:04:00.0: Fail start Tx agg on tid: 0
Mar 31 04:55:12 ramen kernel: [195049.470156] ICMPv6: ND: ndisc_build_skb failed to allocate an skb, err=-11
Mar 31 04:55:13 ramen kernel: [195050.457683] ICMPv6: ND: ndisc_build_skb failed to allocate an skb, err=-11
Mar 31 04:55:13 ramen kernel: [195050.468667] ICMPv6: ND: ndisc_build_skb failed to allocate an skb, err=-11

(these ICMPv6 messages continued until wlan0 was downed/uped when I got up.)

Or last night:

Apr  1 21:10:34 ramen kernel: [339756.720681] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 30 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.729475] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 31 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.729558] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 32 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.731520] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 33 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.731599] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 34 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.745730] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 35 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.754306] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 46 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.757169] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 47 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.760971] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 49 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.772918] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 50 is out of range [0-256] 24 22.
Apr  1 21:10:34 ramen kernel: [339756.778303] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 24 22.
Apr  1 21:10:35 ramen kernel: [339756.798034] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 35 22.
Apr  1 21:10:35 ramen kernel: [339756.808613] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 43 22.
Apr  1 21:10:35 ramen kernel: [339756.808694] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 43 22.
Apr  1 21:10:35 ramen kernel: [339756.825100] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 43 22.
Apr  1 21:10:35 ramen kernel: [339756.827432] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 43 22.
Apr  1 21:10:35 ramen kernel: [339756.830564] iwlwifi 0000:04:00.0: iwl_trans_pcie_reclaim: Read index for DMA queue txq id (13), last_to_free 51 is out of range [0-256] 43 22.

The connection is noticeably bad - an ssh session from my laptop to the
AP box sees a lot of stalls. I do have quite a few overlapping wireless
networks visible from my neighbors, but unfortunately there doesn't seem
to be a clearer channel free to use. I have an rt2872 USB dongle I've
been trying as well (though mostly on 5GHz so far) and it seems more
reliable, but ideally I'd like to run both (or get a proper card with an
external antenna to replace the USB dongle) so I can cover 2.4GHz and
5GHz.

I can recompile with the various wireless debug options enabled if that
helps, but first I wanted to get an idea of whether anyone was likely to
care about the Intel cards in AP mode - I've seen mixed reports of how
likely they are to work that way.

dmesg for device startup:

[    3.502322] iwlwifi 0000:04:00.0: enabling device (0000 -> 0002)
[    3.504085] iwlwifi 0000:04:00.0: irq 46 for MSI/MSI-X
[    3.687965] iwlwifi 0000:04:00.0: loaded firmware version 18.168.6.1
[    3.695200] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    3.697237] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    3.699153] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    3.701094] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    3.703001] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_P2P disabled
[    3.704930] iwlwifi 0000:04:00.0: Detected Intel(R) Centrino(R) Wireless-N 2230 BGN, REV=0xC8
[    3.706939] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
[    3.948180] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
[    7.384349] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
[    7.397823] iwlwifi 0000:04:00.0: Radio type=0x2-0x0-0x0
[    7.769307] iwlwifi 0000:04:00.0: L1 Disabled; Enabling L0S
[    7.779271] iwlwifi 0000:04:00.0: Radio type=0x2-0x0-0x0

lspci -k:
04:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev c4)
        Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
        Kernel driver in use: iwlwifi

hostapd.conf snippets:

interface=wlan0
driver=nl80211
country_code=US
ieee80211d=1
hw_mode=g
channel=7
wmm_enabled=1
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-20][SHORT-GI-40]
wpa=3
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

Thanks,
J.

J.

-- 
I have found the monster - the monster is us.
This .sig brought to you by the letter G and the number 29
Product of the Republic of HuggieTag
