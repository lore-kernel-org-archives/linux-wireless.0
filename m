Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f176.google.com ([209.85.213.176]:37963 "EHLO
        mail-yb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdLKIjw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 03:39:52 -0500
Received: by mail-yb0-f176.google.com with SMTP id h28so168094ybj.5
        for <linux-wireless@vger.kernel.org>; Mon, 11 Dec 2017 00:39:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171209004534.GB3441@builder>
References: <1512750846-13591-1-git-send-email-loic.poulain@linaro.org> <20171209004534.GB3441@builder>
From: Loic Poulain <loic.poulain@linaro.org>
Date: Mon, 11 Dec 2017 09:39:11 +0100
Message-ID: <CAMZdPi-eUquLkhSBLjMhn2RAX-eJ4cf5PviS85nKAL0y81MQiw@mail.gmail.com> (sfid-20171211_093956_904041_E603A682)
Subject: Re: [PATCH] wcn36xx: Fix dynamic power saving
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Nicolas Dechesne <nicolas.dechesne@linaro.org>,
        Eugene Krasnikov <k.eugene.e@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bjorn,

On 9 December 2017 at 01:45, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
>>               }
>>       }
>>
>> +     if (changed & IEEE80211_CONF_CHANGE_PS) {
>> +             list_for_each_entry(tmp, &wcn->vif_list, list) {
>> +                     vif = wcn36xx_priv_to_vif(tmp);
>> +                     if (hw->conf.flags & IEEE80211_CONF_PS) {
>> +                             if (vif->bss_conf.ps) /* ps allowed ? */
>> +                                     wcn36xx_pmc_enter_bmps_state(wcn, vif);
>> +                     } else {
>> +                             wcn36xx_pmc_exit_bmps_state(wcn, vif);
>
> During startup I get the error print from wcn36xx_pmc_exit_bmps_state()
> that we're not in BMPS state. There's no harm in this, but the error
> might concern people.
>
> How about we in addition to this, change the wcn36xx_err() to a
> wcn36xx_dbg(PMC...) ?

Thanks for reporting this, I assume mac80211 disable PS mode before enabling it
on timeout... It makes sense to avoid this error msg since balancing
is well managed
by this driver.

Regards,
Loic
