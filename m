Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34572 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751811AbeGEHhe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 03:37:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 05 Jul 2018 13:07:32 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] cfg80211: Accept multiple RSSI threholds for STA_MON
 command
In-Reply-To: <1530265167.3481.45.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-7-git-send-email-tamizhr@codeaurora.org>
 <1530265167.3481.45.camel@sipsolutions.net>
Message-ID: <0b97dd04efa70ff1016ae6fd2face3a1@codeaurora.org> (sfid-20180705_093737_751332_0A32A04A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 15:09, Johannes Berg wrote:
> On Wed, 2018-06-13 at 16:15 +0530, Tamizh chelvam wrote:
>> Change the NL80211_CMD_STA_MON RSSI threshold attribut to
> 
> This seems weird - you just introduced it a few patches back, and now
> you change it and even worry about compatibility and have both cfg80211
> callbacks etc. Just remove set_sta_mon_rssi_config() and ask that
> drivers/mac80211 implement set_sta_mon_rssi_range_config?
> 
First I've done patch to have single threshold value for AP mode and as 
per the previous discussion extended to multiple thresholds also. Here 
the intention is to accept one or more than one RSSI thresholds to 
monitor. Any thought ?

>>   * @NL80211_EXT_FEATURE_STA_MON_RSSI_CONFIG: With this driver can set
>>   *	rssi threshold using %NL80211_ATTR_STA_MON_RSSI_THOLD attribute
>>   *	for a connected station.
>> + * @NL80211_EXT_FEATURE_STA_MON_RSSI_LIST: With this driver the
>> + *	%NL80211_ATTR_STA_MON_RSSI_THOLD attribute accepts a list of zero 
>> or
>> + *	more RSSI threshold values to monitor rather than exactly one 
>> threshold.
> 
> And maybe not have two bits here either?
> 
> Or do you expect somebody to actually really need the single threshold
> in the near future? It seems you're implementing it for mac80211 only,
> which doesn't care.
> 

Thanks,
Tamizh.
