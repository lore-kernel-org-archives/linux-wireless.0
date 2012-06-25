Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:55456 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab2FYHFd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 03:05:33 -0400
Message-ID: <4FE80DBA.8040703@tieto.com> (sfid-20120625_090537_308969_DAE607D6)
Date: Mon, 25 Jun 2012 09:05:30 +0200
From: Michal Kazior <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFCv2 13/13] cfg80211: respect iface combinations when starting
 operation
References: <1340172859-18146-1-git-send-email-michal.kazior@tieto.com>  <1340172859-18146-14-git-send-email-michal.kazior@tieto.com> <1340291183.4489.39.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340291183.4489.39.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2012-06-20 at 08:14 +0200, Michal Kazior wrote:
>
>> +++ b/net/wireless/mlme.c
>> @@ -302,8 +302,14 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
>>   	if (!req.bss)
>>   		return -ENOENT;
>>
>> +	err = cfg80211_can_use_chan(rdev, wdev, req.bss->channel,
>> +				    CHAN_MODE_SHARED);
>> +	if (err)
>> +		goto end;
>
> I think you need it in assoc too?

Hmm.. I didn't think it's possible for bss to change channels in between 
auth and assoc. I'll add the check for assoc too then.


-- 
Pozdrawiam / Best regards, Michal Kazior.
