Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:48240 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932384Ab1IHI4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 04:56:05 -0400
Received: by mail-yx0-f171.google.com with SMTP id 7so549853yxs.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Sep 2011 01:56:03 -0700 (PDT)
Message-ID: <4E688321.7090704@ti.com> (sfid-20110908_105609_891439_9AB11EEC)
Date: Thu, 08 Sep 2011 11:56:01 +0300
From: Victor Goldenshtein <victorg@ti.com>
Reply-To: victorg@ti.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result event.
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>  <1315224151-16552-4-git-send-email-VictorG@ti.com>  <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>  <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com> <1315464556.3948.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1315464556.3948.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2011 09:49, Johannes Berg wrote:
> On Thu, 2011-09-08 at 09:31 +0300, Victor Goldenshtein wrote:
>> On 07/09/2011 12:26, Johannes Berg wrote:
>>>> The intermediate scan event is not HW dependent, so there is no need to
>>>> advertise it..
>>>
>>> Not with mac80211 drivers, but with cfg80211 drivers?
>>>
>>> johannes
>>>
>>
>> You're right, cfg80211 drivers will not support it. As I couldn't find a
>> way to know whether it mac or cfg based driver, I can add also
>> IEEE80211_HW_SUPPORTS_IM_RESULT" flag (as with cancel_scan) and then
>> will advertise the nl80211 command if it set, is it OK?
>
> I'd prefer not advertising the command, since so far we've only
> advertised supported commands as supported -- a new nl80211 flag would
> be nicer I think.
>
> Come to think of it, maybe it's time to bundle capability flags
> together. We seem to acquire new ones all the time, so maybe we should
> have a HW_CAPABILITY nl80211 attribute that can simply grow as
> needed ...
>
> johannes
>

If I understood you correctly.. I can create new 
NL80211_ATTR_HW_CAPABILITY (u32) attribute which will advertise all 
capabilities with "dev->wiphy.flags".

Thanks,
Victor.
