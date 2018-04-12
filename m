Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:51532 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbeDLMQ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Apr 2018 08:16:59 -0400
Subject: Re: [PATCH] wcn36xx: pass correct BSS index when deleting BSS keys
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Loic Poulain <loic.poulain@linaro.org>,
        wcn36xx@lists.infradead.org, Ramon Fried <rfried@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>
References: <20180412111311.28809-1-daniel@zonque.org>
 <CAMZdPi98WH59nxV08wHcyAoDB06T3ptNT=E9C8S6RK_Yg1pKnQ@mail.gmail.com>
 <62942f8b-3e02-868f-6cb1-7423cd44b828@zonque.org>
 <877epcr58x.fsf@codeaurora.org>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <94a0d7fa-04f6-2c9a-7aa4-1d3ddc28ee8c@zonque.org> (sfid-20180412_141702_930887_C9452EC2)
Date: Thu, 12 Apr 2018 14:16:57 +0200
MIME-Version: 1.0
In-Reply-To: <877epcr58x.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, April 12, 2018 02:14 PM, Kalle Valo wrote:
> Daniel Mack <daniel@zonque.org> writes:
> 
>> On Thursday, April 12, 2018 01:46 PM, Loic Poulain wrote:
>>> Hi Daniel,
>>>
>>>> @@ -564,10 +565,13 @@ static int wcn36xx_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>>>>                 break;
>>>>         case DISABLE_KEY:
>>>>                 if (!(IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags)) {
>>>> +                       if (vif_priv->bss_index != WCN36XX_HAL_BSS_INVALID_IDX)
>>>> +                               wcn36xx_smd_remove_bsskey(wcn,
>>>> +                                       vif_priv->encrypt_type,
>>>> +                                       vif_priv->bss_index,
>>>> +                                       key_conf->keyidx);
>>>> +
>>>>                         vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE;
>>>> -                       wcn36xx_smd_remove_bsskey(wcn,
>>>> -                               vif_priv->encrypt_type,
>>>> -                               key_conf->keyidx);
>>>
>>> Note that moving vif_priv->encrypt_type = WCN36XX_HAL_ED_NONE after
>>> key removal also fixes an issue I observed in AP mode:
>>> wcn36xx: ERROR hal_remove_bsskey response failed err=6
>>
>> Yeah, sorry. I did that intentionally, but missed to mention it in the
>> commit log.
> 
> I can add that to the commit log, just tell me what to add.

I'll resend, hang on :)

Daniel
