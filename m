Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:58161 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527Ab0HTWz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 18:55:58 -0400
Message-ID: <4C6F07AA.3080606@redfish-solutions.com>
Date: Fri, 20 Aug 2010 15:54:34 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 3/3] nl80211: New command for setting TX rate mask for
 rate control
References: <20091229105945.GD18493@jm.kir.nu>	 <4C6DA19B.7010606@redfish-solutions.com> <1282296004.3785.25.camel@jlt3.sipsolutions.net> <4C6EAE6C.50001@redfish-solutions.com>
In-Reply-To: <4C6EAE6C.50001@redfish-solutions.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 8/20/10 9:33 AM, Philip Prindeville wrote:
>  On 8/20/10 2:20 AM, Johannes Berg wrote:
>> On Thu, 2010-08-19 at 14:26 -0700, Philip Prindeville wrote:
>>
>>>> +    /*
>>>> +     * The nested attribute uses enum nl80211_band as the index. This maps
>>>> +     * directly to the enum ieee80211_band values used in cfg80211.
>>>> +     */
>>>> +    nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem)
>>>> +    {
>>>> +        enum ieee80211_band band = nla_type(tx_rates);
>>> Can this even work?  The first entry in nl80211_band is NL80211_BAND_2GHZ, i.e. zero.
>>>
>>> Yet looking at libnl-1.1/lib/attr.c there's:
>>>
>>> int nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head, int len,
>>>                 struct nla_policy *policy)
>>> {
>>> ...
>>>           nla_for_each_attr(nla, head, len, rem) {
>>>                   int type = nla_type(nla);
>>>
>>>                   if (type == 0) {
>> Well, notice how you're quoting code that does the same thing
>> (for_each_attr), but the latter code does the extra non-zero check,
>> which we don't.
>>
>> We don't use nla_parse for this, we have to use
>> nla_parse_nested/for_each_attr. Yeah, it's a little quirky, but still
>> works fine.
>>
>> johannes
>>
>
> Well, I grepped through all the relevant source (i.e. libnl and iw) and the only place that the string "Illegal nla->nla_type == 0" gets printed was there, and I'm definitely seeing it.
>
> So while the condition might be set in the driver, it's detected in "iw" here.
>
> That was my point.


What I'm trying to say is that even though the driver handles the condition of nla_type == 0 when it generates the message, the condition isn't handled correct when the message finally gets passed up into user-space, because the above sequence in the netlink library gets hit both for "iw" and "hostapd".

So it's not enough to handle it correctly in the driver: it needs to be handled in libnl as well.

There are 3 potential solutions:

(1) go with a 1-based enum for the band, instead of 0-based;
(2) remove the test for nla_type == 0 in nla_parse() in libnl;
(3) use a way to convey the band that doesn't involve overloading nla_type;

What's the correct fix?

Thanks,

-Philip

