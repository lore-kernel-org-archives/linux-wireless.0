Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33061 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753432AbeGEVbc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 17:31:32 -0400
Subject: Re: [PATCH v7 02/16] leds: triggers: let struct
 led_trigger::activate() return an error code
To: =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Pavel Machek <pavel@ucw.cz>, kernel@pengutronix.de,
        linux-leds@vger.kernel.org, kernel-patch-test@lists.linaro.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <a9b3548b-09c4-fae4-1bce-abf3392b9ceb@gmail.com>
 <20180702200535.1337-2-u.kleine-koenig@pengutronix.de>
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <1172a776-a951-28d5-fae4-824969f4a82b@gmail.com> (sfid-20180705_233147_049284_482CF31E)
Date: Thu, 5 Jul 2018 23:31:28 +0200
MIME-Version: 1.0
In-Reply-To: <20180702200535.1337-2-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Uwe,

On 07/02/2018 10:05 PM, Uwe Kleine-König wrote:
> Given that activating a trigger can fail, let the callback return an
> indication. This prevents to have a trigger active according to the
> "trigger" sysfs attribute but not functional.
> 
> All users are changed accordingly to return 0 for now. There is no intended
> change in behaviour.
> 
> Acked-by: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
[...]
> -static void ieee80211_tx_led_activate(struct led_classdev *led_cdev)
> +static int ieee80211_tx_led_activate(struct led_classdev *led_cdev)
>   {
>   	struct ieee80211_local *local = container_of(led_cdev->trigger,
>   						     struct ieee80211_local,
>   						     tx_led);
>   
>   	atomic_inc(&local->tx_led_active);
> +
> +	return 0
[...]

s/return 0/return 0;/

Fixed it up and applied. I'm taking lack of net maintainer feedback
as a tacit approval (or lack of interest).

-- 
Best regards,
Jacek Anaszewski
