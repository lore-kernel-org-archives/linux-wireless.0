Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab1LNWLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 17:11:10 -0500
Subject: Re: [PATCH] mac80211: Use appropriate TID for sending BAR, ADDBA
 and DELBA frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	adrian@freebsd.org
In-Reply-To: <1323871851-4808-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111214_151134_351207_1D01AC58)
References: <1323871851-4808-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111214_151134_351207_1D01AC58)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 23:11:07 +0100
Message-ID: <1323900667.3599.5.camel@jlt3.sipsolutions.net> (sfid-20111214_231114_644487_44F7C18E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-14 at 15:10 +0100, Helmut Schaa wrote:

> +void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
> +{
> +	/* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
> +	ieee80211_tx_skb_tid(sdata, skb, 7);
> +}
> +

This is so trivial, maybe it should be an inline?

johannes

