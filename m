Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:38773 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475AbbBIWAa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 17:00:30 -0500
Message-ID: <54D92DFC.1080604@broadcom.com> (sfid-20150209_230034_226349_F13BD30B)
Date: Mon, 9 Feb 2015 23:00:28 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Steeve Morin <steeve.morin@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + AP6120 (brcm43362) doesn't connect to WPA2 AP (unprotected
 ok)
References: <CAEZVCP4bNmfnHH=Ksi6wMQoqdZGbprUH5X_VA41GRf9=h2MT1A@mail.gmail.com>
In-Reply-To: <CAEZVCP4bNmfnHH=Ksi6wMQoqdZGbprUH5X_VA41GRf9=h2MT1A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/15 18:57, Steeve Morin wrote:
> Hi linux-wireless,
>
> I'm running brcmfmac from backports-3.19-rc1-1 on linux 3.10. running
> on an arm Amlogic S805 (cortex-a5, arm7) board (CX-S859).
>
> I had to apply multiple custom patches [1]:
> - Make sure the wifi chip is on via custom GPIO [1]
> - Remove a problematic piece of code related to power manager (will
> look into it later) [1]
> - Mix the mmc->max_blk_count on the host (would cause a BUG_ON
> assertion later on) [2] [3]
>
> After that, I am able to modprobe brcmfmac see wlan0.
> The interface correctly scans for wifi aps, and I can connect to
> unprotected ones.
>
> It fails, however, to connect to WPA/WPA2 protected aps. I have
> attached a debug log obtained with debug=0xffffff [4]
> I don't see any errors in it though...
>
> Would anyone of you guys have any idea why ?

In the log I don't see any connect attempt. Only seeing a scan 
completing. So how do you try to connect?

Regards,
Arend

> Thanks a lot,
>
> [1] https://gist.github.com/steeve/10a9a643476cea99abf4#file-backports-power-on-wifi-sdio-patch
> [2] https://gist.github.com/steeve/10a9a643476cea99abf4#file-fix-block-size-patch
> [3] https://github.com/codesnake/linux-amlogic/blob/master/drivers/amlogic/mmc/aml_sdio.c#L317
> [4] https://gist.github.com/steeve/10a9a643476cea99abf4#file-003-dmesg-log

