Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51085 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYF1RKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 13:10:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH] b43/b43legacy: use RFKILL_STATE_UNBLOCKED instead of RFKILL_STATE_ON
Date: Sat, 28 Jun 2008 19:10:00 +0200
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	stefano.brivio@polimi.it,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
References: <f6ca9fed0806280520u10272c66see3e1d4a24cb2974@mail.gmail.com>
In-Reply-To: <f6ca9fed0806280520u10272c66see3e1d4a24cb2974@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200806281910.00764.mb@bu3sch.de> (sfid-20080628_191040_281081_5A871917)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 28 June 2008 14:20:40 drago01 wrote:
> This patch removes the usage RFKILL_STATE_ON and uses
> RFKILL_STATE_UNBLOCKED instead.
> 
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

ACK. john, please apply this one.

> diff --git a/drivers/net/wireless/b43/rfkill.c
> b/drivers/net/wireless/b43/rfkill.c
> index 4cca203..34ae125 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -135,7 +135,7 @@ void b43_rfkill_init(struct b43_wldev *dev)
>  	snprintf(rfk->name, sizeof(rfk->name),
>  		 "b43-%s", wiphy_name(wl->hw->wiphy));
>  	rfk->rfkill->name = rfk->name;
> -	rfk->rfkill->state = RFKILL_STATE_ON;
> +	rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
>  	rfk->rfkill->data = dev;
>  	rfk->rfkill->toggle_radio = b43_rfkill_soft_toggle;
>  	rfk->rfkill->user_claim_unsupported = 1;
> diff --git a/drivers/net/wireless/b43legacy/rfkill.c
> b/drivers/net/wireless/b43legacy/rfkill.c
> index 8935a30..b32bf6a 100644
> --- a/drivers/net/wireless/b43legacy/rfkill.c
> +++ b/drivers/net/wireless/b43legacy/rfkill.c
> @@ -139,7 +139,7 @@ void b43legacy_rfkill_init(struct b43legacy_wldev *dev)
>  	snprintf(rfk->name, sizeof(rfk->name),
>  		 "b43legacy-%s", wiphy_name(wl->hw->wiphy));
>  	rfk->rfkill->name = rfk->name;
> -	rfk->rfkill->state = RFKILL_STATE_ON;
> +	rfk->rfkill->state = RFKILL_STATE_UNBLOCKED;
>  	rfk->rfkill->data = dev;
>  	rfk->rfkill->toggle_radio = b43legacy_rfkill_soft_toggle;
>  	rfk->rfkill->user_claim_unsupported = 1;
> 
> 



-- 
Greetings Michael.
