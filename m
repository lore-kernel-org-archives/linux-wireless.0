Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:45655 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaIWOWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 10:22:00 -0400
Message-ID: <54218207.6050907@candelatech.com> (sfid-20140923_162204_346429_4B9BA0E0)
Date: Tue, 23 Sep 2014 07:21:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 1/3] ath10k:  use 64-bit vdev map.
References: <1411149890-12618-1-git-send-email-greearb@candelatech.com> <878ulaebug.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878ulaebug.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/23/2014 05:54 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This can allow more than 32 stations to be supported
>> without over-running the bitmap.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> [...]
>
>> -	ar->monitor_vdev_id = bit - 1;
>> +	ar->monitor_vdev_id = bit;
>
> [...]
>
>> -	arvif->vdev_id = bit - 1;
>> +	ath10k_warn(ar, "Creating vdev id: %i  map: %llu\n",
>> +		    bit, ar->free_vdev_map);
>> +
>> +	arvif->vdev_id = bit;
>
> Why remove the "- 1"? Are you sure that's not going to break any
> assumptions somewhere?

I have been testing this patch in one form or another for almost a year
and have not noticed any problems with it.

The return value is subtly different when using the 64-bit version,
so you don't need the -1.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
