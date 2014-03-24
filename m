Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:48876 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaCXKRa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 06:17:30 -0400
Received: by mail-la0-f47.google.com with SMTP id y1so3440089lam.20
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 03:17:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vbv46klt.fsf@kamboji.qca.qualcomm.com>
References: <1395394341-3958-1-git-send-email-janusz.dziedzic@tieto.com>
	<1395394341-3958-5-git-send-email-janusz.dziedzic@tieto.com>
	<87vbv46klt.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 24 Mar 2014 11:17:28 +0100
Message-ID: <CALhHN=q0bK3qUDRtm-_zRKs-RFCpiVcGHihQPuHvMW7CVLiePg@mail.gmail.com> (sfid-20140324_111732_830529_F3BFB9B2)
Subject: Re: [PATCH 4/8] ath10k: setup rx channel per ppdu
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 09:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Setup band and frequency in ieee80211_rx_status
>> only once - for ppdu.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> [...]
>
>> @@ -775,23 +794,7 @@ static void ath10k_process_rx(struct ath10k *ar, struct htt_rx_info *info)
>>       if (info->amsdu_more)
>>               status->flag |= RX_FLAG_AMSDU_MORE;
>>
>> -     status->signal = info->signal;
>
> What about the signal, how is it set now? I don't see that anywhere in
> this patch.
>
This belongs to next patch - will fix it.

BR
janusz
