Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:35781 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932434AbeE2JXm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:23:42 -0400
Subject: Re: [PATCH] mac80211_hwsim: add error check to call to
 rhashtable_init
To: Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20180529091412.8530-1-colin.king@canonical.com>
 <1527585428.6955.7.camel@sipsolutions.net>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <c42f3558-a126-5b68-8203-b937998ec8db@canonical.com> (sfid-20180529_112359_377233_238FFC11)
Date: Tue, 29 May 2018 10:23:40 +0100
MIME-Version: 1.0
In-Reply-To: <1527585428.6955.7.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/05/18 10:17, Johannes Berg wrote:
> On Tue, 2018-05-29 at 10:14 +0100, Colin King wrote:
>>
>> @@ -3573,7 +3573,9 @@ static int __init init_mac80211_hwsim(void)
>>  	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
>>  	if (!hwsim_wq)
>>  		return -ENOMEM;
>> -	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
>> +	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
>> +	if (err)
>> +		return err;
> 
> That's missing a workqueue free, but I can fix that while applying if
> you prefer.

Please do. Thanks
> 
> johannes
> 
