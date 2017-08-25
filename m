Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:45386 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755448AbdHYSnC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 14:43:02 -0400
Date: Fri, 25 Aug 2017 20:42:57 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] rt2800: fix TX_PIN_CFG setting for non MT7620 chips
Message-ID: <20170825184257.GD1159@makrotopia.org> (sfid-20170825_204311_043110_2663A6D9)
References: <20170825150414.GA9283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170825150414.GA9283@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 25, 2017 at 05:04:15PM +0200, Stanislaw Gruszka wrote:
> Since commit 41977e86c984 ("rt2x00: add support for MT7620") we do not
> initialize TX_PIN_CFG setting. This cause breakage at least on some
> RT3573 devices. To fix the problem patch restores previous behaviour
> for non MT7620 chips.
> 
> Fixes: 41977e86c984 ("rt2x00: add support for MT7620")
> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1480829
> Reported-and-tested-by: Jussi Eloranta <jussi.eloranta@csun.edu>
> Cc: Daniel Golle <daniel@makrotopia.org>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Acked-by: Daniel Golle <daniel@makrotopia.org>

> ---
> v1 -> v2: patch for updated linux version
> 
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index 0b75def39c6c..d2c289446c00 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -3702,7 +3702,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
>  	if (rt2x00_rt(rt2x00dev, RT3572))
>  		rt2800_rfcsr_write(rt2x00dev, 8, 0);
>  
> -	tx_pin = rt2800_register_read(rt2x00dev, TX_PIN_CFG);
> +	if (rt2x00_rt(rt2x00dev, RT6352))
> +		tx_pin = rt2800_register_read(rt2x00dev, TX_PIN_CFG);
> +	else
> +		tx_pin = 0;
>  
>  	switch (rt2x00dev->default_ant.tx_chain_num) {
>  	case 3:
> -- 
> 2.7.5
