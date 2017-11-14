Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.yrkesakademin.fi ([85.134.45.195]:25200 "EHLO
        mx2.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbdKNTt1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 14:49:27 -0500
To: <linux-wireless@vger.kernel.org>
CC: <luciano.coelho@intel.com>
From: Thomas Backlund <tmb@mageia.org>
Subject: iwlwifi 8265 firmware crash vith v34 on linux 4.14
Message-ID: <b533ecc1-c4ce-b0fc-b7fb-b7beceb1f1cf@mageia.org> (sfid-20171114_205019_196787_2BF24282)
Date: Tue, 14 Nov 2017 21:49:22 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Running a Lenovo Yoga 720 with kernel 4.14, I pulled the:
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git 
tags/iwlwifi-fw-2017-11-03

to try the new fw version 34 on my:
3f:00.0 Network controller [0280]: Intel Corporation Wireless 8265 / 
8275 [8086:24fd] (rev 78)

And got this firmware crash and no wifi working:
(for reference firmware version 31.560484.0 from same git pull works)


[   11.423208] iwlwifi 0000:3f:00.0: Error sending SCAN_REQ_UMAC: time 
out after 2000ms.
[   11.423211] iwlwifi 0000:3f:00.0: Current CMD queue read_ptr 39 
write_ptr 40
[   11.423362] iwlwifi 0000:3f:00.0: Start IWL Error Log Dump:
[   11.423363] iwlwifi 0000:3f:00.0: Status: 0x00000100, count: 6
[   11.423364] iwlwifi 0000:3f:00.0: Loaded firmware version: 34.0.1
[   11.423365] iwlwifi 0000:3f:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN 

[   11.423366] iwlwifi 0000:3f:00.0: 0x00A002F1 | trm_hw_status0
[   11.423366] iwlwifi 0000:3f:00.0: 0x00000000 | trm_hw_status1
[   11.423367] iwlwifi 0000:3f:00.0: 0x00023FDC | branchlink2
[   11.423368] iwlwifi 0000:3f:00.0: 0x0003915A | interruptlink1
[   11.423369] iwlwifi 0000:3f:00.0: 0x0003915A | interruptlink2
[   11.423369] iwlwifi 0000:3f:00.0: 0x00000000 | data1
[   11.423370] iwlwifi 0000:3f:00.0: 0x00000080 | data2
[   11.423371] iwlwifi 0000:3f:00.0: 0x07830000 | data3
[   11.423372] iwlwifi 0000:3f:00.0: 0x00201DA1 | beacon time
[   11.423372] iwlwifi 0000:3f:00.0: 0x001FE25D | tsf low
[   11.423373] iwlwifi 0000:3f:00.0: 0x00000000 | tsf hi
[   11.423374] iwlwifi 0000:3f:00.0: 0x00000000 | time gp1
[   11.423375] iwlwifi 0000:3f:00.0: 0x001FE25F | time gp2
[   11.423375] iwlwifi 0000:3f:00.0: 0x00000001 | uCode revision type
[   11.423376] iwlwifi 0000:3f:00.0: 0x00000022 | uCode version major
[   11.423377] iwlwifi 0000:3f:00.0: 0x00000000 | uCode version minor
[   11.423378] iwlwifi 0000:3f:00.0: 0x00000230 | hw version
[   11.423378] iwlwifi 0000:3f:00.0: 0x00489000 | board version
[   11.423379] iwlwifi 0000:3f:00.0: 0x00260128 | hcmd
[   11.423380] iwlwifi 0000:3f:00.0: 0x00122080 | isr0
[   11.423381] iwlwifi 0000:3f:00.0: 0x00800000 | isr1
[   11.423381] iwlwifi 0000:3f:00.0: 0x08001802 | isr2
[   11.423382] iwlwifi 0000:3f:00.0: 0x004000C0 | isr3
[   11.423383] iwlwifi 0000:3f:00.0: 0x00000000 | isr4
[   11.423383] iwlwifi 0000:3f:00.0: 0x00260128 | last cmd Id
[   11.423384] iwlwifi 0000:3f:00.0: 0x00000000 | wait_event
[   11.423385] iwlwifi 0000:3f:00.0: 0x0000DFF7 | l2p_control
[   11.423386] iwlwifi 0000:3f:00.0: 0x00000820 | l2p_duration
[   11.423386] iwlwifi 0000:3f:00.0: 0x00000000 | l2p_mhvalid
[   11.423387] iwlwifi 0000:3f:00.0: 0x00000000 | l2p_addr_match
[   11.423388] iwlwifi 0000:3f:00.0: 0x0000000D | lmpm_pmg_sel
[   11.423389] iwlwifi 0000:3f:00.0: 0x30101345 | timestamp
[   11.423389] iwlwifi 0000:3f:00.0: 0x00342030 | flow_handler
[   11.423455] iwlwifi 0000:3f:00.0: 0x00000000 | ADVANCED_SYSASSERT
[   11.423456] iwlwifi 0000:3f:00.0: 0x00000000 | umac branchlink1
[   11.423457] iwlwifi 0000:3f:00.0: 0x00000000 | umac branchlink2
[   11.423457] iwlwifi 0000:3f:00.0: 0x00000000 | umac interruptlink1
[   11.423458] iwlwifi 0000:3f:00.0: 0x00000000 | umac interruptlink2
[   11.423459] iwlwifi 0000:3f:00.0: 0x00000000 | umac data1
[   11.423460] iwlwifi 0000:3f:00.0: 0x00000000 | umac data2
[   11.423460] iwlwifi 0000:3f:00.0: 0x00000000 | umac data3
[   11.423461] iwlwifi 0000:3f:00.0: 0x00000000 | umac major
[   11.423462] iwlwifi 0000:3f:00.0: 0x00000000 | umac minor
[   11.423462] iwlwifi 0000:3f:00.0: 0x00000000 | frame pointer
[   11.423463] iwlwifi 0000:3f:00.0: 0x00000000 | stack pointer
[   11.423464] iwlwifi 0000:3f:00.0: 0x00000000 | last host cmd
[   11.423465] iwlwifi 0000:3f:00.0: 0x00000000 | isr status reg
[   11.423469] ieee80211 phy0: Hardware restart was requested
[   11.423472] iwlwifi 0000:3f:00.0: Scan failed! ret -110
[   11.423481] iwlwifi 0000:3f:00.0: Microcode SW error detected. 
Restarting 0x2000000.


[   15.007405] iwlwifi 0000:3f:00.0: Error sending SCAN_REQ_UMAC: time 
out after 2000ms.
[   15.007407] iwlwifi 0000:3f:00.0: Current CMD queue read_ptr 42 
write_ptr 43
[   15.007507] iwlwifi 0000:3f:00.0: Microcode SW error detected. 
Restarting 0x2000000.
[   15.007559] iwlwifi 0000:3f:00.0: Start IWL Error Log Dump:
[   15.007560] iwlwifi 0000:3f:00.0: Status: 0x00000100, count: 6
[   15.007561] iwlwifi 0000:3f:00.0: Loaded firmware version: 34.0.1
[   15.007562] iwlwifi 0000:3f:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN 

[   15.007563] iwlwifi 0000:3f:00.0: 0x000002F0 | trm_hw_status0
[   15.007564] iwlwifi 0000:3f:00.0: 0x00000000 | trm_hw_status1
[   15.007564] iwlwifi 0000:3f:00.0: 0x00023FDC | branchlink2
[   15.007565] iwlwifi 0000:3f:00.0: 0x0003915A | interruptlink1
[   15.007566] iwlwifi 0000:3f:00.0: 0x0003915A | interruptlink2
[   15.007567] iwlwifi 0000:3f:00.0: 0x00000000 | data1
[   15.007567] iwlwifi 0000:3f:00.0: 0x00000080 | data2
[   15.007568] iwlwifi 0000:3f:00.0: 0x07830000 | data3
[   15.007569] iwlwifi 0000:3f:00.0: 0x00194F47 | beacon time
[   15.007570] iwlwifi 0000:3f:00.0: 0x002C9934 | tsf low
[   15.007570] iwlwifi 0000:3f:00.0: 0x00000000 | tsf hi
[   15.007571] iwlwifi 0000:3f:00.0: 0x00000000 | time gp1
[   15.007572] iwlwifi 0000:3f:00.0: 0x002C9935 | time gp2
[   15.007573] iwlwifi 0000:3f:00.0: 0x00000001 | uCode revision type
[   15.007573] iwlwifi 0000:3f:00.0: 0x00000022 | uCode version major
[   15.007574] iwlwifi 0000:3f:00.0: 0x00000000 | uCode version minor
[   15.007575] iwlwifi 0000:3f:00.0: 0x00000230 | hw version
[   15.007576] iwlwifi 0000:3f:00.0: 0x00489000 | board version
[   15.007576] iwlwifi 0000:3f:00.0: 0x0029012C | hcmd
[   15.007577] iwlwifi 0000:3f:00.0: 0x00022080 | isr0
[   15.007578] iwlwifi 0000:3f:00.0: 0x00800000 | isr1
[   15.007579] iwlwifi 0000:3f:00.0: 0x08001802 | isr2
[   15.007579] iwlwifi 0000:3f:00.0: 0x00400080 | isr3
[   15.007580] iwlwifi 0000:3f:00.0: 0x00000000 | isr4
[   15.007581] iwlwifi 0000:3f:00.0: 0x0029012C | last cmd Id
[   15.007582] iwlwifi 0000:3f:00.0: 0x00000000 | wait_event
[   15.007582] iwlwifi 0000:3f:00.0: 0x0000DFF7 | l2p_control
[   15.007583] iwlwifi 0000:3f:00.0: 0x00000020 | l2p_duration
[   15.007584] iwlwifi 0000:3f:00.0: 0x00000000 | l2p_mhvalid
[   15.007584] iwlwifi 0000:3f:00.0: 0x00000000 | l2p_addr_match
[   15.007585] iwlwifi 0000:3f:00.0: 0x0000008F | lmpm_pmg_sel
[   15.007586] iwlwifi 0000:3f:00.0: 0x30101345 | timestamp
[   15.007587] iwlwifi 0000:3f:00.0: 0x00342030 | flow_handler
[   15.007653] iwlwifi 0000:3f:00.0: 0x00000000 | ADVANCED_SYSASSERT
[   15.007654] iwlwifi 0000:3f:00.0: 0x00000000 | umac branchlink1
[   15.007655] iwlwifi 0000:3f:00.0: 0x00000000 | umac branchlink2
[   15.007656] iwlwifi 0000:3f:00.0: 0x00000000 | umac interruptlink1
[   15.007656] iwlwifi 0000:3f:00.0: 0x00000000 | umac interruptlink2
[   15.007657] iwlwifi 0000:3f:00.0: 0x00000000 | umac data1
[   15.007658] iwlwifi 0000:3f:00.0: 0x00000000 | umac data2
[   15.007659] iwlwifi 0000:3f:00.0: 0x00000000 | umac data3
[   15.007659] iwlwifi 0000:3f:00.0: 0x00000000 | umac major
[   15.007660] iwlwifi 0000:3f:00.0: 0x00000000 | umac minor
[   15.007661] iwlwifi 0000:3f:00.0: 0x00000000 | frame pointer
[   15.007662] iwlwifi 0000:3f:00.0: 0x00000000 | stack pointer
[   15.007662] iwlwifi 0000:3f:00.0: 0x00000000 | last host cmd
[   15.007663] iwlwifi 0000:3f:00.0: 0x00000000 | isr status reg
[   15.007668] ieee80211 phy0: Hardware restart was requested
[   15.007671] iwlwifi 0000:3f:00.0: Scan failed! ret -110



Any other info you need / want ?
