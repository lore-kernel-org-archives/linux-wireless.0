Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaDVPY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 11:24:26 -0400
Message-ID: <1398180248.4211.23.camel@jlt4.sipsolutions.net> (sfid-20140422_172442_869191_9A7FE2D6)
Subject: Re: [PATCH] mac80211: Allow HT capa override to add 40 MHz
 intolerant
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 17:24:08 +0200
In-Reply-To: <20140415161356.GA14293@jouni.qca.qualcomm.com>
References: <20140415161356.GA14293@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-04-15 at 19:13 +0300, Jouni Malinen wrote:
> This can be useful for testing purposes to confirm valid AP behavior on
> HT 20/40 co-existence functionality.

Applied.


> +++ b/net/mac80211/main.c
> @@ -446,7 +446,8 @@ static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
>  	.cap_info = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
>  				IEEE80211_HT_CAP_MAX_AMSDU |
>  				IEEE80211_HT_CAP_SGI_20 |
> -				IEEE80211_HT_CAP_SGI_40),
> +				IEEE80211_HT_CAP_SGI_40 |
> +				IEEE80211_HT_CAP_40MHZ_INTOLERANT),

This had a conflict because LDPC was already in those flags ... I think
I did the right thing by just adding 40MHZ_INTOLERANT.

johannes

