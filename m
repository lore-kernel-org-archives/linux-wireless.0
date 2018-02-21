Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56064 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965189AbeBUN5g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Feb 2018 08:57:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 21 Feb 2018 19:27:35 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/3] cfg80211: enable setting cqm rssi config for AP
 mode
In-Reply-To: <1519046050.16723.8.camel@sipsolutions.net>
References: <1518513656-22324-1-git-send-email-tamizhr@codeaurora.org>
 <1518513656-22324-2-git-send-email-tamizhr@codeaurora.org>
 <1519046050.16723.8.camel@sipsolutions.net>
Message-ID: <f0b1de1c18b8f20c793958570bb73005@codeaurora.org> (sfid-20180221_150034_441446_7079B13A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-19 18:44, Johannes Berg wrote:
> On Tue, 2018-02-13 at 14:50 +0530, Tamizh chelvam wrote:
>> 
>> @@ -9903,8 +9906,10 @@ static int nl80211_set_cqm_rssi(struct 
>> genl_info *info,
>>  		prev = thresholds[i];
>>  	}
>> 
>> -	if (wdev->iftype != NL80211_IFTYPE_STATION &&
>> -	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
>> +	if ((wdev->iftype != NL80211_IFTYPE_STATION &&
>> +	     wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
>> +	     !wiphy_ext_feature_isset(&rdev->wiphy,
>> +				NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG)))
>>  		return -EOPNOTSUPP;
> 
> This enables for everything though - not sure we want that?

I'll add vif type(AP, AP_VLAN and P2P_GO) check in the next version to 
avoid enable this for all.
