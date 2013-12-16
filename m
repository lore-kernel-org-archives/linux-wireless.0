Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56519 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3LPPYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:24:25 -0500
Message-ID: <52AF1B26.3020702@openwrt.org> (sfid-20131216_162428_219954_B7F7E826)
Date: Mon, 16 Dec 2013 16:24:22 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: add helper functions for tracking P2P NoA
 state
References: <1386626388-45880-1-git-send-email-nbd@openwrt.org> <1387206567.2057.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1387206567.2057.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-16 16:09, Johannes Berg wrote:
> On Mon, 2013-12-09 at 22:59 +0100, Felix Fietkau wrote:
> 
>> +static u32
>> +ieee80211_get_noa_absent_time(struct ieee80211_noa_data *data, u32 tsf)
>> +{
>> +	s32 offset = 0;
>> +	int tries = 0;
>> +
>> +	ieee80211_extend_absent_time(data, tsf, &offset);
>> +	do {
>> +		if (!ieee80211_extend_absent_time(data, tsf, &offset))
>> +			break;
>> +
>> +		tries++;
>> +	} while (tries < 5);
> 
> What's "tries < 5"?
Arbitrary value. It tries to merge up to 5 intervals of each NoA
descriptor. I can't let it try forever because that can easily make it
run into an infinite loop if the combination of the NoA descriptors
doesn't leave any presence time inbetween.

- Felix

