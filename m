Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56328 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab1JEWXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:23:39 -0400
Received: by qadb15 with SMTP id b15so1626512qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:23:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8ADBE0.6050406@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <1317637758-11907-6-git-send-email-zefir.kurtisi@neratec.com>
 <CAB=NE6VO4W=ZJcgb3G5Gh=YM-jdkJ3ey5Ppka2Rn0XGmpx8=Gg@mail.gmail.com> <4E8ADBE0.6050406@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 5 Oct 2011 15:23:19 -0700
Message-ID: <CAB=NE6W47W8WAJmRaPO3jMfTOOxs+muZXzrnDCRuUBSpbw40bA@mail.gmail.com> (sfid-20111006_002345_830960_069FCBDA)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 3:11 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> On 10/03/2011 08:27 PM, Luis R. Rodriguez wrote:
>> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>>
>>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>>> ---
>>>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
>>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>> index e8aeb98..5defebe 100644
>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>> @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>>>                        "Unable to reset channel, reset status %d\n", r);
>>>                goto out;
>>>        }
>>> +#ifdef CONFIG_ATH9K_DFS
>>> +       /**
>>> +        * enable radar pulse detection
>>> +        *
>>> +        * TODO: do this only for DFS channels
>>> +        */
>>> +       ah->private_ops.set_radar_params(ah, &ah->radar_conf);
>>> +       ath9k_hw_setrxfilter(ah,
>>> +                       ath9k_hw_getrxfilter(ah) | ATH9K_RX_FILTER_PHYRADAR);
>>> +       ath_dbg(common, ATH_DBG_DFS,
>>> +               "DFS enabled for channel %d\n", hchan->chan->center_freq);
>>> +#endif
>>
>> Please spare the #ifdef and just call something within dfs.c, then
>> dfs.h would wrap it to nothing if DFS is disabled.
>>
> This possibly won't work, since setting up DFS registers is part of HW layer and not
> done in the dfs module. If you want to have DFS conditionally compilable, you can not spare this #ifdefs.

Its not about sparing the ifdefs completely but instead to place them
strategically to remove #ifdef sprinkling all over C code. You can
leave ifdefs on header files, and for C files leaves this as a
conditional build time option.

  Luis
