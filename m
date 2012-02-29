Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:52325 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab2B2Irm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 03:47:42 -0500
Message-ID: <20120229104740.192217ubu30pw7c0@www.81.fi> (sfid-20120229_094746_364305_3610929A)
Date: Wed, 29 Feb 2012 10:47:40 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	linux-wireless@vger.kernel.org
Subject: re: rndis_wlan: split getting current channel to separate function
References: <20120229063234.GB18031@elgon.mountain>
 <20120229100932.97454g5f6tjgmx44@www.81.fi>
In-Reply-To: <20120229100932.97454g5f6tjgmx44@www.81.fi>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Jussi Kivilinna <jussi.kivilinna@mbnet.fi>:

> Quoting Dan Carpenter <dan.carpenter@oracle.com>:
>
>> Hello Jussi,
>>
>> The patch b5257c952: "rndis_wlan: workaround device not returning bss
>> for currently connected AP" from Nov 9, 2011, leads to the following
>> warning:
>> drivers/net/wireless/rndis_wlan.c:1374:36: warning: cast to  
>> restricted __le16
>> drivers/net/wireless/rndis_wlan.c:1374:36: warning: cast from  
>> restricted __le32
>>
>>  1372
>>  1373          if (beacon_interval)
>>  1374                  *beacon_interval = le16_to_cpu(config.beacon_period);
>>  1375          return channel;
>>
>> The problem is that config.beacon_period is declared as le32 but we're
>> using it as le16.
>
> Ah yes, I'll post patch soon. Thanks.

Well.. I ran into interesting problem where driver stops working if I  
correct le16_to_cpu to le32_to_cpu. But if I instead pass  
beacon_interval=0 to cfg80211, driver start working again. So this is  
bug fixing another problem, I'll check it more throughtly when I have  
more time.

-Jussi

>
> -Jussi
>
>>
>> regards,
>> dan carpenter
>>
>>
>>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>



