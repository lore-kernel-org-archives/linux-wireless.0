Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:38816 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdLIT6g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Dec 2017 14:58:36 -0500
Message-ID: <1512849510.26976.46.camel@sipsolutions.net> (sfid-20171209_205839_201835_6AD3F0B3)
Subject: Re: [PATCH 1/2] mac80211: Populate RSC counter in set_key method
From: Johannes Berg <johannes@sipsolutions.net>
To: Govind Singh <govinds@qti.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Sat, 09 Dec 2017 20:58:30 +0100
In-Reply-To: <1512739922-1529-1-git-send-email-govinds@qti.qualcomm.com> (sfid-20171208_143212_579925_57EDA6B1)
References: <1512739922-1529-1-git-send-email-govinds@qti.qualcomm.com>
         (sfid-20171208_143212_579925_57EDA6B1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-08 at 19:02 +0530, Govind Singh wrote:
> Send RSC counter to driver in set_key method, so that FW/driver
> can drop the packet in PN check if received packet sequence
> no is less than current RSC counter during group keys(GTK)
> exchange.

Good idea, but ... does it really work this way? :-)

>  /**
>   * struct ieee80211_key_conf - key information
>   *
> @@ -1586,6 +1588,7 @@ enum ieee80211_key_flags {
>   * 	- Temporal Authenticator Rx MIC Key (64 bits)
>   * @icv_len: The ICV length for this key type
>   * @iv_len: The IV length for this key type
> + * @rx_pn: Last received packet number, must be in little endian.
>   */
>  struct ieee80211_key_conf {
>  	atomic64_t tx_pn;
> @@ -1596,11 +1599,10 @@ struct ieee80211_key_conf {
>  	u8 flags;
>  	s8 keyidx;
>  	u8 keylen;
> +	u8 rx_pn[IEEE80211_MAX_PN_LEN];
>  	u8 key[0];
>  };

I don't think you should put that here, we keep this around in the key
structure forever. We can pass it out of band, I'd say?

> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index 9380493..15e1822 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -538,6 +538,12 @@ struct ieee80211_key *
>  	}
>  	memcpy(key->conf.key, key_data, key_len);
>  	INIT_LIST_HEAD(&key->list);
> +	/* Assign receive packet sequence no, rx_pn remains in
> +	 * little endian format as seq is guaranteed to be in little
> +	 * endian format.
> +	 */
> +	if (seq)
> +		memcpy(&key->conf.rx_pn, seq, seq_len);

It seems that perhaps we should make this more robust - there are
sometimes cases where the key can enable HW acceleration only after
some time. Not the case with ath10k though, but we should probably
handle that.

And once we do, we probably need this per TID, because the RX PN might
have moved around, or we look up the max over all TIDs. All the more
reason to pass it out of band.

Another reason to pass it out of band would be to tell the driver that
indeed it's *not* maintained over the lifetime of the key, unlike the
other fields which are maintained (because constant) over the lifetime
of the key.

johannes
