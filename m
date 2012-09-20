Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4933 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab2ITUJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 16:09:38 -0400
Message-ID: <505B77F9.1010000@broadcom.com> (sfid-20120920_220942_560223_516CE47B)
Date: Thu, 20 Sep 2012 22:09:29 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
cc: "Vladimir Kondratiev" <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] cfg80211: Fix regulatory check for 60GHz band
 frequencies
References: <1348039339-22246-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1348039339-22246-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <20120920183740.GY3354@lenteja.do-not-panic.com>
In-Reply-To: <20120920183740.GY3354@lenteja.do-not-panic.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2012 08:37 PM, Luis R. Rodriguez wrote:
> On Wed, Sep 19, 2012 at 10:22:19AM +0300, Vladimir Kondratiev wrote:
>> @@ -520,9 +522,12 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
>>   	u32 freq_khz)
>>   {
>>   #define ONE_GHZ_IN_KHZ	1000000
>> -	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
>> +	/* DMG frequencies starts from 45 GHz, see 802.11ad */
>
> What's this DMG thing?
>

 From 11ad:

directional multi-gigabit (DMG): Pertaining to operation in a frequency 
band containing a channel with the Channel starting frequency above 45 GHz.

Gr. AvS

