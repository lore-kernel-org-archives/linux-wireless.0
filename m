Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14729 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388Ab1LTUCh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:02:37 -0500
Message-ID: <4EF0E9D1.4000207@qca.qualcomm.com> (sfid-20111220_210240_566172_E6679CEF)
Date: Tue, 20 Dec 2011 22:02:25 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/6] ath6kl: fix sparse warning on init.c
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com> <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com> <4EF0E4A3.9010306@qca.qualcomm.com> <20111220194618.GD15071@tux>
In-Reply-To: <20111220194618.GD15071@tux>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2011 09:46 PM, Luis R. Rodriguez wrote:
> On Tue, Dec 20, 2011 at 09:40:19PM +0200, Kalle Valo wrote:

>> I always check for both compiler and sparse warnings and I have never
>> seen this. What version of compiler do you have?
>>
>> I have:
>>
>> gcc-4.5.real (Ubuntu/Linaro 4.5.2-8ubuntu4) 4.5.2
> 
> Same.
> 
> mcgrof@tux ~ $ gcc --version
> gcc-4.5.real (Ubuntu/Linaro 4.5.2-8ubuntu4) 4.5.2

This is odd as I don't see it, even with latest wireless-testing:

$ make M=drivers/net/wireless/ath/ath6kl
  LD      drivers/net/wireless/ath/ath6kl/built-in.o
  CC [M]  drivers/net/wireless/ath/ath6kl/debug.o
  CC [M]  drivers/net/wireless/ath/ath6kl/hif.o
  CC [M]  drivers/net/wireless/ath/ath6kl/htc.o
  CC [M]  drivers/net/wireless/ath/ath6kl/bmi.o
  CC [M]  drivers/net/wireless/ath/ath6kl/cfg80211.o
  CC [M]  drivers/net/wireless/ath/ath6kl/init.o
  CC [M]  drivers/net/wireless/ath/ath6kl/main.o
  CC [M]  drivers/net/wireless/ath/ath6kl/txrx.o
  CC [M]  drivers/net/wireless/ath/ath6kl/wmi.o
  CC [M]  drivers/net/wireless/ath/ath6kl/sdio.o
  CC [M]  drivers/net/wireless/ath/ath6kl/testmode.o
  CC [M]  drivers/net/wireless/ath/ath6kl/usb.o
  LD [M]  drivers/net/wireless/ath/ath6kl/ath6kl_sdio.o
  LD [M]  drivers/net/wireless/ath/ath6kl/ath6kl_usb.o
  Building modules, stage 2.
  MODPOST 2 modules
  CC      drivers/net/wireless/ath/ath6kl/ath6kl_sdio.mod.o
  LD [M]  drivers/net/wireless/ath/ath6kl/ath6kl_sdio.ko
  CC      drivers/net/wireless/ath/ath6kl/ath6kl_usb.mod.o
  LD [M]  drivers/net/wireless/ath/ath6kl/ath6kl_usb.ko

I really would like to understand what's happening here...

But anyway, I think your test is not needed (unless I'm blind again).
Maybe uninitialized_var() is a better choise?

Kalle
