Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48169 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3A2XzR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 18:55:17 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U0L1H-0001Ta-Pn
	for linux-wireless@vger.kernel.org; Wed, 30 Jan 2013 00:55:15 +0100
Message-ID: <1359503740.8108.24.camel@jlt4.sipsolutions.net> (sfid-20130130_005521_375007_5E4F3C19)
Subject: Re: [PATCH 1/2] cfg80211: refactor hidden SSID finding
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 30 Jan 2013 00:55:40 +0100
In-Reply-To: <1359503120-25685-1-git-send-email-johannes@sipsolutions.net> (sfid-20130130_004508_523732_488C5419)
References: <1359503120-25685-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130130_004508_523732_488C5419)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-30 at 00:45 +0100, Johannes Berg wrote:

> @@ -469,14 +448,9 @@ static int cmp_hidden_bss(struct cfg80211_bss *a, struct cfg80211_bss *b)
>  	ie2 = cfg80211_find_ie(WLAN_EID_SSID, b_ies->data, b_ies->len);
>  
>  	/*
> -	 * Key comparator must use same algorithm in any rb-tree
> -	 * search function (order is important), otherwise ordering
> -	 * of items in the tree is broken and search gives incorrect
> -	 * results. This code uses same order as cmp_ies() does.
> -	 *
> -	 * Note that due to the differring behaviour with hidden SSIDs
> -	 * this function only works when "b" is the tree element and
> -	 * "a" is the key we're looking for.
> +	 * Note that with "hide_ssid", the function returns a match if
> +	 * the already-present BSS ("b") is a hidden SSID beacon for
> +	 * the new BSS ("a").
>  	 */
>  

Need to insert
	if (!ie1 && !ie2)
		return 0;

here.

johannes

