Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:42198 "EHLO
        one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163697AbdDXAyG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Apr 2017 20:54:06 -0400
Date: Sun, 23 Apr 2017 17:54:01 -0700
From: Andi Kleen <andi@firstfloor.org>
To: linuxwifi@intel.com, linux-wireless@vger.kernel.org
Subject: 4.11-rc* iwlwifi instable
Message-ID: <20170424005400.GK22592@two.firstfloor.org> (sfid-20170424_025415_117885_EDA2E2FB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

Since I updated my laptop to 4.11-rc* the wireless is fairly instable
(I think it was already less stable with 4.10 than with 4.8, but no
clear data) 

For example it locked up (no more wireless) with a warn on while connecting
and actually needed a reboot to recover (reloading modules was not
enough)

Any fixes/workarounds?

Thanks,
-Andi

03:00.0 Network controller: Intel Corporation Wireless 7265 (rev 59)

Here's a log of when it locked up:


[63332.119593] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[63332.120046] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[63332.193635] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[63332.194358] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[63335.915939] wlan0: authenticate with 00:26:f2:3c:e3:0a
[63335.922642] wlan0: send auth to 00:26:f2:3c:e3:0a (try 1/3)
[63335.924455] wlan0: authenticated
[63335.925177] wlan0: associate with 00:26:f2:3c:e3:0a (try 1/3)
[63335.927801] wlan0: RX AssocResp from 00:26:f2:3c:e3:0a (capab=0x431 status=0 aid=2)
[63335.929443] wlan0: associated
[63335.935572] iwlwifi 0000:03:00.0: set key failed
[63388.609403] IPv6: ADDRCONF(NETDEV_CHANGE): vpn0: link becomes ready
[63389.418959] IPv6: ADDRCONF(NETDEV_CHANGE): vpn0: link becomes ready
[63770.892368] [drm:hsw_disable_ips [i915]] *ERROR* Timed out waiting for IPS disable
[67270.718504] iwlwifi 0000:03:00.0: regular scan timed out
[67288.638077] iwlwifi 0000:03:00.0: Queue 2 stuck for 10000 ms.
[67288.638102] iwlwifi 0000:03:00.0: Current SW read_ptr 48 write_ptr 53
[67288.638281] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[67288.638443] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[67288.638510] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x80102034
[67288.638574] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x80201013
[67288.638639] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300003
[67288.638704] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[67288.638769] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[67288.638834] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[67288.638900] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090ce
[67288.639005] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [4,4]
[67288.639109] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [20,20]
[67288.639212] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [48,53]
[67288.639315] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.639419] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.639523] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.639626] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.639730] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.639833] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.639936] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [207,207]
[67288.640040] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640143] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640247] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640350] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640453] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640557] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[67288.640660] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640763] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640866] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.640969] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641073] iwlwifi 0000:03:00.0: Q 20 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641176] iwlwifi 0000:03:00.0: Q 21 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641279] iwlwifi 0000:03:00.0: Q 22 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641382] iwlwifi 0000:03:00.0: Q 23 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641486] iwlwifi 0000:03:00.0: Q 24 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641589] iwlwifi 0000:03:00.0: Q 25 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641692] iwlwifi 0000:03:00.0: Q 26 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641795] iwlwifi 0000:03:00.0: Q 27 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.641898] iwlwifi 0000:03:00.0: Q 28 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.642002] iwlwifi 0000:03:00.0: Q 29 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67288.642105] iwlwifi 0000:03:00.0: Q 30 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[67715.006135] IPv6: ADDRCONF(NETDEV_CHANGE): vpn0: link becomes ready
[70583.073904] wlan0: deauthenticating from 00:26:f2:3c:e3:0a by local choice (Reason: 3=DEAUTH_LEAVING)
[70585.074101] iwlwifi 0000:03:00.0: Error sending MAC_CONTEXT_CMD: time out after 2000ms.
[70585.074103] iwlwifi 0000:03:00.0: Current CMD queue read_ptr 207 write_ptr 208
[70585.074356] iwlwifi 0000:03:00.0: Loaded firmware version: 21.302800.0
[70585.074358] iwlwifi 0000:03:00.0: 0x00000000 | ADVANCED_SYSASSERT          
[70585.074359] iwlwifi 0000:03:00.0: 0x00000000 | trm_hw_status0
[70585.074360] iwlwifi 0000:03:00.0: 0x00000000 | trm_hw_status1
[70585.074362] iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
[70585.074363] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
[70585.074364] iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
[70585.074365] iwlwifi 0000:03:00.0: 0x00000000 | data1
[70585.074366] iwlwifi 0000:03:00.0: 0x00000000 | data2
[70585.074367] iwlwifi 0000:03:00.0: 0x00000000 | data3
[70585.074368] iwlwifi 0000:03:00.0: 0x00000000 | beacon time
[70585.074369] iwlwifi 0000:03:00.0: 0x00000000 | tsf low
[70585.074370] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
[70585.074371] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
[70585.074372] iwlwifi 0000:03:00.0: 0x00000000 | time gp2
[70585.074374] iwlwifi 0000:03:00.0: 0x00000000 | uCode revision type
[70585.074375] iwlwifi 0000:03:00.0: 0x00000000 | uCode version major
[70585.074376] iwlwifi 0000:03:00.0: 0x00000000 | uCode version minor
[70585.074377] iwlwifi 0000:03:00.0: 0x00000000 | hw version
[70585.074378] iwlwifi 0000:03:00.0: 0x00000000 | board version
[70585.074379] iwlwifi 0000:03:00.0: 0x00000000 | hcmd
[70585.074380] iwlwifi 0000:03:00.0: 0x00000000 | isr0
[70585.074381] iwlwifi 0000:03:00.0: 0x00000000 | isr1
[70585.074382] iwlwifi 0000:03:00.0: 0x00000000 | isr2
[70585.074383] iwlwifi 0000:03:00.0: 0x00000000 | isr3
[70585.074384] iwlwifi 0000:03:00.0: 0x00000000 | isr4
[70585.074386] iwlwifi 0000:03:00.0: 0x00000000 | last cmd Id
[70585.074387] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
[70585.074388] iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
[70585.074389] iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
[70585.074390] iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
[70585.074391] iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
[70585.074392] iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
[70585.074393] iwlwifi 0000:03:00.0: 0x00000000 | timestamp
[70585.074395] iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
[70585.074406] ieee80211 phy0: Hardware restart was requested
[70585.074414] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -110
[70585.074416] iwlwifi 0000:03:00.0: failed to update MAC 5c:e0:c5:b0:19:a4
[70585.074421] iwlwifi 0000:03:00.0: failed to update power mode
[70585.074468] iwlwifi 0000:03:00.0: Failed to send flush command (-5)
[70585.074470] iwlwifi 0000:03:00.0: flush request fail
[70585.586124] iwlwifi 0000:03:00.0: Queue 9 stuck for 2500 ms.
[70585.586161] iwlwifi 0000:03:00.0: Current SW read_ptr 207 write_ptr 208
[70585.586324] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[70585.586381] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[70585.586432] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x8010203f
[70585.586483] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x80201013
[70585.586534] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300003
[70585.586586] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[70585.586641] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[70585.586697] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[70585.586752] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090cf
[70585.586819] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [4,4]
[70585.586886] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [20,20]
[70585.586953] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [48,17]
[70585.587020] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587087] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587154] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587215] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587277] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587340] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587402] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [207,208]
[70585.587469] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587530] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587592] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587654] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587716] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587779] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[70585.587845] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587907] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.587974] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588035] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588104] iwlwifi 0000:03:00.0: Q 20 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588170] iwlwifi 0000:03:00.0: Q 21 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588237] iwlwifi 0000:03:00.0: Q 22 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588305] iwlwifi 0000:03:00.0: Q 23 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588372] iwlwifi 0000:03:00.0: Q 24 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588434] iwlwifi 0000:03:00.0: Q 25 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588501] iwlwifi 0000:03:00.0: Q 26 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588562] iwlwifi 0000:03:00.0: Q 27 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588629] iwlwifi 0000:03:00.0: Q 28 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588691] iwlwifi 0000:03:00.0: Q 29 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70585.588754] iwlwifi 0000:03:00.0: Q 30 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.075238] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
[70587.075244] iwlwifi 0000:03:00.0: Current SW read_ptr 48 write_ptr 17
[70587.075410] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[70587.075466] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[70587.075521] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x8010203f
[70587.075575] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x80201013
[70587.075630] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300003
[70587.075686] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[70587.075741] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[70587.075796] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[70587.075851] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090cf
[70587.075920] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [4,4]
[70587.075989] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [20,20]
[70587.076269] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [48,17]
[70587.076438] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.076511] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.076583] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.076654] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.076726] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.076797] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.076868] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [207,208]
[70587.076939] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077009] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077193] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077264] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077335] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077406] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[70587.077477] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077547] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077617] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077688] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077758] iwlwifi 0000:03:00.0: Q 20 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077828] iwlwifi 0000:03:00.0: Q 21 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077899] iwlwifi 0000:03:00.0: Q 22 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.077969] iwlwifi 0000:03:00.0: Q 23 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078202] iwlwifi 0000:03:00.0: Q 24 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078273] iwlwifi 0000:03:00.0: Q 25 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078344] iwlwifi 0000:03:00.0: Q 26 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078414] iwlwifi 0000:03:00.0: Q 27 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078484] iwlwifi 0000:03:00.0: Q 28 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078554] iwlwifi 0000:03:00.0: Q 29 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078625] iwlwifi 0000:03:00.0: Q 30 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70587.078757] wlan0: failed to remove key (0, 00:26:f2:3c:e3:0a) from hardware (-5)
[70587.078829] ------------[ cut here ]------------
[70587.078855] WARNING: CPU: 2 PID: 1084 at /home/ak/lsrc/git/linux-2.6/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:2652 iwl_mvm_mac_sta_state+0x524/0x590 [iwlmvm]
[70587.078856] Modules linked in: ctr ccm simple_pt(O) cmac fuse ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat af_packet tun nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic arc4 snd_hda_intel snd_hda_codec x86_pkg_temp_thermal iTCO_wdt snd_hwdep iTCO_vendor_support snd_hda_core coretemp snd_pcm kvm_intel kvm irqbypass snd_seq iwlmvm mac80211 snd_timer snd_seq_device joydev pcspkr serio_raw
[70587.078975]  btusb btrtl i2c_i801 btbcm btintel bluetooth iwlwifi cfg80211 battery rtsx_pci_ms snd ac memstick rfkill thermal wmi e1000e mei_me tpm_tis soundcore tpm_tis_core ptp mei tpm pps_core lpc_ich dm_crypt rtsx_pci_sdmmc mmc_core crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper rtsx_pci mfd_core i915 xhci_pci xhci_hcd i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm video button dm_mod sg autofs4 [last unloaded: test_ftrace]
[70587.079105] CPU: 2 PID: 1084 Comm: NetworkManager Tainted: G           O    4.11.0-rc7-odilo+ #45
[70587.079108] Hardware name: LENOVO 20CMCTO1WW/20CMCTO1WW, BIOS N10ET33W (1.12 ) 04/06/2015
[70587.079110] Call Trace:
[70587.079124]  dump_stack+0x4d/0x6e
[70587.079133]  __warn+0xd1/0xf0
[70587.079141]  warn_slowpath_null+0x1d/0x20
[70587.079163]  iwl_mvm_mac_sta_state+0x524/0x590 [iwlmvm]
[70587.079215]  drv_sta_state+0x84/0x460 [mac80211]
[70587.079261]  sta_info_move_state+0x76/0x230 [mac80211]
[70587.079305]  __sta_info_destroy_part2+0x57/0x190 [mac80211]
[70587.079349]  __sta_info_flush+0xf5/0x1a0 [mac80211]
[70587.079407]  ieee80211_set_disassoc+0xbd/0x500 [mac80211]
[70587.079463]  ieee80211_mgd_deauth+0xfb/0x210 [mac80211]
[70587.079518]  ieee80211_deauth+0x18/0x20 [mac80211]
[70587.079567]  cfg80211_mlme_deauth+0x8f/0x1c0 [cfg80211]
[70587.079611]  cfg80211_mlme_down+0x5c/0x60 [cfg80211]
[70587.079650]  cfg80211_disconnect+0x1ad/0x1d0 [cfg80211]
[70587.079686]  __cfg80211_leave+0x8f/0x120 [cfg80211]
[70587.079723]  cfg80211_leave+0x2b/0x40 [cfg80211]
[70587.079754]  cfg80211_netdev_notifier_call+0x3f3/0x600 [cfg80211]
[70587.079765]  ? rfkill_fop_open+0x1cd/0x1f0 [rfkill]
[70587.079775]  ? misc_open+0xbd/0x160
[70587.079783]  ? inetdev_event+0x28/0x4d0
[70587.079793]  ? skb_dequeue+0x59/0x70
[70587.079803]  notifier_call_chain+0x49/0x70
[70587.079809]  raw_notifier_call_chain+0x16/0x20
[70587.079815]  call_netdevice_notifiers_info+0x35/0x60
[70587.079820]  __dev_close_many+0x3a/0xc0
[70587.079825]  dev_close_many+0x82/0x120
[70587.079831]  dev_close.part.103+0x3b/0x50
[70587.079836]  dev_close+0x1a/0x20
[70587.079867]  cfg80211_shutdown_all_interfaces+0x45/0xc0 [cfg80211]
[70587.079901]  cfg80211_rfkill_set_block+0x26/0x30 [cfg80211]
[70587.079909]  rfkill_set_block+0x90/0x160 [rfkill]
[70587.079916]  rfkill_fop_write+0xcd/0x190 [rfkill]
[70587.079922]  __vfs_write+0x28/0x120
[70587.079927]  vfs_write+0xb2/0x1b0
[70587.079932]  SyS_write+0x46/0xa0
[70587.079938]  entry_SYSCALL_64_fastpath+0x17/0x98
[70587.079942] RIP: 0033:0x7fc2bb47ca1d
[70587.079945] RSP: 002b:00007ffcef40b6a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[70587.079950] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fc2bb47ca1d
[70587.079968] RDX: 0000000000000008 RSI: 00007ffcef40b6d0 RDI: 0000000000000015
[70587.079970] RBP: 00007ffcef40b748 R08: 00000000019a9ca0 R09: 0000000000000050
[70587.079973] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fc2be5d4788
[70587.079975] R13: 0000000001b5dba0 R14: 0000000001ab2d90 R15: 0000000000000000
[70587.079981] ---[ end trace 849fd714e415994d ]---
[70587.079990] ------------[ cut here ]------------
[70587.080040] WARNING: CPU: 2 PID: 1084 at /home/ak/lsrc/git/linux-2.6/net/mac80211/sta_info.c:964 __sta_info_destroy_part2+0x183/0x190 [mac80211]
[70587.080058] Modules linked in: ctr ccm simple_pt(O) cmac fuse ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat af_packet tun nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic arc4 snd_hda_intel snd_hda_codec x86_pkg_temp_thermal iTCO_wdt snd_hwdep iTCO_vendor_support snd_hda_core coretemp snd_pcm kvm_intel kvm irqbypass snd_seq iwlmvm mac80211 snd_timer snd_seq_device joydev pcspkr serio_raw
[70587.080148]  btusb btrtl i2c_i801 btbcm btintel bluetooth iwlwifi cfg80211 battery rtsx_pci_ms snd ac memstick rfkill thermal wmi e1000e mei_me tpm_tis soundcore tpm_tis_core ptp mei tpm pps_core lpc_ich dm_crypt rtsx_pci_sdmmc mmc_core crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper rtsx_pci mfd_core i915 xhci_pci xhci_hcd i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm video button dm_mod sg autofs4 [last unloaded: test_ftrace]
[70587.080221] CPU: 2 PID: 1084 Comm: NetworkManager Tainted: G        W  O    4.11.0-rc7-odilo+ #45
[70587.080223] Hardware name: LENOVO 20CMCTO1WW/20CMCTO1WW, BIOS N10ET33W (1.12 ) 04/06/2015
[70587.080224] Call Trace:
[70587.080232]  dump_stack+0x4d/0x6e
[70587.080239]  __warn+0xd1/0xf0
[70587.080246]  warn_slowpath_null+0x1d/0x20
[70587.080287]  __sta_info_destroy_part2+0x183/0x190 [mac80211]
[70587.080329]  __sta_info_flush+0xf5/0x1a0 [mac80211]
[70587.080378]  ieee80211_set_disassoc+0xbd/0x500 [mac80211]
[70587.080425]  ieee80211_mgd_deauth+0xfb/0x210 [mac80211]
[70587.080476]  ieee80211_deauth+0x18/0x20 [mac80211]
[70587.080518]  cfg80211_mlme_deauth+0x8f/0x1c0 [cfg80211]
[70587.080562]  cfg80211_mlme_down+0x5c/0x60 [cfg80211]
[70587.080605]  cfg80211_disconnect+0x1ad/0x1d0 [cfg80211]
[70587.080636]  __cfg80211_leave+0x8f/0x120 [cfg80211]
[70587.080671]  cfg80211_leave+0x2b/0x40 [cfg80211]
[70587.080707]  cfg80211_netdev_notifier_call+0x3f3/0x600 [cfg80211]
[70587.080715]  ? rfkill_fop_open+0x1cd/0x1f0 [rfkill]
[70587.080724]  ? misc_open+0xbd/0x160
[70587.080731]  ? inetdev_event+0x28/0x4d0
[70587.080737]  ? skb_dequeue+0x59/0x70
[70587.080745]  notifier_call_chain+0x49/0x70
[70587.080752]  raw_notifier_call_chain+0x16/0x20
[70587.080757]  call_netdevice_notifiers_info+0x35/0x60
[70587.080762]  __dev_close_many+0x3a/0xc0
[70587.080768]  dev_close_many+0x82/0x120
[70587.080774]  dev_close.part.103+0x3b/0x50
[70587.080779]  dev_close+0x1a/0x20
[70587.080810]  cfg80211_shutdown_all_interfaces+0x45/0xc0 [cfg80211]
[70587.080845]  cfg80211_rfkill_set_block+0x26/0x30 [cfg80211]
[70587.080852]  rfkill_set_block+0x90/0x160 [rfkill]
[70587.080859]  rfkill_fop_write+0xcd/0x190 [rfkill]
[70587.080864]  __vfs_write+0x28/0x120
[70587.080869]  vfs_write+0xb2/0x1b0
[70587.080874]  SyS_write+0x46/0xa0
[70587.080882]  entry_SYSCALL_64_fastpath+0x17/0x98
[70587.080886] RIP: 0033:0x7fc2bb47ca1d
[70587.080888] RSP: 002b:00007ffcef40b6a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[70587.080894] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fc2bb47ca1d
[70587.080897] RDX: 0000000000000008 RSI: 00007ffcef40b6d0 RDI: 0000000000000015
[70587.080899] RBP: 00007ffcef40b748 R08: 00000000019a9ca0 R09: 0000000000000050
[70587.080902] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fc2be5d4788
[70587.080905] R13: 0000000001b5dba0 R14: 0000000001ab2d90 R15: 0000000000000000
[70587.080911] ---[ end trace 849fd714e415994e ]---
[70587.081570] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -5
[70587.081571] iwlwifi 0000:03:00.0: failed to update MAC 5c:e0:c5:b0:19:a4
[70587.081573] iwlwifi 0000:03:00.0: Failed to remove station. Id=0
[70587.081574] iwlwifi 0000:03:00.0: failed to remove AP station
[70587.081575] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -5
[70587.081577] iwlwifi 0000:03:00.0: failed to update MAC 5c:e0:c5:b0:19:a4 (clear after unassoc)
[70587.081581] iwlwifi 0000:03:00.0: failed to update power mode
[70587.081585] iwlwifi 0000:03:00.0: Failed to send binding (action:3): -5
[70587.081587] iwlwifi 0000:03:00.0: Failed to send MAC context (action:2): -5
[70587.081588] iwlwifi 0000:03:00.0: failed to update MAC 5c:e0:c5:b0:19:a4
[70587.082380] iwlwifi 0000:03:00.0: Failed to send flush command (-5)
[70589.084429] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 2
[70589.084435] iwlwifi 0000:03:00.0: Current SW read_ptr 48 write_ptr 17
[70589.084601] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
[70589.084658] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[70589.084712] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x8010203f
[70589.084767] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x80201013
[70589.084822] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x80300003
[70589.084877] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[70589.084932] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[70589.085060] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[70589.085218] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x007090cf
[70589.085291] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [4,4]
[70589.085362] iwlwifi 0000:03:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [20,20]
[70589.085431] iwlwifi 0000:03:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [48,17]
[70589.085502] iwlwifi 0000:03:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.085573] iwlwifi 0000:03:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.085644] iwlwifi 0000:03:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.085715] iwlwifi 0000:03:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.085786] iwlwifi 0000:03:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.085857] iwlwifi 0000:03:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.085930] iwlwifi 0000:03:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [207,208]
[70589.086411] iwlwifi 0000:03:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.086478] iwlwifi 0000:03:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.086545] iwlwifi 0000:03:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.086664] iwlwifi 0000:03:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.086731] iwlwifi 0000:03:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.086798] iwlwifi 0000:03:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
[70589.086867] iwlwifi 0000:03:00.0: Q 16 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.086935] iwlwifi 0000:03:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087058] iwlwifi 0000:03:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087126] iwlwifi 0000:03:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087193] iwlwifi 0000:03:00.0: Q 20 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087260] iwlwifi 0000:03:00.0: Q 21 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087327] iwlwifi 0000:03:00.0: Q 22 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087394] iwlwifi 0000:03:00.0: Q 23 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087461] iwlwifi 0000:03:00.0: Q 24 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087528] iwlwifi 0000:03:00.0: Q 25 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087596] iwlwifi 0000:03:00.0: Q 26 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087663] iwlwifi 0000:03:00.0: Q 27 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087729] iwlwifi 0000:03:00.0: Q 28 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087845] iwlwifi 0000:03:00.0: Q 29 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087913] iwlwifi 0000:03:00.0: Q 30 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
[70589.087948] iwlwifi 0000:03:00.0: Failed to remove MAC context: -5
[70589.087952] iwlwifi 0000:03:00.0: Failed to disable queue 0 (ret=-5)
[70589.087954] iwlwifi 0000:03:00.0: Failed to disable queue 1 (ret=-5)
[70589.088144] ------------[ cut here ]------------
[70589.088161] WARNING: CPU: 1 PID: 1084 at /home/ak/lsrc/git/linux-2.6/drivers/net/wireless/intel/iwlwifi/mvm/ops.c:1046 iwl_mvm_start_mac_queues+0xc7/0xe0 [iwlmvm]
[70589.088162] Modules linked in: ctr ccm simple_pt(O) cmac fuse ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat af_packet tun nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG xt_limit ip6t_REJECT nf_reject_ipv6 xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ipt_REJECT nf_reject_ipv4 iptable_raw xt_CT iptable_filter ip6table_mangle nf_conntrack_netbios_ns nf_conntrack_broadcast nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables xt_conntrack nf_conntrack ip6table_filter ip6_tables x_tables bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic arc4 snd_hda_intel snd_hda_codec x86_pkg_temp_thermal iTCO_wdt snd_hwdep iTCO_vendor_support snd_hda_core coretemp snd_pcm kvm_intel kvm irqbypass snd_seq iwlmvm mac80211 snd_timer snd_seq_device joydev pcspkr serio_raw
[70589.088217]  btusb btrtl i2c_i801 btbcm btintel bluetooth iwlwifi cfg80211 battery rtsx_pci_ms snd ac memstick rfkill thermal wmi e1000e mei_me tpm_tis soundcore tpm_tis_core ptp mei tpm pps_core lpc_ich dm_crypt rtsx_pci_sdmmc mmc_core crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 crypto_simd cryptd glue_helper rtsx_pci mfd_core i915 xhci_pci xhci_hcd i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm video button dm_mod sg autofs4 [last unloaded: test_ftrace]
[70589.088267] CPU: 1 PID: 1084 Comm: NetworkManager Tainted: G        W  O    4.11.0-rc7-odilo+ #45
[70589.088269] Hardware name: LENOVO 20CMCTO1WW/20CMCTO1WW, BIOS N10ET33W (1.12 ) 04/06/2015
[70589.088272] Call Trace:
[70589.088281]  dump_stack+0x4d/0x6e
[70589.088285]  __warn+0xd1/0xf0
[70589.088288]  warn_slowpath_null+0x1d/0x20
[70589.088298]  iwl_mvm_start_mac_queues+0xc7/0xe0 [iwlmvm]
[70589.088307]  iwl_mvm_wake_sw_queue+0x4a/0x60 [iwlmvm]
[70589.088315]  iwl_pcie_txq_unmap+0x22e/0x280 [iwlwifi]
[70589.088323]  iwl_trans_pcie_txq_disable+0xd4/0x1b0 [iwlwifi]
[70589.088333]  iwl_mvm_disable_txq+0x1a6/0x2c0 [iwlmvm]
[70589.088343]  iwl_mvm_mac_ctxt_release+0x85/0xa0 [iwlmvm]
[70589.088352]  iwl_mvm_mac_remove_interface+0xa0/0x120 [iwlmvm]
[70589.088371]  drv_remove_interface+0x3f/0x110 [mac80211]
[70589.088389]  ieee80211_do_stop+0x4fc/0x820 [mac80211]
[70589.088395]  ? _raw_spin_unlock_bh+0x1a/0x20
[70589.088415]  ieee80211_stop+0x1a/0x20 [mac80211]
[70589.088419]  __dev_close_many+0x79/0xc0
[70589.088425]  dev_close_many+0x82/0x120
[70589.088428]  dev_close.part.103+0x3b/0x50
[70589.088430]  dev_close+0x1a/0x20
[70589.088450]  cfg80211_shutdown_all_interfaces+0x45/0xc0 [cfg80211]
[70589.088467]  cfg80211_rfkill_set_block+0x26/0x30 [cfg80211]
[70589.088471]  rfkill_set_block+0x90/0x160 [rfkill]
[70589.088475]  rfkill_fop_write+0xcd/0x190 [rfkill]
[70589.088478]  __vfs_write+0x28/0x120
[70589.088481]  vfs_write+0xb2/0x1b0
[70589.088483]  SyS_write+0x46/0xa0
[70589.088486]  entry_SYSCALL_64_fastpath+0x17/0x98
[70589.088488] RIP: 0033:0x7fc2bb47ca1d
[70589.088490] RSP: 002b:00007ffcef40b6a0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
[70589.088492] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fc2bb47ca1d
[70589.088493] RDX: 0000000000000008 RSI: 00007ffcef40b6d0 RDI: 0000000000000015
[70589.088494] RBP: 00007ffcef40b748 R08: 00000000019a9ca0 R09: 0000000000000050
[70589.088496] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fc2be5d4788
[70589.088498] R13: 0000000001b5dba0 R14: 0000000001ab2d90 R15: 0000000000000000
[70589.088500] ---[ end trace 849fd714e415994f ]---
[70589.088503] iwlwifi 0000:03:00.0: Failed to disable queue 2 (ret=-5)
[70589.088506] iwlwifi 0000:03:00.0: Failed to disable queue 3 (ret=-5)
[70593.171075] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[70593.171635] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[70593.238254] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
[70593.238809] iwlwifi 0000:03:00.0: L1 Enabled - LTR Enabled
