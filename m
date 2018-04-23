Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50731 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754710AbeDWMFn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 08:05:43 -0400
Date: Mon, 23 Apr 2018 15:05:13 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: [BUG] iwlwifi: Microcode SW error detected.  Restarting 0x2000000.
Message-ID: <20180423120513.GS2173@lahna.fi.intel.com> (sfid-20180423_140547_616771_329BB837)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On my Lenovo X1 Carbon gen 5 system,after I upgraded to v4.17-rc1
iwlwifi started to fail with following splats on dmesg:

  iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
  iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
  iwlwifi 0000:04:00.0: Status: 0x00000100, count: 6
  iwlwifi 0000:04:00.0: Loaded firmware version: 31.560484.0
  iwlwifi 0000:04:00.0: 0x00000038 | BAD_COMMAND                 
  iwlwifi 0000:04:00.0: 0x00A002F1 | trm_hw_status0
  iwlwifi 0000:04:00.0: 0x00000000 | trm_hw_status1
  iwlwifi 0000:04:00.0: 0x0002495C | branchlink2
  iwlwifi 0000:04:00.0: 0x0003962E | interruptlink1
  iwlwifi 0000:04:00.0: 0x00000000 | interruptlink2
  iwlwifi 0000:04:00.0: 0x00000000 | data1
  iwlwifi 0000:04:00.0: 0x00000030 | data2
  iwlwifi 0000:04:00.0: 0x00000030 | data3
  iwlwifi 0000:04:00.0: 0x003B31AF | beacon time
  iwlwifi 0000:04:00.0: 0x0004CE4F | tsf low
  iwlwifi 0000:04:00.0: 0x00000000 | tsf hi
  iwlwifi 0000:04:00.0: 0x00000000 | time gp1
  iwlwifi 0000:04:00.0: 0x0004CE50 | time gp2
  iwlwifi 0000:04:00.0: 0x00000001 | uCode revision type
  iwlwifi 0000:04:00.0: 0x0000001F | uCode version major
  iwlwifi 0000:04:00.0: 0x00088D64 | uCode version minor
  iwlwifi 0000:04:00.0: 0x00000230 | hw version
  iwlwifi 0000:04:00.0: 0x00489000 | board version
  iwlwifi 0000:04:00.0: 0x00000000 | hcmd
  iwlwifi 0000:04:00.0: 0x00122080 | isr0
  iwlwifi 0000:04:00.0: 0x00000000 | isr1
  iwlwifi 0000:04:00.0: 0x28201802 | isr2
  iwlwifi 0000:04:00.0: 0x404001C0 | isr3
  iwlwifi 0000:04:00.0: 0x00000000 | isr4
  iwlwifi 0000:04:00.0: 0x802D0051 | last cmd Id
  iwlwifi 0000:04:00.0: 0x00000000 | wait_event
  iwlwifi 0000:04:00.0: 0x0000DF8E | l2p_control
  iwlwifi 0000:04:00.0: 0x00000820 | l2p_duration
  iwlwifi 0000:04:00.0: 0x00000000 | l2p_mhvalid
  iwlwifi 0000:04:00.0: 0x00000000 | l2p_addr_match
  iwlwifi 0000:04:00.0: 0x0000000D | lmpm_pmg_sel
  iwlwifi 0000:04:00.0: 0x13091828 | timestamp
  iwlwifi 0000:04:00.0: 0x00002838 | flow_handler
  iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
  iwlwifi 0000:04:00.0: Status: 0x00000100, count: 7
  iwlwifi 0000:04:00.0: 0x00000034 | NMI_INTERRUPT_WDG
  iwlwifi 0000:04:00.0: 0x00000000 | umac branchlink1
  iwlwifi 0000:04:00.0: 0xC0086950 | umac branchlink2
  iwlwifi 0000:04:00.0: 0xC00842BC | umac interruptlink1
  iwlwifi 0000:04:00.0: 0xC00840CC | umac interruptlink2
  iwlwifi 0000:04:00.0: 0x00000400 | umac data1
  iwlwifi 0000:04:00.0: 0xC00840CC | umac data2
  iwlwifi 0000:04:00.0: 0xDEADBEEF | umac data3
  iwlwifi 0000:04:00.0: 0x0000001F | umac major
  iwlwifi 0000:04:00.0: 0x00088D64 | umac minor
  iwlwifi 0000:04:00.0: 0xC08861DC | frame pointer
  iwlwifi 0000:04:00.0: 0xC08861DC | stack pointer
  iwlwifi 0000:04:00.0: 0x00000000 | last host cmd
  iwlwifi 0000:04:00.0: 0x00004008 | isr status reg
  ieee80211 phy0: Hardware restart was requested
  iwlwifi 0000:04:00.0: FW Error notification: type 0x00000000 cmd_id 0x00
  iwlwifi 0000:04:00.0: FW Error notification: seq 0x0000 service 0x00000000
  iwlwifi 0000:04:00.0: FW Error notification: timestamp 0x           4CE4B
  iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.

The controller in question is:

  04:00.0 Network controller [0280]: Intel Corporation Wireless 8265 / 8275 [8086:24fd] (rev 88)

Bisection pointed to the following commit and after I reverted it,
things seem to work fine again:
  
  66fa2424df16 ("iwlwifi: fw api: support the new scan request FW API version")

Any idea what might be wrong with that commit and how to fix it
properly?

Thanks!
