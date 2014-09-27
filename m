Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:39675 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbaI0P4y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 11:56:54 -0400
Received: by mail-ie0-f176.google.com with SMTP id ar1so16790364iec.7
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2014 08:56:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <54254931.8020800@kenobrueggemann.de>
References: <CALx5=V8fqQe03Ygi3JpOk7tS5x1Mz6LY6A4VQFYaJ_C_mH=vQQ@mail.gmail.com>
	<542525D3.8000209@kenobrueggemann.de>
	<CALx5=V_7aCci-4p-yg7KyqYkDMCFxmMs__sHwN0i6UOsemPzjA@mail.gmail.com>
	<54254931.8020800@kenobrueggemann.de>
Date: Sat, 27 Sep 2014 23:56:53 +0800
Message-ID: <CALx5=V9Q1LTaTh7HBBTCEv03DGQCa2gTcDSb0G3N0mjcD75POA@mail.gmail.com> (sfid-20140927_175658_687456_6784587A)
Subject: Re: Ubuntu 14.04 and the Intel(R) Centrino(R) Advanced-N 6200
From: Matt Chen <mattsled@gmail.com>
To: =?UTF-8?Q?Keno_Br=C3=BCggemann?= <post@kenobrueggemann.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

1) OK, that would need more logs
  a) /var/log/syslog
  b) /var/log/NetworkManager
  c) dmesg

2) I am sure the v3.16 released from http://kernel.org is not nothing.
Even the http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/,
used to be compat-wireless project, is much convenient if you are not
wiling to build the whole kernel but only some new driver for WLAN, it
helps. :)

Better way is to update to the latest kernel, should be v3.17-rc
something and update to the latest firmware.

Thanks,
    Matt Chen

2014-09-26 19:08 GMT+08:00 Keno Brüggemann <post@kenobrueggemann.de>:
> Hello Matt,
>
> thanks for your help.
>
> 1. I tried the firmware from that page, but now my Networkmanager is killed
> and the card isnt longer listet.
>     I will copy the old firmware back.
>
> 2. That is nothing for me, from my experience building unfinished kernels
> and install software from strange sources arent good.
>     So i have to wait, or buy another wlan-card. Or use a cable.
>
> Greetings
> Keno Brüggemann
>
> Am 26.09.2014 um 11:38 schrieb Matt Chen:
>
>> Hi,
>>
>> Any chance to try the latest firmware[1] and driver[2] build ?
>>
>> [1]
>> http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/,
>> should be iwlwifi-6xxx series, not sure which specifically. You could
>> try to copy all of them and reboot to reload. Use ethtool -i wlan0, if
>> your wifi is wlan0, to see the firmware is still 9.221.4.1 or not.
>> Should be newer.
>>
>> [2] Build the most recent release kernel, should be v3.16 and restart
>> to test. Or try
>> http://drvbp1.linux-foundation.org/~mcgrof/rel-html/backports/ to
>> download the latest version and build to install.
>>
>> 2014-09-26 16:37 GMT+08:00 Keno Brüggemann <post@kenobrueggemann.de>:
>>>
>>> Hello,
>>>
>>> yes of course.
>>>
>>> I greped all iwl . Do you need more Data?
>>>
>>>
>>>
>>> dmesg | grep "iwl"
>>> [    4.189028] iwlwifi: unknown parameter 'probe_wait_ms' ignored
>>> [    4.189741] iwlwifi 0000:04:00.0: can't disable ASPM; OS doesn't have
>>> ASPM control
>>> [    4.189871] iwlwifi 0000:04:00.0: irq 57 for MSI/MSI-X
>>> [    4.195539] iwlwifi 0000:04:00.0: Direct firmware load failed with
>>> error
>>> -2
>>> [    4.195547] iwlwifi 0000:04:00.0: Falling back to user helper
>>> [    4.203413] iwlwifi 0000:04:00.0: Direct firmware load failed with
>>> error
>>> -2
>>> [    4.203423] iwlwifi 0000:04:00.0: Falling back to user helper
>>> [    4.221397] iwlwifi 0000:04:00.0: loaded firmware version 9.221.4.1
>>> build
>>> 25532 op_mode iwldvm
>>> [    4.243713] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUG disabled
>>> [    4.243717] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
>>> [    4.243719] iwlwifi 0000:04:00.0: CONFIG_IWLWIFI_DEVICE_TRACING
>>> enabled
>>> [    4.243722] iwlwifi 0000:04:00.0: Detected Intel(R) Centrino(R)
>>> Advanced-N 6200 AGN, REV=0x74
>>> [    4.243822] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
>>> [    4.250415] iwlwifi 0000:04:00.0: RF_KILL bit toggled to disable
>>> radio.
>>> [    4.278285] ieee80211 phy0: Selected rate control algorithm
>>> 'iwl-agn-rs'
>>> [   27.709050] iwlwifi 0000:04:00.0: RF_KILL bit toggled to enable radio.
>>> [   31.893286] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
>>> [   31.900037] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
>>> [   31.933542] iwlwifi 0000:04:00.0: Microcode SW error detected.
>>> Restarting
>>> 0x82000000.
>>> [   31.933546] iwlwifi 0000:04:00.0: CSR values:
>>> [   31.933548] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
>>> CSR_INT_PERIODIC_REG)
>>> [   31.933555] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG:
>>> 0X0048d704
>>> [   31.933562] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING:
>>> 0X00000040
>>> [   31.933569] iwlwifi 0000:04:00.0:                     CSR_INT:
>>> 0X80000000
>>> [   31.933576] iwlwifi 0000:04:00.0:                CSR_INT_MASK:
>>> 0X00000000
>>> [   31.933582] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS:
>>> 0X40010000
>>> [   31.933589] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN:
>>> 0X0000000f
>>> [   31.933596] iwlwifi 0000:04:00.0:                   CSR_RESET:
>>> 0X00000000
>>> [   31.933606] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL:
>>> 0X080403c5
>>> [   31.933612] iwlwifi 0000:04:00.0:                  CSR_HW_REV:
>>> 0X00000074
>>> [   31.933619] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG:
>>> 0X00000000
>>> [   31.933626] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP:
>>> 0X90000004
>>> [   31.933632] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG:
>>> 0X00020000
>>> [   31.933639] iwlwifi 0000:04:00.0:                 CSR_GIO_REG:
>>> 0X00080046
>>> [   31.933646] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG:
>>> 0X00000000
>>> [   31.933652] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG:
>>> 0X00000002
>>> [   31.933659] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1:
>>> 0X00000000
>>> [   31.933666] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2:
>>> 0X00000000
>>> [   31.933672] iwlwifi 0000:04:00.0:                 CSR_LED_REG:
>>> 0X00000018
>>> [   31.933679] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG:
>>> 0X00000000
>>> [   31.933686] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS:
>>> 0X27800200
>>> [   31.933693] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG:
>>> 0X00000000
>>> [   31.933699] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG:
>>> 0X0001001a
>>> [   31.933706] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG:
>>> 0Xffff0000
>>> [   31.933708] iwlwifi 0000:04:00.0: FH register values:
>>> [   31.933741] iwlwifi 0000:04:00.0: FH_RSCSR_CHNL0_STTS_WPTR_REG:
>>> 0X2303fd00
>>> [   31.933769] iwlwifi 0000:04:00.0: FH_RSCSR_CHNL0_RBDCB_BASE_REG:
>>> 0X02302d90
>>> [   31.933785] iwlwifi 0000:04:00.0: FH_RSCSR_CHNL0_WPTR: 0X000000f8
>>> [   31.933801] iwlwifi 0000:04:00.0: FH_MEM_RCSR_CHNL0_CONFIG_REG:
>>> 0X80801114
>>> [   31.933818] iwlwifi 0000:04:00.0: FH_MEM_RSSR_SHARED_CTRL_REG:
>>> 0X000000fc
>>> [   31.933848] iwlwifi 0000:04:00.0: FH_MEM_RSSR_RX_STATUS_REG:
>>> 0X07030000
>>> [   31.933882] iwlwifi 0000:04:00.0: FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
>>> 0X00000000
>>> [   31.933914] iwlwifi 0000:04:00.0: FH_TSSR_TX_STATUS_REG: 0X07ff0001
>>> [   31.933947] iwlwifi 0000:04:00.0: FH_TSSR_TX_ERROR_REG: 0X00000000
>>> [   31.933949] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1
>>> build 25532
>>> [   31.933951] iwlwifi 0000:04:00.0: Not valid error log pointer
>>> 0x00000000
>>> for Init uCode
>>> [   31.933954] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000
>>> for Init uCode
>>> [   31.934607] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
>>> [   31.934705] iwlwifi 0000:04:00.0: Unable to initialize device.
>>> [   43.466183] iwlwifi 0000:04:00.0: RF_KILL bit toggled to disable
>>> radio.
>>> [ 1447.468326] iwlwifi 0000:04:00.0: RF_KILL bit toggled to enable radio.
>>> [ 1447.470363] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
>>> [ 1447.477185] iwlwifi 0000:04:00.0: Radio type=0x1-0x3-0x1
>>> [ 1447.511612] iwlwifi 0000:04:00.0: Microcode SW error detected.
>>> Restarting
>>> 0x82000000.
>>> [ 1447.511622] iwlwifi 0000:04:00.0: CSR values:
>>> [ 1447.511629] iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is
>>> CSR_INT_PERIODIC_REG)
>>> [ 1447.511643] iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG:
>>> 0X0048d704
>>> [ 1447.511656] iwlwifi 0000:04:00.0:          CSR_INT_COALESCING:
>>> 0X00000040
>>> [ 1447.511675] iwlwifi 0000:04:00.0:                     CSR_INT:
>>> 0X80000000
>>> [ 1447.511687] iwlwifi 0000:04:00.0:                CSR_INT_MASK:
>>> 0X00000000
>>> [ 1447.511702] iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS:
>>> 0X40010000
>>> [ 1447.511712] iwlwifi 0000:04:00.0:                 CSR_GPIO_IN:
>>> 0X0000000f
>>> [ 1447.511723] iwlwifi 0000:04:00.0:                   CSR_RESET:
>>> 0X00000000
>>> [ 1447.511733] iwlwifi 0000:04:00.0:                CSR_GP_CNTRL:
>>> 0X080403c5
>>> [ 1447.511748] iwlwifi 0000:04:00.0:                  CSR_HW_REV:
>>> 0X00000074
>>> [ 1447.511758] iwlwifi 0000:04:00.0:              CSR_EEPROM_REG:
>>> 0X00000000
>>> [ 1447.511768] iwlwifi 0000:04:00.0:               CSR_EEPROM_GP:
>>> 0X90000004
>>> [ 1447.511779] iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG:
>>> 0X00020000
>>> [ 1447.511791] iwlwifi 0000:04:00.0:                 CSR_GIO_REG:
>>> 0X00080046
>>> [ 1447.511799] iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG:
>>> 0X00000000
>>> [ 1447.511806] iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG:
>>> 0X00000002
>>> [ 1447.511814] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1:
>>> 0X00000000
>>> [ 1447.511821] iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2:
>>> 0X00000000
>>> [ 1447.511828] iwlwifi 0000:04:00.0:                 CSR_LED_REG:
>>> 0X00000018
>>> [ 1447.511836] iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG:
>>> 0X00000000
>>> [ 1447.511843] iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS:
>>> 0X27800200
>>> [ 1447.511858] iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG:
>>> 0X00000000
>>> [ 1447.511865] iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG:
>>> 0X0001001a
>>> [ 1447.511872] iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG:
>>> 0Xffff0000
>>> [ 1447.511875] iwlwifi 0000:04:00.0: FH register values:
>>> [ 1447.511909] iwlwifi 0000:04:00.0: FH_RSCSR_CHNL0_STTS_WPTR_REG:
>>> 0X2303fd00
>>> [ 1447.511946] iwlwifi 0000:04:00.0: FH_RSCSR_CHNL0_RBDCB_BASE_REG:
>>> 0X02302d90
>>> [ 1447.511982] iwlwifi 0000:04:00.0: FH_RSCSR_CHNL0_WPTR: 0X000000f8
>>> [ 1447.512025] iwlwifi 0000:04:00.0: FH_MEM_RCSR_CHNL0_CONFIG_REG:
>>> 0X80801114
>>> [ 1447.512061] iwlwifi 0000:04:00.0: FH_MEM_RSSR_SHARED_CTRL_REG:
>>> 0X000000fc
>>> [ 1447.512095] iwlwifi 0000:04:00.0: FH_MEM_RSSR_RX_STATUS_REG:
>>> 0X07030000
>>> [ 1447.512129] iwlwifi 0000:04:00.0: FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV:
>>> 0X00000000
>>> [ 1447.512166] iwlwifi 0000:04:00.0: FH_TSSR_TX_STATUS_REG: 0X07ff0001
>>> [ 1447.512199] iwlwifi 0000:04:00.0: FH_TSSR_TX_ERROR_REG: 0X00000000
>>> [ 1447.512202] iwlwifi 0000:04:00.0: Loaded firmware version: 9.221.4.1
>>> build 25532
>>> [ 1447.512205] iwlwifi 0000:04:00.0: Not valid error log pointer
>>> 0x00000000
>>> for Init uCode
>>> [ 1447.512208] iwlwifi 0000:04:00.0: Invalid event log pointer 0x00000000
>>> for Init uCode
>>> [ 1447.512959] iwlwifi 0000:04:00.0: Failed to run INIT ucode: -5
>>> [ 1447.513065] iwlwifi 0000:04:00.0: Unable to initialize device.
>>>
>>> Grüße
>>> Keno Brüggemann
>>>
>>> Am 26.09.2014 um 10:29 schrieb Matt Chen:
>>>
>>>> Are you able to provide the /var/log/syslog or dmesg command result here
>>>> ?
>>>>
>>>> 2014-09-26 3:44 GMT+08:00 Keno Brüggemann <post@kenobrueggemann.de>:
>>>>>
>>>>> Hello,
>>>>>
>>>>> i switched from an Intel® Centrino® Wireless-N 1000
>>>>> to the Intel® Centrino® Advanced-N 6200 Wireless Card Adapter.
>>>>>
>>>>> My System. Dell xps l701x, ubuntu 14.04
>>>>>
>>>>> The Problem is, this Adpater won't work under Ubuntu 14.04. I've
>>>>> installed
>>>>> both versions of this Firmware.
>>>>> Nothing. Seems to be dead.
>>>>> Under Windows 7 the Card works well.
>>>>>
>>>>> Can i try something else to get it work?
>>>>> Please help.
>>>>>
>>>>> --
>>>>> Greetings
>>>>> Keno Brüggemann
>>>>>
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>> linux-wireless"
>>>>> in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>
