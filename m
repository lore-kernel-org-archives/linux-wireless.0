Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f53.google.com ([209.85.160.53]:41368 "EHLO
        mail-pl0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753165AbeDRCrm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 22:47:42 -0400
Received: by mail-pl0-f53.google.com with SMTP id bj1-v6so191097plb.8
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 19:47:42 -0700 (PDT)
MIME-Version: 1.0
From: Scott Register <sreg@sreg.io>
Date: Tue, 17 Apr 2018 19:47:39 -0700
Message-ID: <CANrGCJeTDQ1DTuum-asODLMoY4StspzukkWfTVtb6fJ+yHBGXg@mail.gmail.com> (sfid-20180418_044745_811073_B6AD09CF)
Subject: iwlwifi 4.18rc1 SYNC TIME_QUOTA_CMD with fw 31
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

After upgrading to 4.18rc1 iwlwifi is printing a FW error. There was a
previous thread with a similar
issue but they seemed to resolve it with a ucode update. I think I'm
running a newer FW and
am still having an issue. 4.13 works--I haven't gone any higher so far.

iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
iwlwifi 0000:02:00.0: Status: 0x00000100, count: 6
iwlwifi 0000:02:00.0: Loaded firmware version: 31.560484.0
iwlwifi 0000:02:00.0: 0x00000038 | BAD_COMMAND
iwlwifi 0000:02:00.0: 0x00A002F1 | trm_hw_status0
iwlwifi 0000:02:00.0: 0x00000000 | trm_hw_status1
iwlwifi 0000:02:00.0: 0x0002495C | branchlink2
iwlwifi 0000:02:00.0: 0x0003962E | interruptlink1
iwlwifi 0000:02:00.0: 0x00000000 | interruptlink2
iwlwifi 0000:02:00.0: 0x00000000 | data1
iwlwifi 0000:02:00.0: 0x00000032 | data2
iwlwifi 0000:02:00.0: 0x00000032 | data3
iwlwifi 0000:02:00.0: 0x003B15C2 | beacon time
iwlwifi 0000:02:00.0: 0x0004EA3C | tsf low
iwlwifi 0000:02:00.0: 0x00000000 | tsf hi
iwlwifi 0000:02:00.0: 0x00000000 | time gp1
iwlwifi 0000:02:00.0: 0x0004EA3D | time gp2
iwlwifi 0000:02:00.0: 0x00000001 | uCode revision type
iwlwifi 0000:02:00.0: 0x0000001F | uCode version major
iwlwifi 0000:02:00.0: 0x00088D64 | uCode version minor
iwlwifi 0000:02:00.0: 0x00000230 | hw version
iwlwifi 0000:02:00.0: 0x00489000 | board version
iwlwifi 0000:02:00.0: 0x00000000 | hcmd
iwlwifi 0000:02:00.0: 0x00122080 | isr0
iwlwifi 0000:02:00.0: 0x00000000 | isr1
iwlwifi 0000:02:00.0: 0x28201802 | isr2
iwlwifi 0000:02:00.0: 0x404001C0 | isr3
iwlwifi 0000:02:00.0: 0x00000000 | isr4
iwlwifi 0000:02:00.0: 0x802F0051 | last cmd Id
iwlwifi 0000:02:00.0: 0x00000000 | wait_event
iwlwifi 0000:02:00.0: 0x0000277E | l2p_control
iwlwifi 0000:02:00.0: 0x00000820 | l2p_duration
iwlwifi 0000:02:00.0: 0x00000000 | l2p_mhvalid
iwlwifi 0000:02:00.0: 0x00000000 | l2p_addr_match
iwlwifi 0000:02:00.0: 0x0000000D | lmpm_pmg_sel
iwlwifi 0000:02:00.0: 0x13091828 | timestamp
iwlwifi 0000:02:00.0: 0x00002838 | flow_handler
iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
iwlwifi 0000:02:00.0: Status: 0x00000100, count: 7
iwlwifi 0000:02:00.0: 0x00000034 | NMI_INTERRUPT_WDG
iwlwifi 0000:02:00.0: 0x00000000 | umac branchlink1
iwlwifi 0000:02:00.0: 0xC0086950 | umac branchlink2
iwlwifi 0000:02:00.0: 0xC00842BC | umac interruptlink1
iwlwifi 0000:02:00.0: 0xC00840CC | umac interruptlink2
iwlwifi 0000:02:00.0: 0x00000400 | umac data1
iwlwifi 0000:02:00.0: 0xC00840CC | umac data2
iwlwifi 0000:02:00.0: 0xDEADBEEF | umac data3
iwlwifi 0000:02:00.0: 0x0000001F | umac major
iwlwifi 0000:02:00.0: 0x00088D64 | umac minor
iwlwifi 0000:02:00.0: 0xC08861DC | frame pointer
iwlwifi 0000:02:00.0: 0xC08861DC | stack pointer
iwlwifi 0000:02:00.0: 0x00000000 | last host cmd
iwlwifi 0000:02:00.0: 0x00004008 | isr status reg
ieee80211 phy0: Hardware restart was requested
ieee80211 phy0: Hardware restart was requested
iwlwifi 0000:02:00.0: FW Error notification: type 0x00000000 cmd_id 0x34
iwlwifi 0000:02:00.0: FW Error notification: seq 0x0070 service 0x00000034
iwlwifi 0000:02:00.0: FW Error notification: timestamp 0x            D559
iwlwifi 0000:02:00.0: FW error in SYNC CMD TIME_QUOTA_CMD
CPU: 7 PID: 83 Comm: kworker/7:1 Tainted: G        W
4.17.0-041700rc1-generic #201804152230
Hardware name: LENOVO 20KHCTO1WW/20KHCTO1WW, BIOS N23ET37W (1.12 ) 02/27/2018

ethtool & lspci:
driver: iwlwifi
version: 4.17.0-041700rc1-generic
firmware-version: 31.560484.0
expansion-rom-version:
bus-info: 0000:02:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: no
supports-priv-flags: no
02:00.0 Network controller: Intel Corporation Wireless 8265 / 8275 (rev 78)

Any ideas?

Cheers,
Scott
