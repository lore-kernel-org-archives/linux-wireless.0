Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:52757 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaKQOyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 09:54:25 -0500
Received: by mail-wi0-f171.google.com with SMTP id bs8so3515566wib.10
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2014 06:54:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87ppclq4mu.fsf@kamboji.qca.qualcomm.com>
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
	<1415110931-10945-5-git-send-email-michal.kazior@tieto.com>
	<87ppclq4mu.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 17 Nov 2014 15:54:23 +0100
Message-ID: <CA+BoTQ=Ws0JGsVBd2J0fe2_JqAhCVpHmNkn10CJx6BCNG-r0cg@mail.gmail.com> (sfid-20141117_155433_549650_C619FDE7)
Subject: Re: [PATCH 4/7] ath10k: unify rx undecapping
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 November 2014 15:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This creates a single, common path for MSDU,
>> A-MSDU and fragmented Rx.
>>
>> Hopefully this will make it easier to understand
>> Rx path and make it easier to work with.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This patch had few checkpatch warnings. I fixed them with the folded
> patch and full patch here:
>
> https://github.com/kvalo/ath/commit/71fbd07d43e54f5f9f442bc5f2f4f9ef83aead63

Thanks!

[...]
> @@ -1132,7 +1133,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
>         bool has_fcs_err;
>         bool has_crypto_err;
>         bool has_tkip_err;
> -       bool has_peer_idx_invalid;
> +       bool has_idx_invalid;
>         bool is_decrypted;

I don't really like the has_idx_invalid. Perhaps has_peer_err conveys
a bit more of the original meaning?

As much as I'd like to leave the original var name I'd like to be
checkpatch warning free. Sigh..


Michał
