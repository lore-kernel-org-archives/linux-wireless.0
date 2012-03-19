Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344Ab2CSLDw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 07:03:52 -0400
Date: Mon, 19 Mar 2012 12:03:34 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: increase led's name buffer length
Message-ID: <20120319110332.GB6169@redhat.com> (sfid-20120319_120355_639375_17F0382C)
References: <1332026212-5391-1-git-send-email-kubakici@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1332026212-5391-1-git-send-email-kubakici@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 18, 2012 at 12:16:52AM +0100, Jakub Kicinski wrote:
> With 9-letter driver names phy's number was truncated
> to two characters, which caused warnings when creating
> sysfs entries for leds on systems with multiple devices.
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
> ---
>  drivers/net/wireless/rt2x00/rt2x00leds.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00leds.c b/drivers/net/wireless/rt2x00/rt2x00leds.c
> index ca585e3..8679d78 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00leds.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00leds.c
> @@ -124,17 +124,15 @@ static int rt2x00leds_register_led(struct rt2x00_dev *rt2x00dev,
>  
>  void rt2x00leds_register(struct rt2x00_dev *rt2x00dev)
>  {
> -	char dev_name[16];
> -	char name[32];
> +	char name[36];
>  	int retval;
>  	unsigned long on_period;
>  	unsigned long off_period;
> -
> -	snprintf(dev_name, sizeof(dev_name), "%s-%s",
> -		 rt2x00dev->ops->name, wiphy_name(rt2x00dev->hw->wiphy));
> +	const char *phy_name = wiphy_name(rt2x00dev->hw->wiphy);
>  
>  	if (rt2x00dev->led_radio.flags & LED_INITIALIZED) {
> -		snprintf(name, sizeof(name), "%s::radio", dev_name);
> +		snprintf(name, sizeof(name), "%s-%s::radio",
> +			 rt2x00dev->ops->name, phy_name);
I guess simpler would be just increase dev_name length, but patch looks
correct to me anyway.

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
