Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:32876 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2DDSZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 14:25:59 -0400
Message-ID: <4F7C922F.7060201@candelatech.com> (sfid-20120404_202602_478696_D7EC0C74)
Date: Wed, 04 Apr 2012 11:25:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k:  Gather and report IRQ sync_cause errors.
References: <1333513250-30478-1-git-send-email-greearb@candelatech.com> <1333556182.16978.9.camel@joe2Laptop>
In-Reply-To: <1333556182.16978.9.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/2012 09:16 AM, Joe Perches wrote:
> On Tue, 2012-04-03 at 21:20 -0700, greearb@candelatech.com wrote:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> Report all defined sync_cause errors in debugfs
>> to aid with debugging.
>
> just trivia:
>
>> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> []
>> @@ -385,63 +385,130 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
>>   				   size_t count, loff_t *ppos)
>>   {
>>   	struct ath_softc *sc = file->private_data;
> []
>>   	if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_EDMA) {
> []
>> +		len += snprintf(buf + len, mxlen - len,
>> +			"%21s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
>
> Alignment is overrated.
>
> I wouldn't change any of the original block
> though perhaps changing the sc pointer to an
> istats pointer so these dereferences become
> similar to istats->rxlp;

Other files in this driver are aligned, so it seems
nice to continue the tradition.  debugfs files are
for human consumption, so making them readable is
a virtue.

If someone wants more efficient access to this data,
then we can use ethtool stats (I'll add ethtool stats
support for these counters if/when my first ethtool
patches make it in...)

>> +void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause)
>> +{
>> +	struct ath_softc *sc = common->priv;
>> +	if (sync_cause)
>> +		sc->debug.stats.istats.sync_cause_all++;
>> +	if (sync_cause&  AR_INTR_SYNC_RTC_IRQ)
>> +		sc->debug.stats.istats.sync_rtc_irq++;
>
> And nicer here to use a pointer to istats too.

Hopefully the compiler is smart enough that this
doesn't really matter.

If the maintainers care, I'll respin the patch, but
otherwise I'm not sure it's worth the effort.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

