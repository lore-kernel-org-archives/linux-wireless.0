Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:16842 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934130Ab3HHJFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 05:05:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 3/3] ath10k: add support for HTT 3.0
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1375949298-7159-4-git-send-email-michal.kazior@tieto.com>
Date: Thu, 8 Aug 2013 12:05:32 +0300
In-Reply-To: <1375949298-7159-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 8 Aug 2013 10:08:18 +0200")
Message-ID: <87eha4363n.fsf@kamboji.qca.qualcomm.com> (sfid-20130808_110555_313430_865476CC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> New firmware comes with new HTT protocol version.
> In 3.0 the separate mgmt tx command has been
> removed. All traffic is to be pushed through data
> tx (tx_frm) command with a twist - FW seems to not
> be able (yet?) to access tx fragment table so for
> manamgement frames frame pointer is passed
> directly.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

>  static int ath10k_htt_verify_version(struct ath10k_htt *htt)
>  {
> -	ath10k_dbg(ATH10K_DBG_HTT,
> -		   "htt target version %d.%d; host version %d.%d\n",
> -		    htt->target_version_major,
> -		    htt->target_version_minor,
> -		    HTT_CURRENT_VERSION_MAJOR,
> -		    HTT_CURRENT_VERSION_MINOR);
> -
> -	if (htt->target_version_major != HTT_CURRENT_VERSION_MAJOR) {
> +	ath10k_dbg(ATH10K_DBG_HTT, "htt target version %d.%d\n",
> +		   htt->target_version_major, htt->target_version_minor);

This debug print is good to have, but with the new htt version it would
be good to print it always using the info level. For example, can we add
it to the same line with "firmware %s booted" string?

(Please take into account that the info messages still need to be
compact, by default they should not be longer than five lines or so.)

> +	if (htt->target_version_major != 2 &&
> +	    htt->target_version_major != 3) {
>  		ath10k_err("htt major versions are incompatible!\n");
>  		return -ENOTSUPP;
>  	}

Print the htt version in the error message as well?

> @@ -401,10 +401,15 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>  		goto err;
>  	}
>  
> -	txfrag = dev_alloc_skb(frag_len);
> -	if (!txfrag) {
> -		res = -ENOMEM;
> -		goto err;
> +	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
> +	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
> +	 * fragment list host driver specifies directly frame pointer. */
> +	if (!(htt->target_version_major >= 3 && ieee80211_is_mgmt(hdr->frame_control))) {

I think using "< 3" is more readable:

if (htt->target_version_major < 3 &&
   !ieee80211_is_mgmt(hdr->frame_control)) {
        ...
}

And is the single line too long? Didn't count it, though.

> @@ -427,23 +432,30 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
>  	if (res)
>  		goto err;
>  
> -	/* tx fragment list must be terminated with zero-entry */
> -	skb_put(txfrag, frag_len);
> -	tx_frags = (struct htt_data_tx_desc_frag *)txfrag->data;
> -	tx_frags[0].paddr = __cpu_to_le32(ATH10K_SKB_CB(msdu)->paddr);
> -	tx_frags[0].len   = __cpu_to_le32(msdu->len);
> -	tx_frags[1].paddr = __cpu_to_le32(0);
> -	tx_frags[1].len   = __cpu_to_le32(0);
> -
> -	res = ath10k_skb_map(dev, txfrag);
> -	if (res)
> -		goto err;
> +	/* Since HTT 3.0 there is no separate mgmt tx command. However in case
> +	 * of mgmt tx using TX_FRM there is not tx fragment list. Instead of tx
> +	 * fragment list host driver specifies directly frame pointer. */
> +	if (!(htt->target_version_major >= 3 && ieee80211_is_mgmt(hdr->frame_control))) {

Ditto.

-- 
Kalle Valo
