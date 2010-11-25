Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52991 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0KYSLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 13:11:07 -0500
Subject: Re: [RFC 1/2] mac80211: Stop BA session event from device
From: Johannes Berg <johannes@sipsolutions.net>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>
References: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 19:11:06 +0100
Message-ID: <1290708666.3770.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-25 at 16:39 +0200, Shahar Levi wrote:

> +void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 tid,
> +				  const u8 *addr);

missing docs

> +void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 tid,
> +				  const u8 *addr)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct sta_info *sta = sta_info_get(sdata, addr);
> +
> +	__ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_INITIATOR, 0, true);
> +}
> +EXPORT_SYMBOL(ieee80211_stop_rx_ba_session);

Locking-wise, this is a disaster, as the function will acquire a mutex
that it also holds across other calls into the driver. It would seem
that this should have caused lockdep to warn you about ABBA style
deadlock since you call this with wl->mutex held, and previously you
said you were going to acquire that mutex from ampdu_action.

This should use a similar trick to the one used in TX aggregation.

johannes

