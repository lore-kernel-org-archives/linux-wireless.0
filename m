Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45480 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab1JZTSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 15:18:01 -0400
Message-ID: <4EA85CE3.6030600@candelatech.com> (sfid-20111026_211807_971148_DC4E68C8)
Date: Wed, 26 Oct 2011 12:17:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: a-MSDU question (bug in debugfs?)
References: <4EA8597A.50609@candelatech.com>  (sfid-20111026_210325_886708_85470263) <1319656123.4229.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1319656123.4229.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/2011 12:08 PM, Johannes Berg wrote:
> On Wed, 2011-10-26 at 12:03 -0700, Ben Greear wrote:
>> This code from net/mac80211/debugfs_sta.c appears to say that
>> if the IEEE80211_HT_CAP_MAX_AMSDU is set, we are at value 3839,
>> but elsewhere on the web it appears the opposite.
>>
>> Anyone know what is correct?  I'm having no good luck finding
>> an official document about this...
>>
>>                  PRINT_HT_CAP((htc->cap&  BIT(11)), "Max AMSDU length: "
>>                                "3839 bytes");
>>                   PRINT_HT_CAP(!(htc->cap&  BIT(11)), "Max AMSDU length: "
>>                                "7935 bytes");
>
> iw also has the other way around and I probably would have checked
> against 802.11n. If you can't find that google for getieee

Thanks, I found the 802.11n doc.  Page 69 (section 7.3.2.56) seems to indicate
this debugfs code is reversed.  I'll post a patch when I
get the rest of my tree sorted out, if no one beats me to it.

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

