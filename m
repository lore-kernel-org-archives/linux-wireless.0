Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33228 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837Ab2B2OCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 09:02:54 -0500
Message-ID: <4F4E3009.5000601@qca.qualcomm.com> (sfid-20120229_150258_322935_952038D2)
Date: Wed, 29 Feb 2012 19:32:49 +0530
From: bkamatch <bkamatch@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Add background scan period attribute.
References: <1330518896-15230-1-git-send-email-bkamatch@qca.qualcomm.com>	 (sfid-20120229_133516_521752_BEEDD972) <1330519154.4714.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1330519154.4714.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 06:09 PM, Johannes Berg wrote:
> On Wed, 2012-02-29 at 18:04 +0530, Bala Shanmugam wrote:
>> Receive background scan period as part of connect
>> command and pass the same to driver.
>>
>> Signed-off-by: Bala Shanmugam<bkamatch@qca.qualcomm.com>
>> ---
>>   include/linux/nl80211.h |    8 ++++++++
>>   include/net/cfg80211.h  |    2 ++
>>   net/wireless/nl80211.c  |    7 +++++++
>>   net/wireless/wext-sme.c |    5 +++++
>>   4 files changed, 22 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> index ad56e21..7cef223 100644
>> --- a/include/linux/nl80211.h
>> +++ b/include/linux/nl80211.h
>> @@ -367,6 +367,9 @@
>>    *	%NL80211_ATTR_WIPHY_FREQ, %NL80211_ATTR_CONTROL_PORT,
>>    *	%NL80211_ATTR_CONTROL_PORT_ETHERTYPE and
>>    *	%NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT.
>> + *	Background scan period can also be
>> + *	optionally specified in %NL80211_ATTR_BG_SCAN_PERIOD.
>> + *	If period value is 0, bg scan will be disabled.
> Nack. We leave out the attribute in those cases and make 0 an invalid
> value.
This is an optional attribute and if we leave out,
BG scan is enabled with default period. We need to disable it
by passing some specific value through this attribute.
I choose 0 for it.
> Also please have this reviewed internally first. I'm tired of pointing
> out all the whitespace, code formatting, etc. issues from QCA folks.
Sorry for any mistakes.  This patch is internally reviewed and
cleared checkpatch.
> johannes
>

