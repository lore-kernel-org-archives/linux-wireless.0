Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36218 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbdFIRWi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 13:22:38 -0400
Received: by mail-wr0-f195.google.com with SMTP id e23so8179551wre.3
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 10:22:38 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: ath10k@lists.infradead.org, "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: ath10k-devel <ath10k-devel@qca.qualcomm.com>,
        "linux-wireless (linux-wireless@vger.kernel.org)"
        <linux-wireless@vger.kernel.org>, hannu.nyman@iki.fi,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Adrian Chadd <adrian@freebsd.org>
Subject: Re: QCA9984 bmi identification failure (fixed)
Date: Fri, 09 Jun 2017 19:22:34 +0200
Message-ID: <13393560.5t7FXRZE7t@debian64> (sfid-20170609_192242_893397_16D2AC12)
In-Reply-To: <3243718.FYinmXYgr7@debian64>
References: <3243718.FYinmXYgr7@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, March 23, 2017 5:47:08 PM CEST Christian Lamparter wrote:
> Hannu Nyman reported a issue with the QCA9984 in his Netgear R7800 
> and LEDE's ath10k: (This is with 936-ath10k_skip_otp_check.patch removed):
> 
> [   25.259266] ath10k_pci 0000:01:00.0: unable to read from the device
> [   25.259288] ath10k_pci 0000:01:00.0: could not execute otp for board id check: -110
> [   25.277326] ath10k_pci 0000:01:00.0: failed to fetch board data for bus=pci,vendor=168c,device=0046,subsystem-vendor=168c,subsystem-device=cafem...from ath10k/QCA9984/hw1.0/board-2.bin
> [   25.277588] ath10k_pci 0000:01:00.0: board_file api 1 bmi_id N/A crc32 dd636801
> [   26.800717] ath10k_pci 0000:01:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal file max-sta 512 raw 0 hwcrypto 1
> [...]
>
> <https://forum.lede-project.org/t/netgear-r7800-exploration-ipq8065-qca9984/285/277>
> 
> What seems strange is that only the call bmi_execute with 
> BMI_PARAM_GET_EEPROM_BOARD_ID is timing out. [...]
> 
> This begs the question, what is so special about the BMI_PARAM_GET_EEPROM_BOARD_ID
> at that time for the QCA9984? Does the device need some extra msleep time after
> the OTP has been uploaded? Or is the BMI_PARAM_GET_EEPROM_BOARD_ID not 
> implemented/has a different ID, etc... ?

The issue regarding the BMI_PARAM_GET_EEPROM_BOARD_ID has
been addressed by the following patch:
"[PATCH] ath10k: Add BMI parameters to fix calibration from DT/pre-cal"
<https://patchwork.kernel.org/patch/9748097/>
|QCA99X0, QCA9888, QCA9984 supports calibration data in
|either OTP or DT/pre-cal file. Current ath10k supports
|Calibration data from OTP only.
|
|If caldata is loaded from DT/pre-cal file, fetching board id
|and applying calibration parameters like tx power gets failed.
|
|error log:
|[   15.733663] ath10k_pci 0000:01:00.0: failed to fetch board file: -2
|[   15.741474] ath10k_pci 0000:01:00.0: could not probe fw (-2)
|
|This patch adds calibration data support from DT/pre-cal
|file.  Below parameters are used to get board id and
|applying calibration parameters from cal data.
|
|		EEPROM[OTP]	FLASH[DT/pre-cal file]
|Cal param	0x700		0x10000
|Board id	0x10		0x8000
|
|Tested on QCA9888 with pre-cal file.

Several developers and users have reported success with Pavel's PR:
<https://github.com/lede-project/source/pull/1153>

[   19.132296] ath10k_pci 0000:01:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
[   19.314182] ath10k_pci 0000:01:00.0: Direct firmware load for ath10k/pre-cal-pci-0000:01:00.0.bin failed with error -2
[   19.314235] ath10k_pci 0000:01:00.0: Falling back to user helper
[   32.827197] ath10k_pci 0000:01:00.0: qca9984/qca9994 hw1.0 target 0x01000000 chip_id 0x00000000 sub 168c:cafe
[   32.827233] ath10k_pci 0000:01:00.0: kconfig debug 0 debugfs 1 tracing 0 dfs 1 testmode 1
[   32.839487] ath10k_pci 0000:01:00.0: firmware ver 10.4-3.4-00082 api 5 features no-p2p,mfp,peer-flow-ctrl,[...]
[   35.116999] ath10k_pci 0000:01:00.0: *board_file api 2 bmi_id 0:1* crc32 751efba1
[   40.981190] ath10k_pci 0000:01:00.0: htt-ver 2.2 wmi-op 6 htt-op 4 cal pre-cal-file max-sta 512 raw 0 hwcrypto 1

All existing users of 936-ath10k_skip_otp_check.patch should be
able to drop the 936-patch entirely and switch to the pre-cal
file cal method for their devices.

Regards,
Christian
