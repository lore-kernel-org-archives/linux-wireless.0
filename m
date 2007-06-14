Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43589 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752706AbXFNKCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2007 06:02:07 -0400
Message-ID: <4671121C.3000705@warmcat.com>
Date: Thu, 14 Jun 2007 11:02:04 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH Try#12 2/3] cfg80211: Radiotap parser
References: <20070613093732.535166329@warmcat.com>	 <20070613093943.634743151@warmcat.com> <1181760467.29767.130.camel@johannes.berg>
In-Reply-To: <1181760467.29767.130.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

>> + * @max_length: total length we can parse into (eg, whole packet length)
> 
>> +	/* sanity check for allowed length and radiotap length field */
>> +	if (max_length < le16_to_cpu(radiotap_header->it_len))
>> +		return -EINVAL;
> 
>> +	iterator->max_length = le16_to_cpu(radiotap_header->it_len);
> 
> This is fine, at first sight, but if you let the caller modify the skb
> like mac80211 now does with stripping the FCS, the max length really
> needs to be passed to each invocation of
> ieee80211_radiotap_iterator_next in order to catch invalid skbs. Mind
> you, we wouldn't Oops since trimming just moves the skb tail pointer,

Looking at the code, I think this can be okay unless I didn't understand
your point.  At the time that the skb length is modified, I have this:

				if (skb->len < (iterator.max_length + FCS_LEN))
					return TXRX_DROP;

				skb_trim(skb, skb->len - FCS_LEN);

iterator.max_length is the claimed radiotap header total length, which
was verified to be within the original skb length already.  So at skb
length modification time, we take care beforehand that we have skb data
after the radiotap area to trim, otherwise we bail.  Trimming into the
radiotap header region would be a bug in the code calling the parser, so
we trust that if the radiotap header length fitted in the skb at the
start it does so during the parsing.

> but something that indicated a longer length and then just have a packet
> like
> 
> 0x00, 0x00, // <-- radiotap version
> 0x08, 0x00, // <- radiotap header length
> 0x10, 0x00, 0x00, 0x00, // <-- bitmap, FCS bit set
> 
> which might not do the right thing and it'd be better IMHO to catch it
> explicitly.

This case is explicitly captured here if we accept that any skb length
modification ensures that the original radiotap header length is left alone:

		/*
		 * check for insanity where we are given a bitmap that
		 * claims to have more arg content than the length of the
		 * radiotap section.  We will normally end up equalling this
		 * max_length on the last arg, never exceeding it.
		 */

		if (((ulong)iterator->arg - (ulong)iterator->rtheader) >
		    iterator->max_length)
			return -EINVAL;

> Also related to FCS, if you respin I think I'd like to have an explicit
> "0x00" entry in rt_sizes for it so it's obvious that it's intentionally
> 0, otherwise I'll post a patch after the code goes in.

I'm sorry I wasn't able to understand this.  FCS presence is a feature
of the IEEE80211_RADIOTAP_FLAGS radiotap entry which does have an entry
in rt_sizes?

> Another question: since there's no alignment requirement for the skb
> that contains the radiotap header, I think you need something like
> 
> iterator->bitmap_shifter = 
> 	le32_to_cpu(get_unaligned(iterator->next_bitmap))
> 
> instead of
> 
>> +                               iterator->bitmap_shifter =
>> +                                   le32_to_cpu(*iterator->next_bitmap);
> 
> in many places.

However this is a real objection I can understand :-/  Happens I
recently had experience of these alignment issues on mISDN for ARM,
although that has an (expensive) magic fixup exception handler some
arches, I was told Blackfin, don't.

I will have a go at fixing these and am interested in your take on the
other points.

-Andy
