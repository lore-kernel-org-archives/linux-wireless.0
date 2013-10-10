Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42443 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab3JJSAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 14:00:10 -0400
Date: Thu, 10 Oct 2013 13:45:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kevin Lo <kevlo@kevlo.org>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: rt2800lib: fix RF registers for RT5390/RT5392
Message-ID: <20131010174535.GE2691@tuxdriver.com> (sfid-20131010_200016_956325_F112BD2C)
References: <524BEB7A.8040508@kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <524BEB7A.8040508@kevlo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is corrupt...

On Wed, Oct 02, 2013 at 05:46:34PM +0800, Kevin Lo wrote:
> Update rf registers to use the same values that the MediaTek/Ralink
> reference driver DPO_RT5572_LinuxSTA_2.6.1.3_20121022 uses.
> 
> References:
>   RF5390RegTable in chips/rt5390.c
>   RF5392RegTable in chips/rt5390.c
> 
> Tested on TP-Link TL-WN727N and D-Link DWA-140 Rev.b3 usb wifi dongles.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> ---
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
> b/drivers/net/wireless/rt2x00/rt2800lib.c
> index f414978..0bbd1b5 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -6449,7 +6449,7 @@ static void rt2800_init_rfcsr_5390(struct
> rt2x00_dev *rt2x00dev)
>         rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
>         rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
> 
> -       rt2800_rfcsr_write(rt2x00dev, 30, 0x00);
> +       rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
>         rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
>         rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
>         rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
> @@ -6487,7 +6487,7 @@ static void rt2800_init_rfcsr_5390(struct
> rt2x00_dev *rt2x00dev)
>         rt2800_rfcsr_write(rt2x00dev, 56, 0x22);
>         rt2800_rfcsr_write(rt2x00dev, 57, 0x80);
>         rt2800_rfcsr_write(rt2x00dev, 58, 0x7f);
> -       rt2800_rfcsr_write(rt2x00dev, 59, 0x63);
> +       rt2800_rfcsr_write(rt2x00dev, 59, 0x8f);
> 
>         rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
>         if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F))
> @@ -6507,7 +6507,6 @@ static void rt2800_init_rfcsr_5392(struct
> rt2x00_dev *rt2x00dev)
>         rt2800_rf_init_calibration(rt2x00dev, 2);
> 
>         rt2800_rfcsr_write(rt2x00dev, 1, 0x17);
> -       rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
>         rt2800_rfcsr_write(rt2x00dev, 3, 0x88);
>         rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
>         rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
