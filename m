Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3KXSfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 13:35:36 -0500
Message-ID: <1385318128.23961.0.camel@jlt4.sipsolutions.net> (sfid-20131124_193554_130494_AE4D6ACD)
Subject: Re: [PATCH 1/3] mac80211: implement ieee80211_get_vif_by_addr
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mcgrof@do-not-panic.com, sujith@msujith.org,
	rmanohar@qca.qualcomm.com
Date: Sun, 24 Nov 2013 19:35:28 +0100
In-Reply-To: <1385312211-3119-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131124_175656_328014_B79295F8)
References: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1385312211-3119-2-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20131124_175656_328014_B79295F8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-11-24 at 17:56 +0100, Lorenzo Bianconi wrote:
> ieee80211_get_vif_by_addr allows low level drivers to get a reference to
> vif data structure which is not added to the driver as monitor interface.
> ieee80211_get_vif_by_addr will be used in ath9k tx99 code

Is that really better than having the driver use the iteration
functions?

> + */
> +struct ieee80211_vif *ieee80211_get_vif_by_addr(struct ieee80211_hw *hw,
> +						const u8 *mac)
> +{
> +	struct ieee80211_vif *vif = NULL;
> +	struct ieee80211_local *local = hw_to_local(hw);
> +	struct ieee80211_sub_if_data *sdata;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
> +		if (!compare_ether_addr(sdata->vif.addr, mac)) {
> +			vif = &sdata->vif;
> +			break;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	return vif;

In any case, this is completely broken wrt. locking, so I'm not taking
it.

johannes

