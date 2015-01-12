Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbbALNUx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 08:20:53 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add additional fw build version to info print
References: <1420716572-23826-1-git-send-email-michal.kazior@tieto.com>
	<87vbkccg3s.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQk6W1+qi3PY4PjG209L+SZsFc6ktd=eQMKqhrSYpi2AUw@mail.gmail.com>
Date: Mon, 12 Jan 2015 15:20:41 +0200
In-Reply-To: <CA+BoTQk6W1+qi3PY4PjG209L+SZsFc6ktd=eQMKqhrSYpi2AUw@mail.gmail.com>
	(Michal Kazior's message of "Mon, 12 Jan 2015 14:10:41 +0100")
Message-ID: <87mw5oceza.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_142106_667738_CB669B6E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 12 January 2015 at 13:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> [...]
>>>  void ath10k_print_driver_info(struct ath10k *ar)
>>>  {
>>> -     ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
>>> +     ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d build %u.%u.%u.%u\n",
> [...]
>>
>> So now we print two different firmware versions to the user? That's just
>> confusing. It's ok to print this build id in debug level, but not in
>> info level. From user's point of view we should have only one firmware
>> version.
>
> I guess we shouldn't be printing htt version then too. Nevertheless I
> understand your concern.

Yeah, but htt version is an interface version and I'm having a hard time
to believe that someone will mistake that as the actual firmware
version.

But what people confuse is the FW API version. When I ask what firmware
version you have way too often I get "firmware-3.bin" as a reply :) But
I have no ideas how to solve that.

-- 
Kalle Valo
