Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0KIQsY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 11:48:24 -0500
Subject: Re: [PATCH] mac80211: Add function to get probe request template
 for current AP
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1289290893-6766-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1289290893-6766-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 11:47:44 -0500
Message-ID: <1289321264.3660.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-09 at 10:21 +0200, juuso.oikarinen@nokia.com wrote:

> +struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
> +					  struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +	struct sk_buff *skb;
> +	const u8 *ssid;
> +
> +	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
> +		return NULL;
> +
> +	ASSERT_MGD_MTX(ifmgd);

This is interesting locking, you will definitely need to document better
that this may only be called from within the bss_info_changed callback.

johannes

