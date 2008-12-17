Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbYLQLtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:49:52 -0500
Subject: Re: [PATCH] ath9k: Key cache allocation for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081217113217.GB18060@jm.kir.nu> (sfid-20081217_123225_574711_95FEDA6B)
References: <20081217113217.GB18060@jm.kir.nu>
	 (sfid-20081217_123225_574711_95FEDA6B)
Content-Type: text/plain
Date: Wed, 17 Dec 2008 12:30:11 +0100
Message-Id: <1229513411.4566.0.camel@localhost> (sfid-20081217_124955_862436_3923E5D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 13:32 +0200, Jouni Malinen wrote:

> +		if (vif->type != NL80211_IFTYPE_AP) {
> +			/* Only keyidx 0 should be used with unicast key, but
> +			 * allow this for client mode for now. */
> +			idx = key->keyidx;

Hey, good point, should we make the check in mac80211 stricter as well?
I know we accept non-zero pairwise key idx for some broken pairwise WEP
implementations, but that's only relevant for STA as you note.

johannes

