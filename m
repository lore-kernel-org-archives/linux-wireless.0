Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:53061 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab1JDKLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 06:11:48 -0400
Message-ID: <4E8ADBE0.6050406@neratec.com> (sfid-20111004_121152_805213_3F665290)
Date: Tue, 04 Oct 2011 12:11:44 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <1317637758-11907-6-git-send-email-zefir.kurtisi@neratec.com> <CAB=NE6VO4W=ZJcgb3G5Gh=YM-jdkJ3ey5Ppka2Rn0XGmpx8=Gg@mail.gmail.com>
In-Reply-To: <CAB=NE6VO4W=ZJcgb3G5Gh=YM-jdkJ3ey5Ppka2Rn0XGmpx8=Gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/03/2011 08:27 PM, Luis R. Rodriguez wrote:
> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>
>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index e8aeb98..5defebe 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>>                        "Unable to reset channel, reset status %d\n", r);
>>                goto out;
>>        }
>> +#ifdef CONFIG_ATH9K_DFS
>> +       /**
>> +        * enable radar pulse detection
>> +        *
>> +        * TODO: do this only for DFS channels
>> +        */
>> +       ah->private_ops.set_radar_params(ah, &ah->radar_conf);
>> +       ath9k_hw_setrxfilter(ah,
>> +                       ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
>> +       ath_dbg(common, ATH_DBG_DFS,
>> +               "DFS enabled for channel %d\n", hchan->chan->center_freq);
>> +#endif
> 
> Please spare the #ifdef and just call something within dfs.c, then
> dfs.h would wrap it to nothing if DFS is disabled.
> 
This possibly won't work, since setting up DFS registers is part of HW layer and not done in the dfs module. If you want to have DFS conditionally compilable, you can not spare this #ifdefs.

But I see that this would work in patch 6/6 when calling ath9k_dfs_process_phyerr() on ATH9K_PHYERR_RADAR. Will be considered.

>   Luis

Thanks,
Zefir
