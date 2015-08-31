Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33358 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbbHaFTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 01:19:17 -0400
Received: by iods203 with SMTP id s203so146812008iod.0
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2015 22:19:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V8=fWseiOPfTB63iX-MoA3gcfUF5HfZ8maC8wpxvNQ3_A@mail.gmail.com>
References: <loom.20150829T071838-73@post.gmane.org>
	<CALx5=V8=fWseiOPfTB63iX-MoA3gcfUF5HfZ8maC8wpxvNQ3_A@mail.gmail.com>
Date: Mon, 31 Aug 2015 13:19:16 +0800
Message-ID: <CALx5=V-FtgTg8b_mp8R-g5WX_0EmRwGKviBUjLLCWfO4Uhx5aQ@mail.gmail.com> (sfid-20150831_071920_959107_87402617)
Subject: Re: Ubuntu 14.04 and the intel 3160 chip monitor mode support
From: Matt Chen <mattsled@gmail.com>
To: John Keeler <keeler@airintech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Or you could also refer to
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi.
Choose a core release[1] for your OS, build it and load it to your system.

[1]
https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/core_release

2015-08-31 10:38 GMT+08:00 Matt Chen <mattsled@gmail.com>:
> Your kernel and wifi firmware(iwlwifi-3160-8.ucode) seems to be too
> old. Update your kernel and wifi firmware from the upstream shall be
> helpful. Or contact the OS vendor for the solution.
>
> 2015-08-29 13:20 GMT+08:00 John Keeler <keeler@airintech.com>:
>> Hi,
>> I am having issues with monitor mode with ubuntu 14.04 and the intel 3160
>> chip. I am having similar issues with 3.13 and a 7265 chip on a intel NUC
>> Monitor mode says it takes but it captures no packets
>>
>> and help would be appreciated
>>
>> Thanks
>> John
>>
>> Commands that trigger the crash :
>>
>> sudo ifconfig wlan0 down
>> sudo iwconfig wlan0 mode monitor
>> sudo ifconfig wlan0 up
>>
>>
>> Ubuntu 14.04.3 LTS
>>
>> uname -a:
>> Linux 3.13.0-62-generic #102-Ubuntu SMP Tue Aug 11 14:29:36 UTC 2015 x86_64
>> x86_64 x86_64 GNU/Linux
>>
>> lspci -k :
>> 03:00.0 Network controller: Intel Corporation Wireless 3160 (rev 83)
>>     Subsystem: Intel Corporation Dual Band Wireless-AC 3160
>>     Kernel driver in use: iwlwifi
>>
>>
>>
>>
>> dmesg:
>> [ 2481.330395] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
>> [ 2481.330722] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
>> [ 2481.344124] iwlwifi 0000:03:00.0: Microcode SW error detected.
>> Restarting 0x2000000.
>> [ 2481.344133] iwlwifi 0000:03:00.0: CSR values:
>> [ 2481.344136] iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is
>> CSR_INT_PERIODIC_REG)
>> [ 2481.344143] iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c89204
>> [ 2481.344148] iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X8000ff40
>> [ 2481.344154] iwlwifi 0000:03:00.0:                     CSR_INT: 0X00000000
>> [ 2481.344160] iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
>> [ 2481.344165] iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
>> [ 2481.344170] iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
>> [ 2481.344176] iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000000
>> [ 2481.344182] iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080403c5
>> [ 2481.344187] iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X00000164
>> [ 2481.344193] iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00000000
>> [ 2481.344198] iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X80000000
>> [ 2481.344204] iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X803a0000
>> [ 2481.344209] iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080044
>> [ 2481.344215] iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X00000000
>> [ 2481.344220] iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
>> [ 2481.344225] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
>> [ 2481.344231] iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
>> [ 2481.344236] iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000060
>> [ 2481.344242] iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X881f6fb6
>> [ 2481.344247] iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
>> [ 2481.344253] iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0Xd55555d5
>> [ 2481.344258] iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
>> [ 2481.344263] iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
>> [ 2481.344267] iwlwifi 0000:03:00.0: FH register values:
>> [ 2481.344281] iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG:
>> 0X21084000
>> [ 2481.344295] iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG:
>> 0X01f5c740
>> [ 2481.344309] iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR:
>> 0X00000018
>> [ 2481.344323] iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG:
>> 0X80801114
>> [ 2481.344337] iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG:
>> 0X000000fc
>> [ 2481.344351] iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG:
>> 0X07030000
>> [ 2481.344365] iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
>> 0X00000000
>> [ 2481.344379] iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG:
>> 0X07ff0001
>> [ 2481.344394] iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG:
>> 0X00000000
>> [ 2481.344507] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
>> [ 2481.344511] iwlwifi 0000:03:00.0: Status: 0x00000000, count: 6
>> [ 2481.344514] iwlwifi 0000:03:00.0: Loaded firmware version: 22.24.8.0
>> [ 2481.344518] iwlwifi 0000:03:00.0: 0x00000103 | ADVANCED_SYSASSERT
>> [ 2481.344521] iwlwifi 0000:03:00.0: 0x000002F0 | uPc
>> [ 2481.344524] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
>> [ 2481.344527] iwlwifi 0000:03:00.0: 0x00000BEA | branchlink2
>> [ 2481.344529] iwlwifi 0000:03:00.0: 0x00014218 | interruptlink1
>> [ 2481.344532] iwlwifi 0000:03:00.0: 0x0029E0D2 | interruptlink2
>> [ 2481.344535] iwlwifi 0000:03:00.0: 0xDEADBEEF | data1
>> [ 2481.344538] iwlwifi 0000:03:00.0: 0xDEADBEEF | data2
>> [ 2481.344541] iwlwifi 0000:03:00.0: 0xDEADBEEF | data3
>> [ 2481.344543] iwlwifi 0000:03:00.0: 0x003FE7E9 | beacon time
>> [ 2481.344546] iwlwifi 0000:03:00.0: 0x00001816 | tsf low
>> [ 2481.344549] iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
>> [ 2481.344552] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
>> [ 2481.344555] iwlwifi 0000:03:00.0: 0x00001816 | time gp2
>> [ 2481.344557] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
>> [ 2481.344560] iwlwifi 0000:03:00.0: 0x00041618 | uCode version
>> [ 2481.344563] iwlwifi 0000:03:00.0: 0x00000164 | hw version
>> [ 2481.344566] iwlwifi 0000:03:00.0: 0x00C89204 | board version
>> [ 2481.344569] iwlwifi 0000:03:00.0: 0x091C002C | hcmd
>> [ 2481.344571] iwlwifi 0000:03:00.0: 0x00022000 | isr0
>> [ 2481.344574] iwlwifi 0000:03:00.0: 0x00000000 | isr1
>> [ 2481.344577] iwlwifi 0000:03:00.0: 0x00000002 | isr2
>> [ 2481.344580] iwlwifi 0000:03:00.0: 0x0040DCC0 | isr3
>> [ 2481.344582] iwlwifi 0000:03:00.0: 0x00000000 | isr4
>> [ 2481.344585] iwlwifi 0000:03:00.0: 0x00000110 | isr_pref
>> [ 2481.344588] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
>> [ 2481.344591] iwlwifi 0000:03:00.0: 0x00000080 | l2p_control
>> [ 2481.344594] iwlwifi 0000:03:00.0: 0x00000020 | l2p_duration
>> [ 2481.344596] iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
>> [ 2481.344599] iwlwifi 0000:03:00.0: 0x00008000 | l2p_addr_match
>> [ 2481.344602] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
>> [ 2481.344605] iwlwifi 0000:03:00.0: 0x23021719 | timestamp
>> [ 2481.344608] iwlwifi 0000:03:00.0: 0x00001828 | flow_handler
>> [ 2481.344613] ieee80211 phy2: Hardware restart was requested
>> [ 2481.345296] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
>> [ 2481.345668] iwlwifi 0000:03:00.0: L1 Disabled - LTR Enabled
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
