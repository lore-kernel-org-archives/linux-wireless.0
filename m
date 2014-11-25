Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40412 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaKYJWG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 04:22:06 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so693461wiw.15
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 01:22:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87egsr1wj7.fsf@kamboji.qca.qualcomm.com>
References: <1416839648-31803-1-git-send-email-michal.kazior@tieto.com>
	<87egsr1wj7.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 25 Nov 2014 10:22:04 +0100
Message-ID: <CA+BoTQnk+40Pxkxfcu47Z-3j=8h2iMP8tKqXKf2GhAY3WkQxCw@mail.gmail.com> (sfid-20141125_102211_785643_A1AA5EF9)
Subject: Re: [PATCH] ath10k: don't drop corrupted mgmt frames
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 November 2014 at 10:04, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
[...]
>> @@ -1394,12 +1396,19 @@ static bool ath10k_htt_rx_amsdu_allowed(struct ath10k *ar,
>>               return false;
>>       }
>>
>> +     is_mgmt = !!(rxd->attention.flags &
>> +                  __cpu_to_le32(RX_ATTENTION_FLAGS_MGMT_TYPE));
>> +     has_fcs_err = !!(rxd->attention.flags &
>> +                      __cpu_to_le32(RX_ATTENTION_FLAGS_FCS_ERR));
>
> I think I asked this before in some other patch, but isn't '!!' operator
> useless here? is_mgmt is a boolean so the compiler should convert it
> correctly without '!!' anyway, right?

If I remove `!!` I get:

 warning: incorrect type in assignment (different base types)
    expected bool [unsigned] [usertype] is_mgmt
    got restricted __le32

I could do a temporary `u32 attention` to get rid of the `!!`. You
want me to update it?


Michał
