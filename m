Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53587 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996Ab2E1GPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 02:15:50 -0400
Message-ID: <4FC3180F.1060902@qca.qualcomm.com> (sfid-20120528_081554_570451_8102663F)
Date: Mon, 28 May 2012 11:45:43 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: net_ratelimit few aggregation related messages
References: <1337960224-7428-1-git-send-email-mohammed@qca.qualcomm.com> <1337976166.30100.6.camel@joe2Laptop>
In-Reply-To: <1337976166.30100.6.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Saturday 26 May 2012 01:32 AM, Joe Perches wrote:
> On Fri, 2012-05-25 at 21:07 +0530, Mohammed Shafi Shajakhan wrote:
>> net_ratelimit few aggregation related messages,
> []
>> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> []
>> @@ -464,8 +464,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
>>   		return -EINVAL;
>>
>>   #ifdef CONFIG_MAC80211_HT_DEBUG
>> -	printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
>> -	       pubsta->addr, tid);
>> +	if (net_ratelimit())
>> +		printk(KERN_DEBUG "Open BA session requested for %pM tid %u\n",
>> +		       pubsta->addr, tid);
>
> perhaps
> 	net_dbg_ratelimited(...)
>
> etc...
>

thanks for your inputs!
just today saw this link where you had introduced net_dbg_ratelimited
http://www.digipedia.pl/usenet/thread/18978/31017/
so should i send the v2 patch using net_dbg_ratelimited to net-next 
rather than wireless-testing tree ?

-- 
thanks,
shafi
