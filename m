Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab2JPTDV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2012 15:03:21 -0400
Message-ID: <1350414234.10177.14.camel@jlt4.sipsolutions.net> (sfid-20121016_210325_443997_E4EDFBA3)
Subject: Re: [PATCH v4 4/6] mac80211: add ability to enable TX on op-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	igalc@ti.com, adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 16 Oct 2012 21:03:54 +0200
In-Reply-To: <1350226137-13704-5-git-send-email-victorg@ti.com>
References: <1350226137-13704-1-git-send-email-victorg@ti.com>
	 <1350226137-13704-5-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:

> +static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev,
> +			       struct ieee80211_channel *chan)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +	int ret = -ENOENT;
> +
> +	if (!local->ops->dfs_en_tx)
> +		return -EOPNOTSUPP;
> +
> +	ret = drv_dfs_en_tx(local, sdata, chan);
> +	return ret;

What's with the "ret" variable here?

johannes

