Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:58902 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab1JMWp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Oct 2011 18:45:56 -0400
Date: Fri, 14 Oct 2011 01:45:32 +0300
From: Jouni Malinen <j@w1.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: handle HT PHY BSS membership selector value
 correctly
Message-ID: <20111013224532.GA1959@jm.kir.nu> (sfid-20111014_004607_596725_AC0B14B1)
References: <201110132108.50019.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201110132108.50019.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 13, 2011 at 09:08:49PM +0200, Christian Lamparter wrote:
> 802.11n-2009 extends the supported rates element with a
> magic value which can be used to prevent legacy stations
> from joining the BSS.

Well, it can be used to try to make legacy stations not attempt
connection, but no guarantees on them actually checking whether they
support all the "basic rates".. For example, where is mac80211 (or
wpa_supplicant) doing that check? ;-)

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> @@ -1463,6 +1463,38 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
> +static void ieee80211_get_rates(struct ieee80211_supported_band *sband,

> +	for (i = 0; i < supp_rates_len; i++) {
> +		int rate = (supp_rates[i] & 0x7f) * 5;
> +		bool is_basic = !!(supp_rates[i] & BSS_MEMBERSHIP_SELECTOR);

This looks a bit odd since the BSS_MEMBERSHIP_SELECTOR is not exactly
same as basic rate indicator even through they share the same bit. We
used to have the magic 0x80 value here which could actually look less
confusing than the mixing of basic and BSS membership terms.

> +		if (rate > 110)
> +			*have_higher_than_11mbit = true;

While this is not really introduced by this patch, this looks quite
bogus since the higher-than-11Mbps is then used to figure out whether
this was a 802.11g network. That is not correct since a network with a
single supported rate 6 Mbps should also get that behavior.. More robust
mechanism would be to check for any OFDM rate being listed.

> +	ieee80211_get_rates(sband, elems.supp_rates, elems.supp_rates_len,
> +			    &rates, &basic_rates, &have_higher_than_11mbit);

> +	ieee80211_get_rates(sband, elems.ext_supp_rates,
> +			    elems.ext_supp_rates_len, &rates, &basic_rates,
> +			    &have_higher_than_11mbit);

Yay for getting rid of the duplicated loop :-).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
