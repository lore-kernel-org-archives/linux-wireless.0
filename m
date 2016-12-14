Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36380 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754722AbcLNJBc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Dec 2016 04:01:32 -0500
Received: by mail-pg0-f43.google.com with SMTP id f188so6105701pgc.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2016 01:01:32 -0800 (PST)
Subject: Re: [RFC V3 03/11] nl80211: add support for gscan
To: Johannes Berg <johannes@sipsolutions.net>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
 <1481543997-24624-4-git-send-email-arend.vanspriel@broadcom.com>
 <1481645962.20412.41.camel@sipsolutions.net>
 <3dd64ef5-f05e-4a80-0c98-9a2548affd1c@broadcom.com>
 <1481668194.22319.0.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <f4f83c57-3e46-b017-fa36-b3776d71670a@broadcom.com> (sfid-20161214_100149_920581_273D0234)
Date: Wed, 14 Dec 2016 10:01:27 +0100
MIME-Version: 1.0
In-Reply-To: <1481668194.22319.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 13-12-2016 23:29, Johannes Berg wrote:
> On Tue, 2016-12-13 at 21:09 +0100, Arend Van Spriel wrote:
>>  
>>> There's a bit of a weird hard-coded restriction to 16 channels too,
>>> that's due to the bucket map?
>>
>> Uhm. Is there? I will check, but if you can give me a pointer where
>> to look it is appreciated.
> 
> Just look for "< 16" or "<= 16" or so in the patch. I do think that's
> because the channel map is a u16 though, not sure we'd want to change
> that.

Had to look for "> 16" ;-)

> +	/* ignore channels if band is specified */
> +	if (band_select)
> +		return 0;
> +
> +        nla_for_each_nested(chan,
tb[NL80211_GSCAN_BUCKET_ATTR_CHANNELS], rem) {
> +                num_chans++;
> +        }

Here an instance of the tab vs. space issue you mentioned. Will go over
the patch and fix that.

> +	if (num_chans > 16)
> +		return -EINVAL;

I suspect this is the restriction you were referring to. There is no
reason for this although the android wifi hal has max 16 channels in a
bucket so I might have picked that up. So could a driver have a similar
limit and should we add such to the gscan capabilities? For instance our
firmware api has a nasty restriction of 64 channels for all buckets
together, eg. can do 4 buckets of 16 channels each.

Regards,
Arend
