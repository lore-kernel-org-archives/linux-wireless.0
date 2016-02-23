Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36409 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380AbcBWUqK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 15:46:10 -0500
Received: by mail-pf0-f169.google.com with SMTP id e127so118435725pfe.3
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 12:46:10 -0800 (PST)
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Reply-To: arend@broadcom.com
Subject: Re: [PATCH V7 1/2] nl80211: add feature for BSS selection support
References: <1455706070-11915-1-git-send-email-arend@broadcom.com>
 <1456237245.9910.16.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <56CCC50E.4040300@broadcom.com> (sfid-20160223_214618_899529_73414769)
Date: Tue, 23 Feb 2016 21:46:06 +0100
MIME-Version: 1.0
In-Reply-To: <1456237245.9910.16.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-2-2016 15:20, Johannes Berg wrote:
> On Wed, 2016-02-17 at 11:47 +0100, Arend van Spriel wrote:
>>  
>> + * @NL80211_ATTR_BSS_SELECT: nested attribute for driver supporting the
>> + *	BSS selection feature. When used with %NL80211_CMD_GET_WIPHY it contains
>> + *	NLA_FLAG type according &enum nl80211_bss_select_attr to indicate what
>> + *	BSS selection behaviours are supported. When used with %NL80211_CMD_CONNECT
>> + *	it contains the behaviour and parameters for BSS selection to be done by
>> + *	driver and/or firmware.
> 
> Maybe we should be less specific here regarding the NLA_FLAG and say
> that it will contain attributes for each, indicating which behaviours
> are supported, and say there's behaviour-dependent data inside each of
> those attributes?

For the GET_WIPHY case there will be not behaviour dependent data.

> It seems entirely plausible that future behaviours would require their
> own sub-capabilities; perhaps that's even the case today for having an
> adjustment range for example, not that I think it's really necessary
> now.

At least it does not harm to take that into account.

>> @@ -3617,6 +3624,7 @@ enum nl80211_band {
>>  	NL80211_BAND_2GHZ,
>>  	NL80211_BAND_5GHZ,
>>  	NL80211_BAND_60GHZ,
>> +	NUM_NL80211_BAND,
> 
> You should use IEEE80211_NUM_BANDS and remove this.

Ok. missed that one.

>> +static bool is_band_valid(struct wiphy *wiphy, enum nl80211_band b)
>> +{
>> +	return b < NUM_NL80211_BAND && wiphy->bands[b];
>> +}
> 
> Here.

will change it.

>> +static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
>> +			    struct cfg80211_bss_selection
>> *bss_select)
>> +{
>> +	struct nlattr *attr[NL80211_BSS_SELECT_ATTR_MAX + 1];
>> +	struct nlattr *nest;
>> +	int err;
>> +	bool found = false;
>> +	int i;
>> +
>> +	/* only process one nested attribute */
>> +	nest = nla_data(nla);
>> +	if (!nla_ok(nest, nla_len(nest)))
>> +		return -EBADF;
> 
> This isn't quite clear to me. Shouldn't you do this by declaring it
> NLA_TESTED in the nl80211_policy?

Guess you mean NLA_NESTED.

> Actually, not really? you use nla_ok() on the inner (without having
> checked at all that it's even long enough btw, since you didn't do the
> policy change), but that would already be done by nla_parse() below?

Because ATTR_BSS_SELECT is used in CMD_GET_WIPHY and CMD_CONNECT the
length of the attribute is not a constant. Or do I only need to put
length in nl80211_policy for userspace-2-kernel direction, ie. for
ATTR_BSS_SELECT in CMD_CONNECT.

> What are you trying to do here?

ATTR_BSS_SELECT will have only a single nested attribute. So I looked at
nla_for_each_nested():

1233 /**
1234  * nla_for_each_attr - iterate over a stream of attributes
1235  * @pos: loop counter, set to current attribute
1236  * @head: head of attribute stream
1237  * @len: length of attribute stream
1238  * @rem: initialized to len, holds bytes currently remaining in stream
1239  */
1240 #define nla_for_each_attr(pos, head, len, rem) \
1241         for (pos = head, rem = len; \
1242              nla_ok(pos, rem); \
1243              pos = nla_next(pos, &(rem)))
1244
1245 /**
1246  * nla_for_each_nested - iterate over nested attributes
1247  * @pos: loop counter, set to current attribute
1248  * @nla: attribute containing the nested attributes
1249  * @rem: initialized to len, holds bytes currently remaining in stream
1250  */
1251 #define nla_for_each_nested(pos, nla, rem) \
1252         nla_for_each_attr(pos, nla_data(nla), nla_len(nla), rem)

So:

  nla_for_each_nested(nest, nla, rem)

becomes:
  for(nest = nla_data(nla), rem = nla_len(nla); nla_ok(nest, rem); ...)

As there is no need to iterate I just do the for loop initializer and
the loop condition using the if(nla_ok()).

> Regardless of that, EBADF seems like a bad error number.

Ok. Just use EINVAL here as well?

>> +	err = nla_parse(attr, NL80211_BSS_SELECT_ATTR_MAX,
>> nla_data(nest),
>> +			nla_len(nest), nl80211_bss_select_policy);
>> +	if (err)
>> +		return err;
>> +
>> +	/* only one attribute may be given */
>> +	for (i = 0; i <= NL80211_BSS_SELECT_ATTR_MAX; i++)
>> +		if (attr[i]) {
>> +			if (found)
>> +				return -EINVAL;
>> +			found = true;
>> +		}
> 
> I'd kinda prefer braces, but maybe that's just me. Surely not a
> blocking issue :)

I don't have strong opinion about it so I can change it.

Regards,
Arend
