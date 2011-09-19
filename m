Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48491 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ISVOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:14:53 -0400
Received: by qyk30 with SMTP id 30so3191905qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 14:14:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E77AAFB.1080805@openwrt.org>
References: <1316453903-75710-1-git-send-email-nbd@openwrt.org>
 <1316453903-75710-2-git-send-email-nbd@openwrt.org> <CAB=NE6XvanRQ6Yje_qHhkfzbLmZn9o5Q+5y1NobJwCyuMLFEvg@mail.gmail.com>
 <4E77AAFB.1080805@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Mon, 19 Sep 2011 14:14:31 -0700
Message-ID: <CAB=NE6XgSz7zz_ZXaPQEsaue307ipd7Qnzgi5QWr8Y4SS1j=Lg@mail.gmail.com> (sfid-20110919_231456_901493_5A291192)
Subject: Re: [PATCH v2 2/4] ath9k_hw: clean up tx power handling
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 1:50 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-09-19 10:41 PM, Luis R. Rodriguez wrote:
>>
>> On Mon, Sep 19, 2011 at 10:38 AM, Felix Fietkau<nbd@openwrt.org>  wrote:
>>>
>>>  @@ -986,21 +995,15 @@ static void
>>> ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
>>>                                                   struct ath9k_channel
>>> *chan,
>>>                                                   int16_t *ratesArray,
>>>                                                   u16 cfgCtl,
>>>  -                                                 u16 AntennaReduction,
>>>  -                                                 u16
>>> twiceMaxRegulatoryPower,
>>>  +                                                 u16 antenna_reduction,
>>>                                                   u16 powerLimit)
>>>   {
>>>   #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
>>>   #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   9 /* 10*log10(3)*2 */
>>>
>>>  -       struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
>>>         struct ar5416_eeprom_def *pEepData =&ah->eeprom.def;
>>>         u16 twiceMaxEdgePower = MAX_RATE_POWER;
>>>  -       static const u16 tpScaleReductionTable[5] =
>>>  -               { 0, 3, 6, 9, MAX_RATE_POWER };
>>>  -
>>>         int i;
>>>  -       int16_t twiceLargestAntenna;
>>>         struct cal_ctl_data *rep;
>>>         struct cal_target_power_leg targetPowerOfdm, targetPowerCck = {
>>>                 0, { 0, 0, 0, 0}
>>>  @@ -1012,7 +1015,7 @@ static void
>>> ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
>>>         struct cal_target_power_ht targetPowerHt20, targetPowerHt40 = {
>>>                 0, {0, 0, 0, 0}
>>>         };
>>>  -       u16 scaledPower = 0, minCtlPower, maxRegAllowedPower;
>>>  +       u16 scaledPower = 0, minCtlPower;
>>>         static const u16 ctlModesFor11a[] = {
>>>                 CTL_11A, CTL_5GHT20, CTL_11A_EXT, CTL_5GHT40
>>>         };
>>
>> Although we do not use the reg->tp_scale I see no log which explains
>> that it will not, I'm reviewing TPC right now and we do need to
>> support it but its unclear to me yet if we are doing everything
>> correctly in mac80211 / cfg80211 for it. As far as I can see the
>> tp_scale stuff is used only if the default is not set, but as you
>> noted its always set to the default. I am trying to review the
>> internal code to see under what cases this changes but its hard to
>> review. Although I'd like to see this removed I'd prefer to treat this
>> separately from the cleanup you are doing, which I do find highly
>> valuable.
>
> Why keep it? All it does is subtract something from the max regulatory power
> level, so it does not make any sense to keep this crap duplicated in all the
> the eeprom files.

You're right that they do seem to use the same array values, but the
fact that its all common code is separate from the question of
removing it.

> If we ever do need it (which I doubt),

I suspect this is needed for APs that support DFS and since we do not
yet support DFS I do not think this is used. I am not 100% certain yet
but at least in my review in the last few minutes it seems the AP can
decide to change TPC constraints dynamically based on TPC reports from
the STAs. I suspec this is where this comes in to play.

> it needs to be added in a different place anyway.

If its card specific so I do not think we can move any of this
commonly into cfg80211 / mac80211.

One thing is to simply common code, another is to remove code which we
is not enabled right now, but may be later. I think we should treat
these separately.

  Luis
