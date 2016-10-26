Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47832 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752233AbcJZFuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 01:50:06 -0400
Message-ID: <1477460999.4059.13.camel@sipsolutions.net> (sfid-20161026_075010_734990_AACB2CFB)
Subject: Re: [PATCH 7/8] mac80211: FILS AEAD protection for station mode
 association frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 07:49:59 +0200
In-Reply-To: <1477435489-8555-3-git-send-email-jouni@qca.qualcomm.com>
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
         <1477435489-8555-3-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +static u8 *fils_find_session(u8 *pos, u8 *end)
> +{
> +	while (end - pos > 2 && end - pos >= 2 + pos[1]) {
> +		if (pos[0] == 255 && pos[1] == 1 + 8 && pos[2] == 4)
> +			return pos;
> +		pos += 2 + pos[1];
> +	}
> +
> +	return NULL;
> +}

Hmm. I think we should try to write this in terms of cfg80211_find_ie,
or perhaps cfg80211_find_ie_match, maybe we need to extend those but
this won't be the only one using the 255 escape.

Perhaps just making the eid passed there be a u16, and extending the
EID definitions appropriately?

The code would probably be shorter as is for now, but still ...

> +	if (!session) {
> +		sdata_info(sdata,
> +			   "No FILS Session element in
> (Re)Association Response frame from %pM",
> +			   mgmt->sa);
> +		return -EINVAL;

Should we really print the message this prominently? It seems like an
error case that we may not want to log at all, in case somebody tries
to flood us with such frames?

> +	crypt_len = frame + *frame_len - encr;
> +	if (crypt_len < AES_BLOCK_SIZE) {
> +		sdata_info(sdata,
> +			   "Not enough room for AES-SIV data after
> FILS Session element in (Re)Association Response frame from %pM",
> +			   mgmt->sa);
> +		return -EINVAL;
> +	}
> +	res = aes_siv_decrypt(assoc_data->fils_kek, assoc_data-
> >fils_kek_len,
> +			      encr, crypt_len, 5, addr, len, encr);
> +	if (res != 0) {
> +		sdata_info(sdata,
> +			   "AES-SIV decryption of (Re)Association
> Response frame from %pM failed",
> +			   mgmt->sa);
> +		return res;
> +	}

Likewise here. Perhaps make these mlme_dbg() or so instead?

> +	if (req->fils_nonces)
> +		assoc_data_len += 2 * FILS_NONCE_LEN;

Is this really correct? It seems like a bit of an artifact of initially
having had the nonces in a variable part of the struct?

Or perhaps they have to go into the frame in some place that I missed?
Please add a comment if so.

Also, you're never checking req->fils_nonces_set, so you can get rid of
that.

johannes
