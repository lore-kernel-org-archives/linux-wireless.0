Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:38192 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbYFQSHF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:07:05 -0400
Date: Tue, 17 Jun 2008 21:06:10 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 3/7] 802.11w: Add BIP (AES-128-CMAC)
Message-ID: <20080617180610.GC4974@jm.kir.nu> (sfid-20080617_200710_017391_6DDDA530)
References: <20080617154008.883383150@localhost> <20080617155904.082926456@localhost> <1213721714.3803.83.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213721714.3803.83.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 17, 2008 at 06:55:14PM +0200, Johannes Berg wrote:

> > +/* Management MIC information element (IEEE 802.11w) */
> > +struct ieee80211_mmie {
> > +	u8 element_id;
> > +	u8 length;
> > +	u8 key_id[2]; /* little endian, but may be unaligned */
> 
> Since you say the struct is packed you should be able to use __le16 just
> fine.

Is that guaranteed to force all accesses of the field to not use 16-bit
read/write?

> > +	if ((tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
> 
> I think one set of parentheses suffices ;)

Aah.. That's a copy-paste from something old.. I think I removed the
IEEE80211_KEY_FLAG_GENERATE_IV flag from here for BIP.. I'm not
completely sure yet, how we should have this, i.e., whether that flag
should be used here or not. It is unclear what type of hwaccel, if any,
vendors are going to implement for BIP.


> > +	if (skb_tailroom(skb) < sizeof(*mmie)) {
> > +		if (pskb_expand_head(skb, skb_headroom(skb),
> > +				     skb_tailroom(skb) + sizeof((*mmie)),
> > +				     GFP_ATOMIC) < 0)
> > +			return TX_DROP;
> > +	}
> 
> I tried ensure pskb_expand_head is only called at most once when the
> frame is handed to master_start_xmit to avoid problems with skb truesize
> and such. Could you add the necessary space at that point already,
> possibly simply reserving max(mmic-len, mmie-len) or so instead of the
> current mmic-len (I think)? I'd hate to add back calls to
> pskb_expand_head at other places, and it's only 18 bytes so not really
> huge.

I thought about that for a moment, but then decided that it would be
okay to just do this here since MMIE is larger than any other tailroom
we have and there is next to no real use for multicast/broadcast
management frames, so there is no need to optimize this. I don't see how
this would require any other place to use pskb_expand_head.

Anyway, I would assume it would be possible to do this by changing
IEEE80211_ENCRYPT_TAILROOM from 12 to 22 which would waste 10 bytes
extra for every frame (well, not waste for BIP-protected frames but
there are next to none of them).

> > +	if ((rx->fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_MGMT)
> > +		return RX_CONTINUE;
> 
> Harvey just added a bunch of helper inlines to include/linux/ieee80211.h
> for stuff like that, I think you could use one of them here.

I converted some of the places to use the new helpers, but did not go
through all places. I would assume there is still places that can be
made to use them, but as long as FC is available in host byte order, it
is easier and faster to use it. Sure, if rx->fc were to disappear, that
may make it more likely that these get changed ;-).

> > +       mmie = (struct ieee80211_mmie *)
> > +               (skb->data + skb->len - sizeof(*mmie));
> > +       if (mmie->element_id != WLAN_EID_MMIE ||
> > +           mmie->length != sizeof(*mmie) - 2)
> > +               return RX_DROP_UNUSABLE; /* Invalid MMIE */
> 
> Is that what the draft says? Because iterating the IEs would be
> different, this means you could potentially have something like a vendor
> IE last that encapsulates the MMIE including type/len fields, which
> should probably not be used?

MMIE has to be the last "IE" in the frame. Sure, it would, in theory, be
possible to receive a frame that does not have MMIE, but has "MMIE like"
data in another IE. As long as we can make sure that this is reached
only for frames that are received from MFP enabled AP, the simple
solution of pointing to the end of the frame is enough. Otherwise, we
would need to parse all the IEs and know about the start of IEs in all
different types of Action frames.. That's not really something I would
like to do.

> > +	/* Remove MMIE */
> > +	skb_trim(skb, skb->len - sizeof(*mmie));
> 
> Is that actually necessary? Since it's an IE, it should be ignored by
> all other code, no? Not that it matters though.

I don't think it is necessary in the sense that leaving the "IE" in
would break anything. However, I do think this is the correct thing to
do here and matches with what we do with TKIP/CCMP. MMIE is not really
an IE, it is just a frame component that is made to look like one. The
current IEEE 802.11w draft is bit confused about what MMIE is at places,
but anyway, I would compare it to TKIP ICV and CCMP MIC in the end of
the frames.

-- 
Jouni Malinen                                            PGP id EFC895FA
