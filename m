Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:50583 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3FYVIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 17:08:05 -0400
References: <1372193849-21630-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1372193849-21630-1-git-send-email-juhosg@openwrt.org>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <6746D568-D668-4A19-A5A0-2BE8B2E657F7@gmail.com> (sfid-20130625_230810_616358_9BE18D3B)
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Gabor Juhos <juhosg@openwrt.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"#@arrakis.dune.hu" <#@arrakis.dune.hu>,
	"3.10@arrakis.dune.hu" <3.10@arrakis.dune.hu>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: rt2800lib: fix default TX power check for RT55xx
Date: Tue, 25 Jun 2013 23:08:02 +0200
To: Gabor Juhos <juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 25 jun. 2013, at 22:57, Gabor Juhos <juhosg@openwrt.org> wrote:

> The code writes the default_power2 value into the TX field
> of the RFCSR50 register, however the condition in the if
> statement uses default_power1. Due to this, wrong TX power
> value might be written into the register.
> 
> Use the correct value in the condition to fix the issue.
> 
> Compile tested only.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> Cc: stable@vger.kernel.org # 3.10

Good catch. Thanks for spotting it.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>


> ---
> John,
> 
> This is for 3.11. Even though the original code is introduced in
> 3.10-rc2 phase, but it is already too late to fix it in 3.10.
> 
> -Gabor
> ---
> drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 25f7dbe..1f80ea5 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2392,7 +2392,7 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
>    rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
> 
>    rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
> -    if (info->default_power1 > power_bound)
> +    if (info->default_power2 > power_bound)
>        rt2x00_set_field8(&rfcsr, RFCSR50_TX, power_bound);
>    else
>        rt2x00_set_field8(&rfcsr, RFCSR50_TX, info->default_power2);
> -- 
> 1.7.10
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
