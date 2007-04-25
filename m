Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:51403
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992717AbXDYM51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 08:57:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH] bcm43xx-mac80211: fix rx status reported frequency
Date: Wed, 25 Apr 2007 14:55:47 +0200
Cc: linux-wireless@vger.kernel.org, Joseph Jezak <josejx@gentoo.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <462E6DD1.4050108@warmcat.com>
In-Reply-To: <462E6DD1.4050108@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200704251455.48012.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Always inline patches, please.

On Tuesday 24 April 2007 22:51, Andy Green wrote:
> diff --git a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
> b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h index
> 44fa515..0372064 100644
> --- a/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
> +++ b/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.h
> @@ -190,8 +190,8 @@ struct bcm43xx_rxhdr_fw4 {
> =A0/* RX channel */
> =A0#define BCM43xx_RX_CHAN_GAIN=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A00xFC0=
0 /* Gain */
> =A0#define BCM43xx_RX_CHAN_GAIN_SHIFT=A0=A0=A0=A0=A010
> -#define BCM43xx_RX_CHAN_ID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A00x0=
3FC /* Channel ID */
> -#define BCM43xx_RX_CHAN_ID_SHIFT=A0=A0=A0=A0=A0=A0=A02
> +#define BCM43xx_RX_CHAN_ID=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A00x0=
3F8 /* Channel ID */
> +#define BCM43xx_RX_CHAN_ID_SHIFT=A0=A0=A0=A0=A0=A0=A03
> =A0#define BCM43xx_RX_CHAN_PHYTYPE=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A00x0003 /* PHY type */

according to the specs the value 0x3FC is right.
Johannes, Joe?

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
