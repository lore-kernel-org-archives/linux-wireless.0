Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:60034 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbYFHKSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 06:18:36 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1403938waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 03:18:36 -0700 (PDT)
Message-ID: <1ba2fa240806080318g45a8042csb4eec293a3d1ee5b@mail.gmail.com> (sfid-20080608_121840_117261_05AB5E83)
Date: Sun, 8 Jun 2008 13:18:36 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcin Slusarz" <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] iwlwifi: fix oops in iwl3945_led_brightness_set
Cc: linux-wireless@vger.kernel.org, "Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080608084855.GA8167@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080608084855.GA8167@joi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 8, 2008 at 11:48 AM, Marcin Slusarz
<marcin.slusarz@gmail.com> wrote:
> fix race between:
> ieee80211_open->ieee80211_led_radio->led_trigger_event->led_set_brightness->iwl3945_led_brightness_set
> (which assumes that "led->priv" is not NULL)
> and
> iwl3945_pci_probe->iwl3945_setup_deferred_work->(...)->iwl3945_bg_alive_start->iwl3945_alive_start->iwl3945_led_register->iwl3945_led_register_led
> which sets priv field in struct iwl3945_led
> after
> led->led_dev.brightness_set = iwl3945_led_brightness_set;
> (...)
> led_classdev_register(device, &led->led_dev);
>
> http://kerneloops.org/guilty.php?guilty=iwl3945_led_brightness_set&version=2.6.25-release&start=1671168&end=1703935&class=oops
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Reinette Chatre <reinette.chatre@intel.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: ipw3945-devel@lists.sourceforge.net
> ---
>
> Compile tested only. Please review and test on real hardware.
>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945-led.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> index d200d08..9f08568 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
> @@ -185,6 +185,8 @@ static void iwl3945_led_brightness_set(struct led_classdev *led_cdev,
>                                               struct iwl3945_led, led_dev);
>        struct iwl3945_priv *priv = led->priv;
>
> +       if (!led->registered)
> +               return;
>        if (test_bit(STATUS_EXIT_PENDING, &priv->status))
>                return;
>
> --
> 1.5.4.5
>
NACK
Just need to revert the order in registration command as done in
iwl_leds_register_led.
Let me know if you want to provide that fix

Thanks
Tomas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
