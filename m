Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3BZUb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:31:27 -0500
Message-ID: <1361910682.8440.7.camel@jlt4.sipsolutions.net> (sfid-20130226_213130_685695_4B4F96AA)
Subject: Re: [PATCHv2] cfg80211: Extend support for IEEE 802.11r Fast BSS
 Transition
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Feb 2013 21:31:22 +0100
In-Reply-To: <20130226103819.GA5630@jouni.qca.qualcomm.com>
References: <20130221060843.GA24491@w1.fi>
	 <1361565394.3420.17.camel@jlt4.sipsolutions.net>
	 <20130226103819.GA5630@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hmm, I forgot something:

> +struct cfg80211_update_ft_ies_params {
> +	u16 md;
> +	u8 *ie;

> +struct cfg80211_ft_event_params {
> +	u8 *ies;
> +	size_t ies_len;
> +	u8 *target_ap;
> +	u8 *ric_ies;

The pointers should probably be const, but I actually made that change.

> +	return rdev->ops->update_ft_ies(&rdev->wiphy, dev, &ft_params);

However what I think you should still do is add tracing here and in the
event below:

> +void cfg80211_ft_event(struct net_device *netdev,
> +		       struct cfg80211_ft_event_params *ft_event)

johannes

