Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42372 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118Ab3HHJ3R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 05:29:17 -0400
Received: by mail-bk0-f46.google.com with SMTP id 6so905397bkj.5
        for <linux-wireless@vger.kernel.org>; Thu, 08 Aug 2013 02:29:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871u6435c6.fsf@kamboji.qca.qualcomm.com>
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1375949298-7159-4-git-send-email-michal.kazior@tieto.com>
	<87eha4363n.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnoVmQcMnajTx3vsKwct5PLCNOt6w2qo17fyigm=gO5-w@mail.gmail.com>
	<871u6435c6.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 8 Aug 2013 11:29:15 +0200
Message-ID: <CA+BoTQnsH6XxpgoBh0tTNCjXvNz-fL6OaCp=LP-Eap_4tqYNkw@mail.gmail.com> (sfid-20130808_112924_566419_F38247FA)
Subject: Re: [RFC 3/3] ath10k: add support for HTT 3.0
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 August 2013 11:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 8 August 2013 11:05, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>
>>> This debug print is good to have, but with the new htt version it would
>>> be good to print it always using the info level. For example, can we add
>>> it to the same line with "firmware %s booted" string?
>>
>> HTT target version is not known when firmware boots up. It's not known
>> until everything other (HTC, WMI) is set up. We then send a version
>> request command and we get a response.
>
> Oh, missed that.
>
>> We need to print it in a separate line.
>
> Or could we print the "firmware booted" message later?

I'm worried it may be error-prone in case of firmware loading failure
in-between (i.e. firmware is booted, but WMI init fails). We'd need to
print the firmware version in the error path then.


>
>>> (Please take into account that the info messages still need to be
>>> compact, by default they should not be longer than five lines or so.)
>>>
>>>> +     if (htt->target_version_major != 2 &&
>>>> +         htt->target_version_major != 3) {
>>>>               ath10k_err("htt major versions are incompatible!\n");
>>>>               return -ENOTSUPP;
>>>>       }
>>>
>>> Print the htt version in the error message as well?
>>
>> Target version is printed in ath10k_dbg() now. If we change that to
>> ath10k_info() I don't see any reason to print the version again on
>> error.
>
> Frequently users just copy the error message, that's why it's better to
> have the firmware's htt version in the error message as well.

Good point.


Pozdrawiam / Best regards,
Michał Kazior.
