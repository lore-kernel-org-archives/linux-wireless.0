Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33549 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638AbbELMe6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 08:34:58 -0400
Received: by wief7 with SMTP id f7so111050003wie.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2015 05:34:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iobygf96.fsf@kamboji.qca.qualcomm.com>
References: <CAJa-X95EBdGASnz3KAdYz5R6w5g-a=dBy5VCZYwHp6SzQ+gUSw@mail.gmail.com>
	<CA+BoTQkFSQe0di1vqqB5cAPKaizRkBT5cu4fA8dQ_uR_a2HdJw@mail.gmail.com>
	<CAJa-X96spUg7+EZqH-Mv3s7OzbHzmXmcZ7uOw1KvPShexW6D_w@mail.gmail.com>
	<CA+BoTQ=Qpws=928TZe22Ds-UO_qQJ2Om+=DW=VUNUS59o1BQAA@mail.gmail.com>
	<CAJa-X96KPw6dY0pK1zc8UD4TdQcG0KuA3m6DSueVVyK-VPhn9g@mail.gmail.com>
	<CA+BoTQ=bqHPrdgGVfSfdJa5vobDBRdxRwMR_wJzUj4Z9WjotoQ@mail.gmail.com>
	<87iobygf96.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 12 May 2015 14:34:57 +0200
Message-ID: <CA+BoTQkduFA78B70hyn9FNbyKX_Yd=9cH9notfEC93Owm9sRSg@mail.gmail.com> (sfid-20150512_143505_240514_6E1B15A6)
Subject: Re: Ath10 firmware crashing in Monitor mode(Sniffer mode)
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: s prasad <sprasad.kandregula@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 May 2015 at 14:19, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 11 May 2015 at 23:27, s prasad <sprasad.kandregula@gmail.com> wrote:
>>> Tested as you suggested, however didn't help. Please find attached log
>>> files for each firmware type.
>>>
>>> While executing following commands in sequence, captured dmesg. I hope
>>> those logs will help. If not please let me know.
>>
>> Thanks!
>>
>> Apparently I've missed from your original email the fact that you're
>> trying to inject packets. This isn't supported in ath10k.
>
> IMHO we should somehow warn the user or prevent that happening. Is there
> a way to do that?

We could add an extra condition in ath10k_tx() to drop/free packets
immediately and warn if an injection attempt is made.


Michał
