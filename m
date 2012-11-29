Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:28826
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019Ab2K2L6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 06:58:15 -0500
Message-ID: <50B74DDC.3060207@posedge.com> (sfid-20121129_125819_269155_F6AAC4BC)
Date: Thu, 29 Nov 2012 17:28:20 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Remove unused VHT chan code
References: <50B71FA3.7050304@posedge.com>  <1354179167.9557.0.camel@jlt4.sipsolutions.net>  <50B723CF.20903@posedge.com>  <1354179955.9557.1.camel@jlt4.sipsolutions.net>  (sfid-20121129_100538_966311_BCCEF54F) <1354180010.9557.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354180010.9557.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2012 2:36 PM, Johannes Berg wrote:
> On Thu, 2012-11-29 at 10:05 +0100, Johannes Berg wrote:
>> On Thu, 2012-11-29 at 14:28 +0530, Mahesh Palivela wrote:
>>> On 11/29/2012 02:22 PM, Johannes Berg wrote:
>>>> On Thu, 2012-11-29 at 14:11 +0530, Mahesh Palivela wrote:
>>>>> From: Mahesh Palivela <maheshp@posedge.com>
>>>>>
>>>>> Cleanup of unused VHT channel config related code.
>>>>
>>>> Huh, good catch, thanks. Applied.
>>>
>>> Thanks. Even below also can be removed as cfg80211_chandef_usable()
>>> checks this at the beginning.
>>>
>>>          if (!cfg80211_chandef_valid(chandef))
>>>                  return -EINVAL;
>>
>> Hmm good point I'll roll that in.
>
> No actually it can't, cfg80211_chandef_usable() triggers a warning which
> we can't do if userspace just sends invalid information; however it's
> doing that for all other in-kernel users intentionally.

ok. So in case of nl80211_parse_chandef() we will be calling 
cfg80211_chandef_valid() twice.
No problem.

>
> johannes
>

-- 
Thanks,
Mahesh
