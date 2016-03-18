Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:34716 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbcCRLMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 07:12:54 -0400
Received: by mail-ob0-f180.google.com with SMTP id ts10so112276275obc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2016 04:12:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318104846.GD24990@redhat.com>
References: <cover.1458262312.git.julian.calaby@gmail.com> <3aaac3629455d27b0e9c56ef1615b89873b1b8cf.1458262312.git.julian.calaby@gmail.com>
 <20160318104846.GD24990@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 Mar 2016 22:12:34 +1100
Message-ID: <CAGRGNgVh+-UOMVmo98HMashUi3CejdXTx4S=sTxq8VcNNrWeag@mail.gmail.com> (sfid-20160318_121258_490800_5666B10B)
Subject: Re: [PATCH MOREWORK 17/19] iwl4965: Fix a memory leak in error
 handling code of __il4965_up
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, Mar 18, 2016 at 9:48 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Mar 18, 2016 at 01:28:33PM +1100, Julian Calaby wrote:
>> From: Jia-Ju Bai <baijiaju1990@163.com>
>>
>> When il4965_hw_nic_init in __il4965_up fails, the memory allocated by
>> iwl4965_sta_alloc_lq in iwl4965_alloc_bcast_station is not freed.
>>
>> This patches adds il_dealloc_bcast_stations in the error handling code of
>> __il4965_up to fix this problem.
>>
>> This patch has been tested in real device, and it actually fixes the bug.
>
> Could the call trace from the bug be provided ?
>
>> Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
>> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
>> ---
>>  drivers/net/wireless/intel/iwlegacy/4965-mac.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
>> index b75f4ef..30d9dd3 100644
>> --- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
>> +++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
>> @@ -5577,6 +5577,7 @@ __il4965_up(struct il_priv *il)
>>       ret = il4965_hw_nic_init(il);
>>       if (ret) {
>>               IL_ERR("Unable to init nic\n");
>> +             il_dealloc_bcast_stations(il);
>
> I missed that before, but now this look suspicious for me.
>
> il_dealloc_bcast_stations() do:
>
>                 il->num_stations--;
>                 BUG_ON(il->num_stations < 0);
>
> But on il4965_alloc_bcast_station() we do not increase il->num_stations
> Hence either this BUG_ON should be removed or il->num_stations should be
> increased during allocation.

I don't think you're right. Looking closely at the code,
il->num_stations gets incremented in il_prep_station() which is called
unconditionally from il4965_alloc_bcast_station().

So I think this and the following patch are fine.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
