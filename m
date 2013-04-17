Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:43148 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966587Ab3DQPur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:50:47 -0400
Received: by mail-we0-f178.google.com with SMTP id z53so1311892wey.23
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 08:50:46 -0700 (PDT)
Date: Wed, 17 Apr 2013 17:46:40 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v2 3/5] mac80211: improve the rate control API
Message-ID: <20130417154640.GC4319@magnum.frso.rivierawaves.com> (sfid-20130417_175051_089012_5A689AE6)
References: <1366112326-92981-1-git-send-email-nbd@openwrt.org>
 <1366112326-92981-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366112326-92981-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 01:38:44PM +0200, Felix Fietkau wrote:
> @@ -454,40 +666,27 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
[...]
> +int rate_control_set_rates(struct ieee80211_hw *hw,
> +			   struct ieee80211_sta *pubsta,
> +			   struct ieee80211_sta_rates *rates)
> +{
> +	struct ieee80211_sta_rates *old = rcu_dereference(pubsta->rates);
> +
> +	rcu_assign_pointer(pubsta->rates, rates);
> +	if (old)
> +		kfree_rcu(old, rcu_head);

This means the rate control module must allocate a different
ieee80211_sta_rates right ?

 
Karl
