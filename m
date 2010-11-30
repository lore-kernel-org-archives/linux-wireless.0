Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0K3NBx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 08:01:53 -0500
Date: Tue, 30 Nov 2010 14:01:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Microcode SW error detected on current wireless-testing
Message-ID: <20101130130148.GA3074@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Today pull on wireless testing caused this on my 4965 device (100%
reproducible on my system, yesterday w-t does not have this).

iwlagn 0000:40:00.0: Microcode SW error detected.  Restarting 0x82000000.
iwlagn 0000:40:00.0: Loaded firmware version: 228.61.2.24
iwlagn 0000:40:00.0: Start IWL Error Log Dump:
iwlagn 0000:40:00.0: Status: 0x0002B3E4, count: 5
iwlagn 0000:40:00.0: Desc                                  Time       data1      data2      line
iwlagn 0000:40:00.0: SYSASSERT                    (0x0005) 0000851408 0x000000FF 0x00000000 578
iwlagn 0000:40:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
iwlagn 0000:40:00.0: 0x13AC0 0x13A36 0x13AD6 0x006DE 0x00000 0x44140080
iwlagn 0000:40:00.0: FH register values:
iwlagn 0000:40:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X11a7cd00
iwlagn 0000:40:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X0119e720
iwlagn 0000:40:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000060
iwlagn 0000:40:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819004
iwlagn 0000:40:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X0000003c
iwlagn 0000:40:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
iwlagn 0000:40:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
iwlagn 0000:40:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0002
iwlagn 0000:40:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
iwlagn 0000:40:00.0: Start IWL Event Log Dump: display last 20 entries
iwlagn 0000:40:00.0: EVT_LOGT:0000851099:0x781c3b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851103:0x7c233b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851105:0x7c1b3b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851109:0x80223b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851111:0x801b3b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851115:0x84213b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851117:0x841b3b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851121:0x88223b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851123:0x881a3b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851128:0x8c213b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851130:0x8c193b6e:0450
iwlagn 0000:40:00.0: EVT_LOGT:0000851132:0x0000007f:0601
iwlagn 0000:40:00.0: EVT_LOGT:0000851138:0x00000100:0706
iwlagn 0000:40:00.0: EVT_LOGT:0000851140:0x00000000:0708
iwlagn 0000:40:00.0: EVT_LOGT:0000851143:0x01000300:0706
iwlagn 0000:40:00.0: EVT_LOGT:0000851145:0x01000300:0725
iwlagn 0000:40:00.0: EVT_LOGT:0000851146:0x00000000:0710
iwlagn 0000:40:00.0: EVT_LOGT:0000851148:0x00000024:0729
iwlagn 0000:40:00.0: EVT_LOGT:0000851149:0x000cfccc:0729
iwlagn 0000:40:00.0: EVT_LOGT:0000851411:0x00000000:0125
iwlagn 0000:40:00.0: Command REPLY_SCAN_CMD failed: FW Error

Is Intel aware of that problem? Should I bisect it?

Stanislaw
