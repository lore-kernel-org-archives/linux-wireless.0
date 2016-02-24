Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:35716 "EHLO
	mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbcBXKEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 05:04:45 -0500
Received: by mail-pf0-f173.google.com with SMTP id c10so10851711pfc.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 02:04:45 -0800 (PST)
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reply-To: arend@broadcom.com
Subject: Re: [PATCH V7 1/2] nl80211: add feature for BSS selection support
References: <1455706070-11915-1-git-send-email-arend@broadcom.com>
 <1456237245.9910.16.camel@sipsolutions.net> <56CCC50E.4040300@broadcom.com>
 <1456260764.9910.31.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>, arend@broadcom.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <56CD8039.9060407@broadcom.com> (sfid-20160224_110454_812723_35E2E950)
Date: Wed, 24 Feb 2016 11:04:41 +0100
MIME-Version: 1.0
In-Reply-To: <1456260764.9910.31.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-2-2016 21:52, Johannes Berg wrote:
> On Tue, 2016-02-23 at 21:46 +0100, Arend Van Spriel wrote:
>>  
>>> Maybe we should be less specific here regarding the NLA_FLAG and
>>> say
>>> that it will contain attributes for each, indicating which
>>> behaviours
>>> are supported, and say there's behaviour-dependent data inside each
>>> of
>>> those attributes?
>>
>> For the GET_WIPHY case there will be not behaviour dependent data.
>>
>>> It seems entirely plausible that future behaviours would require
>>> their
>>> own sub-capabilities; perhaps that's even the case today for having
>>> an
>>> adjustment range for example, not that I think it's really
>>> necessary
>>> now.
>>
>> At least it does not harm to take that into account.
> 
> Right; there isn't today, but there might be later, so for the
> GET_WIPHY case it might be worth just specifying that there will be an
> attribute, not that it's NLA_FLAG?

Will try and be vague :-)

> Not that it'll matter much - only when we actually add such could
> applications possibly want to parse them :)

That goes without saying :-p

>>>> +	/* only process one nested attribute */
>>>> +	nest = nla_data(nla);
>>>> +	if (!nla_ok(nest, nla_len(nest)))
>>>> +		return -EBADF;
>>>
>>> This isn't quite clear to me. Shouldn't you do this by declaring it
>>> NLA_TESTED in the nl80211_policy?
>>
>> Guess you mean NLA_NESTED.
> 
> Heh, yeah.
> 
>>> Actually, not really? you use nla_ok() on the inner (without having
>>> checked at all that it's even long enough btw, since you didn't do
>>> the
>>> policy change), but that would already be done by nla_parse()
>>> below?
>>
>> Because ATTR_BSS_SELECT is used in CMD_GET_WIPHY and CMD_CONNECT the
>> length of the attribute is not a constant. Or do I only need to put
>> length in nl80211_policy for userspace-2-kernel direction, ie. for
>> ATTR_BSS_SELECT in CMD_CONNECT.
> 
> Ah. kernel->userspace messages don't use the policy in any way, it's
> just for the userspace->kernel message validation, so you can put there
> what's needed for CMD_CONNECT and ignore GET_WIPHY.

I actually do not see any NLA_NESTED attributes with an explicit length.
As you mentioned the nla_parse() of the nested attribute will validate
the length of the stream so no need to put that in the policy.

Regards,
Arend
