Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab2HJQg7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 12:36:59 -0400
Date: Fri, 10 Aug 2012 18:36:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, johannes@sipsolutions.net,
	coelho@ti.com, assaf@ti.com, yoni.divinsky@ti.com, igalc@ti.com,
	adrian@freebsd.org, nbd@nbd.name,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: Re: [PATCH v3 6/7] mac80211: add ap channel switch command/event
Message-ID: <20120810163635.GC17559@redhat.com> (sfid-20120810_183703_069570_605EAF16)
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
 <1344426823-1795-7-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1344426823-1795-7-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2012 at 02:53:42PM +0300, Victor Goldenshtein wrote:
>  	void (*channel_switch)(struct ieee80211_hw *hw,
>  			       struct ieee80211_channel_switch *ch_switch);
> +	void (*ap_channel_switch)(struct ieee80211_hw *hw,
> +				  struct ieee80211_ap_ch_switch *ap_ch_switch);

Why we can not use ->channel_switch calback for this purpose (merge
ieee80211_channel_switch and ieee80211_ap_ch_switch)?

> +static int
> +ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
> +				struct net_device *dev,
> +				struct ieee80211_ap_ch_switch *ap_ch_switch)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +	struct ieee80211_local *local = sdata->local;
> +
> +	if (!local->ops->channel_switch)
> +		return -EOPNOTSUPP;

Probably you want to check local->ops->ap_channel_switch.

Stanislaw
