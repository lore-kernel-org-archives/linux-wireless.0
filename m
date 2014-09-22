Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41958 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaIVMHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 08:07:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/3] ath10k: dump hex bytes with dev string prefix
References: <1411046721-20510-1-git-send-email-michal.kazior@tieto.com>
	<1411046721-20510-3-git-send-email-michal.kazior@tieto.com>
	<877g0wlyga.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQm1_X992b_fMokcpuuqooQFThHpQoAEe4cjzOu7P3CV1A@mail.gmail.com>
Date: Mon, 22 Sep 2014 15:07:35 +0300
In-Reply-To: <CA+BoTQm1_X992b_fMokcpuuqooQFThHpQoAEe4cjzOu7P3CV1A@mail.gmail.com>
	(Michal Kazior's message of "Mon, 22 Sep 2014 14:03:48 +0200")
Message-ID: <8738bjn9iw.fsf@kamboji.qca.qualcomm.com> (sfid-20140922_140750_528607_F29FC735)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 22 September 2014 12:52, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> -             print_hex_dump_bytes(prefix, DUMP_PREFIX_OFFSET, buf, len);
>>> +             for (ptr = buf; (ptr - buf) < len; ptr += 16) {
>>> +                     linebuflen = 0;
>>> +                     if (prefix)
>>> +                             linebuflen += scnprintf(linebuf + linebuflen,
>>> +                                                     sizeof(linebuf) -
>>> +                                                     linebuflen,
>>> +                                                     "%s", prefix);
>>> +                     linebuflen += scnprintf(linebuf + linebuflen,
>>> +                                             sizeof(linebuf) - linebuflen,
>>> +                                             "%08x: ",
>>> +                                             (unsigned int)(ptr - buf));
>>> +                     hex_dump_to_buffer(ptr, len - (ptr - buf), 16, 1,
>>> +                                        linebuf + linebuflen,
>>> +                                        sizeof(linebuf) - linebuflen, true);
>>> +                     dev_printk(KERN_DEBUG, ar->dev, "%s\n", linebuf);
>>> +             }
>>
>> Would it be possible to simplify this to one scnprintf()? Something
>> like:
>>
>> linebuflen += scnprintf(linebuf + linebuflen,
>>                         sizeof(linebuf) - linebuflen,
>>                         "%s%08x: ",
>>                         prefix ? prefix : "",
>>                         (unsigned int)(ptr - buf));
>
> It should be fine. You want me to re-send it?

Yes, that would be good. I don't feel comfortable editing patches with
logic changes like this.

-- 
Kalle Valo
