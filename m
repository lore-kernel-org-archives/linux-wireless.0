Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43226 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3DOOT4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 10:19:56 -0400
Message-ID: <516C0C7F.3000204@openwrt.org> (sfid-20130415_161959_505945_3890C37A)
Date: Mon, 15 Apr 2013 16:19:43 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] mac80211: fix and optimize MCS mask handling
References: <1365890626-86895-1-git-send-email-nbd@openwrt.org> <1366033124.8361.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366033124.8361.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-15 3:38 PM, Johannes Berg wrote:
> 
>>  	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
>> +		struct ieee80211_supported_band *sband = wiphy->bands[i];
>> +		int j;
>> +
>>  		sdata->rc_rateidx_mask[i] = mask->control[i].legacy;
>>  		memcpy(sdata->rc_rateidx_mcs_mask[i], mask->control[i].mcs,
>>  		       sizeof(mask->control[i].mcs));
>> +
>> +		sdata->rc_has_mcs_mask[i] = false;
>> +		if (!sband)
>> +			continue;
>> +
>> +		for (j = 0; j < IEEE80211_HT_MCS_MASK_LEN; j++)
> 
> I think I'd kinda prefer extra braces, but hey, I'd change that myself,
> but there's another question:
> 
>> +			if (~sdata->rc_rateidx_mcs_mask[i][j]) {
> 
> That ~ seems a bit odd to me, any reason you didn't just use ! ?
It's not a boolean, here I'm checking if any of the bits are set to 0.

- Felix
