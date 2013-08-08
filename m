Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:39449 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934111Ab3HHJWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 05:22:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [RFC 3/3] ath10k: add support for HTT 3.0
References: <1375949298-7159-1-git-send-email-michal.kazior@tieto.com>
	<1375949298-7159-4-git-send-email-michal.kazior@tieto.com>
	<87eha4363n.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQnoVmQcMnajTx3vsKwct5PLCNOt6w2qo17fyigm=gO5-w@mail.gmail.com>
Date: Thu, 8 Aug 2013 12:22:01 +0300
In-Reply-To: <CA+BoTQnoVmQcMnajTx3vsKwct5PLCNOt6w2qo17fyigm=gO5-w@mail.gmail.com>
	(Michal Kazior's message of "Thu, 8 Aug 2013 11:12:58 +0200")
Message-ID: <871u6435c6.fsf@kamboji.qca.qualcomm.com> (sfid-20130808_112214_996546_D4B4600E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 8 August 2013 11:05, Kalle Valo <kvalo@qca.qualcomm.com> wrote:

>> This debug print is good to have, but with the new htt version it would
>> be good to print it always using the info level. For example, can we add
>> it to the same line with "firmware %s booted" string?
>
> HTT target version is not known when firmware boots up. It's not known
> until everything other (HTC, WMI) is set up. We then send a version
> request command and we get a response.

Oh, missed that.

> We need to print it in a separate line.

Or could we print the "firmware booted" message later?

>> (Please take into account that the info messages still need to be
>> compact, by default they should not be longer than five lines or so.)
>>
>>> +     if (htt->target_version_major != 2 &&
>>> +         htt->target_version_major != 3) {
>>>               ath10k_err("htt major versions are incompatible!\n");
>>>               return -ENOTSUPP;
>>>       }
>>
>> Print the htt version in the error message as well?
>
> Target version is printed in ath10k_dbg() now. If we change that to
> ath10k_info() I don't see any reason to print the version again on
> error.

Frequently users just copy the error message, that's why it's better to
have the firmware's htt version in the error message as well.

> We may want to print the list of supported HTT major version numbers
> though?

That's good to have as well, at least in the debug messages.

-- 
Kalle Valo
