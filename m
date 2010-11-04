Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab0KDCOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Nov 2010 22:14:06 -0400
Subject: Re: [PATCH 3/4] mac80211: don't fragment packets when
 HW-fragmentation is on
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1288821053-19013-4-git-send-email-arik@wizery.com>
References: <1288821053-19013-1-git-send-email-arik@wizery.com>
	 <1288821053-19013-4-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 03:15:08 +0100
Message-ID: <1288836908.4083.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-03 at 23:50 +0200, Arik Nemtsov wrote:
> If the driver supports hardware TX fragmentation, don't fragment
> packets in the stack.

I'm not sure why you have three patches? Seems like it could all be a
single mac80211 patch.

> @@ -1181,8 +1183,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
>  	/*
>  	 * Set this flag (used below to indicate "automatic fragmentation"),
>  	 * it will be cleared/left by radiotap as desired.
> +	 * Only valid when fragmentation is done by the stack.
>  	 */
> -	tx->flags |= IEEE80211_TX_FRAGMENTED;
> +	if (!(local->hw.flags & IEEE80211_HW_TX_FRAGMENTATION))
> +		tx->flags |= IEEE80211_TX_FRAGMENTED;

Do we really need the hw flag? Couldn't we go off the callback, like we
used to? I'm not really sure which one would perform better though, I
guess the flag might ...

johannes

