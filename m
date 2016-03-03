Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56355 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbcCCOyY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 09:54:24 -0500
Message-ID: <1457016860.2044.11.camel@sipsolutions.net> (sfid-20160303_155429_613233_590ACEF1)
Subject: Re: [PATCH v2 1/2] mac80211: add A-MSDU tx support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com
Date: Thu, 03 Mar 2016 15:54:20 +0100
In-Reply-To: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-02-24 at 10:28 +0100, Felix Fietkau wrote:
> 
> +	/*
> +	 * HT A-MPDU limits maximum MPDU size to 4095 bytes. Since aggregation
> +	 * sessions are started/stopped without txq flush, use the limit here
> +	 * to avoid having to de-aggregate later.
> +	 */
> +	if (skb->len + head->len > 4095 &&
> +	    !sta->sta.vht_cap.vht_supported)
> +		goto out;

I'm not entirely happy with this. You're silently assuming that when
VHT is supported, HT MCSes will never be used.

This is (I think) true for minstrel_ht, but at the very least you
should also document it along with the max_rc_amsdu_len then, which btw
I was going to reword to:

+ * @IEEE80211_HW_TX_AMSDU: Hardware (or driver) supports software aggregated
+ *     A-MSDU frames. Requires software tx queueing and fast-xmit support.
+ *     When not using minstrel/minstrel_ht rate control, the driver needs to
+ *     limit the maximum A-MSDU size based on the current tx rate by setting
+ *     max_rc_amsdu_len in struct ieee80211_sta to avoid mac80211 building
+ *     A-MSDUs that require too much airtime (are too long for a TXOP.)


All that said, I'm not sure how much value there really is in
aggregating that much? I'd think the value of A-MSDU really is more for
lots of small frames like TCP ACKs, since the PER goes up exponentially
with the BER for A-MSDU (unlike A-MPDU.)

johannes
