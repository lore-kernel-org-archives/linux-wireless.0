Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:32787 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753990Ab1AKAy1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 19:54:27 -0500
Received: by mail-fx0-f48.google.com with SMTP id 2so19353147fxm.35
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 16:54:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294674256.1992.141.camel@pimenta>
References: <1294062164-3459-1-git-send-email-shahar_levi@ti.com>
	<1294062164-3459-3-git-send-email-shahar_levi@ti.com>
	<1294674256.1992.141.camel@pimenta>
Date: Tue, 11 Jan 2011 02:54:26 +0200
Message-ID: <AANLkTimNRzc9M0wKZsQLMh4ihSHEeycFJ-S34CA=jPAc@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] wl12xx: BA receiver support
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 10, 2011 at 5:44 PM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2011-01-03 at 14:42 +0100, Shahar Levi wrote:
>> Add new ampdu_action ops to support receiver BA.
>> The BA initiator session management in FW independently.
>>
>> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
>> ---
>
> Some comments.
Thanks for your review.

>
>
>
>> diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
>> index 54fd68d..f33ab50 100644
>> --- a/drivers/net/wireless/wl12xx/acx.c
>> +++ b/drivers/net/wireless/wl12xx/acx.c
>> @@ -1359,6 +1359,42 @@ out:
>>       return ret;
>>  }
>>
>> +/* setup BA session receiver setting in the FW. */
>> +int wl1271_acx_set_ba_receiver_session(struct wl1271 *wl, u8 tid_index,
>> +                                    u16 *ssn, u8 policy)
>
> You don't modify ssn here, so why pass it as a pointer? Use u16 directly
> here instead.
>
> Actually it's even worse.  As stated in mac80211.h, ssn can be NULL
> here, so you would be accessing a NULL pointer in that case.
>
> I see that you check "policy", which indicates whether ssn is valid or
> not, but why not make it cleaner by checking if ssn is NULL and setting
> it to zero before passing instead?
good chtch. it was left from previous implantation. will be fix.

>
>
>> +       acx->enable = policy;
>
> Also, because of this, it would make more sense if policy was a boolean
> and was called "enable" instead.
np, will be fix

>
>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index c44462d..04b69ab 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -2251,6 +2251,64 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
>>       return 0;
>>  }
>>
>> +int wl1271_op_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>> +                        enum ieee80211_ampdu_mlme_action action,
>> +                        struct ieee80211_sta *sta, u16 tid, u16 *ssn)
>> +{
>> +     struct wl1271 *wl = hw->priv;
>> +     int ret;
>> +
>> +     mutex_lock(&wl->mutex);
>> +
>> +     if (unlikely(wl->state == WL1271_STATE_OFF)) {
>> +             ret = -EAGAIN;
>> +             goto out;
>> +     }
>> +
>> +     ret = wl1271_ps_elp_wakeup(wl, false);
>> +     if (ret < 0)
>> +             goto out;
>> +
>> +     switch (action) {
>> +     case IEEE80211_AMPDU_RX_START:
>> +             if ((wl->ba_allowed) && (wl->ba_support)) {
>
> I'm a bit confused.  What is ba_allowed, actually? In the previous patch
> you always call wl1271_set_ba_policies() which always sets it to true.
> So it seems quite useless.
ba_allowed belong to next path "Stop BA session event from device". i
will move it.

>
>
>> +                     ret = wl1271_acx_set_ba_receiver_session(wl, tid, ssn,
>> +                                                              true);
>> +                     if (!ret)
>> +                             wl->ba_rx_bitmap |= BIT(tid);
>> +             } else
>> +                     ret = -EPERM;
>
> The indentation is wrong here.  And -EPERM is definitely not the right
> return code for this.  It should probably -ENOTSUPP or something like
> that.
any error will be good. i go on "Operation not permitted". will be fix.

>
>> +     /*
>> +      * The BA initiator session management in FW independently.
>> +      * Falling break here on purpose for all TX APDU commands.
>> +      */
>> +     case IEEE80211_AMPDU_TX_START:
>> +     case IEEE80211_AMPDU_TX_STOP:
>> +     case IEEE80211_AMPDU_TX_OPERATIONAL:
>> +             ret = -EINVAL;
>> +             break;
>
> -EINVAL? Actually, should mac80211 even call us with these actions? I
> don't remember now, did you implement the way to prevent mac80211 from
> trying to to AMPDU_TX by itself?
the mac souldn't call those due to the fact the rate management is in the FW.

>
>
>> +
>> +     default:
>> +             wl1271_error("Incorrect ampdu action id=%x\n", action);
>> +             ret = -ENODEV;
>
> -ENODEV? All these error codes look quite random to me.  Can you explain
> your choices?
amm, i am trying to remeber why i use that one without success. i will
switch it to EINVAL.

>
>
> --
> Cheers,
> Luca.
Shahar
