Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:41260 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeIEMiq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Sep 2018 08:38:46 -0400
Message-ID: <1536134975.3528.0.camel@sipsolutions.net> (sfid-20180905_100948_570085_CF3FED8D)
Subject: Re: [PATCH] mac80211: use non-zero TID only for QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Date: Wed, 05 Sep 2018 10:09:35 +0200
In-Reply-To: <5B8F8E83.1090707@broadcom.com> (sfid-20180905_100631_619747_8CED9977)
References: <20180905080036.9177-1-johannes@sipsolutions.net>
         <5B8F8E83.1090707@broadcom.com> (sfid-20180905_100631_619747_8CED9977)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-09-05 at 10:06 +0200, Arend van Spriel wrote:
> 
> > +++ b/net/mac80211/tx.c
> > @@ -1260,7 +1260,10 @@ static struct txq_info *ieee80211_get_txq(struct ieee80211_local *local,
> >   			txq = sta->sta.txq[IEEE80211_NUM_TIDS];
> >   		}
> >   	} else if (sta) {
> > -		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
> > +		u8 tid = 0;
> > +
> > +		if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA))
> > +			tid = skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
> 
> Is the use of different mask intentional here? Just a quick glance so 
> did not look into it further.

Ah, I forgot to mention that in the commit log. That just aligns it with
most of the other code, but since we never have values other than 0-7 it
doesn't actually matter.

johannes
