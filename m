Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51962 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955AbcAKMoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 07:44:44 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jia-Ju Bai <baijiaju1990@163.com>, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com, ilw@linux.intel.com,
	linuxwifi@intel.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] iwl4965: Fix a memory leak in error handling code of __il4965_up
References: <1452392363-3600-1-git-send-email-baijiaju1990@163.com>
	<20160111121610.GF25015@redhat.com>
Date: Mon, 11 Jan 2016 14:44:31 +0200
In-Reply-To: <20160111121610.GF25015@redhat.com> (Stanislaw Gruszka's message
	of "Mon, 11 Jan 2016 13:16:10 +0100")
Message-ID: <878u3wi8uo.fsf@kamboji.qca.qualcomm.com> (sfid-20160111_134452_516038_CF914B97)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Sun, Jan 10, 2016 at 10:19:23AM +0800, Jia-Ju Bai wrote:
>> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
>> index 6656215..fd7b5c7 100644
>> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
>> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
>> @@ -5577,6 +5577,7 @@ __il4965_up(struct il_priv *il)
>>  	ret = il4965_hw_nic_init(il);
>>  	if (ret) {
>>  		IL_ERR("Unable to init nic\n");
>> +		il_dealloc_bcast_stations(il);
>>  		return ret;
>>  	}
>
> Please do not repost patches so frequent and if you repost
> the unchanged patch mark it so i.e. [PATCH repost].

"repost" just confuses me and creates more work for me. Better to ping
on the original patch and even better is to check patchwork which shows
up-to-date status of wireless patches:

https://patchwork.kernel.org/project/linux-wireless/list/

-- 
Kalle Valo
