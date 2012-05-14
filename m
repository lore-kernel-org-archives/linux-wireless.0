Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57934 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2ENTLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 15:11:11 -0400
Received: by obbtb18 with SMTP id tb18so7798516obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 12:11:11 -0700 (PDT)
Message-ID: <4FB158CB.2010704@lwfinger.net> (sfid-20120514_211115_553819_73A55ABD)
Date: Mon, 14 May 2012 14:11:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix single queue drivers
References: <1336405529.4325.31.camel@jlt3.sipsolutions.net> <4FAF3AB8.90900@lwfinger.net> <20120514175603.GB2428@tuxdriver.com>
In-Reply-To: <20120514175603.GB2428@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/14/2012 12:56 PM, John W. Linville wrote:
> On Sat, May 12, 2012 at 11:38:16PM -0500, Larry Finger wrote:
>> On 05/07/2012 10:45 AM, Johannes Berg wrote:
>>> From: Johannes Berg<johannes.berg@intel.com>
>>>
>>> My queue management rework broke drivers that don't
>>> have multiple AC queues and register a single queue
>>> only, causing a warning:
>>>
>>> WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues
>>>
>>> This was due to filling the queues wrongly and then
>>> noticing the error when checking later.
>>>
>>> Reported-and-Tested-by: Larry Finger<Larry.Finger@lwfinger.net>
>>> Signed-off-by: Johannes Berg<johannes.berg@intel.com>
>>
>> John,
>>
>> I know you have been busy and that Linus is restricting the patches
>> to be added after 3.4-rc7; however, this one really needs to get
>> into 3.4. If it does not make it, every wireless device with only
>> one hardware queue will break.
>>
>> Larry
>
> Actually, it doesn't seem to apply in 3.4.  The original commit that
> causes the problem (3a25a8c8) seems to only exist in wireless-next.
>
> Is there some other version of this patch to apply for 3.4?

I got confused about that one. Sorry for the noise.

The one that does need to be in 3.4 is "[PATCH] rtlwifi: fix for race condition 
when firmware is cached". The original commit (b0302ab) is in mainline, but this 
fix is not.

Larry

