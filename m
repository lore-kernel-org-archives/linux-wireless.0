Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35922 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab2FGHLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 03:11:14 -0400
Message-ID: <4FD0540C.5060808@qca.qualcomm.com> (sfid-20120607_091117_439723_853C75F9)
Date: Thu, 7 Jun 2012 12:41:08 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com> <1339050308.6009.9.camel@joe2Laptop>
In-Reply-To: <1339050308.6009.9.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Thursday 07 June 2012 11:55 AM, Joe Perches wrote:
> On Thu, 2012-06-07 at 11:32 +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> ratelimit few aggregation related messages, these messages
>> floods the log when aggregation is disabled in the AP(for some
>> wifi testcases) and we run traffic between STA and AP.
>
> I looked at all of the #ifdef CONFIG_MAC80211_HT_DEBUG uses.
>
> I think it's better simply to define a mac80211_ht_dbg
> macro for each of the !CONFIG and CONFIG cases and convert
> all of the other #ifdef CONFIG_MAC80211_HT_DEBUG logging
> messages.

oh, ok.

>
> #ifdef CONFIG_MAC80211_HT_DEBUG
> #define mac80211_ht_dbg(fmt, ...)				\
> 	net_dbg_ratelimited(fmt, ##__VA_ARGS__)
> #else
> #define mac80211_ht_dbg(fmt, ...)				\
> do {								\
> 	if (0)							\
> 		net_dbg_ratelimited(fmt, ##__VA_ARGS__);	\
> } while (0)
>
> etc...
>
> I think there's one use of wiphy_dbg that could be a
> mac80211_ht_dbg without much loss.
>
> Maybe add "%s", wiphy_name() to the args there.
>

sorry, i could not understand with wiphy_debug, with mac80211_ht_debug. 
the later is for HT and aggregation related messages.

-- 
thanks,
shafi
