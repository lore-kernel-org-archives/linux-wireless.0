Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38366 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3HWJXC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:23:02 -0400
Message-ID: <1377249774.14021.15.camel@jlt4.sipsolutions.net> (sfid-20130823_112307_174018_ECB748AD)
Subject: Re: [PATCH v2 01/16] wcn36xx: Add main.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Fri, 23 Aug 2013 11:22:54 +0200
In-Reply-To: <1377248299-21007-2-git-send-email-k.eugene.e@gmail.com> (sfid-20130823_105928_264143_4BF93F2F)
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	 <1377248299-21007-2-git-send-email-k.eugene.e@gmail.com>
	 (sfid-20130823_105928_264143_4BF93F2F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 10:58 +0200, Eugene Krasnikov wrote:

> +static const struct ieee80211_iface_limit if_limits[] = {
> +	{ .max = 2, .types = BIT(NL80211_IFTYPE_STATION) },
> +	{ .max = 1, .types = BIT(NL80211_IFTYPE_AP) },
> +};
> +
> +static const struct ieee80211_iface_combination if_comb = {
> +	.limits = if_limits,
> +	.n_limits = ARRAY_SIZE(if_limits),
> +	.max_interfaces = 2,
> +	.num_different_channels = 1,
> +};

> +static int wcn36xx_add_interface(struct ieee80211_hw *hw,
> +				 struct ieee80211_vif *vif)
> +{
> +	struct wcn36xx *wcn = hw->priv;
> +
> +	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac add interface vif %p type %d\n",
> +		    vif, vif->type);
> +
> +	wcn->current_vif = (struct wcn36xx_vif *)vif->drv_priv;

If you actually support two interfaces (and that looks more likely now)
I don't think this "current_vif" makes any sense at all, it'll be
randomly pointing to one or the other depending on which one was added
last.

> +static int wcn36xx_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +			   struct ieee80211_sta *sta)
> +{
> +	struct wcn36xx *wcn = hw->priv;
> +
> +	wcn36xx_dbg(WCN36XX_DBG_MAC, "mac sta add vif %p sta %pM\n",
> +		    vif, sta->addr);
> +
> +	wcn->sta = (struct wcn36xx_sta *)sta->drv_priv;
> +	wcn->aid = sta->aid;

You support more than one interface and AP, but there's no way this code
can then be correct. It seems to me that you're really only supporting a
single client interface correctly right now.

johannes

