Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:35687 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZHLTFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 15:05:15 -0400
Received: by fxm28 with SMTP id 28so197785fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 12:05:15 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] mac80211: fix dynamic power save for devices which have nullfunc support
References: <20090812145200.23691.17281.stgit@tikku>
	<20090812145209.23691.82.stgit@tikku>
	<1250089389.26464.1.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 12 Aug 2009 21:57:53 +0300
In-Reply-To: <1250089389.26464.1.camel@johannes.local> (Johannes Berg's message of "Wed\, 12 Aug 2009 17\:03\:09 +0200")
Message-ID: <87fxbwkgge.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2009-08-12 at 17:52 +0300, Kalle Valo wrote:
>
>>  static bool is_dynamic_ps_enabled(struct ieee80211_local *local)
>>  {
>> -	if (!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
>> +
>> +	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_PS))
>>  		/* driver doesn't support power save */
>>  		return false;
>
> Why the blank line?

A mistake, will remove.

>> +	if (local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)
>> +		/* hardware does dynamic power save */
>> +		return false;
>
> FWIW, also applies to patch 1, I think I prefer
>
> 	/* check if hardware does dynamic power save */
> 	if (local->hw.flags & ...)
> 		return false;
>
> (wrt. comment location)

I'll change that.

> and you should probably rename the function to do_software_dynamic_ps()
> or something like that?

I had problems coming up with a good name. "do" in a sense is confusing
because the function only checks the state, it doesn't have any code to
change the timer or anything like that. I'll think of this a bit more.
Suggestions are welcome.

I'll send v2 later this week. John, please drop these three patches.

-- 
Kalle Valo
