Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.tohojo.dk ([77.235.48.147]:50251 "EHLO mail2.tohojo.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753056AbcJLP6B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 11:58:01 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [bug report] mac80211: Move reorder-sensitive TX handlers to
        after TXQ dequeue
References: <20161012061458.GM12841@mwanda>
Date: Wed, 12 Oct 2016 17:57:56 +0200
In-Reply-To: <20161012061458.GM12841@mwanda> (Dan Carpenter's message of "Wed,
        12 Oct 2016 09:14:58 +0300")
Message-ID: <87a8e91rwb.fsf@toke.dk> (sfid-20161012_175807_463077_3B06F35D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:

> Hello Toke H=C3=B8iland-J=C3=B8rgensen,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch bb42f2d13ffc: "mac80211: Move reorder-sensitive TX handlers=20
> to after TXQ dequeue" from Sep 22, 2016, leads to the following=20
> Smatch complaint:
>
> net/mac80211/tx.c:3242 ieee80211_xmit_fast_finish()
> 	 error: we previously assumed 'key' could be null (see line 3209)
>
> net/mac80211/tx.c
>   3208=09
>   3209		if (key)
>                     ^^^
> Check.
>
>   3210			info->control.hw_key =3D &key->conf;
>   3211=09
>   3212		ieee80211_tx_stats(skb->dev, skb->len);
>   3213=09
>   3214		if (hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_QOS_DATA)) {
>   3215			tid =3D skb->priority & IEEE80211_QOS_CTL_TAG1D_MASK;
>   3216			*ieee80211_get_qos_ctl(hdr) =3D tid;
>   3217			hdr->seq_ctrl =3D ieee80211_tx_next_seq(sta, tid);
>   3218		} else {
>   3219			info->flags |=3D IEEE80211_TX_CTL_ASSIGN_SEQ;
>   3220			hdr->seq_ctrl =3D cpu_to_le16(sdata->sequence_number);
>   3221			sdata->sequence_number +=3D 0x10;
>   3222		}
>   3223=09
>   3224		if (skb_shinfo(skb)->gso_size)
>   3225			sta->tx_stats.msdu[tid] +=3D
>   3226				DIV_ROUND_UP(skb->len, skb_shinfo(skb)->gso_size);
>   3227		else
>   3228			sta->tx_stats.msdu[tid]++;
>   3229=09
>   3230		info->hw_queue =3D sdata->vif.hw_queue[skb_get_queue_mapping(skb)=
];
>   3231=09
>   3232		/* statistics normally done by ieee80211_tx_h_stats (but that
>   3233		 * has to consider fragmentation, so is more complex)
>   3234		 */
>   3235		sta->tx_stats.bytes[skb_get_queue_mapping(skb)] +=3D skb->len;
>   3236		sta->tx_stats.packets[skb_get_queue_mapping(skb)]++;
>   3237=09
>   3238		if (pn_offs) {
>                     ^^^^^^^
> Maybe when pn_offs is non-zero that implies key is non-NULL?

Yes, it does. fast_tx->pn_offs is set in ieee80211_check_fast_xmit()
which only sets it if fast_tx->key is set. The other call to
ieee80211_xmit_fast_finish() is in ieee80211_tx_dequeue() which also
only sets pn_offs if the key is set.

-Toke
