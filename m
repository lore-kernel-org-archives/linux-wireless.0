Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:36691 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbEYS1l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 14:27:41 -0400
Received: by lbbqq2 with SMTP id qq2so55860681lbb.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 11:27:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150525181043.GA10755@light.dominikbrodowski.net>
References: <20150525181043.GA10755@light.dominikbrodowski.net>
Date: Mon, 25 May 2015 21:27:39 +0300
Message-ID: <CANUX_P0+oGdKvY360xSekCmZjZFpe7PMS+shC9==-G-A-1O3sw@mail.gmail.com> (sfid-20150525_202745_039140_40F57D4E)
Subject: Re: iwlwifi: Queue 16 stuck for 10000 ms - Microcode SW error detected.
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2015 at 9:10 PM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:
> Hey,
>
> on my pretty new iwlwifi device 8086:08b1 (7260), the following error just
> appeared twice in dmesg on 4.1.0-rc4+ (Linus' tree as of Saturday/Sunday
> morning):

Firmware problem. Please try to update your -13.ucode from the git
repository (https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/)

>
> iwlwifi 0000:02:00.0: Queue 16 stuck for 10000 ms.
> iwlwifi 0000:02:00.0: Current SW read_ptr 109 write_ptr 243
> iwl data: 00000000: 00 00 00 00 00 00 00 00 00 e0 ff 1f 00 00 00 00  ................
> iwlwifi 0000:02:00.0: FH TRBs(0) = 0x80003019
> iwlwifi 0000:02:00.0: FH TRBs(1) = 0xc011007c
> iwlwifi 0000:02:00.0: FH TRBs(2) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(3) = 0x80300015
> iwlwifi 0000:02:00.0: FH TRBs(4) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(5) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(6) = 0x00000000
> iwlwifi 0000:02:00.0: FH TRBs(7) = 0x007090d3
> iwlwifi 0000:02:00.0: Q 0 is active and mapped to fifo 3 ra_tid 0x0000 [22,22]
> iwlwifi 0000:02:00.0: Q 1 is active and mapped to fifo 2 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 2 is active and mapped to fifo 1 ra_tid 0x0000 [187,187]
> iwlwifi 0000:02:00.0: Q 3 is active and mapped to fifo 0 ra_tid 0x0000 [10,39]
> iwlwifi 0000:02:00.0: Q 4 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 5 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 6 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 7 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 8 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 9 is active and mapped to fifo 7 ra_tid 0x0000 [212,212]
> iwlwifi 0000:02:00.0: Q 10 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 11 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 12 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 13 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 14 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 15 is active and mapped to fifo 5 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 16 is active and mapped to fifo 1 ra_tid 0x0000 [109,243]
> iwlwifi 0000:02:00.0: Q 17 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 18 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Q 19 is inactive and mapped to fifo 0 ra_tid 0x0000 [0,0]
> iwlwifi 0000:02:00.0: Microcode SW error detected.  Restarting 0x2000000.
> iwlwifi 0000:02:00.0: CSR values:
> iwlwifi 0000:02:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> iwlwifi 0000:02:00.0:        CSR_HW_IF_CONFIG_REG: 0X40489204
> iwlwifi 0000:02:00.0:          CSR_INT_COALESCING: 0X80000040
> iwlwifi 0000:02:00.0:                     CSR_INT: 0X00000000
> iwlwifi 0000:02:00.0:                CSR_INT_MASK: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_FH_INT_STATUS: 0X00000000
> iwlwifi 0000:02:00.0:                 CSR_GPIO_IN: 0X00000000
> iwlwifi 0000:02:00.0:                   CSR_RESET: 0X00000000
> iwlwifi 0000:02:00.0:                CSR_GP_CNTRL: 0X080403c5
> iwlwifi 0000:02:00.0:                  CSR_HW_REV: 0X00000144
> iwlwifi 0000:02:00.0:              CSR_EEPROM_REG: 0X00000000
> iwlwifi 0000:02:00.0:               CSR_EEPROM_GP: 0X80000000
> iwlwifi 0000:02:00.0:              CSR_OTP_GP_REG: 0X803a0000
> iwlwifi 0000:02:00.0:                 CSR_GIO_REG: 0X00080040
> iwlwifi 0000:02:00.0:            CSR_GP_UCODE_REG: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> iwlwifi 0000:02:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> iwlwifi 0000:02:00.0:                 CSR_LED_REG: 0X00000060
> iwlwifi 0000:02:00.0:        CSR_DRAM_INT_TBL_REG: 0X8821408e
> iwlwifi 0000:02:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> iwlwifi 0000:02:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
> iwlwifi 0000:02:00.0:      CSR_MONITOR_STATUS_REG: 0X3c08019d
> iwlwifi 0000:02:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> iwlwifi 0000:02:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0010
> iwlwifi 0000:02:00.0: FH register values:
> iwlwifi 0000:02:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X21418b00
> iwlwifi 0000:02:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X021418a0
> iwlwifi 0000:02:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000080
> iwlwifi 0000:02:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00801114
> iwlwifi 0000:02:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> iwlwifi 0000:02:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
> iwlwifi 0000:02:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> iwlwifi 0000:02:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> iwlwifi 0000:02:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> iwlwifi 0000:02:00.0: Start IWL Error Log Dump:
> iwlwifi 0000:02:00.0: Status: 0x00000000, count: 6
> iwlwifi 0000:02:00.0: Loaded firmware version: 25.24.13.0
> iwlwifi 0000:02:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN
> iwlwifi 0000:02:00.0: 0x00000230 | uPc
> iwlwifi 0000:02:00.0: 0x00000000 | branchlink1
> iwlwifi 0000:02:00.0: 0x00000B2E | branchlink2
> iwlwifi 0000:02:00.0: 0x00016210 | interruptlink1
> iwlwifi 0000:02:00.0: 0x00016210 | interruptlink2
> iwlwifi 0000:02:00.0: 0x00000000 | data1
> iwlwifi 0000:02:00.0: 0x00000080 | data2
> iwlwifi 0000:02:00.0: 0x07030000 | data3
> iwlwifi 0000:02:00.0: 0x50C13A19 | beacon time
> iwlwifi 0000:02:00.0: 0x0844762D | tsf low
> iwlwifi 0000:02:00.0: 0x00000075 | tsf hi
> iwlwifi 0000:02:00.0: 0x00000000 | time gp1
> iwlwifi 0000:02:00.0: 0x4577111A | time gp2
> iwlwifi 0000:02:00.0: 0x00000000 | time gp3
> iwlwifi 0000:02:00.0: 0x00041918 | uCode version
> iwlwifi 0000:02:00.0: 0x00000144 | hw version
> iwlwifi 0000:02:00.0: 0x40489204 | board version
> iwlwifi 0000:02:00.0: 0x09D30018 | hcmd
> iwlwifi 0000:02:00.0: 0x24022003 | isr0
> iwlwifi 0000:02:00.0: 0x01800000 | isr1
> iwlwifi 0000:02:00.0: 0x0000000A | isr2
> iwlwifi 0000:02:00.0: 0x004140C0 | isr3
> iwlwifi 0000:02:00.0: 0x00000000 | isr4
> iwlwifi 0000:02:00.0: 0x00000110 | isr_pref
> iwlwifi 0000:02:00.0: 0x00000000 | wait_event
> iwlwifi 0000:02:00.0: 0x00000080 | l2p_control
> iwlwifi 0000:02:00.0: 0x00010030 | l2p_duration
> iwlwifi 0000:02:00.0: 0x0000003F | l2p_mhvalid
> iwlwifi 0000:02:00.0: 0x000000CE | l2p_addr_match
> iwlwifi 0000:02:00.0: 0x00000005 | lmpm_pmg_sel
> iwlwifi 0000:02:00.0: 0x09051509 | timestamp
> iwlwifi 0000:02:00.0: 0x00348090 | flow_handler
> ieee80211 phy0: Hardware restart was requested
> iwlwifi 0000:02:00.0: L1 Enabled - LTR Disabled
>
> wifi works fine afterwards (at maximum, a reconnect is required), but
> still something seems to be at odds here...
>
> Best,
>         Dominik
