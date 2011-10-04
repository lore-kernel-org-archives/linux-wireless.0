Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38672 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666Ab1JDJzQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 05:55:16 -0400
Message-ID: <4E8AD800.9040208@neratec.com> (sfid-20111004_115520_273568_3CE3B1B5)
Date: Tue, 04 Oct 2011 11:55:12 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC 4/6] ath9k: add DFS build parameter
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <1317637758-11907-5-git-send-email-zefir.kurtisi@neratec.com> <CAB=NE6XxW_kMnWLkC4dy4naUKaTk_hZi0_F86LNyuk3RNyqNQA@mail.gmail.com>
In-Reply-To: <CAB=NE6XxW_kMnWLkC4dy4naUKaTk_hZi0_F86LNyuk3RNyqNQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 08:26 PM, Luis R. Rodriguez wrote:
> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>
>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/Kconfig  |    7 +++++++
>>  drivers/net/wireless/ath/ath9k/Makefile |    2 ++
>>  2 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
>> index d9c08c6..adddcca 100644
>> --- a/drivers/net/wireless/ath/ath9k/Kconfig
>> +++ b/drivers/net/wireless/ath/ath9k/Kconfig
>> @@ -58,6 +58,13 @@ config ATH9K_RATE_CONTROL
>>          Say Y, if you want to use the ath9k specific rate control
>>          module instead of minstrel_ht.
>>
>> +config ATH9K_DFS
>> +       bool "Atheros ath9k DFS support"
>> +       depends on ATH9K
>> +       default y
> 
> At this point selecting y does nothing. Leave this patch out until
> selecting "y" means something.
> 
What do you mean by 'nothing'? It allows you to select DFS as ath9k feature in your kernel configuration, or? Though, I agree that enabling it by default is not a good idea.

> Default should be n, and in particular Atheros itself can only likely
> commit to supporting DFS for AR9003 when it finds resources to do so
> as well as properly test it, so DFS support kconfig should state this.
> If someone wants to step up to completely support all bugs for older
> families that is their prerogative but we cannot commit to it, due to
> the regulatory considerations though unless this happens this cannot
> and should not be enabled for older families in code.
> 
In fact, AR9003 is the platform we are interested in. Although it seems that older chipsets do also detect pulses with this patches (AR9280 does, IIRC), I agree to limit DFS support to AR9003 (and later). This should be easily possible by setting priv_ops->set_radar_params for AR9003 only. I'll remove it for AR5008 in my v2 RFC.

>   Luis

Thanks,
Zefir
