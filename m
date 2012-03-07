Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38762 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab2CGUSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 15:18:41 -0500
Message-ID: <4F57C29C.1050900@qca.qualcomm.com> (sfid-20120307_211845_332490_246ADD3B)
Date: Wed, 7 Mar 2012 22:18:36 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/12] ath6kl: alignment should match open parenthesis
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>	 <20120229171855.24264.64135.stgit@localhost6.localdomain6> <1331148403.2140.67.camel@joe2Laptop>
In-Reply-To: <1331148403.2140.67.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2012 09:26 PM, Joe Perches wrote:
> On Wed, 2012-02-29 at 19:18 +0200, Kalle Valo wrote:
>> Fix the issues which checkpatch found and were easy to fix. Especially
>> callers of ath6kl_bmi_write() are tricky and that needs to be fixed
>> separately.
> 
> Just a trivial note.
> 
>> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> []
>> @@ -390,7 +390,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
>>  		return false;
>>  
>>  	if (ar->ibss_if_active || ((type == NL80211_IFTYPE_ADHOC) &&
>> -	    ar->num_vif))
>> +				   ar->num_vif))
> 
> I think this would be better as:
> 
> 	if (ar->ibss_if_active ||
> 	    (type == NL80211_IFTYPE_ADHOC && ar->num_vif))
> 
> Bundling dependent tests on a single line is sensible.

I agree, but I just pushed this patch and I can't change it anymore. I
try to remember this in the future.

Kalle
