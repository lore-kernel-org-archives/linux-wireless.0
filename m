Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60402 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbbA0JQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 04:16:32 -0500
Message-ID: <1422350188.1890.56.camel@sipsolutions.net> (sfid-20150127_101635_926054_10EE4A7E)
Subject: Re: [PATCH 4/6] mac80111: Add CCMP-256 cipher
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 10:16:28 +0100
In-Reply-To: <1422121929-18238-4-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
	 <1422121929-18238-4-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-01-24 at 19:52 +0200, Jouni Malinen wrote:

>  ieee80211_tx_result
> -ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx);
> +ieee80211_crypto_ccmp_encrypt(struct ieee80211_tx_data *tx, bool ccmp256);
>  ieee80211_rx_result
> -ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx);
> +ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx, bool ccmp256);

Perhaps it would make sense to pass the mic_len, which would allow
removing the conditional inside these functions?

johannes

