Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.9]:28231 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbbEDKEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 06:04:07 -0400
Date: Mon, 4 May 2015 12:04:01 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: Re: [PATCH 1/2] add mt7601u driver
Message-ID: <20150504120401.30835e07@north> (sfid-20150504_120411_821410_206AEBCD)
In-Reply-To: <1430732248.2013.16.camel@sipsolutions.net>
References: <1430571690-9054-1-git-send-email-moorray3@wp.pl>
	<1430571690-9054-2-git-send-email-moorray3@wp.pl>
	<1430732248.2013.16.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 04 May 2015 11:37:28 +0200, Johannes Berg wrote:
> On Sat, 2015-05-02 at 15:01 +0200, moorray3@wp.pl wrote:
> 
> > +int mt7601u_wait_asic_ready(struct mt7601u_dev *dev)
> > +{
> > +	int i = 100;
> > +	u32 val;
> > +
> > +	do {
> > +		val = mt7601u_rr(dev, MT_MAC_CSR0);
> > +		if (val && ~val)
> > +			return 0;
> 
> No delays here? Seems odd. You do have one in the next function where
> you also call the _rr() function.

I have not seen this check fail ever, but placing a delay won't hurt.

> > +	skb = alloc_skb(seg_len, GFP_ATOMIC);
> > +	if (!skb)
> > +		return NULL;
> > +
> > +	memset(skb->cb, 0, sizeof(skb->cb));
> 
> Pretty sure that's pointless.

Shamefully pointless, thanks for spotting it.

> > +	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD)) {
> > +		int hdr_len = ieee80211_get_hdrlen_from_buf(data, seg_len);
> > +
> > +		memcpy(skb_put(skb, hdr_len), data, hdr_len);
> > +		data += hdr_len + 2;
> > +		seg_len -= hdr_len;
> > +	}
> > +
> > +	memcpy(skb_put(skb, seg_len), data, seg_len);
> > +
> > +	return skb;
> 
> Don't know how your buffers are set up, but if the DMA engine consumes
> pages you could consider using paged RX instead of the memcpy().

DMA engine can concatenate multiple frames into a single USB bulk
transfer to a large continuous buffer.  There is no way to request 
any alignment of the frames within that large buffer so I think paged 
RX is not an option.
