Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:61080 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2EJJFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:05:49 -0400
Message-ID: <4FAB84EA.4060306@tieto.com> (sfid-20120510_110625_385246_38DA219B)
Date: Thu, 10 May 2012 11:05:46 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/7] cfg80211: extend get_channel to take wdev argument
References: <1336632282-2278-1-git-send-email-michal.kazior@tieto.com>  <1336632282-2278-6-git-send-email-michal.kazior@tieto.com> <1336634995.4334.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1336634995.4334.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>
>>   	struct ieee80211_channel *(*get_channel)(struct wiphy *wiphy,
>> -					       enum nl80211_channel_type *type);
>> +						 struct wireless_dev *wdev,
>> +						 enum nl80211_channel_type *type);
>
> Hmm. This is mostly used for monitor mode, and there we would have to
> return NULL anyway while using multiple channels at the same time. Is it
> really worth the complexity?

Would we really have to return NULL? With my last patch that moves 
oper_channel to sdata it can return proper channel.

But then monitor mode.. ugh.


-- 
Pozdrawiam / Best regards, Michal Kazior.
