Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28310 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934200Ab3HHJmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 05:42:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [RFC 3/3] ath10k: add support for HTT 3.0
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1375949298-7159-4-git-send-email-michal.kazior@tieto.com>
	<87eha4363n.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnoVmQcMnajTx3vsKwct5PLCNOt6w2qo17fyigm=gO5-w@mail.gmail.com>
	<871u6435c6.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnsH6XxpgoBh0tTNCjXvNz-fL6OaCp=LP-Eap_4tqYNkw@mail.gmail.com>
Date: Thu, 8 Aug 2013 12:42:46 +0300
In-Reply-To: <CA+BoTQnsH6XxpgoBh0tTNCjXvNz-fL6OaCp=LP-Eap_4tqYNkw@mail.gmail.com>
	(Michal Kazior's message of "Thu, 8 Aug 2013 11:29:15 +0200")
Message-ID: <87ppto1pt5.fsf@kamboji.qca.qualcomm.com> (sfid-20130808_114258_743350_E2ACD66A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 8 August 2013 11:22, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> On 8 August 2013 11:05, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>
>>>> This debug print is good to have, but with the new htt version it would
>>>> be good to print it always using the info level. For example, can we add
>>>> it to the same line with "firmware %s booted" string?
>>>
>>> HTT target version is not known when firmware boots up. It's not known
>>> until everything other (HTC, WMI) is set up. We then send a version
>>> request command and we get a response.
>>
>> Oh, missed that.
>>
>>> We need to print it in a separate line.
>>
>> Or could we print the "firmware booted" message later?
>
> I'm worried it may be error-prone in case of firmware loading failure
> in-between (i.e. firmware is booted, but WMI init fails). We'd need to
> print the firmware version in the error path then.

True, let's just print in a separate line. We can worry about compacting
it later.

-- 
Kalle Valo
