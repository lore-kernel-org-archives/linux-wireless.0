Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54167 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZIZME4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 08:04:56 -0400
Received: by fxm18 with SMTP id 18so2751909fxm.17
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2009 05:04:59 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH 2/4] ath9k: move hw code to its own module
Date: Sat, 26 Sep 2009 14:04:54 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	devel@linuxdriverproject.org, ath9k-devel@lists.ath9k.org,
	Jouni Malinen <jouni.malinen@atheros.com>
References: <1253761622-9530-1-git-send-email-lrodriguez@atheros.com> <1253761622-9530-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1253761622-9530-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200909261404.54906.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 September 2009 05:07:00 Luis R. Rodriguez wrote:
> hw code for Atheros 802.11n hardware is commmon between
> different chipsets. This moves this code into a separate
> module, the next expected user of this code will be
> the ath9k_htc module.
> 
> The ath9k/ dir is now selected by ATH9K_HW, an option which
> gets selected by either ath9k or ath9k_htc, but remains
> invisible for user menuconfig configuration. If either
> ath9k or ath9k_htc will be compiled into the kernel
> ath9k_hw will also be compiled in.
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 7a4de3d..7d167a1 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -33,6 +33,23 @@ static u32 ath9k_hw_ini_fixup(struct ath_hw *ah,
>  static void ath9k_hw_9280_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
>  static void ath9k_hw_spur_mitigate(struct ath_hw *ah, struct ath9k_channel *chan);
>  
> +MODULE_AUTHOR("Atheros Communications");
[...]
> +
> +static int __init ath9k_init(void)
> +{
> +	return 0;
> +}
> +module_init(ath9k_init);
> +
> +static void __exit ath9k_exit(void)
> +{
> +	return;
> +}
> +module_exit(ath9k_exit);
> +
>  /********************/
>  /* Helper Functions */
>  /********************/

FYI: there's no need for module_init/module_exit stubs.
( http://osdir.com/ml/linux-wireless/2009-04/msg00478.html )
