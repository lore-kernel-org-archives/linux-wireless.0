Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53887 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065AbZHPSJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2009 14:09:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: LP-PHY: Update B2062 radio init with recent spec changes
Date: Sun, 16 Aug 2009 20:09:34 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A884B0D.5000808@gmail.com>
In-Reply-To: <4A884B0D.5000808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908162009.34744.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 16 August 2009 20:08:13 Gábor Stefanik wrote:
> The spec for initializing the B2062 radio have changed recently,
> update the code to match the changes.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>

ack

> ---
>  drivers/net/wireless/b43/phy_lp.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 5a7b873..34b7910 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -539,10 +539,15 @@ static void lpphy_2062_init(struct b43_wldev *dev)
>  	b43_radio_write(dev, B2062_N_TX_CTL3, 0);
>  	b43_radio_write(dev, B2062_N_TX_CTL4, 0);
>  	b43_radio_write(dev, B2062_N_TX_CTL5, 0);
> +	b43_radio_write(dev, B2062_N_TX_CTL6, 0);
>  	b43_radio_write(dev, B2062_N_PDN_CTL0, 0x40);
>  	b43_radio_write(dev, B2062_N_PDN_CTL0, 0);
>  	b43_radio_write(dev, B2062_N_CALIB_TS, 0x10);
>  	b43_radio_write(dev, B2062_N_CALIB_TS, 0);
> +	if (dev->phy.rev > 0) {
> +		b43_radio_write(dev, B2062_S_BG_CTL1,
> +			(b43_radio_read(dev, B2062_N_COMM2) >> 1) | 0x80);
> +	}
>  	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
>  		b43_radio_set(dev, B2062_N_TSSI_CTL0, 0x1);
>  	else



-- 
Greetings, Michael.
