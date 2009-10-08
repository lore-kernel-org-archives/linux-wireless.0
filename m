Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16722 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933409AbZJHURh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 16:17:37 -0400
Message-ID: <4ACE4877.50308@nokia.com>
Date: Thu, 08 Oct 2009 23:15:51 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D/Tampere)" <juuso.oikarinen@nokia.com>
Subject: Re: [PATCH 15/20] wl1271: Multicast filtering configuration
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>	 <1255028196-6565-16-git-send-email-luciano.coelho@nokia.com> <1255032103.3713.33.camel@johannes.local>
In-Reply-To: <1255032103.3713.33.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

ext Johannes Berg wrote:
> On Thu, 2009-10-08 at 21:56 +0300, Luciano Coelho wrote:
> 
>> +	/* first, get the filter parameters */
>> +	spin_lock_irqsave(&wl->wl_lock, flags);
>> +	fp = wl->filter_params;
>> +	wl->filter_params = NULL;
>> +	spin_unlock_irqrestore(&wl->wl_lock, flags);
>> +
>> +	if (!fp)
>> +		return;
> 
>> +	kfree(fp);
> 
>> +static u64 wl1271_op_prepare_multicast(struct ieee80211_hw *hw, int mc_count,
>> +				       struct dev_addr_list *mc_list)
>> +{
>> +	struct wl1271 *wl = hw->priv;
>> +	struct wl1271_filter_params *fp;
>> +	unsigned long flags;
>> +	int i;
>> +
>> +	/*
>> +	 * FIXME: we should return a hash that will be passed to
>> +	 * configure_filter() instead of saving everything in the context.
>> +	 */
>> +
>> +	fp = kzalloc(sizeof(*fp), GFP_KERNEL);
>> +	if (!fp) {
>> +		wl1271_error("Out of memory setting filters.");
>> +		return 0;
>> +	}
> 
> It's a u64 on purpose, you can return the parameters struct to pass it
> through to configure_filter.

Yes, you're right.  It's just that I have forwarded-ported loads of patches at 
once, so I just made a quick hack to get this to compile and work before the 
real thing is done.  Juuso Oikarinen (who is also working on the wl1271) has 
already implemented the final solution for this and his patch will be included 
in one of my next batches ;)

Thanks a lot for your timely comment (as usual).

--
Cheers,
Luca.
