Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:33386 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799AbYJMQAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 12:00:36 -0400
Date: Mon, 13 Oct 2008 18:59:38 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: fix short preamble determination
Message-ID: <20081013155938.GA30095@jm.kir.nu> (sfid-20081013_180040_855989_FC6474E0)
References: <1223713593.29811.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1223713593.29811.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 11, 2008 at 10:26:33AM +0200, Johannes Berg wrote:
> When looking at this code during the rate control API rewrite
> yesterday, we wondered whether the determination of short
> preamble was correct or not. I don't think it was, and this
> should be better.

> -	if (ieee80211_is_data(hdr->frame_control) &&
> -	    tx->sdata->vif.bss_conf.use_short_preamble &&
> -	    (!tx->sta || test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE)))
> +	if (tx->sdata->vif.bss_conf.use_short_preamble &&
> +	    (ieee80211_is_data(hdr->frame_control) ||
> +	     (tx->sta && test_sta_flags(tx->sta, WLAN_STA_SHORT_PREAMBLE)))

Changing '!tx->sta ||' to 'tx->sta &&' sounds reasonable, but I'm not so
sure about the other change.. In theory, short preamble is negotiated
per STA and while we do current disable short preamble completely in the
BSS if a non-short-preamble-capable STA associates, I'm not sure whether
that would be an absolute requirement. As far as management frames
(e.g., Probe Response) are concerned, IEEE 802.11-2007 18.2.2.2 has an
interesting statement: "all management traffic is returned with the same
type preamble as received". I have not been able to find normative
requirement for that being the case, though.

-- 
Jouni Malinen                                            PGP id EFC895FA
