Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:56853 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2IEIde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 04:33:34 -0400
Message-ID: <50470E54.6030801@blackshift.org> (sfid-20120905_103340_418505_C798D94F)
Date: Wed, 05 Sep 2012 10:33:24 +0200
From: Marc Kleine-Budde <mkl@blackshift.org>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: fix votage setting for RT3572/RT3592
References: <1346019997-14487-1-git-send-email-mkl@blackshift.org> <CAOZOX0VBUZzGYnAM1O4Do7VyskpjXUE5ewW=qtW7JsbKJtLAMQ@mail.gmail.com>
In-Reply-To: <CAOZOX0VBUZzGYnAM1O4Do7VyskpjXUE5ewW=qtW7JsbKJtLAMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2012 10:19 AM, Ivo Van Doorn wrote:
> On Mon, Aug 27, 2012 at 12:26 AM, Marc Kleine-Budde <mkl@blackshift.org> wrote:
>> According to the vendor driver v2.6.0.1, during the rf register init the SRAM
>> voltage should be increased to 1.35V and after 1ms decreased back to 1.2V. This
>> patch adds the field setting of LDO_CFG0_LDO_CORE_VLEVEL accordingly.
>>
>> Cc: Gertjan van Wingerde <gwingerde@gmail.com>
>> Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
> 
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

Ping. Is someone taking care of this patch?

Marc

> 
>> ---
>> Hello,
>>
>> I don't have the hardware to test, just stumbled over this while hacking on the
>> rt3593.
>>
>> regards,  Marc
>>
>>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
>> index cb8c2ac..b93516d 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -4089,6 +4089,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
>>                 rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>>                 msleep(1);
>>                 rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
>> +               rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
>>                 rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
>>                 rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
>>         }
>> --
>> 1.7.10
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

