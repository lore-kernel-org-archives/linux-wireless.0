Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52133 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616Ab2ALUux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 15:50:53 -0500
Subject: Re: [PATCH 2/2] mac80211: in IBSS use the Auth frame to trigger
 STA reinsertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1326400616-1109-2-git-send-email-ordex@autistici.org>
References: <1326400616-1109-1-git-send-email-ordex@autistici.org>
	 <1326400616-1109-2-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 21:50:51 +0100
Message-ID: <1326401451.3463.11.camel@jlt3.sipsolutions.net> (sfid-20120112_215057_541933_39B91364)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-12 at 21:36 +0100, Antonio Quartulli wrote:

> +static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
> +					struct ieee80211_mgmt *mgmt,
> +					size_t len)
> +{
> +	u16 auth_alg, auth_transaction;
> +	size_t baselen;
> +
> +	lockdep_assert_held(&sdata->u.ibss.mtx);
> +
> +	if (len < 24 + 6)
> +		return;
> +
> +	baselen = (u8 *) mgmt->u.auth.variable - (u8 *) mgmt;
> +	if (baselen > len)
> +		return;
> +
> +	auth_alg = le16_to_cpu(mgmt->u.auth.auth_alg);
> +	auth_transaction = le16_to_cpu(mgmt->u.auth.auth_transaction);
> +
> +	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1) {

negating & return would be easier to read & less indentation

> +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> +		printk(KERN_DEBUG "%s: RX Auth SA=%pM DA=%pM BSSID=%pM."
> +		       "(auth_transaction=%d)\n",
> +		       sdata->name, mgmt->sa, mgmt->da, mgmt->bssid,
> +		       auth_transaction);
> +#endif
> +		if (sta_info_destroy_addr(sdata, mgmt->sa) != -ENOENT) {
> +			ieee80211_ibss_add_sta(sdata, mgmt->bssid, mgmt->sa, 0,
> +					       false);
> +			rcu_read_unlock();
> +		}

This doesn't seem to make sense, why not add the station even if we
didn't know about it before?

johannes

