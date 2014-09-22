Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:46550 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbaIVMDt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 08:03:49 -0400
Received: by mail-wi0-f178.google.com with SMTP id z2so2815506wiv.17
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 05:03:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877g0wlyga.fsf@kamboji.qca.qualcomm.com>
References: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com>
	<1411046721-20510-3-git-send-email-michal.kazior@tieto.com>
	<877g0wlyga.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 22 Sep 2014 14:03:48 +0200
Message-ID: <CA+BoTQm1_X992b_fMokcpuuqooQFThHpQoAEe4cjzOu7P3CV1A@mail.gmail.com> (sfid-20140922_140353_239128_0CAA74FC)
Subject: Re: [PATCH 2/3] ath10k: dump hex bytes with dev string prefix
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 September 2014 12:52, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This makes it easier to debug hex dumps on systems
>> with more than a single ath10k device.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> -             print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
>> +             for (ptr = buf; (ptr - buf) < len; ptr += 16) {
>> +                     linebuflen = 0;
>> +                     if (prefix)
>> +                             linebuflen += scnprintf(linebuf + linebuflen,
>> +                                                     sizeof(linebuf) -
>> +                                                     linebuflen,
>> +                                                     "%s", prefix);
>> +                     linebuflen += scnprintf(linebuf + linebuflen,
>> +                                             sizeof(linebuf) - linebuflen,
>> +                                             "%08x: ",
>> +                                             (unsigned int)(ptr - buf));
>> +                     hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
>> +                                        linebuf + linebuflen,
>> +                                        sizeof(linebuf) - linebuflen, true);
>> +                     dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
>> +             }
>
> Would it be possible to simplify this to one scnprintf()? Something
> like:
>
> linebuflen += scnprintf(linebuf + linebuflen,
>                         sizeof(linebuf) - linebuflen,
>                         "%s%08x: ",
>                         prefix ? prefix : "",
>                         (unsigned int)(ptr - buf));

It should be fine. You want me to re-send it?


Michał
