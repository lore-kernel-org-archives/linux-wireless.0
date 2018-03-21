Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f53.google.com ([209.85.160.53]:44985 "EHLO
        mail-pl0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752010AbeCUPBy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:01:54 -0400
Received: by mail-pl0-f53.google.com with SMTP id 9-v6so3264745ple.11
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 08:01:54 -0700 (PDT)
Subject: Re: [RFC v5 3/9] nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180313215942.29176-1-denkenz@gmail.com>
 <20180313215942.29176-4-denkenz@gmail.com>
 <1521618479.2645.1.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <286ad6b3-479c-0294-b123-7f68b5e6349a@gmail.com> (sfid-20180321_160158_605515_D3794521)
Date: Wed, 21 Mar 2018 10:01:51 -0500
MIME-Version: 1.0
In-Reply-To: <1521618479.2645.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 03/21/2018 02:47 AM, Johannes Berg wrote:
> On Tue, 2018-03-13 at 16:59 -0500, Denis Kenzior wrote:
>>
>> +	if (info->attrs[NL80211_ATTR_CONTROL_PORT_OVER_NL80211]) {
>> +		if (!info->attrs[NL80211_ATTR_SOCKET_OWNER])
>> +			return -EINVAL;
>>
> There might be value in adding GENL_SET_ERR_MSG() calls to new
> instances of -EINVAL, but if you don't want to do that now I won't
> insist (and perhaps add some when I apply the patches).
> 

Sure, that sounds easy enough.  Did you see the TODO comments I added in 
RFC v5 0/9 message?  I need your help figuring out how you want to 
handle those.  Those are pretty esoteric though and would require more 
surgery.

Any chance that we can merge the non-controversial bits of this RFC so 
that we can get some wider testing and start encouraging non-mac80211 
based drivers to support these mechanisms?

Regards,
-Denis
