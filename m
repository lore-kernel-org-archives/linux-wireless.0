Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:43815 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986Ab1KPOur (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 09:50:47 -0500
Message-ID: <4EC3CDC3.3050907@neratec.com> (sfid-20111116_155050_777558_83FE3B26)
Date: Wed, 16 Nov 2011 15:50:43 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, shafi.wireless@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 2/2] ath9k: integrate initial DFS module
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com> <1320770044-12271-3-git-send-email-zefir.kurtisi@neratec.com> <CAB=NE6UKgk0jdWq8fNsdaqvYZK2qvxw=nK=fUevOSxqH4pLFzw@mail.gmail.com>
In-Reply-To: <CAB=NE6UKgk0jdWq8fNsdaqvYZK2qvxw=nK=fUevOSxqH4pLFzw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

thanks for the feedback.

This series went through several RFCs before I posted it as patch. Now that there are still some general concerns open, would you prefer to go back to RFC or are you ok with PATCH_v2?


On 11/15/2011 05:45 PM, Luis R. Rodriguez wrote:
> On Tue, Nov 8, 2011 at 8:34 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> This patch integrates the DFS module into ath9k, including
>>  * build the module into ath9k_hw
>>  [...]
>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
>> index 7ab7a1e..de0309e 100644
>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> @@ -563,6 +563,7 @@ struct ath_ant_comb {
>>  #define SC_OP_BT_SCAN               BIT(13)
>>  #define SC_OP_ANI_RUN               BIT(14)
>>  #define SC_OP_PRIM_STA_VIF          BIT(15)
>> +#define SC_OP_DFS                   BIT(16)
> 
> The way you use this is to set the bit when a DFS channel is found on
> the mac80211 config() callback so that upon ath_complete_reset() we
> call ath9k_hw_set_radar_params() with the params captured in
> ath_calcrxfilter(). This seems fair... but have you considered all the
> other cases that will call ath_complete_reset() that do come through
> the mac80211 config() callback? What got me thinking about this was
> the actual declaration of this bit, is it really necessary? It seems
> to reflect a state from a small state machine that you need to ensure
> is respected. If this is true you just need then to guarantee that
> that the ath9k_hw_set_radar_params() will get called properly for all
> the cases that you do need. Its not clear from the current
> implementation that this is the case right now, it seems a bit
> fragile. Consider all the idle() and non-idle() calls that mac80211
> could use to call on the driver. Granted, the idle stuff is mostly
> observed on the client side, but its just one case I am thinking off
> the top of my head based on a quick review of this patch.
> 
We need to ensure two things to get the pulse reporting done:
1. write the configuration params to the DFS detector regs via ath9k_hw_set_radar_params() after chip reset
2. set the PHYRADAR bit in RX filter, i.e. let ath_calcrxfilter() add this bit in its mask returned to be correctly set with the following ath9k_hw_setrxfilter()

In my RFC_v2 I proposed to set the radar parameters when the device is set to a DFS channel and to preserve the PHYRADAR bit in the RX filter register. Felix pointed out that we can not rely on the register value being always valid (e.g. during reset) and we need to keep the information about DFS channel operation in higher layers.

Defining a DFS opmode flag for that is arguable (since we have the information from (curchan->flags & IEEE80211_CHAN_RADAR)), but for sure improves readability.

As for your concern about ath_complete_reset() being called from wherever: right now, it is called from three locations that end to be all in the processing path of either device initialization or configuration. From there, worst thing that can happen is that the device is reconfigured with the channel unchanged - resulting in a redundant write of radar configuration. I expect writing those handful registers twice being irrelevant to performance, or did you mean something else?

>>  [...]
>> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> index 76dbc85..c9ba80d 100644
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -2333,6 +2333,13 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
>>                pCap->pcie_lcr_offset = 0x80;
>>        }
>>
>> +       if (AR_SREV_9280_20_OR_LATER(ah)) {
>> +               /*
>> +                * TODO: check for which chip-sets we want to support DFS
>> +                */
>> +               pCap->hw_caps |= ATH9K_HW_CAP_DFS;
>> +       }
>> +
> 
> Please change to AR_SREV_9300_20_OR_LATER(), its the only family that
> we can likely get resources to support, validate and test for. I'm
> even having a hard time getting support, etc for AR9003 but I think
> its fair to at least get this chugging for AR9003. If someone wants to
> pick up support, validation and testing for AR9002 then great, but
> this is not trivial to commit to. I rather deal only with what we can
> get commitment to properly test and validate.
> 
> In fact I will need to verify our test plan for this. I'll start on
> that while you review my comments.
> 
Thanks for that. I remember Felix was asking to include support for AR9002 and after I tested pulse detection is working with 9280 I let it in. But sure, seeing it working somewhat and committing to support it in the long run are not the same.

I'm fine with reducing support to 9300_20_OR_LATER in v2.

>> [...]
>> @@ -1722,9 +1726,21 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
>>                        memset(&sc->survey[pos], 0, sizeof(struct survey_info));
>>                }
>>
>> +               if (curchan->flags & IEEE80211_CHAN_RADAR) {
>> +                       if (!(ah->caps.hw_caps & ATH9K_HW_CAP_DFS)) {
>> +                               ath_err(common, "HW does not support DFS\n");
>> +                               mutex_unlock(&sc->mutex);
>> +                               return -EINVAL;
> 
> Seems like a wrong place for this, shouldn't cfg80211 deal with this
> check for us? That is, export a cfg80211 DFS capability and cfg80211
> would deny using any DFS channel unless the wiphy declares itself
> capable.
> 
Thats ideally true. Problem is that the DFS managing component (which capability handling is part of) is not ready yet (big hello to TI guys) and I don't want to mess around with some half-baked capability handling in cfg/mac80211.

For now, lack of master support for DFS channels in mac80211/hostapd ensures that we are regulatory compliant here, since DFS channels will only be set in monitor mode.

I'd opt to take it as it is, maybe replace the above check with a WARN_ON until capability handling at upper layer is fully tested. Agree?

>> [...]
>> @@ -1855,11 +1858,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>                if (sc->sc_flags & SC_OP_RXFLUSH)
>>                        goto requeue_drop_frag;
>>
>> -               retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
>> -                                                rxs, &decrypt_error);
>> -               if (retval)
>> -                       goto requeue_drop_frag;
>> -
>>                rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
>>                if (rs.rs_tstamp > tsf_lower &&
>>                    unlikely(rs.rs_tstamp - tsf_lower > 0x10000000))
>> @@ -1869,6 +1867,17 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>                    unlikely(tsf_lower - rs.rs_tstamp > 0x10000000))
>>                        rxs->mactime += 0x100000000ULL;
>>
>> +               if ((rs.rs_status & ATH9K_RXERR_PHY) &&
>> +                   (rs.rs_phyerr == ATH9K_PHYERR_RADAR)) {
>> +                       /* DFS: check for radar pulse */
>> +                       ath9k_dfs_process_phyerr(sc, hdr, &rs, rxs->mactime);
>> +               }
>> +
>> +               retval = ath9k_rx_skb_preprocess(common, hw, hdr, &rs,
>> +                                                rxs, &decrypt_error);
>> +               if (retval)
>> +                       goto requeue_drop_frag;
>> +
> 
> As noted in the other e-mail please split the move of the check to
> another patch, the new code can be kept here.

Done: [PATCH] ath9k: trivial: reorder rx_tasklet processing

> 
>   Luis

Thanks,
Zefir
