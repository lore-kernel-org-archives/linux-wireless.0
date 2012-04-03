Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51361 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab2DCVRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 17:17:35 -0400
Message-ID: <4F7B68EA.4060905@candelatech.com> (sfid-20120403_231738_852781_6457CCCA)
Date: Tue, 03 Apr 2012 14:17:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Gather and report bus-timeout errors.
References: <1333484545-14273-1-git-send-email-greearb@candelatech.com> <1333486979.2695.8.camel@joe2Laptop>
In-Reply-To: <1333486979.2695.8.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2012 02:02 PM, Joe Perches wrote:
> On Tue, 2012-04-03 at 13:22 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Seems like a useful stat to report (when debugfs
>> is enabled).
> []
>> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> []
>> @@ -385,57 +385,61 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
>>   				   size_t count, loff_t *ppos)
>>   {
>>   	struct ath_softc *sc = file->private_data;
>> -	char buf[512];
>> +	char buf[800];
>
> 800 seems excessive.
> Maybe it's better to kmalloc this.

Ok.

>>   	unsigned int len = 0;
>>
>>   	if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_EDMA) {
>>   		len += snprintf(buf + len, sizeof(buf) - len,
>> -			"%8s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
>> +			"%11s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
>
> why change the size from 8 to 11?

To make the columns line up properly.

>> +#define ATH_INCR_IRQ_STAT_COMMON(c, s)					\
>> +	do {								\
>> +		struct ath_softc *sc = (struct ath_softc *) (c)->priv;	\
>
> Isn't priv void *?
> I think you don't need the cast.

Dunno..just copied existing code.  I'll see if it compiles w/out
the explicit cast.

>
>> +		sc->debug.stats.istats.s++;				\
>> +	} while (0);
>
> sb: "while (0)" without the ;

Ok.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
