Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kramwerk.de ([62.75.162.77]:42283 "EHLO mail.kramwerk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0L2LCD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 06:02:03 -0500
From: Florian Kriener <florian@kriener.org>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Subject: Re: BUG: Microcode SW error detected / Frequent disconnects
Date: Wed, 29 Dec 2010 12:01:59 +0100
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <201012101409.38146.florian@kriener.org> <1291994774.10280.183.camel@wwguy-ubuntu> <201012102010.16921.florian@kriener.org>
In-Reply-To: <201012102010.16921.florian@kriener.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012291201.59525.florian@kriener.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 December 2010 20:10:16 Florian Kriener wrote:
> On Friday 10 December 2010 16:26:14 Guy, Wey-Yi wrote:
> > Looks like you have 5000 NIC device based on the firmware version.
> > Please let me know the problem still happen in 2.6.36. If does, we
> > can look into possible firmware problem
> 
> Yes, it is a 5300 . I guess you mean 2.6.37 and yes I will let you
> know.

I promised to mail again if I see the firmware error again with 2.6.37.
There you go:


[ 2296.117090] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 4
[ 2298.344144] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:1f:3f:62:fd:83 tid = 0
[ 3132.669181] iwlagn 0000:03:00.0: low ack count detected, restart firmware
[ 3132.669190] iwlagn 0000:03:00.0: On demand firmware reload
[ 3132.706279] iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
[ 3132.706290] iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19
[ 3209.576047] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:1f:3f:62:fd:83 tid = 0
[ 4913.689836] iwlagn 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
[ 4913.689846] iwlagn 0000:03:00.0: Loaded firmware version: 8.24.2.12
[ 4913.689866] iwlagn 0000:03:00.0: Start IWL Error Log Dump:
[ 4913.689873] iwlagn 0000:03:00.0: Status: 0x000212E4, count: 5
[ 4913.690031] iwlagn 0000:03:00.0: Desc                                  Time       data1      data2      line
[ 4913.690041] iwlagn 0000:03:00.0: SYSASSERT                    (0x0005) 0000521857 0x00008035 0x00006905 1364
[ 4913.690047] iwlagn 0000:03:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
[ 4913.690055] iwlagn 0000:03:00.0: 0x03AE8 0x039B8 0x039B8 0x008B2 0x00000 0x4E7004E
[ 4913.690060] iwlagn 0000:03:00.0: CSR values:
[ 4913.690065] iwlagn 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
[ 4913.690075] iwlagn 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
[ 4913.690084] iwlagn 0000:03:00.0:          CSR_INT_COALESCING: 0X0000ff40
[ 4913.690093] iwlagn 0000:03:00.0:                     CSR_INT: 0X00000000
[ 4913.690101] iwlagn 0000:03:00.0:                CSR_INT_MASK: 0X00000000
[ 4913.690110] iwlagn 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
[ 4913.690118] iwlagn 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
[ 4913.690127] iwlagn 0000:03:00.0:                   CSR_RESET: 0X00000000
[ 4913.690135] iwlagn 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
[ 4913.690143] iwlagn 0000:03:00.0:                  CSR_HW_REV: 0X00000024
[ 4913.690152] iwlagn 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
[ 4913.690160] iwlagn 0000:03:00.0:               CSR_EEPROM_GP: 0X90000004
[ 4913.690169] iwlagn 0000:03:00.0:              CSR_OTP_GP_REG: 0X00060000
[ 4913.690178] iwlagn 0000:03:00.0:                 CSR_GIO_REG: 0X00080046
[ 4913.690186] iwlagn 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000885
[ 4913.690195] iwlagn 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
[ 4913.690203] iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
[ 4913.690211] iwlagn 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
[ 4913.690220] iwlagn 0000:03:00.0:                 CSR_LED_REG: 0X00000058
[ 4913.690229] iwlagn 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88134338
[ 4913.690237] iwlagn 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
[ 4913.690246] iwlagn 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
[ 4913.690255] iwlagn 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
[ 4913.690263] iwlagn 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
[ 4913.690269] iwlagn 0000:03:00.0: FH register values:
[ 4913.690287] iwlagn 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X13623e00
[ 4913.690305] iwlagn 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01367fb0
[ 4913.690324] iwlagn 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000050
[ 4913.690342] iwlagn 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
[ 4913.690361] iwlagn 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
[ 4913.690380] iwlagn 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X07030000
[ 4913.690398] iwlagn 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
[ 4913.690416] iwlagn 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
[ 4913.690435] iwlagn 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
[ 4913.690497] iwlagn 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
[ 4913.690522] iwlagn 0000:03:00.0: EVT_LOGT:1780995800:0x00000000:0212
[ 4913.690537] iwlagn 0000:03:00.0: EVT_LOGT:1780995854:0x00000000:0215
[ 4913.690553] iwlagn 0000:03:00.0: EVT_LOGT:1780995858:0x00000008:0220
[ 4913.690568] iwlagn 0000:03:00.0: EVT_LOGT:1780996115:0x0a1a001c:0206
[ 4913.690584] iwlagn 0000:03:00.0: EVT_LOGT:1780996117:0xc0000000:0228
[ 4913.690600] iwlagn 0000:03:00.0: EVT_LOGT:1780996118:0x00000001:0204
[ 4913.690615] iwlagn 0000:03:00.0: EVT_LOGT:1780996121:0x00000001:0214
[ 4913.690630] iwlagn 0000:03:00.0: EVT_LOGT:1780996122:0x01041110:0205
[ 4913.690646] iwlagn 0000:03:00.0: EVT_LOGT:1780996144:0x00000020:0208
[ 4913.690661] iwlagn 0000:03:00.0: EVT_LOGT:1780996163:0x00000000:0302
[ 4913.690677] iwlagn 0000:03:00.0: EVT_LOGT:1780996193:0x000000c4:0303
[ 4913.690693] iwlagn 0000:03:00.0: EVT_LOGT:1780996199:0x00000001:0203
[ 4913.690708] iwlagn 0000:03:00.0: EVT_LOGT:1780996203:0x0a1a001c:0206
[ 4913.690723] iwlagn 0000:03:00.0: EVT_LOGT:1780996204:0x00000040:0204
[ 4913.690739] iwlagn 0000:03:00.0: EVT_LOGT:1780996207:0x01040110:0211
[ 4913.690754] iwlagn 0000:03:00.0: EVT_LOGT:1780996212:0x00000000:0212
[ 4913.690769] iwlagn 0000:03:00.0: EVT_LOGT:1780996266:0x00000000:0215
[ 4913.690785] iwlagn 0000:03:00.0: EVT_LOGT:1780996270:0x00000008:0220
[ 4913.690800] iwlagn 0000:03:00.0: EVT_LOGT:1780996636:0x04e7004e:0401
[ 4913.690816] iwlagn 0000:03:00.0: EVT_LOGT:1780996648:0x00000000:0125
[ 4913.736574] iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
[ 4913.736584] iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19
[ 4964.632025] iwlagn 0000:03:00.0: Aggregation not enabled for tid 0 because load = 0
[ 4973.649242] iwlagn 0000:03:00.0: iwlagn_tx_agg_start on ra = 00:1f:3f:62:fd:83 tid = 0
[ 5037.471815] iwlagn 0000:03:00.0: low ack count detected, restart firmware
[ 5037.471824] iwlagn 0000:03:00.0: On demand firmware reload
[ 5037.507502] iwlagn 0000:03:00.0: Stopping AGG while state not ON or starting
[ 5037.507513] iwlagn 0000:03:00.0: queue number out of range: 0, must be 10 to 19


The card is a iwl5300 and the kernel is of version 2.6.37-rc7 running on amd64 arch.
It's the newest from debian experimental (2.6.37~rc7-1~experimental.1).

I have a full dmesg.log here which I can send you in private, just ask.

Sincerely,
Florian.
