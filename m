Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:51725 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031005Ab2CSUV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 16:21:59 -0400
Received: by wejx9 with SMTP id x9so6181955wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 13:21:58 -0700 (PDT)
References: <1332026212-5391-1-git-send-email-kubakici@wp.pl>
In-Reply-To: <1332026212-5391-1-git-send-email-kubakici@wp.pl>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <322D82E0-0B84-4EFA-B198-E3CB00A2FC3E@gmail.com> (sfid-20120319_212204_019024_9BFA00F8)
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"IvDoorn@gmail.com" <IvDoorn@gmail.com>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	Jakub Kicinski <kubakici@wp.pl>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: increase led's name buffer length
Date: Mon, 19 Mar 2012 21:21:56 +0100
To: Jakub Kicinski <kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 mrt. 2012, at 00:16, Jakub Kicinski <kubakici@wp.pl> wrote:

> With 9-letter driver names phy's number was truncated
> to two characters, which caused warnings when creating
> sysfs entries for leds on systems with multiple devices.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
> drivers/net/wireless/rt2x00/rt2x00leds.c |   16 ++++++++--------
> 1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
> index ca585e3..8679d78 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00leds.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
> @@ -124,17 +124,15 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
> 
> void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
> {
> -    char dev_name[16];
> -    char name[32];
> +    char name[36];
>    int retval;
>    unsigned long on_period;
>    unsigned long off_period;
> -
> -    snprintf(dev_name, sizeof(dev_name), "%s-%s",
> -         rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
> +    const char *phy_name = wiphy_name(rt2x00dev->hw->wiphy);
> 
>    if (rt2x00dev->led_radio.flags & LED_INITIALIZED) {
> -        snprintf(name, sizeof(name), "%s::radio", dev_name);
> +        snprintf(name, sizeof(name), "%s-%s::radio",
> +             rt2x00dev->ops->name, phy_name);
> 
>        retval = rt2x00leds_register_led(rt2x00dev,
>                         &rt2x00dev->led_radio,
> @@ -144,7 +142,8 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
>    }
> 
>    if (rt2x00dev->led_assoc.flags & LED_INITIALIZED) {
> -        snprintf(name, sizeof(name), "%s::assoc", dev_name);
> +        snprintf(name, sizeof(name), "%s-%s::assoc",
> +             rt2x00dev->ops->name, phy_name);
> 
>        retval = rt2x00leds_register_led(rt2x00dev,
>                         &rt2x00dev->led_assoc,
> @@ -154,7 +153,8 @@ void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
>    }
> 
>    if (rt2x00dev->led_qual.flags & LED_INITIALIZED) {
> -        snprintf(name, sizeof(name), "%s::quality", dev_name);
> +        snprintf(name, sizeof(name), "%s-%s::quality",
> +             rt2x00dev->ops->name, phy_name);
> 
>        retval = rt2x00leds_register_led(rt2x00dev,
>                         &rt2x00dev->led_qual,
> -- 
> 1.7.7.6
> 
