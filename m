Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44980 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbbEDJhd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 05:37:33 -0400
Message-ID: <1430732248.2013.16.camel@sipsolutions.net> (sfid-20150504_113737_289306_0BDA3B6A)
Subject: Re: [PATCH 1/2] add mt7601u driver
From: Johannes Berg <johannes@sipsolutions.net>
To: moorray3@wp.pl
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Date: Mon, 04 May 2015 11:37:28 +0200
In-Reply-To: <1430571690-9054-2-git-send-email-moorray3@wp.pl> (sfid-20150502_150258_155524_72DB255C)
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	 <1430571690-9054-2-git-send-email-moorray3@wp.pl>
	 (sfid-20150502_150258_155524_72DB255C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-02 at 15:01 +0200, moorray3@wp.pl wrote:

> +int mt7601u_wait_asic_ready(struct mt7601u_dev *dev)
> +{
> +	int i = 100;
> +	u32 val;
> +
> +	do {
> +		val = mt7601u_rr(dev, MT_MAC_CSR0);
> +		if (val && ~val)
> +			return 0;

No delays here? Seems odd. You do have one in the next function where
you also call the _rr() function.

> +	skb = alloc_skb(seg_len, GFP_ATOMIC);
> +	if (!skb)
> +		return NULL;
> +
> +	memset(skb->cb, 0, sizeof(skb->cb));

Pretty sure that's pointless.

> +	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD)) {
> +		int hdr_len = ieee80211_get_hdrlen_from_buf(data, seg_len);
> +
> +		memcpy(skb_put(skb, hdr_len), data, hdr_len);
> +		data += hdr_len + 2;
> +		seg_len -= hdr_len;
> +	}
> +
> +	memcpy(skb_put(skb, seg_len), data, seg_len);
> +
> +	return skb;

Don't know how your buffers are set up, but if the DMA engine consumes
pages you could consider using paged RX instead of the memcpy().

johannes

