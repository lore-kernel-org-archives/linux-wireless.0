Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52770 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2IUM7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 08:59:05 -0400
Message-ID: <1348232380.4160.7.camel@jlt4.sipsolutions.net> (sfid-20120921_145911_034275_9FEF7A53)
Subject: Re: [RFC] mac80211: validate key before MIC verify
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Date: Fri, 21 Sep 2012 14:59:40 +0200
In-Reply-To: <20120921124141.GA3100@redhat.com> (sfid-20120921_144231_551799_5DDB2F3B)
References: <20120921124141.GA3100@redhat.com>
	 (sfid-20120921_144231_551799_5DDB2F3B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-21 at 14:41 +0200, Stanislaw Gruszka wrote:

> --- a/net/mac80211/wpa.c
> +++ b/net/mac80211/wpa.c
> @@ -97,6 +97,14 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
>  		return RX_CONTINUE;
>  
>  	/*
> +	 * Some hardware seems to generate Michael MIC failure reports; even
> +	 * though, the frame was not encrypted with TKIP and therefore has no
> +	 * MIC. Ignore the flag them to avoid triggering countermeasures.
> +	 */
> +	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP)
> +		return RX_CONTINUE;
> +
> +	/*
>  	 * No way to verify the MIC if the hardware stripped it or
>  	 * the IV with the key index. In this case we have solely rely
>  	 * on the driver to set RX_FLAG_MMIC_ERROR in the event of a

Hm, this doesn't seem _quite_ right, but I'm not sure: it seems that
previously it was possible that we don't have a key pointer but the
driver set all of RX_FLAG_MMIC_STRIPPED, RX_FLAG_IV_STRIPPED and
RX_FLAG_MMIC_ERROR, in which case after your change the frame will be
accepted rather than rejected.

johannes

