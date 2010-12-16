Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0LPSzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 13:55:36 -0500
Subject: Re: [PATCH 2/3 v2] mac80211: Let userspace enable and configure
 vendor specific path selection.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1292524200-14791-2-git-send-email-javier@cozybit.com>
References: <1292234643.3539.6.camel@jlt3.sipsolutions.net>
	 <1292524200-14791-2-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 19:55:34 +0100
Message-ID: <1292525734.3612.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 10:29 -0800, Javier Cardona wrote:

> +	ifmsh->vendor_ie_len = setup->vendor_ie_len;
> +	if (setup->vendor_ie_len) {
> +		new_ie = kmalloc(setup->vendor_ie_len, GFP_KERNEL);
> +		if (new_ie)
> +			new_ie = memcpy(new_ie, setup->vendor_ie,
> +					setup->vendor_ie_len);

kmemdup?


> @@ -287,6 +287,12 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
>  	*pos++ |= sdata->u.mesh.accepting_plinks ?
>  	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
>  	*pos++ = 0x00;
> +
> +	if (sdata->u.mesh.vendor_ie) {
> +		int len = sdata->u.mesh.vendor_ie_len;
> +		const u8 *data = sdata->u.mesh.vendor_ie;
> +		memcpy(skb_put(skb, len), data, len);
> +	}

don't you have to account for the size of these in the skb allocation?


> +	if (tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]) {
> +		setup->vendor_ie =
> +			nla_data(tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]);
> +		setup->vendor_ie_len =
> +			nla_len(tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE]);

I think you should check that these are well-formed IEs, there's a
utility function for that somewhere.

johannes

