Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47409 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbcAVI13 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 03:27:29 -0500
Date: Fri, 22 Jan 2016 11:27:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 24/26] staging: wilc1000: add ops tx power in cfg80211
Message-ID: <20160122082714.GF5325@mwanda> (sfid-20160122_092756_591520_AA1441D7)
References: <1452584395-24910-1-git-send-email-glen.lee@atmel.com>
 <1452584395-24910-25-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1452584395-24910-25-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 12, 2016 at 04:39:53PM +0900, Glen Lee wrote:
> +static void handle_set_tx_pwr(struct wilc_vif *vif, u8 tx_pwr)
> +{
> +	s32 ret = 0;

s32 should almost always be changed to int.  Don't initialize variables
with bogus values.  GCC has a helper warning for uninitialized variables
and this disables GCC's uninitialized variable checking.

> +	struct wid wid;
> +
> +	wid.id = (u16)WID_TX_POWER;
> +	wid.type = WID_CHAR;
> +	wid.val = (s8 *)&tx_pwr;

Casting an unsigned value from the user to signed seems like a recipe
for disaster.

> +	wid.size = sizeof(char);
> +
> +	ret = wilc_send_config_pkt(vif->wilc, SET_CFG, &wid, 1,
> +			     wilc_get_vif_idx(vif));
> +	if(ret)

grumble grumble... checkpatch.

> +		netdev_err(vif->ndev,"Failed to set TX PWR\n");
> +}

[ snip]

> +static int set_tx_power(struct wiphy *wiphy, struct wireless_dev *wdev,
> +			enum nl80211_tx_power_setting type, int mbm)
> +{
> +	int ret = 0;

No need.

> +	s32 tx_power = MBM_TO_DBM(mbm);
> +	struct wilc_priv *priv = wiphy_priv(wiphy);
> +	struct wilc_vif *vif = netdev_priv(priv->dev);
> +
> +	netdev_info(vif->ndev, "Setting tx power to %d\n", tx_power);

Remove this debug output.

> +
> +	if(tx_power < 0)

grumble.

> +		tx_power = 0;
> +	else if(tx_power > 18)
> +		tx_power = 18;
> +	ret = wilc_set_tx_power(vif ,(u8)tx_power);

This cast is not needed.  Whitespace grumble.

regards,
dan carpenter

