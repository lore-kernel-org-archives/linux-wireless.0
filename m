Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22361 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608Ab2C2PhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 11:37:00 -0400
Message-ID: <4F748194.5080009@qca.qualcomm.com> (sfid-20120329_173710_124623_9273E47D)
Date: Thu, 29 Mar 2012 18:36:52 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joyce Chain <joycechien0306@gmail.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [Question] AR6003 build-in for Linux Kernel 3.0.8
References: <CA+eKVEmqx4RnVCPkCnDcD_W1ZKatK9QPVLnGSEfVVYEtw-4LAQ@mail.gmail.com>
In-Reply-To: <CA+eKVEmqx4RnVCPkCnDcD_W1ZKatK9QPVLnGSEfVVYEtw-4LAQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joyce,

On 03/27/2012 10:36 AM, Joyce Chain wrote:
> I have to try compile ath6kl on Linux Kernel 3.0.8 for out target.
> The compile options are CONFIG_ATH6K_LEGACY=Y, CONFIG_MMC=y,
> CONFIG_WLAN=y, CONFIG_CFG80211=y.
> And copy binary files(bdata.SD31.bin, bdata.SD32.bin, bdata.WB31.bin,
> data.patch.bin, endpointping.bin, fw-2.bin, otp.bin) to [Linux
> Kernel]/firmware/ath6k/AR6003/hw2.1.1/.
> But the execute results are as below on out target:
> 
> mmc1: queuing unknown CIS tuple 0x80 (1 bytes)
> mmc1: queuing unknown CIS tuple 0x81 (1 bytes)
> mmc1: queuing unknown CIS tuple 0x82 (1 bytes)
> mmc1: new high speed SDIO card at address 0001
> AR6000: Unsupported configuration opcode: 3
> AR6000: Unsupported configuration opcode: 3
> HIF Interrupt processing is SYNC ONLY
> AR6000: Unsupported configuration opcode: 7
> AR6000: Unsupported configuration opcode: 5
> In aggr_init..
> going out of aggr_init..status OK
>   baud = 0x0001C200
>   quot = 0x00030068
>         -E- SdioHost_WaitTransfer timeout : 1
>         -E- McardC=10202, McSdC=5db5, McSdArg=941fb824, McSdIc=1, McSdOp=0
>         -E- SDIO fail in CMD-53
>         [DMA] CurAddr f4d8024 StartAddr f4d8000 MC_DMARL 800009
>         dwTimeOut 0x3000000
> AR6000: SDIO bus operation failed! MMC stack returned : -2
> Unable to send the BMI data to the device
> Unable to write to the device
> BMI operation failed: 1134
> ar6000_avail: ar6000_sysfs_bmi_get_config failed

You are still using the old version of ath6kl from staging. But it seems
that there's a problem with the SDIO bus, I just don't know what as I
have forgotten almost everything from the staging version.

If you want to try the "new" ath6kl you need to install compat-wireless
on your device. But I don't know if that will work any better.

Kalle
