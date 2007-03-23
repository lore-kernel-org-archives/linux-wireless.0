Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35908 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933926AbXCWRwu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 13:52:50 -0400
Date: Fri, 23 Mar 2007 18:52:46 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jouni Malinen <jkmaline@cc.hut.fi>
Subject: Re: [PATCH v3] d80211: Add software sequence support
Message-ID: <20070323185246.43d78753@griffin.suse.cz>
In-Reply-To: <200703110025.30400.IvDoorn@gmail.com>
References: <200702141423.27823.IvDoorn@gmail.com>
	<200703102021.40041.IvDoorn@gmail.com>
	<200703102032.36463.mb@bu3sch.de>
	<200703110025.30400.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 11 Mar 2007 00:25:30 +0100, Ivo van Doorn wrote:
> +static void ieee80211_include_sequence(struct ieee80211_sub_if_data *sdata,
> +				       struct ieee80211_hdr *hdr)

I'd prefer specifying this as inline function.

> +{
> +	/*
> +	 * Set the sequence number for this frame.
> +	 */
> +	hdr->seq_ctrl = cpu_to_le16(sdata->sequence & IEEE80211_SCTL_SEQ);

No need to do "& IEEE80211_SCTL_SEQ" here.

> +
> +	/*
> +	 * Increase the sequence number.
> +	 */

Please reduce this and previous comment to one line each.

> +	sdata->sequence = (sdata->sequence + 0x10) & IEEE80211_SCTL_SEQ;
> +}
> +
>  struct ieee80211_key_conf *
>  ieee80211_key_data2conf(struct ieee80211_local *local,
>  			const struct ieee80211_key *data)
> @@ -445,6 +459,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
>  	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
>  	struct sk_buff **frags, *first, *frag;
>  	int i;
> +	u16 seq;
>  	u8 *pos;
>  	int frag_threshold = tx->local->fragmentation_threshold;
>  
> @@ -463,6 +478,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
>  		goto fail;
>  
>  	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREFRAGS);
> +	seq = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ;
>  	pos = first->data + hdrlen + per_fragm;
>  	left = payload_len - per_fragm;
>  	for (i = 0; i < num_fragm - 1; i++) {
> @@ -490,7 +506,7 @@ ieee80211_tx_h_fragment(struct ieee80211_txrx_data *tx)
>  		memcpy(fhdr, first->data, hdrlen);
>  		if (i == num_fragm - 2)
>  			fhdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_MOREFRAGS);
> -		fhdr->seq_ctrl = cpu_to_le16(i + 1);
> +		fhdr->seq_ctrl = cpu_to_le16(seq + ((i + 1) & IEEE80211_SCTL_FRAG));

I'd prefer | instead of + here.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
