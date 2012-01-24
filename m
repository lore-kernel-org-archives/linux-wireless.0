Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:32935 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab2AXVwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 16:52:35 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 9F368CA9E0D
	for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 22:52:30 +0100 (CET)
Subject: [iwlegacy/4965] Microcode SW error detected on 3.3rc1
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Tue, 24 Jan 2012 22:51:50 +0100
Message-ID: <1327441910.21837.94.camel@sakura.staff.proxad.net> (sfid-20120124_225238_775434_B653C97F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I can reliably reproduce this on 3.3rc1 (build from ubuntu ppa), it was
present on 3.2 too.

Linux max-laptop 3.3.0-030300rc1-generic #201201191835 SMP Thu Jan 19 23:36:54 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

[ 1053.054034] iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
[ 1053.054047] iwl4965 0000:03:00.0: Loaded firmware version: 228.61.2.24
[ 1053.054069] iwl4965 0000:03:00.0: Start IWL Error Log Dump:
[ 1053.054077] iwl4965 0000:03:00.0: Status: 0x000213E4, count: 5
[ 1053.054239] iwl4965 0000:03:00.0: Desc                                  Time       data1      data2      line
[ 1053.054250] iwl4965 0000:03:00.0: NMI_INTERRUPT_WDG            (0x0004) 0643296734 0x00000002 0x07430000 208
[ 1053.054258] iwl4965 0000:03:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
[ 1053.054266] iwl4965 0000:03:00.0: 0x0046C 0x08370 0x004C2 0x006DE 0x018B8 0x7DB001C
[ 1053.054273] iwl4965 0000:03:00.0: FH register values:
[ 1053.054305] iwl4965 0000:03:00.0:       FH49_RSCSR_CHNL0_STTS_WPTR_REG: 0X06f5ed00
[ 1053.054325] iwl4965 0000:03:00.0:      FH49_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0079fd80
[ 1053.054345] iwl4965 0000:03:00.0:                FH49_RSCSR_CHNL0_WPTR: 0X00000028
[ 1053.054365] iwl4965 0000:03:00.0:       FH49_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819000
[ 1053.054385] iwl4965 0000:03:00.0:        FH49_MEM_RSSR_SHARED_CTRL_REG: 0X0000003c
[ 1053.054404] iwl4965 0000:03:00.0:          FH49_MEM_RSSR_RX_STATUS_REG: 0X07430000
[ 1053.054423] iwl4965 0000:03:00.0:   FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 1053.054443] iwl4965 0000:03:00.0:              FH49_TSSR_TX_STATUS_REG: 0X07ff0003
[ 1053.054463] iwl4965 0000:03:00.0:               FH49_TSSR_TX_ERROR_REG: 0X00000000
[ 1053.054809] ieee80211 phy0: Hardware restart was requested
[ 1053.407016] iwl4965 0000:03:00.0: Stopping AGG while state not ON or starting
[ 1053.407028] iwl4965 0000:03:00.0: queue number out of range: 0, must be 7 to 14

Single TCP transfer (AP -> STA) on a 802.11n/HT20 AP 2.4G

Once rate reaches about 7MB/s, then transfer stalls for 1 second and
starts again, I get one of this about every minute.

Any log I could enable to help you ?

Thanks,

-- 
Maxime


