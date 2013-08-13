Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:56980 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab3HMFSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:18:43 -0400
Received: by mail-bk0-f48.google.com with SMTP id my13so2138581bkb.7
        for <linux-wireless@vger.kernel.org>; Mon, 12 Aug 2013 22:18:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878v07t0up.fsf@kamboji.qca.qualcomm.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
	<1375949813-10969-4-git-send-email-michal.kazior@tieto.com>
	<878v07t0up.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 13 Aug 2013 07:18:42 +0200
Message-ID: <CA+BoTQnC=oA0MEkHo8qqcxDY6nLUSFf11VcFk+81OG7+iY_Cyg@mail.gmail.com> (sfid-20130813_071847_433054_8B277816)
Subject: Re: [PATCH 3/4] ath10k: implement 802.3 SNAP rx decap type A-MSDU handling
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 August 2013 16:55, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This enables driver to rx another decapped a-msdu
>> frames. It should possibly help with throughputs
>> in some cases and reduce (or eliminate) number of
>> messages like this:
>>
>>   ath10k: error processing msdus -524
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -659,6 +658,15 @@ static int ath10k_htt_rx_amsdu(struct ath10k_htt *htt,
>>                       decap_hdr += roundup(crypto_len, 4);
>>               }
>>
>> +             if (fmt == RX_MSDU_DECAP_8023_SNAP_LLC) {
>> +                     /* SNAP 802.3 consists of:
>> +                      * [dst:6][src:6][len:2][dsap:1][ssap:1][ctl:1][snap:5]
>> +                      * [data][fcs:4].
>> +                      *
>> +                      * Since this overlaps with A-MSDU header (da, sa, len)
>> +                      * there's nothing extra to do. */
>> +             }
>
> This block doesn't have any code, is that on purpose? Most likely a
> static checker finds this later and we need to remove it.
>
> If your idea is to document the LLC case (which is very good!) it's
> better to do everything inside a comment, for example like this:
>
>         /* When fmt == RX_MSDU_DECAP_8023_SNAP_LLC:
>          *
>          * SNAP 802.3 consists of:
>          * [dst:6][src:6][len:2][dsap:1][ssap:1][ctl:1][snap:5]
>          * [data][fcs:4].
>          *
>          * Since this overlaps with A-MSDU header (da, sa, len)
>          * there's nothing extra to do. */

Yes, it's on purpose. I'll make a comment out of it then.


Pozdrawiam / Best regards,
Michał Kazior.
