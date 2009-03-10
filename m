Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f122.google.com ([209.85.221.122]:53649 "EHLO
	mail-qy0-f122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbZCJBkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 21:40:45 -0400
Received: by qyk28 with SMTP id 28so1442973qyk.33
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 18:40:42 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236317982.12430.9.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0903011937p6538adbfpc0dab859a6742394@mail.gmail.com>
	 <1236141120.12734.2.camel@rainbow> <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk> <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 21:40:34 -0400
Message-Id: <1236649234.6685.9.camel@rainbow> (sfid-20090310_024051_713045_895965AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I thought I had made a big breakthrough when I found the solution to
getting 
"iwlwifi: use iwl_cmd instead of iwl3945_cmd"
bb64785ad94d575fe4f5f9e69f4f6c0b24e9905d to work.  Then I discovered
that casting to iwl3945_tx_cmd was fixed later by "iwl3945: use
iwl3945_tx_cmd instead of iwl_tx_cmd" fadd267e...

However, with this new knowledge, I was able to get farther.

Using my iwl3945_tx_cmd conversion patch, a patch for allocating rb_stts
and a patch for the BUG_ON -> WARN_ON, I was able to narrow down commit
"iwl3945: sync tx queue data structure with iwlagn"
ff5010c3e12f1d0da27a5f871c2e3d5333dfbe2f as the one that starts
introducing Microcode SW errors.

I tried adding in Reinette's iwl3945_hw_txq_free_tfd pci_unmap_single
patch from earlier, but it did not fix the problem.

Would TX debugging output be more helpful?

Any thoughts on what could be going wrong?

Thanks,

Jason

Mar  9 21:24:57 rainbow kernel: [17660.697045] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for Linux, 1.2.26kds
Mar  9 21:24:57 rainbow kernel: [17660.697053] iwl3945: Copyright(c) 2003-2008 Intel Corporation
Mar  9 21:24:57 rainbow kernel: [17660.697248] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar  9 21:24:57 rainbow kernel: [17660.697267] iwl3945 0000:03:00.0: setting latency timer to 64
Mar  9 21:24:57 rainbow kernel: [17660.745287] iwl3945 0000:03:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
Mar  9 21:24:57 rainbow kernel: [17660.745295] iwl3945 0000:03:00.0: Detected Intel Wireless WiFi Link 3945ABG
Mar  9 21:24:57 rainbow kernel: [17660.762675] phy12: Selected rate control algorithm 'iwl-3945-rs'
Mar  9 21:25:01 rainbow kernel: [17664.799933] iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Mar  9 21:25:01 rainbow kernel: [17664.800295] iwl3945 0000:03:00.0: irq 2295 for MSI/MSI-X
Mar  9 21:25:01 rainbow kernel: [17664.800409] iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
Mar  9 21:25:01 rainbow kernel: [17664.809518] iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Mar  9 21:25:01 rainbow kernel: [17664.826140] ieee80211 phy12: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Mar  9 21:25:01 rainbow kernel: [17664.837857] ieee80211 phy12: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Mar  9 21:25:01 rainbow kernel: [17664.853044] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
Mar  9 21:25:01 rainbow kernel: [17664.853127] ieee80211 phy12: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Mar  9 21:25:01 rainbow kernel: [17664.853565] iwl3945 0000:03:00.0: Unsupported interface type 515
Mar  9 21:25:01 rainbow kernel: [17664.853581] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
Mar  9 21:25:01 rainbow kernel: [17664.855003] ieee80211 phy12: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Mar  9 21:25:01 rainbow kernel: [17664.855035] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
Mar  9 21:25:01 rainbow kernel: [17664.857974] ieee80211 phy12: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:01 rainbow kernel: [17664.860224] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
Mar  9 21:25:02 rainbow kernel: [17664.870778] ieee80211 phy12: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:02 rainbow kernel: [17664.870812] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
Mar  9 21:25:02 rainbow kernel: [17664.873555] ieee80211 phy12: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Mar  9 21:25:02 rainbow kernel: [17664.874273] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Mar  9 21:25:02 rainbow kernel: [17664.876288] ieee80211 phy12: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:02 rainbow kernel: [17664.876313] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
Mar  9 21:25:02 rainbow kernel: [17664.878994] ieee80211 phy12: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:02 rainbow kernel: [17664.879146] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0407, 56 bytes at 7[7]:4
Mar  9 21:25:02 rainbow kernel: [17664.881767] ieee80211 phy12: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:02 rainbow kernel: [17664.885953] Registered led device: iwl-phy12:radio
Mar  9 21:25:02 rainbow kernel: [17664.885965] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0408, 12 bytes at 8[8]:4
Mar  9 21:25:02 rainbow kernel: [17664.886026] Registered led device: iwl-phy12:assoc
Mar  9 21:25:02 rainbow kernel: [17664.886062] Registered led device: iwl-phy12:RX
Mar  9 21:25:02 rainbow kernel: [17664.886096] Registered led device: iwl-phy12:TX
Mar  9 21:25:02 rainbow kernel: [17664.886127] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0409, 12 bytes at 9[9]:4
Mar  9 21:25:02 rainbow kernel: [17664.886158] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040A, 48 bytes at 10[10]:4
Mar  9 21:25:02 rainbow kernel: [17664.887597] ieee80211 phy12: I iwl3945_rx_handle r 12 i 10 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  9 21:25:02 rainbow kernel: [17664.887611] ieee80211 phy12: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  9 21:25:02 rainbow kernel: [17664.887683] ieee80211 phy12: I iwl3945_rx_handle r 13 i 12 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:02 rainbow kernel: [17664.887745] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x040B, 56 bytes at 11[11]:4
Mar  9 21:25:02 rainbow kernel: [17664.890488] ieee80211 phy12: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:02 rainbow kernel: [17664.890541] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040C, 68 bytes at 12[12]:4
Mar  9 21:25:02 rainbow kernel: [17664.893755] ieee80211 phy12: I iwl3945_rx_handle r = 15, i = 14, REPLY_ADD_STA, 0x18
Mar  9 21:25:02 rainbow kernel: [17664.893812] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040D, 56 bytes at 13[13]:4
Mar  9 21:25:02 rainbow kernel: [17664.896990] ieee80211 phy12: I iwl3945_rx_handle r 16 i 15 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:02 rainbow kernel: [17664.897019] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040E, 56 bytes at 14[14]:4
Mar  9 21:25:02 rainbow kernel: [17664.900205] ieee80211 phy12: I iwl3945_rx_handle r 17 i 16 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:02 rainbow kernel: [17664.918044] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x040F, 48 bytes at 15[15]:4
Mar  9 21:25:02 rainbow kernel: [17664.928734] ieee80211 phy12: I iwl3945_rx_handle r 18 i 17 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:02 rainbow kernel: [17664.928785] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0410, 56 bytes at 16[16]:4
Mar  9 21:25:02 rainbow kernel: [17664.931523] ieee80211 phy12: I iwl3945_rx_handle r 19 i 18 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:02 rainbow kernel: [17664.931551] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0411, 68 bytes at 17[17]:4
Mar  9 21:25:02 rainbow kernel: [17664.934394] ieee80211 phy12: I iwl3945_rx_handle r = 20, i = 19, REPLY_ADD_STA, 0x18
Mar  9 21:25:02 rainbow kernel: [17664.934458] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0412, 56 bytes at 18[18]:4
Mar  9 21:25:02 rainbow kernel: [17664.937175] ieee80211 phy12: I iwl3945_rx_handle r 21 i 20 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:02 rainbow kernel: [17664.937205] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0413, 56 bytes at 19[19]:4
Mar  9 21:25:02 rainbow kernel: [17664.940008] ieee80211 phy12: I iwl3945_rx_handle r 22 i 21 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:02 rainbow kernel: [17664.941958] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Mar  9 21:25:02 rainbow kernel: [17664.956102] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4414, 351 bytes at 20[32]:4
Mar  9 21:25:02 rainbow kernel: [17664.966648] ieee80211 phy12: I iwl3945_rx_handle r = 23, i = 22, REPLY_SCAN_CMD, 0x80
Mar  9 21:25:02 rainbow kernel: [17664.967612] ieee80211 phy12: I iwl3945_rx_handle r = 25, i = 23, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17664.967626] ieee80211 phy12: I iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0415, 12 bytes at 21[21]:4
Mar  9 21:25:02 rainbow kernel: [17664.967670] ieee80211 phy12: I iwl3945_rx_handle r = 25, i = 24, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17664.968241] ieee80211 phy12: I iwl3945_rx_handle r 26 i 25 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  9 21:25:02 rainbow kernel: [17664.969784] ieee80211 phy12: I iwl3945_rx_handle r = 27, i = 26, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17664.973623] ieee80211 phy12: I iwl3945_rx_handle r = 28, i = 27, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17664.975156] ieee80211 phy12: I iwl3945_rx_handle r = 29, i = 28, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.007614] ieee80211 phy12: I iwl3945_rx_handle r = 30, i = 29, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.008626] ieee80211 phy12: I iwl3945_rx_handle r = 32, i = 30, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.008640] ieee80211 phy12: I iwl3945_rx_handle r = 32, i = 31, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.021190] ieee80211 phy12: I iwl3945_rx_handle r = 33, i = 32, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.022134] ieee80211 phy12: I iwl3945_rx_handle r = 35, i = 33, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.022151] ieee80211 phy12: I iwl3945_rx_handle r = 35, i = 34, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.034542] ieee80211 phy12: I iwl3945_rx_handle r = 36, i = 35, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.035512] ieee80211 phy12: I iwl3945_rx_handle r = 38, i = 36, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.035524] ieee80211 phy12: I iwl3945_rx_handle r = 38, i = 37, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.037632] ieee80211 phy12: I iwl3945_rx_handle r = 39, i = 38, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.040581] ieee80211 phy12: I iwl3945_rx_handle r = 40, i = 39, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.044800] ieee80211 phy12: I iwl3945_rx_handle r = 41, i = 40, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.075466] ieee80211 phy12: I iwl3945_rx_handle r = 42, i = 41, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.076456] ieee80211 phy12: I iwl3945_rx_handle r = 44, i = 42, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.076470] ieee80211 phy12: I iwl3945_rx_handle r = 44, i = 43, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.079425] ieee80211 phy12: I iwl3945_rx_handle r = 45, i = 44, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.081802] ieee80211 phy12: I iwl3945_rx_handle r = 46, i = 45, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.102103] ieee80211 phy12: I iwl3945_rx_handle r = 47, i = 46, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.116457] ieee80211 phy12: I iwl3945_rx_handle r = 48, i = 47, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.117441] ieee80211 phy12: I iwl3945_rx_handle r = 50, i = 48, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.117463] ieee80211 phy12: I iwl3945_rx_handle r = 50, i = 49, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.119538] ieee80211 phy12: I iwl3945_rx_handle r = 51, i = 50, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.121866] ieee80211 phy12: I iwl3945_rx_handle r = 52, i = 51, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.123858] ieee80211 phy12: I iwl3945_rx_handle r = 53, i = 52, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.125180] ieee80211 phy12: I iwl3945_rx_handle r = 54, i = 53, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.126810] ieee80211 phy12: I iwl3945_rx_handle r = 55, i = 54, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.128381] ieee80211 phy12: I iwl3945_rx_handle r = 56, i = 55, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.143283] ieee80211 phy12: I iwl3945_rx_handle r = 57, i = 56, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.147207] ieee80211 phy12: I iwl3945_rx_handle r = 58, i = 57, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.157381] ieee80211 phy12: I iwl3945_rx_handle r = 59, i = 58, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.158467] ieee80211 phy12: I iwl3945_rx_handle r = 61, i = 59, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.158490] ieee80211 phy12: I iwl3945_rx_handle r = 61, i = 60, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.161328] ieee80211 phy12: I iwl3945_rx_handle r = 62, i = 61, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.172387] ieee80211 phy12: I iwl3945_rx_handle r = 63, i = 62, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.173421] ieee80211 phy12: I iwl3945_rx_handle r = 65, i = 63, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.173443] ieee80211 phy12: I iwl3945_rx_handle r = 65, i = 64, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.177570] ieee80211 phy12: I iwl3945_rx_handle r = 66, i = 65, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.186047] ieee80211 phy12: I iwl3945_rx_handle r = 67, i = 66, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.187097] ieee80211 phy12: I iwl3945_rx_handle r = 69, i = 67, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.187117] ieee80211 phy12: I iwl3945_rx_handle r = 69, i = 68, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.199870] ieee80211 phy12: I iwl3945_rx_handle r = 70, i = 69, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.200891] ieee80211 phy12: I iwl3945_rx_handle r = 72, i = 70, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.200914] ieee80211 phy12: I iwl3945_rx_handle r = 72, i = 71, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.214005] ieee80211 phy12: I iwl3945_rx_handle r = 73, i = 72, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.214976] ieee80211 phy12: I iwl3945_rx_handle r = 75, i = 73, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.214996] ieee80211 phy12: I iwl3945_rx_handle r = 75, i = 74, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.218315] ieee80211 phy12: I iwl3945_rx_handle r = 76, i = 75, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.220410] ieee80211 phy12: I iwl3945_rx_handle r = 77, i = 76, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.222560] ieee80211 phy12: I iwl3945_rx_handle r = 78, i = 77, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.225258] ieee80211 phy12: I iwl3945_rx_handle r = 79, i = 78, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.245137] ieee80211 phy12: I iwl3945_rx_handle r = 80, i = 79, UNKNOWN, 0x1b
Mar  9 21:25:02 rainbow kernel: [17665.254937] ieee80211 phy12: I iwl3945_rx_handle r = 81, i = 80, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.255971] ieee80211 phy12: I iwl3945_rx_handle r = 82, i = 81, SCAN_COMPLETE_NOTIFICATION, 0x84
Mar  9 21:25:02 rainbow kernel: [17665.258203] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_SCAN_CMD (#80), seq: 0x4416, 367 bytes at 22[32]:4
Mar  9 21:25:02 rainbow kernel: [17665.258436] ieee80211 phy12: I iwl3945_rx_handle r = 83, i = 82, REPLY_SCAN_CMD, 0x80
Mar  9 21:25:02 rainbow kernel: [17665.259400] ieee80211 phy12: I iwl3945_rx_handle r = 85, i = 83, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.259421] ieee80211 phy12: I iwl3945_rx_handle r = 85, i = 84, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.372061] ieee80211 phy12: I iwl3945_rx_handle r = 86, i = 85, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.373011] ieee80211 phy12: I iwl3945_rx_handle r = 88, i = 86, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.373034] ieee80211 phy12: I iwl3945_rx_handle r = 88, i = 87, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.485621] ieee80211 phy12: I iwl3945_rx_handle r = 89, i = 88, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.486573] ieee80211 phy12: I iwl3945_rx_handle r = 91, i = 89, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.486597] ieee80211 phy12: I iwl3945_rx_handle r = 91, i = 90, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.599238] ieee80211 phy12: I iwl3945_rx_handle r = 92, i = 91, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.600152] ieee80211 phy12: I iwl3945_rx_handle r = 94, i = 92, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.600174] ieee80211 phy12: I iwl3945_rx_handle r = 94, i = 93, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.712858] ieee80211 phy12: I iwl3945_rx_handle r = 95, i = 94, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.713770] ieee80211 phy12: I iwl3945_rx_handle r = 97, i = 95, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.713792] ieee80211 phy12: I iwl3945_rx_handle r = 97, i = 96, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:02 rainbow kernel: [17665.826397] ieee80211 phy12: I iwl3945_rx_handle r = 98, i = 97, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:02 rainbow kernel: [17665.827324] ieee80211 phy12: I iwl3945_rx_handle r = 100, i = 98, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:02 rainbow kernel: [17665.827348] ieee80211 phy12: I iwl3945_rx_handle r = 100, i = 99, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17665.940017] ieee80211 phy12: I iwl3945_rx_handle r = 101, i = 100, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17665.940941] ieee80211 phy12: I iwl3945_rx_handle r = 103, i = 101, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17665.940964] ieee80211 phy12: I iwl3945_rx_handle r = 103, i = 102, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.053600] ieee80211 phy12: I iwl3945_rx_handle r = 104, i = 103, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.054874] ieee80211 phy12: I iwl3945_rx_handle r = 106, i = 104, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17666.054896] ieee80211 phy12: I iwl3945_rx_handle r = 106, i = 105, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.167550] ieee80211 phy12: I iwl3945_rx_handle r = 107, i = 106, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.168836] ieee80211 phy12: I iwl3945_rx_handle r = 109, i = 107, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17666.168858] ieee80211 phy12: I iwl3945_rx_handle r = 109, i = 108, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.281512] ieee80211 phy12: I iwl3945_rx_handle r = 110, i = 109, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.282417] ieee80211 phy12: I iwl3945_rx_handle r = 112, i = 110, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17666.282434] ieee80211 phy12: I iwl3945_rx_handle r = 112, i = 111, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.395064] ieee80211 phy12: I iwl3945_rx_handle r = 113, i = 112, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.395995] ieee80211 phy12: I iwl3945_rx_handle r = 115, i = 113, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17666.396004] ieee80211 phy12: I iwl3945_rx_handle r = 115, i = 114, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.508609] ieee80211 phy12: I iwl3945_rx_handle r = 116, i = 115, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.509524] ieee80211 phy12: I iwl3945_rx_handle r = 118, i = 116, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17666.509534] ieee80211 phy12: I iwl3945_rx_handle r = 118, i = 117, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.622219] ieee80211 phy12: I iwl3945_rx_handle r = 119, i = 118, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.623106] ieee80211 phy12: I iwl3945_rx_handle r = 121, i = 119, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:03 rainbow kernel: [17666.623117] ieee80211 phy12: I iwl3945_rx_handle r = 121, i = 120, SCAN_START_NOTIFICATION, 0x82
Mar  9 21:25:03 rainbow kernel: [17666.735810] ieee80211 phy12: I iwl3945_rx_handle r = 122, i = 121, SCAN_RESULTS_NOTIFICATION, 0x83
Mar  9 21:25:03 rainbow kernel: [17666.736892] ieee80211 phy12: I iwl3945_rx_handle r = 123, i = 122, SCAN_COMPLETE_NOTIFICATION, 0x84
Mar  9 21:25:03 rainbow kernel: [17666.736941] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0417, 56 bytes at 23[23]:4
Mar  9 21:25:03 rainbow kernel: [17666.739628] ieee80211 phy12: I iwl3945_rx_handle r 124 i 123 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:03 rainbow kernel: [17666.757089] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0418, 48 bytes at 24[24]:4
Mar  9 21:25:03 rainbow kernel: [17666.768731] ieee80211 phy12: I iwl3945_rx_handle r 125 i 124 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:03 rainbow kernel: [17666.768763] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0419, 56 bytes at 25[25]:4
Mar  9 21:25:03 rainbow kernel: [17666.771986] ieee80211 phy12: I iwl3945_rx_handle r 126 i 125 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:03 rainbow kernel: [17666.772419] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041A, 68 bytes at 26[26]:4
Mar  9 21:25:03 rainbow kernel: [17666.774863] ieee80211 phy12: I iwl3945_rx_handle r = 127, i = 126, REPLY_ADD_STA, 0x18
Mar  9 21:25:03 rainbow kernel: [17666.774927] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041B, 56 bytes at 27[27]:4
Mar  9 21:25:03 rainbow kernel: [17666.777710] ieee80211 phy12: I iwl3945_rx_handle r 128 i 127 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.778841] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x041C, 56 bytes at 28[28]:4
Mar  9 21:25:03 rainbow kernel: [17666.780626] ieee80211 phy12: I iwl3945_rx_handle r 129 i 128 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.780657] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x041D, 48 bytes at 29[29]:4
Mar  9 21:25:03 rainbow kernel: [17666.783625] ieee80211 phy12: I iwl3945_rx_handle r 130 i 129 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:03 rainbow kernel: [17666.783647] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x041E, 56 bytes at 30[30]:4
Mar  9 21:25:03 rainbow kernel: [17666.786480] ieee80211 phy12: I iwl3945_rx_handle r 131 i 130 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:03 rainbow kernel: [17666.786504] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x041F, 68 bytes at 31[31]:4
Mar  9 21:25:03 rainbow kernel: [17666.789736] ieee80211 phy12: I iwl3945_rx_handle r = 132, i = 131, REPLY_ADD_STA, 0x18
Mar  9 21:25:03 rainbow kernel: [17666.789757] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0420, 56 bytes at 32[0]:4
Mar  9 21:25:03 rainbow kernel: [17666.792978] ieee80211 phy12: I iwl3945_rx_handle r 133 i 132 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.792998] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0421, 56 bytes at 33[1]:4
Mar  9 21:25:03 rainbow kernel: [17666.796190] ieee80211 phy12: I iwl3945_rx_handle r 134 i 133 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.796497] ieee80211 phy12: U iwl_reset_qos set QoS to default 
Mar  9 21:25:03 rainbow kernel: [17666.796507] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0422, 48 bytes at 34[2]:4
Mar  9 21:25:03 rainbow kernel: [17666.799274] ieee80211 phy12: I iwl3945_rx_handle r 135 i 134 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:03 rainbow kernel: [17666.799340] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0423, 56 bytes at 35[3]:4
Mar  9 21:25:03 rainbow kernel: [17666.802094] ieee80211 phy12: I iwl3945_rx_handle r 136 i 135 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:03 rainbow kernel: [17666.802122] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0424, 68 bytes at 36[4]:4
Mar  9 21:25:03 rainbow kernel: [17666.804892] ieee80211 phy12: I iwl3945_rx_handle r = 137, i = 136, REPLY_ADD_STA, 0x18
Mar  9 21:25:03 rainbow kernel: [17666.804912] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0425, 56 bytes at 37[5]:4
Mar  9 21:25:03 rainbow kernel: [17666.808094] ieee80211 phy12: I iwl3945_rx_handle r 138 i 137 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.808133] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0426, 56 bytes at 38[6]:4
Mar  9 21:25:03 rainbow kernel: [17666.811292] ieee80211 phy12: I iwl3945_rx_handle r 139 i 138 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.811320] wlan0: authenticate with AP 00:30:bd:c0:90:24
Mar  9 21:25:03 rainbow kernel: [17666.817870] ieee80211 phy12: I iwl3945_rx_handle r = 140, i = 139, REPLY_TX, 0x1c
Mar  9 21:25:03 rainbow kernel: [17666.819199] ieee80211 phy12: I iwl3945_rx_handle r = 141, i = 140, UNKNOWN, 0x1b
Mar  9 21:25:03 rainbow kernel: [17666.819314] wlan0: authenticated
Mar  9 21:25:03 rainbow kernel: [17666.819321] wlan0: associate with AP 00:30:bd:c0:90:24
Mar  9 21:25:03 rainbow kernel: [17666.820393] ieee80211 phy12: I iwl3945_rx_handle r = 142, i = 141, REPLY_TX, 0x1c
Mar  9 21:25:03 rainbow kernel: [17666.821738] ieee80211 phy12: I iwl3945_rx_handle r = 143, i = 142, UNKNOWN, 0x1b
Mar  9 21:25:03 rainbow kernel: [17666.823290] wlan0: RX AssocResp from 00:30:bd:c0:90:24 (capab=0x1 status=0 aid=6)
Mar  9 21:25:03 rainbow kernel: [17666.823295] wlan0: associated
Mar  9 21:25:03 rainbow kernel: [17666.823330] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0427, 12 bytes at 39[7]:4
Mar  9 21:25:03 rainbow kernel: [17666.823373] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0428, 48 bytes at 40[8]:4
Mar  9 21:25:03 rainbow kernel: [17666.823473] ieee80211 phy12: I iwl3945_rx_handle r 144 i 143 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  9 21:25:03 rainbow kernel: [17666.823630] ieee80211 phy12: I iwl3945_rx_handle r 145 i 144 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:03 rainbow kernel: [17666.823829] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0429, 56 bytes at 41[9]:4
Mar  9 21:25:03 rainbow kernel: [17666.826442] ieee80211 phy12: I iwl3945_rx_handle r 146 i 145 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:03 rainbow kernel: [17666.826482] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x042A, 68 bytes at 42[10]:4
Mar  9 21:25:03 rainbow kernel: [17666.829676] ieee80211 phy12: I iwl3945_rx_handle r = 147, i = 146, REPLY_ADD_STA, 0x18
Mar  9 21:25:03 rainbow kernel: [17666.829730] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x042B, 56 bytes at 43[11]:4
Mar  9 21:25:03 rainbow kernel: [17666.832473] ieee80211 phy12: I iwl3945_rx_handle r 148 i 147 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.832496] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x042C, 56 bytes at 44[12]:4
Mar  9 21:25:03 rainbow kernel: [17666.835680] ieee80211 phy12: I iwl3945_rx_handle r 149 i 148 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.835707] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON_TIMING (#14), seq: 0x042D, 24 bytes at 45[13]:4
Mar  9 21:25:03 rainbow kernel: [17666.838902] ieee80211 phy12: I iwl3945_rx_handle r 150 i 149 No handler needed for REPLY_RXON_TIMING, 0x14
Mar  9 21:25:03 rainbow kernel: [17666.838960] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x042E, 48 bytes at 46[14]:4
Mar  9 21:25:03 rainbow kernel: [17666.841840] ieee80211 phy12: I iwl3945_rx_handle r 151 i 150 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:03 rainbow kernel: [17666.841873] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x042F, 56 bytes at 47[15]:4
Mar  9 21:25:03 rainbow kernel: [17666.842148] ieee80211 phy12: I iwl3945_rx_handle r 152 i 151 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:03 rainbow kernel: [17666.842199] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0430, 68 bytes at 48[16]:4
Mar  9 21:25:03 rainbow kernel: [17666.842317] ieee80211 phy12: I iwl3945_rx_handle r = 153, i = 152, REPLY_ADD_STA, 0x18
Mar  9 21:25:03 rainbow kernel: [17666.842336] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0431, 56 bytes at 49[17]:4
Mar  9 21:25:03 rainbow kernel: [17666.842456] ieee80211 phy12: I iwl3945_rx_handle r 154 i 153 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.842516] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0432, 56 bytes at 50[18]:4
Mar  9 21:25:03 rainbow kernel: [17666.842633] ieee80211 phy12: I iwl3945_rx_handle r 155 i 154 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:03 rainbow kernel: [17666.842650] iwl3945 0000:03:00.0: iwl3945_post_associate Should not be called in 515 mode
Mar  9 21:25:03 rainbow kernel: [17666.842658] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_QOS_PARAM (#13), seq: 0x0433, 40 bytes at 51[19]:4
Mar  9 21:25:03 rainbow kernel: [17666.842780] ieee80211 phy12: I iwl3945_rx_handle r 156 i 155 No handler needed for REPLY_QOS_PARAM, 0x13
Mar  9 21:25:03 rainbow kernel: [17666.843087] wlan0: disassociating by local choice (reason=3)
Mar  9 21:25:03 rainbow kernel: [17666.843154] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0434, 12 bytes at 52[20]:4
Mar  9 21:25:03 rainbow kernel: [17666.844014] ieee80211 phy12: I iwl3945_rx_handle r = 158, i = 156, REPLY_TX, 0x1c
Mar  9 21:25:03 rainbow kernel: [17666.844026] ieee80211 phy12: I iwl3945_rx_handle r 158 i 157 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  9 21:25:04 rainbow kernel: [17666.986432] ieee80211 phy12: I iwl3945_rx_handle r = 160, i = 158, UNKNOWN, 0x1b
Mar  9 21:25:04 rainbow kernel: [17666.986449] ieee80211 phy12: I iwl3945_rx_handle r = 160, i = 159, STATISTICS_NOTIFICATION, 0x9d
Mar  9 21:25:04 rainbow kernel: [17666.986511] iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
Mar  9 21:25:04 rainbow kernel: [17666.986542] iwl3945 0000:03:00.0: Start IWL Error Log Dump:
Mar  9 21:25:04 rainbow kernel: [17666.986547] iwl3945 0000:03:00.0: Status: 0x000302E4, count: 1
Mar  9 21:25:04 rainbow kernel: [17666.986552] iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
Mar  9 21:25:04 rainbow kernel: [17666.986627] iwl3945 0000:03:00.0: SYSASSERT     (#5) 4135805861 0x0089A 0x08D56 0x00304 0x00000 811
Mar  9 21:25:04 rainbow kernel: [17666.986630] 
Mar  9 21:25:04 rainbow kernel: [17666.986695] iwl3945 0000:03:00.0: Start IWL Event Log Dump: display count 512, wraps 17
Mar  9 21:25:04 rainbow kernel: [17666.986730] iwl3945 0000:03:00.0: 0000006094^I0x00017832^I0610
Mar  9 21:25:04 rainbow kernel: [17666.986763] iwl3945 0000:03:00.0: 0000006095^I0x00000000^I0610
Mar  9 21:25:04 rainbow kernel: [17666.986797] iwl3945 0000:03:00.0: 0000006143^I0x00000500^I0600
Mar  9 21:25:04 rainbow kernel: [17666.986830] iwl3945 0000:03:00.0: 0000007644^I0x000001ed^I0616
Mar  9 21:25:04 rainbow kernel: [17666.986862] iwl3945 0000:03:00.0: 0000006137^I0x00017807^I0638
Mar  9 21:25:04 rainbow kernel: [17666.986895] iwl3945 0000:03:00.0: 0000006560^I0x0000001c^I1101
Mar  9 21:25:04 rainbow kernel: [17666.986928] iwl3945 0000:03:00.0: 0000006593^I0x0000001a^I1101
Mar  9 21:25:04 rainbow kernel: [17666.986961] iwl3945 0000:03:00.0: 0000006620^I0x000000ff^I1103
Mar  9 21:25:04 rainbow kernel: [17666.986994] iwl3945 0000:03:00.0: 0000006621^I0xffff9111^I1103
Mar  9 21:25:04 rainbow kernel: [17666.987026] iwl3945 0000:03:00.0: 0000006623^I0x00000010^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987059] iwl3945 0000:03:00.0: 0000006641^I0x00000011^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987092] iwl3945 0000:03:00.0: 0000006654^I0x00000000^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987125] iwl3945 0000:03:00.0: 0000006655^I0x00000000^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987158] iwl3945 0000:03:00.0: 0000006657^I0x000001d8^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987191] iwl3945 0000:03:00.0: 0000006659^I0x00000065^I1104
Mar  9 21:25:04 rainbow kernel: [17666.987224] iwl3945 0000:03:00.0: 0000006661^I0x0000000e^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987257] iwl3945 0000:03:00.0: 0000006662^I0x00680034^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987290] iwl3945 0000:03:00.0: 0000006663^I0x00670035^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987323] iwl3945 0000:03:00.0: 0000006665^I0x007e0036^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987356] iwl3945 0000:03:00.0: 0000006667^I0x007c0037^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987389] iwl3945 0000:03:00.0: 0000006668^I0x00000038^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987422] iwl3945 0000:03:00.0: 0000006670^I0x00840052^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987455] iwl3945 0000:03:00.0: 0000006671^I0x00840053^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987488] iwl3945 0000:03:00.0: 0000006673^I0x007e0054^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987521] iwl3945 0000:03:00.0: 0000006674^I0x007d0055^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987554] iwl3945 0000:03:00.0: 0000006676^I0x00000056^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987587] iwl3945 0000:03:00.0: 0000006677^I0x00007050^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987620] iwl3945 0000:03:00.0: 0000006679^I0x00017051^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987653] iwl3945 0000:03:00.0: 0000006681^I0x00008204^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987686] iwl3945 0000:03:00.0: 0000006683^I0x00018205^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987719] iwl3945 0000:03:00.0: 0000006686^I0x00000001^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987752] iwl3945 0000:03:00.0: 0000006687^I0x008b0063^I1102
Mar  9 21:25:04 rainbow kernel: [17666.987785] iwl3945 0000:03:00.0: 0000006689^I0x0000001d^I1104
Mar  9 21:25:04 rainbow kernel: [17666.987818] iwl3945 0000:03:00.0: 0000006691^I0x00000069^I1114
Mar  9 21:25:04 rainbow kernel: [17666.987851] iwl3945 0000:03:00.0: 0000006712^I0x0000020f^I0605
Mar  9 21:25:04 rainbow kernel: [17666.987883] iwl3945 0000:03:00.0: 0000006713^I0x0000026b^I0621
Mar  9 21:25:04 rainbow kernel: [17666.987916] iwl3945 0000:03:00.0: 0000006717^I0x0000010b^I1108
Mar  9 21:25:04 rainbow kernel: [17666.987949] iwl3945 0000:03:00.0: 0000006719^I0x0000000e^I1101
Mar  9 21:25:04 rainbow kernel: [17666.987982] iwl3945 0000:03:00.0: 0000006720^I0x00680034^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988015] iwl3945 0000:03:00.0: 0000006721^I0x00670035^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988048] iwl3945 0000:03:00.0: 0000006723^I0x007e0036^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988082] iwl3945 0000:03:00.0: 0000006724^I0x007c0037^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988114] iwl3945 0000:03:00.0: 0000006726^I0x00000038^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988148] iwl3945 0000:03:00.0: 0000006727^I0x00840052^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988180] iwl3945 0000:03:00.0: 0000006729^I0x00840053^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988214] iwl3945 0000:03:00.0: 0000006730^I0x007e0054^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988247] iwl3945 0000:03:00.0: 0000006732^I0x007d0055^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988280] iwl3945 0000:03:00.0: 0000006733^I0x00000056^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988313] iwl3945 0000:03:00.0: 0000006735^I0x00007050^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988346] iwl3945 0000:03:00.0: 0000006737^I0x00017051^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988379] iwl3945 0000:03:00.0: 0000006739^I0x00008204^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988412] iwl3945 0000:03:00.0: 0000006741^I0x00018205^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988446] iwl3945 0000:03:00.0: 0000006744^I0x00000001^I1101
Mar  9 21:25:04 rainbow kernel: [17666.988479] iwl3945 0000:03:00.0: 0000006745^I0x008b0063^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988512] iwl3945 0000:03:00.0: 0000006747^I0x0000001c^I1104
Mar  9 21:25:04 rainbow kernel: [17666.988545] iwl3945 0000:03:00.0: 0000006748^I0x00000002^I1101
Mar  9 21:25:04 rainbow kernel: [17666.988578] iwl3945 0000:03:00.0: 0000006749^I0x0083903f^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988611] iwl3945 0000:03:00.0: 0000006751^I0x0001d213^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988644] iwl3945 0000:03:00.0: 0000006754^I0x00000002^I1101
Mar  9 21:25:04 rainbow kernel: [17666.988676] iwl3945 0000:03:00.0: 0000006755^I0x0003d206^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988710] iwl3945 0000:03:00.0: 0000006757^I0x0083903e^I1102
Mar  9 21:25:04 rainbow kernel: [17666.988743] iwl3945 0000:03:00.0: 0000006761^I0x00000059^I1101
Mar  9 21:25:04 rainbow kernel: [17666.988776] iwl3945 0000:03:00.0: 0000006861^I0x00000013^I1101
Mar  9 21:25:04 rainbow kernel: [17666.988809] iwl3945 0000:03:00.0: 0000006879^I0x00000005^I1107
Mar  9 21:25:04 rainbow kernel: [17666.988842] iwl3945 0000:03:00.0: 0000007447^I0x000172ea^I1110
Mar  9 21:25:04 rainbow kernel: [17666.988874] iwl3945 0000:03:00.0: 0000007458^I0xffffff69^I0454
Mar  9 21:25:04 rainbow kernel: [17666.988908] iwl3945 0000:03:00.0: 0000007459^I0x00000000^I0472
Mar  9 21:25:04 rainbow kernel: [17666.988941] iwl3945 0000:03:00.0: 0000007469^I0x0000000b^I0463
Mar  9 21:25:04 rainbow kernel: [17666.988974] iwl3945 0000:03:00.0: 0000007472^I0xffffff69^I1111
Mar  9 21:25:04 rainbow kernel: [17666.989006] iwl3945 0000:03:00.0: 0000007477^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989039] iwl3945 0000:03:00.0: 0000007477^I0x0000000e^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989072] iwl3945 0000:03:00.0: 0000007482^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989105] iwl3945 0000:03:00.0: 0000007486^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989138] iwl3945 0000:03:00.0: 0000007490^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989171] iwl3945 0000:03:00.0: 0000007494^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989204] iwl3945 0000:03:00.0: 0000007499^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989236] iwl3945 0000:03:00.0: 0000007503^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989270] iwl3945 0000:03:00.0: 0000007507^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989302] iwl3945 0000:03:00.0: 0000007512^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989335] iwl3945 0000:03:00.0: 0000007516^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989367] iwl3945 0000:03:00.0: 0000007520^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989400] iwl3945 0000:03:00.0: 0000007524^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989433] iwl3945 0000:03:00.0: 0000007529^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989466] iwl3945 0000:03:00.0: 0000007533^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989499] iwl3945 0000:03:00.0: 0000007537^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989532] iwl3945 0000:03:00.0: 0000007541^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989565] iwl3945 0000:03:00.0: 0000007546^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989598] iwl3945 0000:03:00.0: 0000007550^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989631] iwl3945 0000:03:00.0: 0000007554^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989664] iwl3945 0000:03:00.0: 0000007559^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989697] iwl3945 0000:03:00.0: 0000007563^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989730] iwl3945 0000:03:00.0: 0000007567^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989763] iwl3945 0000:03:00.0: 0000007571^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989796] iwl3945 0000:03:00.0: 0000007576^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989829] iwl3945 0000:03:00.0: 0000007580^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989862] iwl3945 0000:03:00.0: 0000007584^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989895] iwl3945 0000:03:00.0: 0000007588^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989927] iwl3945 0000:03:00.0: 0000007593^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989961] iwl3945 0000:03:00.0: 0000007597^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.989994] iwl3945 0000:03:00.0: 0000007601^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990027] iwl3945 0000:03:00.0: 0000007606^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990060] iwl3945 0000:03:00.0: 0000007610^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990092] iwl3945 0000:03:00.0: 0000007614^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990125] iwl3945 0000:03:00.0: 0000007618^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990158] iwl3945 0000:03:00.0: 0000007623^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990191] iwl3945 0000:03:00.0: 0000007627^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990224] iwl3945 0000:03:00.0: 0000007631^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990258] iwl3945 0000:03:00.0: 0000007635^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990291] iwl3945 0000:03:00.0: 0000007640^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990323] iwl3945 0000:03:00.0: 0000007644^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990356] iwl3945 0000:03:00.0: 0000007648^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007653^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007657^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007661^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007665^I0x00000001^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007666^I0x0000000f^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007668^I0x000003b8^I1105
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007671^I0x000004e8^I1115
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007675^I0x0000000b^I0463
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007676^I0x0000000b^I0462
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007687^I0x0000010c^I0601
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 0000007698^I0x042d0014^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039281^I0x0000010f^I0603
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039358^I0x00000180^I0604
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039360^I0x0000019c^I0610
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039361^I0x000060c0^I0610
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039362^I0x00000000^I0610
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039410^I0x00000500^I0600
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040912^I0x000001ed^I0616
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039404^I0x00006094^I0638
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039427^I0x0000001c^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039460^I0x0000001a^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039487^I0x000000ff^I1103
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039488^I0xffff9111^I1103
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039490^I0x00000010^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039508^I0x00000011^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039521^I0x00000000^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039522^I0x00000000^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039524^I0x000001d8^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039526^I0x00000065^I1104
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039528^I0x0000000e^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039529^I0x00680034^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039530^I0x00670035^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039532^I0x007e0036^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039534^I0x007c0037^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039535^I0x00000038^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039537^I0x00840052^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039538^I0x00840053^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039540^I0x007e0054^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039541^I0x007d0055^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039543^I0x00000056^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039544^I0x00007050^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039546^I0x00017051^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039548^I0x00008204^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039550^I0x00018205^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039553^I0x00000001^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039554^I0x008b0063^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039556^I0x0000001d^I1104
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039558^I0x00000069^I1114
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039579^I0x0000020f^I0605
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039580^I0x0000026b^I0621
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039584^I0x0000010b^I1108
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039586^I0x0000000e^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039587^I0x00680034^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039588^I0x00670035^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039590^I0x007e0036^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039591^I0x007c0037^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039593^I0x00000038^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039594^I0x00840052^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039596^I0x00840053^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039597^I0x007e0054^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039599^I0x007d0055^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039600^I0x00000056^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039602^I0x00007050^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039604^I0x00017051^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039606^I0x00008204^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039608^I0x00018205^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039611^I0x00000001^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039612^I0x008b0063^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039614^I0x0000001c^I1104
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039615^I0x00000002^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039616^I0x0083903f^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039618^I0x0001d213^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039621^I0x00000002^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039622^I0x0003d206^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039624^I0x0083903e^I1102
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039628^I0x00000059^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039728^I0x00000013^I1101
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134039746^I0x00000005^I1107
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040314^I0x00005d07^I1110
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040325^I0xffffff69^I0454
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040326^I0x00000000^I0472
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040336^I0x0000000b^I0463
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040339^I0xffffff69^I1111
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040344^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040344^I0x0000000e^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040349^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040353^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040357^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040361^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040366^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040370^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040374^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040379^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040383^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040387^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040391^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040396^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040400^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040404^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040408^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040413^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040417^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040421^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040426^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040430^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040434^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040438^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040443^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040447^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040451^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040455^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040460^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040464^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040468^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040473^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040477^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040481^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040485^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040490^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040494^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040498^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040502^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040507^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040511^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040515^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040520^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040524^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040528^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040532^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040537^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040541^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040545^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040550^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040554^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040558^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040562^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040567^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040571^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040575^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040579^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040584^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040588^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040592^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040597^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040601^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040605^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040609^I0x00000000^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040614^I0x00000001^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040614^I0x0000000f^I1106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040616^I0x0000040a^I1105
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040619^I0x000004e8^I1115
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040623^I0x0000000b^I0463
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040624^I0x0000000b^I0462
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040636^I0x0000010c^I0601
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040646^I0x042e0010^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040649^I0x00000183^I0601
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040674^I0x000004bc^I0506
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040675^I0x0000046a^I0506
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040707^I0x000000aa^I0103
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040716^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040718^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040794^I0x00000010^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040804^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040812^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040814^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040882^I0x00000011^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040892^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040899^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040901^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040976^I0x00000012^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040987^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040994^I0x042f0097^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134040997^I0x0000000b^I0451
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134041016^I0x00000000^I0451
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134041192^I0x04300018^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134041329^I0x04310047^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134041509^I0x04320047^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134041652^I0x04330013^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042126^I0x0002001c^I0206
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042128^I0x00000001^I0204
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042131^I0x00000001^I0219
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042132^I0x00020041^I0211
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042137^I0x00000000^I0212
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042485^I0x00000000^I0215
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042559^I0x00000008^I0220
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042577^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042845^I0x000000d4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042887^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042889^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042925^I0x00000001^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134042941^I0x04340048^I0401
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043086^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043088^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043114^I0x00000002^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043140^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043142^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043150^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043164^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043166^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043200^I0x00000003^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043291^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043293^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043296^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043331^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043333^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043370^I0x00000004^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043386^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043387^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043424^I0x00000005^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043882^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134043884^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044075^I0x000000c4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044088^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044090^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044121^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044155^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044157^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044177^I0x00000002^I0357
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044178^I0x00000006^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044437^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044439^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044631^I0x000000c4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044649^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044651^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044673^I0x00000007^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044700^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044702^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134044730^I0x000000d4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048051^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048053^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048243^I0x000000c4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048256^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048258^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048289^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048323^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048325^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048345^I0x00000004^I0357
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048346^I0x00000008^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048526^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048528^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048723^I0x000000c4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048789^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048791^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134048822^I0x000000d4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134051795^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134051797^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134051803^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134054438^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134054440^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134054781^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063095^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063096^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063105^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063115^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063117^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063121^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063162^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063163^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063171^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063189^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063190^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063199^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063221^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063223^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063228^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063243^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063245^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063285^I0x00000009^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063302^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063303^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063323^I0x0000000a^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063344^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063346^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063389^I0x0000000b^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063404^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063406^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134063427^I0x0000000c^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134078599^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134078600^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134078975^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134079562^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134079563^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134079937^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082665^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082667^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082739^I0x00000013^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082750^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082756^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082758^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082837^I0x00000014^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082848^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082854^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134082856^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134083088^I0x00000015^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134083099^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134083904^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134083906^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134084286^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134114873^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134114874^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134114897^I0x0000000d^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134114968^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134114969^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115010^I0x0000000e^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115040^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115041^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115083^I0x0000000f^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115474^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115475^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134115854^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134122342^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134122344^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134122725^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134124705^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134124707^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134125085^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134131420^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134131422^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134131498^I0x00000016^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134131509^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134133105^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134133106^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134133111^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134134832^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134134833^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135025^I0x00000017^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135094^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135096^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135126^I0x000000d4^I0303
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135129^I0x00000005^I0357
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135841^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135842^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135915^I0x00000018^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134135926^I0x00000000^I0352
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138670^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138672^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138696^I0x00000010^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138889^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138891^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138912^I0x00000011^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138927^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138929^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134138933^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139068^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139070^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139078^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139144^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139145^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139171^I0x00000012^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139200^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139201^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139210^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139344^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139345^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139367^I0x00000013^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139459^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139460^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134139494^I0x00000014^I0353
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134142306^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134142307^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134142687^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134144502^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134144503^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134144879^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134145801^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134145803^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134146180^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134147834^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134147836^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134148206^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134156819^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134156820^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134157181^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134170944^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134170946^I0x00000000^I0302
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134170954^I0x00008000^I0350
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134180892^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134180894^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134181274^I0x00000000^I0304
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134184601^I0x000000d9^I0106
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134184602^I0x00000000^I0301
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134184978^I0x00000080^I0313
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134184980^I0x000001fe^I0501
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134185240^I0x00000000^I0502
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134185279^I0x000000c3^I0310
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134185280^I0x00000000^I0314
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4134185282^I0x0000031a^I0501
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805784^I0x000003f8^I0504
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805785^I0xf6836358^I0503
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805786^I0x00000039^I0503
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805786^I0x03018ca8^I0503
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805787^I0xf66aa944^I0503
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805788^I0x00000039^I0503
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805789^I0x020146bc^I0503
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805791^I0x03018ca1^I0500
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805792^I0x03018ca1^I0600
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805793^I0x00000000^I0600
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805812^I0x000000a2^I0600
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805826^I0x03000190^I0630
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805826^I0x04017c78^I0630
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: 4135805863^I0x00000100^I0125
Mar  9 21:25:04 rainbow kernel: [17666.990374] ieee80211 phy12: I iwl3945_irq_handle_error Restarting adapter due to uCode error.
Mar  9 21:25:04 rainbow kernel: [17666.990374] ieee80211 phy12: I iwl3945_rx_handle r = 161, i = 160, REPLY_ERROR, 0x02
Mar  9 21:25:04 rainbow kernel: [17666.990374] iwl3945 0000:03:00.0: Error Reply type 0x00000000 cmd REPLY_LEDS_CMD (0x48) seq 0x0434 ser 0x00000000
Mar  9 21:25:04 rainbow kernel: [17667.007939] iwl3945 0000:03:00.0: Can't stop Rx DMA.
Mar  9 21:25:04 rainbow kernel: [17667.030464] ieee80211 phy12: I iwl3945_rx_handle r = 1, i = 0, REPLY_ALIVE, 0x01
Mar  9 21:25:04 rainbow kernel: [17667.044774] ieee80211 phy12: I iwl3945_rx_handle r = 2, i = 1, REPLY_ALIVE, 0x01
Mar  9 21:25:04 rainbow kernel: [17667.057467] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command POWER_TABLE_CMD (#77), seq: 0x0400, 36 bytes at 0[0]:4
Mar  9 21:25:04 rainbow kernel: [17667.057551] ieee80211 phy12: I iwl3945_rx_handle r 3 i 2 No handler needed for POWER_TABLE_CMD, 0x77
Mar  9 21:25:04 rainbow kernel: [17667.057624] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_BT_CONFIG (#9b), seq: 0x0401, 16 bytes at 1[1]:4
Mar  9 21:25:04 rainbow kernel: [17667.059423] ieee80211 phy12: I iwl3945_rx_handle r 4 i 3 No handler needed for REPLY_BT_CONFIG, 0x9b
Mar  9 21:25:04 rainbow kernel: [17667.059449] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0402, 48 bytes at 2[2]:4
Mar  9 21:25:04 rainbow kernel: [17667.062362] ieee80211 phy12: I iwl3945_rx_handle r 5 i 4 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:04 rainbow kernel: [17667.062372] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0403, 56 bytes at 3[3]:4
Mar  9 21:25:04 rainbow kernel: [17667.062472] ieee80211 phy12: I iwl3945_rx_handle r 6 i 5 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:04 rainbow kernel: [17667.062506] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x0404, 68 bytes at 4[4]:4
Mar  9 21:25:04 rainbow kernel: [17667.062619] ieee80211 phy12: I iwl3945_rx_handle r = 7, i = 6, REPLY_ADD_STA, 0x18
Mar  9 21:25:04 rainbow kernel: [17667.062627] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0405, 56 bytes at 5[5]:4
Mar  9 21:25:04 rainbow kernel: [17667.062703] ieee80211 phy12: I iwl3945_rx_handle r 8 i 7 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:04 rainbow kernel: [17667.062735] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x0406, 56 bytes at 6[6]:4
Mar  9 21:25:04 rainbow kernel: [17667.062846] ieee80211 phy12: I iwl3945_rx_handle r 9 i 8 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:04 rainbow kernel: [17667.062903] Registered led device: iwl-phy12:radio
Mar  9 21:25:04 rainbow kernel: [17667.062906] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_LEDS_CMD (#48), seq: 0x0407, 12 bytes at 7[7]:4
Mar  9 21:25:04 rainbow kernel: [17667.062950] Registered led device: iwl-phy12:assoc
Mar  9 21:25:04 rainbow kernel: [17667.062965] Registered led device: iwl-phy12:RX
Mar  9 21:25:04 rainbow kernel: [17667.062978] Registered led device: iwl-phy12:TX
Mar  9 21:25:04 rainbow kernel: [17667.062981] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RXON (#10), seq: 0x0408, 48 bytes at 8[8]:4
Mar  9 21:25:04 rainbow kernel: [17667.062984] ieee80211 phy12: I iwl3945_rx_handle r 10 i 9 No handler needed for REPLY_LEDS_CMD, 0x48
Mar  9 21:25:04 rainbow kernel: [17667.063234] ieee80211 phy12: I iwl3945_rx_handle r 11 i 10 No handler needed for REPLY_RXON, 0x10
Mar  9 21:25:04 rainbow kernel: [17667.063766] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_TX_PWR_TABLE_CMD (#97), seq: 0x0409, 56 bytes at 9[9]:4
Mar  9 21:25:04 rainbow kernel: [17667.066069] ieee80211 phy12: I iwl3945_rx_handle r 12 i 11 No handler needed for REPLY_TX_PWR_TABLE_CMD, 0x97
Mar  9 21:25:04 rainbow kernel: [17667.066133] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040A, 68 bytes at 10[10]:4
Mar  9 21:25:04 rainbow kernel: [17667.069350] ieee80211 phy12: I iwl3945_rx_handle r = 13, i = 12, REPLY_ADD_STA, 0x18
Mar  9 21:25:04 rainbow kernel: [17667.069360] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040B, 56 bytes at 11[11]:4
Mar  9 21:25:04 rainbow kernel: [17667.072545] ieee80211 phy12: I iwl3945_rx_handle r 14 i 13 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:04 rainbow kernel: [17667.072583] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_RATE_SCALE (#47), seq: 0x040C, 56 bytes at 12[12]:4
Mar  9 21:25:04 rainbow kernel: [17667.075746] ieee80211 phy12: I iwl3945_rx_handle r 15 i 14 No handler needed for REPLY_RATE_SCALE, 0x47
Mar  9 21:25:04 rainbow kernel: [17667.078037] ieee80211 phy12: U iwl3945_enqueue_hcmd Sending command REPLY_ADD_STA (#18), seq: 0x040D, 68 bytes at 13[13]:4
Mar  9 21:25:04 rainbow kernel: [17667.088537] ieee80211 phy12: I iwl3945_rx_handle r = 16, i = 15, REPLY_ADD_STA, 0x18
Mar  9 21:25:12 rainbow kernel: [17674.892151] iwl3945 0000:03:00.0: MAC is in deep sleep!
Mar  9 21:25:12 rainbow kernel: [17674.892684] iwl3945 0000:03:00.0: MAC is in deep sleep!
Mar  9 21:25:12 rainbow kernel: [17674.892780] iwl3945 0000:03:00.0: MAC is in deep sleep!

