Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58566 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab0BIXBD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2010 18:01:03 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 09/11] b43: N-PHY: isloate 2055 radio setup
Date: Wed, 10 Feb 2010 00:01:00 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com> <1265745883-3392-10-git-send-email-zajec5@gmail.com>
In-Reply-To: <1265745883-3392-10-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201002100001.00411.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 February 2010 21:04:41 Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/phy_n.c |   24 ++++++++++++++++++------
>  1 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
> index 835d0da..631e01f 100644
> --- a/drivers/net/wireless/b43/phy_n.c
> +++ b/drivers/net/wireless/b43/phy_n.c
> @@ -155,6 +155,23 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
>  	//TODO
>  }
>  
> +
> +/* http://bcm-v4.sipsolutions.net/802.11/PHY/Radio/2055Setup */
> +static void b43_radio_2055_setup(struct b43_wldev *dev,
> +				const struct b43_nphy_channeltab_entry *e)
> +{
> +	B43_WARN_ON(dev->phy.rev >= 3);
> +
> +	b43_chantab_radio_upload(dev, e);
> +	udelay(50);
> +	b43_radio_write(dev, B2055_VCO_CAL10, 5);
> +	b43_radio_write(dev, B2055_VCO_CAL10, 45);
> +	if (dev->dev->bus->bustype == SSB_BUSTYPE_PCI)
> +		b43_read32(dev, B43_MMIO_MACCTL);

Just read MACCTL unconditionally. It obviously is just used for bus posting.
We usually also add a comment.

	b43_read32(dev, B43_MMIO_MACCTL); /* flush writes */

-- 
Greetings, Michael.
