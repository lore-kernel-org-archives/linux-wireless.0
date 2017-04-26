Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34591 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2998115AbdDZKY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 06:24:58 -0400
Received: by mail-qk0-f182.google.com with SMTP id y63so138334874qkd.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 03:24:57 -0700 (PDT)
Subject: Re: [PATCH V3 1/9] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1492776308-15120-1-git-send-email-arend.vanspriel@broadcom.com>
 <1492776308-15120-2-git-send-email-arend.vanspriel@broadcom.com>
 <1493149747.15192.0.camel@sipsolutions.net>
 <3ce6aed5-7d00-3446-a39b-b5da4b788358@broadcom.com>
 <1493196583.2464.14.camel@sipsolutions.net>
 <4323eaab-39c2-1946-a4dd-3d37361e3d8c@broadcom.com>
 <1493197685.2464.15.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5bdba644-82db-9df1-bfac-14c707dbdfda@broadcom.com> (sfid-20170426_122543_627175_EB72A263)
Date: Wed, 26 Apr 2017 12:24:53 +0200
MIME-Version: 1.0
In-Reply-To: <1493197685.2464.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 4/26/2017 11:08 AM, Johannes Berg wrote:
> On Wed, 2017-04-26 at 11:05 +0200, Arend van Spriel wrote:
>> I guess it could be done, but I'm tending towards doing that less
>>> again, I have no strong preference in this case. If it was
>>> something
>>> that seems likely to get abused, perhaps, but here...
>>
>> Ok. As long as drivers don't think they can use the list_head to push
>> it on a private list.
> 
> They'll crash immediately and be disabused of that notion :)
> 
>> The internal use comment does not end up in
>> kerneldoc. So maybe we can improve that? Would work for me.
> 
> It's difficult - though we could replace it with /* private: */ and
> remove those things from kernel-doc entirely.

probably won't work:

	/* internal */
	struct wiphy *wiphy;
	struct net_device *dev;
	unsigned long scan_start;
	struct rcu_head rcu_head;
	u32 owner_nlportid;

	/* keep last */
	struct ieee80211_channel *channels[0];
};

Regards,
Arend
