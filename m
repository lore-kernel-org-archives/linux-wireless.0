Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1HHNVd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:21:33 -0400
Subject: Re: [PATCH 1/6] mac80211: fix mesh beacon format
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1311638357-28740-2-git-send-email-thomas@cozybit.com> (sfid-20110726_020028_218245_4C8AE607)
References: <1311638357-28740-1-git-send-email-thomas@cozybit.com>
	 <1311638357-28740-2-git-send-email-thomas@cozybit.com>
	 (sfid-20110726_020028_218245_4C8AE607)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 15:21:30 +0200
Message-ID: <1312809690.4372.31.camel@jlt3.sipsolutions.net> (sfid-20110808_152149_198441_DF5D75F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-07-25 at 16:59 -0700, Thomas Pedersen wrote:

> -void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
> +inline int
> +mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)

Please don't manually mark any functions as inline -- the compiler will
do it for you where it makes sense.

> +++ b/net/mac80211/mesh.h
> @@ -199,6 +199,20 @@ bool mesh_matches_local(struct ieee802_11_elems *ie,
>  void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
>  void mesh_mgmt_ies_add(struct sk_buff *skb,
>  		struct ieee80211_sub_if_data *sdata);
> +inline int mesh_add_meshconf_ie(struct sk_buff *skb,
> +				struct ieee80211_sub_if_data *sdata);

Except it can't even do it... are you confused about how inline works?


> -		mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
> +		mgmt->u.beacon.capab_info |= sdata->u.mesh.security
> +					     ? WLAN_CAPABILITY_PRIVACY
> +					     : 0;

Not really important, but it'd probably look better to write as
		mgmt->u.beacon.capa_info |=
			mesh.security ? ... : 0;
 
since then the ternary might fit on one line.

johannes

