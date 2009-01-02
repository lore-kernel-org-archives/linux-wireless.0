Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:17018 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943AbZABLOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 06:14:20 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1978303yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 03:14:17 -0800 (PST)
Message-ID: <a32f33a40901020314h3f33347dw6433e485abd627e5@mail.gmail.com> (sfid-20090102_121425_147815_E43B2150)
Date: Fri, 2 Jan 2009 12:14:17 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Andrew Price" <andy@andrewprice.me.uk>
Subject: Re: [PATCH] rt2x00: Fix radio LED type check
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090102080527.GA16585@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090102080527.GA16585@silver.sucs.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 2, 2009 at 9:05 AM, Andrew Price <andy@andrewprice.me.uk> wrote:
> Since commit 9a95dba32735534bda59def40c747bf606fedf05 "rt2x00: Fix LED
> state handling", rt2x00leds_led_radio wrongly checks that the LED type
> is LED_TYPE_ASSOC. This patch makes it check for LED_TYPE_RADIO once
> again.
>
> Signed-off-by: Andrew Price <andy@andrewprice.me.uk>

Good catch. Thanks.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2x00leds.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
> index 68f4e0f..a0cd35b 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00leds.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
> @@ -97,7 +97,7 @@ void rt2x00leds_led_assoc(struct rt2x00_dev *rt2x00dev, bool enabled)
>
>  void rt2x00leds_led_radio(struct rt2x00_dev *rt2x00dev, bool enabled)
>  {
> -       if (rt2x00dev->led_radio.type == LED_TYPE_ASSOC)
> +       if (rt2x00dev->led_radio.type == LED_TYPE_RADIO)
>                rt2x00led_led_simple(&rt2x00dev->led_radio, enabled);
>  }
>
> --
> 1.5.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
