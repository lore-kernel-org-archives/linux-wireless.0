Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:58737 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbeIEOQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 10:16:49 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
In-Reply-To: <20180905080036.9177-1-johannes@sipsolutions.net>
References: <20180905080036.9177-1-johannes@sipsolutions.net>
Date: Wed, 05 Sep 2018 11:47:21 +0200
Message-ID: <87in3k6zti.fsf@toke.dk> (sfid-20180905_114727_307468_A80B60B6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> Some frames may have a non-zero skb->priority assigned by
> mac80211 internally, e.g. TDLS setup frames, regardless of
> support for QoS.
>
> Currently, we set skb->priority to 0 for all data frames.
> Note that there's a comment that this is "required for
> correct WPA/11i MIC", but that doesn't seem true as we use
>
>         if (ieee80211_is_data_qos(hdr->frame_control))
>                 qos_tid = ieee80211_get_tid(hdr);
>         else
>                 qos_tid = 0;
>
> in the code there. We could therefore reconsider this, but
> it seems like unnecessary complexity for the unlikely (and
> not very useful) case of not having QoS on the connection.
>
> This situation then causes something strange - most data
> frames will go on TXQ for TID 0 for non-QoS connections,
> but very few exceptions that are internally generated will
> go on another TXQ, possibly causing confusion.

What kind of confusion are you seeing? Reordering issues, or something
else?

-Toke
