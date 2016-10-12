Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43006 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752653AbcJLMZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 08:25:26 -0400
Message-ID: <1476275121.5271.28.camel@sipsolutions.net> (sfid-20161012_142540_813358_94826DA1)
Subject: Re: [PATCH v2] mac80211: fix A-MSDU outer SA/DA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Felix Fietkau <nbd@openwrt.org>
Date: Wed, 12 Oct 2016 14:25:21 +0200
In-Reply-To: <1476269870-32007-1-git-send-email-michael-dev@fami-braun.de>
References: <1476269870-32007-1-git-send-email-michael-dev@fami-braun.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-12 at 12:57 +0200, Michael Braun wrote:
> According to IEEE 802.11-2012 section 8.3.2 table 8-19, the outer
> SA/DA of A-MSDU frames need to be changed depending on FromDS/ToDS
> values.

actually ...

>  	struct ieee80211_hdr *hdr;

802.11 header

> -	struct ethhdr amsdu_hdr;
> +	struct ethhdr *amsdu_hdr;
>  	int hdr_len = fast_tx->hdr_len - sizeof(rfc1042_header);

802.11 header length

> +	data = skb_push(skb, sizeof(*amsdu_hdr));

push ethernet header in

> +	memmove(data, data + sizeof(*amsdu_hdr), hdr_len);

move 802.11 header from back to front

> +	hdr = data;

hdr is at the beginning of the frame

> +	amsdu_hdr = data + hdr_len;

amsdu_hdr is actually the *inner* header after all.


So, I actually think my first instinct that you were erroneously
changing the inner header *was* right.


Seems like this code should be inserted towards the end of
ieee80211_amsdu_aggregate() instead, where it's adding the RFC 1042
header?

Need Felix to take a look, I guess.

johannes
