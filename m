Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:32906 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933574AbdEKTHN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 15:07:13 -0400
Received: by mail-oi0-f45.google.com with SMTP id w10so41838078oif.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 12:07:13 -0700 (PDT)
Subject: Re: [PATCH v2 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if
 status changes or auto adjust is set
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170505161712.8685-1-Larry.Finger@lwfinger.net>
 <20170505161712.8685-7-Larry.Finger@lwfinger.net>
 <8760h7vcbm.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <d4b1749f-aa16-3bc0-7169-12e457c8453b@lwfinger.net> (sfid-20170511_210716_587194_6196E433)
Date: Thu, 11 May 2017 14:07:11 -0500
MIME-Version: 1.0
In-Reply-To: <8760h7vcbm.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2017 06:54 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>
>> The driver will periodically ask the coex, and the coex only runs the
>> mechanism when the status was changed or the auto adjust is set.
>>
>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Pkshih <pkshih@realtek.com>
>> Cc: Birming Chiu <birming@realtek.com>
>> Cc: Shaofu <shaofu@realtek.com>
>> Cc: Steven Ting <steventing@realtek.com>
>
> [...]
>
>> +#ifdef BT_AUTO_REPORT_ONLY_8821A_2ANT
>>  	btc8821a2ant_query_bt_info(btcoexist);
>> +#else
>>  	btc8821a2ant_monitor_bt_ctr(btcoexist);
>>  	btc8821a2ant_monitor_wifi_ctr(btcoexist);
>> +
>> +	if (btc8821a2ant_is_wifi_status_changed(btcoexist) ||
>> +	    coex_dm->auto_tdma_adjust)
>> +		btc8821a2ant_run_coexist_mechanism(btcoexist);
>> +#endif
>
> Isn't this adding dead code again?

Yes it is. V3 just submitted. The typos in patch 8 have also been fixed.

Thanks,

Larry
