Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422967Ab3CVVI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 17:08:27 -0400
Message-ID: <1363986499.8238.68.camel@jlt4.sipsolutions.net> (sfid-20130322_220832_088247_CE16507B)
Subject: Re: [RFC V3 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Fri, 22 Mar 2013 22:08:19 +0100
In-Reply-To: <1363967304-4394-1-git-send-email-karl.beldan@gmail.com> (sfid-20130322_165146_376383_D7D32205)
References: <1363967304-4394-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130322_165146_376383_D7D32205)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-03-22 at 16:48 +0100, Karl Beldan wrote:

> +		if (chandef.chan == local->_oper_chandef.chan)
> +			chandef = local->_oper_chandef;
> +		else {
> +			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
> +			chandef.center_freq1 = chandef.chan->center_freq;
> +		}

I'll agree with checkpatch that you should probably put braces against
both arms of the if :)

> -	if (chan != local->_oper_channel ||
> -	    channel_type != local->_oper_channel_type)
> +		chandef.chan = local->tmp_channel;
> +		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
> +		chandef.center_freq1 = chandef.chan->center_freq;
> +	} else
> +		chandef = local->_oper_chandef;

same here I guess

> +	/*
> +	 * FIXME: Here we are downgrading to NL80211_CHAN_WIDTH_20_NOHT
> +	 * and don't adjust our ht/vht settings
> +	 * This is wrong - we should behave according to the CSA params
> +	 */

I can live with this in this patch. I know we need to fix it, but I
don't want to do it in this patch nor do I really want to require it for
this patch. If you feel it's a requirement for this feel free to pick up
my other patches, but then I'd prefer you did it in a separate patch.

> - out:
> +out:

that seems a little unnecessary :)

>  #define CHANDEF_ASSIGN(c)							\
> -			__entry->chan_width = (c)->width;			\
> -			__entry->center_freq1 = (c)->center_freq1;		\
> +			__entry->chan_width = (c)->width;				\
> +			__entry->center_freq1 = (c)->center_freq1;			\

hmm, why did these lines change?

johannes

