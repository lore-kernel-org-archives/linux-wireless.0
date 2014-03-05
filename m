Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60335 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaCELNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 06:13:40 -0500
Message-ID: <1394018015.5275.24.camel@jlt4.sipsolutions.net> (sfid-20140305_121343_289657_39FF5F8B)
Subject: Re: [PATCH 3.14.0-rc5 v3 6/10] rsi: MAC80211 callbacks and
 management functions internal to device
From: Johannes Berg <johannes@sipsolutions.net>
To: Fariya Fatima <fariya.f@redpinesignals.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Mar 2014 12:13:35 +0100
In-Reply-To: <53143B7C.5030602@redpinesignals.com> (sfid-20140303_092250_887269_13F7DCB5)
References: <53143B7C.5030602@redpinesignals.com>
	 (sfid-20140303_092250_887269_13F7DCB5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-03-03 at 13:51 +0530, Fariya Fatima wrote:

> +int rsi_mac80211_attach(struct rsi_common *common)
> +{
> +	int status = 0;
> +	struct ieee80211_hw *hw = NULL;
> +	struct wiphy *wiphy = NULL;
> +	struct rsi_hw *adapter = common->priv;
> +	u8 addr_mask[ETH_ALEN] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x3};
> +	struct ieee80211_supported_band *sband = &adapter->sbands[0];

This is pretty odd

> +	wiphy->bands[IEEE80211_BAND_2GHZ] = &sband[IEEE80211_BAND_2GHZ];

combined with that.

> +	/* wiphy->bands[IEEE80211_BAND_5GHZ] = &sband[IEEE80211_BAND_5GHZ]; */
> +
> +	status = ieee80211_register_hw(hw);
> +	if (status)
> +		return status;
> +
> +#ifdef CONFIG_RSI_DEBUGFS
> +	if (rsi_init_dbgfs(adapter)) {

similar comment here like with the teardown.

> +		rsi_dbg(ERR_ZONE, "%s: dbgfs not created\n", __func__);
> +		return -1;

-1 is also not a good error code, like before

johannes

