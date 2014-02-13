Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:47777 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaBMOt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:49:56 -0500
Received: by mail-bk0-f45.google.com with SMTP id mz11so2690524bkb.32
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 06:49:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8738jn9ijt.fsf@kamboji.qca.qualcomm.com>
References: <1391676841-11107-1-git-send-email-michal.kazior@tieto.com>
	<1392042915-11648-1-git-send-email-michal.kazior@tieto.com>
	<8738jn9ijt.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 13 Feb 2014 15:49:55 +0100
Message-ID: <CA+BoTQmGWuQe=zjk0eeftE0R-i=+f0ZHoGcCdebc1W69FWRNWw@mail.gmail.com> (sfid-20140213_154959_324633_58201EC8)
Subject: Re: [PATCH v2] ath10k: implement sta_rc_update()
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 February 2014 15:46, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This allows dynamic changes of bandwidth/nss/smps,
>> e.g. via ht/vht operation mode change
>> notification.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -228,6 +228,17 @@ struct ath10k_peer {
>>       struct ieee80211_key_conf *keys[WMI_MAX_KEY_INDEX + 1];
>>  };
>>
>> +struct ath10k_sta {
>> +     struct ath10k_vif *arvif;
>> +
>> +     u32 changed; /* IEEE80211_RC_* */
>> +     u32 bw;
>> +     u32 nss;
>> +     u32 smps;
>> +
>> +     struct work_struct update_wk;
>> +};
>
> Apparently this structure is protected with data_lock, but it would be
> good to document that in the code to make it clear.

Good point.



>> +             case IEEE80211_STA_RX_BW_160:
>> +                     ath10k_warn("unsupported STA BW: %d\n", sta->bandwidth);
>> +                     bw = WMI_PEER_CHWIDTH_20MHZ;
>> +                     break;
>
> I think it would be also useful to print STA's address in the warning.
>

[...]

>> +             case IEEE80211_SMPS_NUM_MODES:
>> +                     ath10k_warn("invalid smps mode: %d\n", sta->smps_mode);
>> +                     smps = WMI_PEER_SMPS_PS_NONE;
>> +                     break;
>
> Maybe here as well?

Sounds good. I'll send a v3 with all these things fixed.


Michał
