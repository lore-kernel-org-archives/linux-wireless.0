Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:53225 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3JAIR7 (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Tue, 1 Oct 2013 04:17:59 -0400
Received: by mail-ie0-f174.google.com with SMTP id u16so12761132iet.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 01:17:44 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 1 Oct 2013 16:17:44 +0800
Message-ID: <CALx5=V_voRtb_e=9BFhNmt7rLO4v5iQKdZ0NCyZATtYCOUh7JA@mail.gmail.com> (sfid-20131001_101814_083349_CA085999)
Subject: iwlegacy: iwl4965 reload firmware issue.
From: Matt Chen <machen@suse.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: kvoz123@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

Recently a user reported a issue happened in his Intel 4965 wifi
issue. The issue happened to him is as below :

1. Boot system
2. Wait for 10 min
3. Look at dmesg output

412.869861] iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting
0x82000000.
[  412.869867] iwl4965 0000:03:00.0: Loaded firmware version: 228.61.2.24
[  412.869882] iwl4965 0000:03:00.0: Start IWL Error Log Dump:
[  412.869884] iwl4965 0000:03:00.0: Status: 0x000213E4, count: 5
[  412.870053] iwl4965 0000:03:00.0: Desc                                  Time
      data1      data2      line
[  412.870056] iwl4965 0000:03:00.0: FH49_ERROR                   (0x000C)
1661571581 0x00000008 0x03130000 208
[  412.870058] iwl4965 0000:03:00.0: pc      blink1  blink2  ilink1  ilink2
hcmd
[  412.870060] iwl4965 0000:03:00.0: 0x0046C 0x07A10 0x004C2 0x006DA 0x07A5A
0x2B0001C
[  412.870062] iwl4965 0000:03:00.0: FH register values:
[  412.870076] iwl4965 0000:03:00.0:       FH49_RSCSR_CHNL0_STTS_WPTR_REG:
0X132c1e00
[  412.870090] iwl4965 0000:03:00.0:      FH49_RSCSR_CHNL0_RBDCB_BASE_REG:
0X0133bfe0
[  412.870103] iwl4965 0000:03:00.0:                FH49_RSCSR_CHNL0_WPTR:
0X000000f8
[  412.870117] iwl4965 0000:03:00.0:       FH49_MEM_RCSR_CHNL0_CONFIG_REG:
0X00819000
[  412.870131] iwl4965 0000:03:00.0:        FH49_MEM_RSSR_SHARED_CTRL_REG:
0X0000003c
[  412.870144] iwl4965 0000:03:00.0:          FH49_MEM_RSSR_RX_STATUS_REG:
0X03130000
[  412.870158] iwl4965 0000:03:00.0:   FH49_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
0X00000000
[  412.870171] iwl4965 0000:03:00.0:              FH49_TSSR_TX_STATUS_REG:
0X07ff0002
[  412.870185] iwl4965 0000:03:00.0:               FH49_TSSR_TX_ERROR_REG:
0X00000000
[  412.870282] ieee80211 phy0: Hardware restart was requested



I traced the path, found it happened in
drivers/net/wireless/iwlegacy/4965-mac.c: il4965_irq_tasklet(), which
is handling the interrupt from pci bus. Also found it happenes in :
/* Error detected by uCode */
if (inta & CSR_INT_BIT_SW_ERR) {
    IL_ERR("Microcode SW error detected. " " Restarting 0x%X.\n", inta);
    il->isr_stats.sw++;
    il_irq_handle_error(il);
    handled |= CSR_INT_BIT_SW_ERR;
}

The restart path is through il_irq_handle_error(il). My question is if
this is a firmware issue, driver issue or hardware issue ?


Thanks.
