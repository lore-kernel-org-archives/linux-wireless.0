Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f200.google.com ([209.85.221.200]:37780 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0BQSeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:34:04 -0500
Received: by qyk38 with SMTP id 38so2166714qyk.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Feb 2010 10:34:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B7C35C9.30607@lwfinger.net>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
Date: Wed, 17 Feb 2010 19:34:00 +0100
Message-ID: <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: okias <d.okias@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	herton@mandriva.com.br, htl10@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did test on small C program, and "int a" is equal to int a = 0; so
it should be fine, but maybe I'm wrong.

David

2010/2/17 Larry Finger <Larry.Finger@lwfinger.net>:
> On 02/17/2010 12:15 PM, okias wrote:
>>>From 3f02b3ec0c3e6d7fa0599de12af0b76150854b94 Mon Sep 17 00:00:00 2001
>> From: David Heidelberger <d.okias@gmail.com>
>> Date: Wed, 17 Feb 2010 19:13:46 +0100
>> Subject: [PATCH] rtl8187: micro cleanup
>>
>> ---
>>  drivers/net/wireless/rtl818x/rtl8187_dev.c |    2 --
>>  1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> b/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> index 7ba3052..2fe0c84 100644
>> --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
>> @@ -1175,8 +1175,6 @@ static void rtl8187_bss_info_changed(struct
>> ieee80211_hw *dev,
>>
>>               if (priv->is_rtl8187b)
>>                       reg = RTL818X_MSR_ENEDCA;
>> -             else
>> -                     reg = 0;
>>
>>               if (is_valid_ether_addr(info->bssid)) {
>>                       reg |= RTL818X_MSR_INFRA;
>
> Did you forget the initialization to 0 when you declare the variable? It was in
> the first version. This change will cause the RTL8187L to fail.
>
> Larry
>



-- 
Jabber/XMPP: okias@isgeek.info
SIP VoIP: sip:17474537254@proxy01.sipphone.com
