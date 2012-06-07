Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5215 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760132Ab2FGG17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 02:27:59 -0400
Message-ID: <4FD049E8.3090201@qca.qualcomm.com> (sfid-20120607_082809_352721_14E7C964)
Date: Thu, 7 Jun 2012 11:57:52 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com> <20432.18148.937220.807081@gargle.gargle.HOWL>
In-Reply-To: <20432.18148.937220.807081@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Thursday 07 June 2012 11:45 AM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> ratelimit few aggregation related messages, these messages
>> floods the log when aggregation is disabled in the AP(for some
>> wifi testcases) and we run traffic between STA and AP.
>> mac80211 gives up after 15 addba requests, but
>> ieee80211_start_tx_ba_session will be repeatedly called
>> by drivers rate control tx_status callback. These net_dbg_ratelimited
>> messages will be visible only when dynamic debug is enabled for
>> mac80211 module.
>
> I think the drivers need to be fixed. For ath9k, we probably need
> an intermediate state to track whether an ADDBA request is pending.
>

the timeout till the addba requests can be sent out is completely taken 
care by mac80211 and we stop trying after a particular amount of time 
which is also tracked by mac80211, these are just logs after sometime

-- 
thanks,
shafi
