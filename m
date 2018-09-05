Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:40698 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeIEMfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 08:35:31 -0400
Received: by mail-qt0-f194.google.com with SMTP id h4-v6so7074886qtj.7
        for <linux-wireless@vger.kernel.org>; Wed, 05 Sep 2018 01:06:30 -0700 (PDT)
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180905080036.9177-1-johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Johannes Berg <johannes.berg@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B8F8E83.1090707@broadcom.com> (sfid-20180905_100634_399781_1CF810AB)
Date: Wed, 5 Sep 2018 10:06:27 +0200
MIME-Version: 1.0
In-Reply-To: <20180905080036.9177-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/5/2018 10:00 AM, Johannes Berg wrote:
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
>          if (ieee80211_is_data_qos(hdr->frame_control))
>                  qos_tid = ieee80211_get_tid(hdr);
>          else
>                  qos_tid = 0;
>
> in the code there. We could therefore reconsider this, but
> it seems like unnecessary complexity for the unlikely (and
> not very useful) case of not having QoS on the connection.
>
> This situation then causes something strange - most data
> frames will go on TXQ for TID 0 for non-QoS connections,
> but very few exceptions that are internally generated will
> go on another TXQ, possibly causing confusion.
>
> Avoid this confusion by putting non-QoS data frames into
> TID 0 regardless of the skb->priority.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   net/mac80211/tx.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 5b6e06ad35ff..6540595addd1 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1260,7 +1260,10 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
>   			txq = sta->sta.txq[IEEE80211_NUM_TIDS];
>   		}
>   	} else if (sta) {
> -		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
> +		u8 tid = 0;
> +
> +		if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA))
> +			tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;

Is the use of different mask intentional here? Just a quick glance so 
did not look into it further.

Gr. AvS
