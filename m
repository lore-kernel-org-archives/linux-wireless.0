Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37822 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab0C3T4M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 15:56:12 -0400
Received: by ewy20 with SMTP id 20so1627617ewy.1
        for <linux-wireless@vger.kernel.org>; Tue, 30 Mar 2010 12:56:11 -0700 (PDT)
Message-ID: <4BB25756.2040201@lwfinger.net>
Date: Tue, 30 Mar 2010 14:56:06 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: reinette chatre <reinette.chatre@intel.com>
CC: wireless <linux-wireless@vger.kernel.org>, lee_matheson@hotmail.com
Subject: Problem with IW5300
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette,

This info comes from an openSUSE 11.3 M4 bug report at
https://bugzilla.novell.com/show_bug.cgi?id=592399
The kernel is 2.6.33 with openSUSE patches, but none of them should touch iwlagn.

The lspci info for this card is:

04:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
	Subsystem: Intel Corporation Device 1121
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping-
SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 31
	Region 0: Memory at f8000000 (64-bit, non-prefetchable) [size=8K]
	Capabilities: <access denied>
	Kernel driver in use: iwlagn

His problem is that the wireless keeps getting a microcode error and is dropping
and remaking the connection about every 40 seconds. It logs the following:

[   49.842706] iwlagn 0000:04:00.0: firmware: requesting iwlwifi-5000-2.ucode
[   50.998519] iwlagn 0000:04:00.0: loaded firmware version 8.24.2.12
[   51.194842] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   51.196424]   alloc irq_desc for 33 on node -1
[   51.196427]   alloc kstat_irqs on node -1
[   51.196449] tg3 0000:08:00.0: irq 33 for MSI/MSI-X
[   51.299431] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   52.370360] NET: Registered protocol family 17
[  278.379210] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  541.820669] ip_tables: (C) 2000-2006 Netfilter Core Team
[  548.937278] pan0: no IPv6 routers present
[  607.590793] tg3 0000:08:00.0: irq 33 for MSI/MSI-X
[  607.693733] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  625.378949] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  626.979855] wlan0: direct probe to AP 00:1f:3f:16:37:fb (try 1)
[  626.982854] wlan0: direct probe responded
[  626.982857] wlan0: authenticate with AP 00:1f:3f:16:37:fb (try 1)
[  626.986838] wlan0: authenticated
[  626.986853] wlan0: associate with AP 00:1f:3f:16:37:fb (try 1)
[  626.990204] wlan0: RX AssocResp from 00:1f:3f:16:37:fb (capab=0x431 status=0
aid=2)
[  626.990207] wlan0: associated
[  626.992668] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  626.992706] cfg80211: Calling CRDA for country: DE
[  626.996564] cfg80211: Current regulatory domain updated by AP to: DE
[  626.996572]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  626.996579]     (2402000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  627.169581] Intel AES-NI instructions are not detected.
[  627.362747] padlock: VIA PadLock not detected.
[  652.749175] iwlagn 0000:04:00.0: Microcode SW error detected.  Restarting
0x2000000.
[  652.749201] iwlagn 0000:04:00.0: Start IWL Error Log Dump:
[  652.749207] iwlagn 0000:04:00.0: Status: 0x000212E4, count: 5
[  652.749346] iwlagn 0000:04:00.0: Desc                               Time
  data1      data2      line
[  652.749356] iwlagn 0000:04:00.0: NMI_INTERRUPT_WDG            (#04)
1197632519 0x00000002 0x07030000 3664
[  652.749361] iwlagn 0000:04:00.0: blink1  blink2  ilink1  ilink2
[  652.749367] iwlagn 0000:04:00.0: 0x005AA 0x006E8 0x008B2 0x0CF76
[  652.749427] iwlagn 0000:04:00.0: Start IWL Event Log Dump: display last 20
entries
[  652.749451] iwlagn 0000:04:00.0: EVT_LOGT:0027194576:0x01002110:0211
[  652.749466] iwlagn 0000:04:00.0: EVT_LOGT:0027194580:0x00000000:0212
[  652.749480] iwlagn 0000:04:00.0: EVT_LOGT:0027194618:0x00000000:0215
[  652.749495] iwlagn 0000:04:00.0: EVT_LOGT:0027194622:0x00000008:0220
[  652.749509] iwlagn 0000:04:00.0: EVT_LOGT:0027194639:0x00000000:0302
[  652.749523] iwlagn 0000:04:00.0: EVT_LOGT:0027194668:0x000000d4:0303
[  652.749538] iwlagn 0000:04:00.0: EVT_LOGT:0027194672:0x0000107f:0217
[  652.749553] iwlagn 0000:04:00.0: EVT_LOGT:0027194673:0x027e001c:0217
[  652.749567] iwlagn 0000:04:00.0: EVT_LOGT:0027194890:0x0000010f:0106
[  652.749582] iwlagn 0000:04:00.0: EVT_LOGT:0027194892:0x00000000:0302
[  652.749597] iwlagn 0000:04:00.0: EVT_LOGT:0027194921:0x000000b4:0303
[  652.749611] iwlagn 0000:04:00.0: EVT_LOGT:0027194930:0x000000c4:0322
[  652.749625] iwlagn 0000:04:00.0: EVT_LOGT:0027194979:0x00000000:0302
[  652.749640] iwlagn 0000:04:00.0: EVT_LOGT:0027195006:0x00000436:0323
[  652.749654] iwlagn 0000:04:00.0: EVT_LOGT:0027195029:0x00000000:1350
[  652.749669] iwlagn 0000:04:00.0: EVT_LOGT:0027195029:0x00000000:1351
[  652.749683] iwlagn 0000:04:00.0: EVT_LOGT:0027195029:0x00000000:1352
[  652.749698] iwlagn 0000:04:00.0: EVT_LOGT:0027195030:0x00000002:1353
[  652.749713] iwlagn 0000:04:00.0: EVT_LOGT:0027394882:0x000000d7:0123
[  652.749727] iwlagn 0000:04:00.0: EVT_LOGT:0027394890:0x00000000:0125
[  689.800558] iwlagn 0000:04:00.0: iwl_tx_agg_start on ra = 00:1f:3f:16:37:fb
tid = 0
[  690.011770] iwlagn 0000:04:00.0: Microcode SW error detected.  Restarting
0x2000000.
[  690.011797] iwlagn 0000:04:00.0: Start IWL Error Log Dump:
[  690.011803] iwlagn 0000:04:00.0: Status: 0x000212E4, count: 5
[  690.011933] iwlagn 0000:04:00.0: Desc                               Time
  data1      data2      line
[  690.011942] iwlagn 0000:04:00.0: NMI_INTERRUPT_WDG            (#04)
1234894045 0x00000002 0x07030000 3664
[  690.011947] iwlagn 0000:04:00.0: blink1  blink2  ilink1  ilink2
[  690.011953] iwlagn 0000:04:00.0: 0x005AA 0x006E8 0x008B2 0x022C8
[  690.012035] iwlagn 0000:04:00.0: Start IWL Event Log Dump: display last 20
entries
[  690.012059] iwlagn 0000:04:00.0: EVT_LOGT:0037028048:0x00000040:0219
[  690.012074] iwlagn 0000:04:00.0: EVT_LOGT:0037028050:0x01000110:0211
[  690.012089] iwlagn 0000:04:00.0: EVT_LOGT:0037028054:0x00000000:0212
[  690.012104] iwlagn 0000:04:00.0: EVT_LOGT:0037028091:0x00000000:0215
[  690.012119] iwlagn 0000:04:00.0: EVT_LOGT:0037028095:0x00000008:0220
-- continues on and on ---

Have there been changes that would have fixed this problem, or is this a known
regression? The OP (Cc'd here) reports that it works better on 11.1 (a 2.6.27
kernel) and 11.2 (a 2.6.31 kernel) than it does with this 2.6.33 kernel.

Thanks,

Larry


