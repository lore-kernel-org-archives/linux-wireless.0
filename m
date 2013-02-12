Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3BLJJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 04:09:27 -0500
Message-ID: <1360660163.8178.5.camel@jlt4.sipsolutions.net> (sfid-20130212_100932_383439_D9017360)
Subject: Re: [PATCH] nl80211: add packet offset information for wowlan
 pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 12 Feb 2013 10:09:23 +0100
In-Reply-To: <1360655802-21515-2-git-send-email-bzhao@marvell.com>
References: <1360655802-21515-1-git-send-email-bzhao@marvell.com>
	 <1360655802-21515-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 23:56 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> If user knows the location of a wowlan pattern to be matched in
> Rx packet, he can provide an offset with the pattern. This will
> help drivers to ignore initial bytes and match the pattern
> efficiently.

This is a bit tricky. Right now, the documentation says:

 * @NL80211_WOWLAN_TRIG_PKT_PATTERN: wake up on the specified packet patterns
 *      which are passed in an array of nested attributes, each nested attribute
 *      defining a with attributes from &struct nl80211_wowlan_trig_pkt_pattern.
 *      Each pattern defines a wakeup packet. The matching is done on the MSDU,
 *      i.e. as though the packet was an 802.3 packet, so the pattern matching
 *      is done after the packet is converted to the MSDU.

I don't mind adding the offset, but not all devices will support that
(ours doesn't) so when advertising the feature it needs to be documented
to be something like the maximum possible offset? So you also need to
modify the documentation for that and the code in nl80211_send_wiphy().

> @@ -7070,7 +7073,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
>  				  nla_data(pat), nla_len(pat), NULL);
>  			err = -EINVAL;
>  			if (!pat_tb[NL80211_WOWLAN_PKTPAT_MASK] ||
> -			    !pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN])
> +			    !pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN] ||
> +			    !pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET])
>  				goto error;

You can't just break backward compatibility like that, the new attribute
must be optional and assumed 0 if it's not present.

> @@ -7096,6 +7100,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
>  			memcpy(new_triggers.patterns[i].pattern,
>  			       nla_data(pat_tb[NL80211_WOWLAN_PKTPAT_PATTERN]),
>  			       pat_len);
> +			new_triggers.patterns[i].pkt_offset = nla_get_u32(
> +					pat_tb[NL80211_WOWLAN_PKTPAT_OFFSET]);

Since all existing users of the API would ignore the pkt_offset, you
must reject the configuration if the offset exceeds the maximum
permissible offset the device advertises (existing ones would advertise
0)

johannes

