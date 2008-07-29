Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:11654 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbYG2Uu2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 16:50:28 -0400
Received: by yw-out-2324.google.com with SMTP id 9so38106ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 13:50:27 -0700 (PDT)
Message-ID: <1ba2fa240807291350m4d698713k7c3ea21d25ee105f@mail.gmail.com> (sfid-20080729_225032_576524_34D9D465)
Date: Tue, 29 Jul 2008 23:50:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andreas Schwab" <schwab@suse.de>
Subject: Re: Fix iwlwifi compilation without CONFIG_IWLWIFI_DEBUG
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <jebq0g8qdf.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <jebq0g8qdf.fsf@sykes.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 10:03 PM, Andreas Schwab <schwab@suse.de> wrote:
> drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str' undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function it appears in.)
>
> Signed-off-by: Andreas Schwab <schwab@suse.de>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
> index 899d7a2..a58571c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-led.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-led.c
> @@ -195,8 +195,10 @@ static void iwl_led_brightness_set(struct led_classdev *led_cdev,
>                return;
>
>
> +#ifdef CONFIG_IWLWIFI_DEBUG
>        IWL_DEBUG_LED("Led type = %s brightness = %d\n",
>                        led_type_str[led->type], brightness);
> +#endif
>        switch (brightness) {
>        case LED_FULL:
>                if (led->type == IWL_LED_TRG_ASSOC)
>

Thanks for your patch
But the fixes were already sent out  a week ago or You can find them
on this mailing list.
Tomas
