Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63099 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab1LZFPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Dec 2011 00:15:12 -0500
Message-ID: <4EF802DB.10100@qca.qualcomm.com> (sfid-20111226_061516_639289_9EAF58E4)
Date: Mon, 26 Dec 2011 10:45:07 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<pstew@chromium.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: use rcu_read_lock before sta_info_get
References: <1324825752-8186-1-git-send-email-mohammed@qca.qualcomm.com> <201112251758.41131.chunkeey@googlemail.com>
In-Reply-To: <201112251758.41131.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

thanks for your review!

On Sunday 25 December 2011 10:28 PM, Christian Lamparter wrote:
> On Sunday 25 December 2011 16:09:12 Mohammed Shafi Shajakhan wrote:
>> @@ -1385,7 +1385,9 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
>>   	struct sta_info *sta;
>>
>>   	if (ifmgd->associated) {
>> +		rcu_read_lock();
>>   		sta = sta_info_get(sdata, ifmgd->bssid);
>> +		rcu_read_unlock();
>>   		if (sta)
>>   			sta->beacon_loss_count++;
>>   	}
>
> uh, I think it should be:
>
>> +		rcu_read_lock();
>>   		sta = sta_info_get(sdata, ifmgd->bssid);
>>   		if (sta)
>>   			sta->beacon_loss_count++;
>> +		rcu_read_unlock();
>
> Since we update a member of the rcu-protected "sta"
> reference.


ok i will add this changes also in a proper patch, thank you.

>
> Regards,
> 	Chr


-- 
thanks,
shafi
