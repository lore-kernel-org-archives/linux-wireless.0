Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2LUOLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 09:11:05 -0500
Message-ID: <1356099083.9580.7.camel@jlt4.sipsolutions.net> (sfid-20121221_151110_396835_5DCC979C)
Subject: Re: [PATCH] mac80211: Fix the MAX MTU calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya <chaitanyatk@posedge.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 21 Dec 2012 15:11:23 +0100
In-Reply-To: <50D44BCC.30304@posedge.com>
References: <201212211141.qBLBfZdq015078@chaitanya-desktop>
	 <50D44BCC.30304@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-21 at 17:15 +0530, Chaitanya wrote:
> Fix the Max MTU calculations.
> Do not take headers in to account, only MAX MSDU size
> as per 802.11-2012(8.2.3) is enough.

Applied, but I rewrote the changelog a bit,

> ToDo: Add support for AMSDU in future.

removed this (AMSDU is irrelevant here)

> -	int meshhdrlen;
> -	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> -
> -	meshhdrlen = (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) ? 5 : 0;
> +	/* 802.11-2012: 8.2.3: The maximum frame body size is determined by
> +	1. The maximum MSDU size (2304 octets),
> +	2. plus the length of the Mesh Control field (6, 12, or 18 octets)
> +		if present,
> +	3. the maximum unencrypted MMPDU size excluding the MAC header and
> +		FCS (2304 octets) or
> +	4. the maximum A- MSDU size (3839 or 7935 octets),
> +		plus any overhead from security encapsulation.
> +	Note1: IEEE80211_MAX_DATA_LEN doesnt include any headers (2304),
> +		so it can be used directly+ Mesh HDR Len
> +	Note2: In Other places (skb_alloc) its handled properly.
> +
> +	ToDO: Make the MAX_DATA_LEN driver configurable through its
> +	AMSDU capabilities.
> +	 */

and I also removed the big comment that doesn't really apply

johannes

