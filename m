Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33483 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab3FAMe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 08:34:27 -0400
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ulf Samuelsson <ntp@emagii.com>
Subject: Re: ath6kl_sdio blocked by RFKILL
References: <51A4C6D6.1020002@emagii.com>
Date: Sat, 1 Jun 2013 15:34:21 +0300
In-Reply-To: <51A4C6D6.1020002@emagii.com> (Ulf Samuelsson's message of "Tue,
	28 May 2013 17:01:42 +0200")
Message-ID: <8738t2nh6a.fsf@kamboji.qca.qualcomm.com> (sfid-20130601_143429_560292_F7A9BA52)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulf Samuelsson <ntp@emagii.com> writes:

> Have built the ath6kl_sdio driver for an Cortex-A5 chip using the
> linux-3.6.9 kernel
> File system built using Yocto  and Busybox RF-Kill.
>
> Kernel Config contains:
>
> CONFIG_RFKILL=m
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y
> # CONFIG_RFKILL_GPIO is not set
>
> When I do
>
> # ifconfig wlan0 up.
>
> I get the error message:
>
> ifconfig: SIOCSIFFLAGS: Operation not possible due to RF-kill
>
> If I run "rfkill list" I get
>
> 1: phy1: wlan
>         Soft blocked: yes
>         Hard blocked: no
>
>
> If I try to unblock using "rfkill unblock all" or "wifi" or "wlan",
> the soft block remains.

Have you tried "rfkill unblock 1"?

-- 
Kalle Valo
