Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33465 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbcHKQiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 12:38:04 -0400
Received: by mail-pa0-f65.google.com with SMTP id vy10so40703pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2016 09:38:03 -0700 (PDT)
Subject: Re: [RESEND PATCH] nl80211: Allow GET_INTERFACE dumps to be filtered
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1470261735-2977-1-git-send-email-denkenz@gmail.com>
 <1470919643.12075.7.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <57ACA9E9.4020507@gmail.com> (sfid-20160811_183839_738308_37F600C8)
Date: Thu, 11 Aug 2016 11:38:01 -0500
MIME-Version: 1.0
In-Reply-To: <1470919643.12075.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 08/11/2016 07:47 AM, Johannes Berg wrote:
> On Wed, 2016-08-03 at 17:02 -0500, Denis Kenzior wrote:
>>
>> +static int nl80211_dump_interface_parse(struct sk_buff *skb,
>> +				    struct netlink_callback *cb,
>> +				    int *filter_wiphy)
>
> Wrong indentation :)

Sorry :)

Speaking of indentation, can you point me to a doc of the rules I should 
follow?

>
>>   static int nl80211_dump_interface(struct sk_buff *skb, struct
>> netlink_callback *cb)
>>   {
>>   	int wp_idx = 0;
>>   	int if_idx = 0;
>>   	int wp_start = cb->args[0];
>>   	int if_start = cb->args[1];
>> +	int filter_wiphy = cb->args[2];
>>   	struct cfg80211_registered_device *rdev;
>>   	struct wireless_dev *wdev;
>>
>> +	if (!wp_start && !if_start && !filter_wiphy) {
>
> This seems incorrect - you're setting
>
>> +		int ret;
>> +
>> +		filter_wiphy = -1;
>> +
>> +		ret = nl80211_dump_interface_parse(skb, cb,
>> &filter_wiphy);
>
> it here, but it can take the value 0, so !filter_wiphy seems wrong?
>

I can confirm that I sanity checked this patch. Both ATTR_WIPHY, 
ATTR_WDEV and wildcard dumps seemed to produce expected results.

I noticed you applied this patch.  Is there a particular scenario where 
it goes wrong or did you convince yourself it is correct?

Regards,
-Denis
