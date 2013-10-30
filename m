Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:36431 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3J3Hkj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 03:40:39 -0400
Received: by mail-bk0-f52.google.com with SMTP id u13so297599bkz.25
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 00:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFSJ42ZWiH0K7JKxBUHA8dqBLT++=Zu-mvyoF=egk4kP1+Detw@mail.gmail.com>
References: <CAPgLHd9HRb_o+hac5_RjKhK1K-jJFtQmrv9P2iy7zegQv=WOcw@mail.gmail.com>
	<CAFSJ42ZWiH0K7JKxBUHA8dqBLT++=Zu-mvyoF=egk4kP1+Detw@mail.gmail.com>
Date: Wed, 30 Oct 2013 15:40:36 +0800
Message-ID: <CAPgLHd-wL-uKe2WGUHwa8dhMLAuUuhYjqRSyerzSg-Jq_y6+UA@mail.gmail.com> (sfid-20131030_084041_810581_ED3C2243)
Subject: Re: [PATCH -next] wcn36xx: fix missing unlock on error in wcn36xx_smd_update_proberesp_tmpl()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: k.eugene.e@gmail.com
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/30/2013 03:12 PM, Eugene Krasnikov wrote:
> Looks good to me! I assume this patch is the result of running smatch?
> I made the same patch, just did not have time to send it out.

Hi, 

I used coccinelle with script to found this. ^_^

>
> On Wed, Oct 30, 2013 at 5:30 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Add the missing unlock before return from function
>> wcn36xx_smd_update_proberesp_tmpl() in the error
>> handling case.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  drivers/net/wireless/ath/wcn36xx/smd.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
>> index f8c3a10..04df70b 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
>> @@ -1327,7 +1327,8 @@ int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
>>         if (skb->len > BEACON_TEMPLATE_SIZE) {
>>                 wcn36xx_warn("probe response template is too big: %d\n",
>>                              skb->len);
>> -               return -E2BIG;
>> +               ret = -E2BIG;
>> +               goto out;
>>         }
>>
>>         msg.probe_resp_template_len = skb->len;
>>
>
>


