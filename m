Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3BGIUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 03:20:08 -0500
Message-ID: <1360225230.8038.1.camel@jlt4.sipsolutions.net> (sfid-20130207_092015_818234_C792262E)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: chaitanyatk@posedge.com
Cc: linux-wireless@vger.kernel.org, maheshp@posedge.com
Date: Thu, 07 Feb 2013 09:20:30 +0100
In-Reply-To: <7384f4ddc838247a0f467708d66baa8c@posedge.com>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-07 at 00:01 -0800, chaitanyatk@posedge.com wrote:

> @@ -470,6 +470,7 @@ enum mac80211_tx_control_flags {
>   	IEEE80211_TX_STATUS_EOSP		= BIT(28),
>   	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
>   	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
> +	IEEE80211_TX_CTL_AMSDU			= BIT(31),

Hmm. I'm not exactly happy with using (one of) the last control flag for
a pure debug facility.

> +++ b/net/mac80211/ieee80211_i.h
> @@ -402,7 +402,6 @@ struct ieee80211_mgd_assoc_data {
>   	bool have_beacon;
>   	bool sent_assoc;
>   	bool synced;
> -

All those spurious whitespace changes just make the patch appear
longer ... :)

johannes

