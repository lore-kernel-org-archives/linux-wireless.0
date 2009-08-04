Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34978 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754503AbZHDWR5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:17:57 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?utf-8?q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [PATCH] b43: Typo fixes & minor cleanup
Date: Wed, 5 Aug 2009 00:17:53 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A78B1F2.8050803@gmail.com>
In-Reply-To: <4A78B1F2.8050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908050017.53378.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 August 2009 00:10:58 Gábor Stefanik wrote:
> Fix a typo in the HostFlags #defines.
> Make use of HostFlags defines in the LP-PHY code.
> Fix fallout from the IEEE80211_IF_TYPE to NL80211_IFTYPE change.
> 
> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> ---
> 
>  drivers/net/wireless/b43/b43.h    |    4 ++--
>  drivers/net/wireless/b43/phy_lp.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
> index 41ca727..5d79d10 100644
> --- a/drivers/net/wireless/b43/b43.h
> +++ b/drivers/net/wireless/b43/b43.h
> @@ -300,7 +300,7 @@ enum {
>  #define B43_HF_TXBTCHECK	0x000002000000ULL /* Bluetooth check during transmission */
>  #define B43_HF_SKCFPUP		0x000004000000ULL /* Skip CFP update */
>  #define B43_HF_N40W		0x000008000000ULL /* N PHY 40 MHz workaround (rev >= 13 only) */
> -#define B43_HF_ANTSEL		0x000020000000ULL /* Antenna selection (for testing antenna div.) */
> +#define B43_HF_ANTSEL		0x000010000000ULL /* Antenna selection (for testing antenna div.) */

Uhm, no?
http://bcm-v4.sipsolutions.net/802.11/Host Flags

The code it correct.

>  #define B43_HF_BT3COEXT		0x000020000000ULL /* Bluetooth 3-wire coexistence (rev >= 13 only) */
>  #define B43_HF_BTCANT		0x000040000000ULL /* Bluetooth coexistence (antenna mode) (rev >= 13 only) */
>  #define B43_HF_ANTSELEN		0x000100000000ULL /* Antenna selection enabled (rev >= 13 only) */
> @@ -627,7 +627,7 @@ struct b43_wl {
>  	u8 mac_addr[ETH_ALEN];
>  	/* Current BSSID */
>  	u8 bssid[ETH_ALEN];
> -	/* Interface type. (IEEE80211_IF_TYPE_XXX) */
> +	/* Interface type. (NL80211_IFTYPE_XXX) */

ack

>  	int if_type;
>  	/* Is the card operating in AP, STA or IBSS mode? */
>  	bool operating;
> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> index 5d50943..03a9b50 100644
> --- a/drivers/net/wireless/b43/phy_lp.c
> +++ b/drivers/net/wireless/b43/phy_lp.c
> @@ -130,7 +130,7 @@ static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
>  		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x0006);
>  		b43_phy_write(dev, B43_LPPHY_GPIO_SELECT, 0x0005);
>  		b43_phy_write(dev, B43_LPPHY_GPIO_OUTEN, 0xFFFF);
> -		b43_hf_write(dev, b43_hf_read(dev) | 0x0800ULL << 32);
> +		b43_hf_write(dev, b43_hf_read(dev) | B43_HF_PR45960W);

ack

>  	}
>  	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
>  		b43_phy_set(dev, B43_LPPHY_LP_PHY_CTL, 0x8000);



-- 
Greetings, Michael.
