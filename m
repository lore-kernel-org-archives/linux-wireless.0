Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48575 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643Ab2LEIIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 03:08:11 -0500
Received: by mail-qc0-f174.google.com with SMTP id o22so2569147qcr.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Dec 2012 00:08:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA++WF2Okd8vD7r5ydMsPprWOwmvjKh+W-=cT7_dYiAf1r5k3iQ@mail.gmail.com>
References: <CAPgLHd-k+RY5m804tBg4uzbWsUhS16coW9cQ62R7mPCjKjGffg@mail.gmail.com>
	<CA++WF2Okd8vD7r5ydMsPprWOwmvjKh+W-=cT7_dYiAf1r5k3iQ@mail.gmail.com>
Date: Wed, 5 Dec 2012 03:08:10 -0500
Message-ID: <CAPgLHd8Ps9nDTfQShSTgi4n7iCBEH17uH4yqxQtgA=MmG72-FA@mail.gmail.com> (sfid-20121205_090814_885340_C7B0448C)
Subject: Re: [PATCH -next] ipw2200: return error code on error in ipw_wx_get_auth()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: stas.yakovlev@gmail.com
Cc: linville@tuxdriver.com, yongjun_wei@trendmicro.com.cn,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2012 02:55 PM, Stanislav Yakovlev wrote:
> Hello, Wei,
>
> On 3 December 2012 22:03, Wei Yongjun <weiyj.lk@gmail.com> wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> We have assinged error code to 'ret' when get auth from some
>> option is not supported but never used it, but we'd better return
>> the error code.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>> ---
>>  drivers/net/wireless/ipw2x00/ipw2200.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
>> index 482f505..1ad72d5 100644
>> --- a/drivers/net/wireless/ipw2x00/ipw2200.c
>> +++ b/drivers/net/wireless/ipw2x00/ipw2200.c
>> @@ -6812,7 +6812,6 @@ static int ipw_wx_get_auth(struct net_device *dev,
>>         struct libipw_device *ieee = priv->ieee;
>>         struct lib80211_crypt_data *crypt;
>>         struct iw_param *param = &wrqu->param;
>> -       int ret = 0;
>>
>>         switch (param->flags & IW_AUTH_INDEX) {
>>         case IW_AUTH_WPA_VERSION:
>> @@ -6822,7 +6821,7 @@ static int ipw_wx_get_auth(struct net_device *dev,
>>                 /*
>>                  * wpa_supplicant will control these internally
>>                  */
>> -               ret = -EOPNOTSUPP;
>> +               return -EOPNOTSUPP;
>>                 break;
> Could you remove this break as well?

My mistake, I will send a update patch soon.

Regards,
Yongjun Wei

