Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43765 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbbALNKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 08:10:43 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so19145153wgg.10
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 05:10:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87vbkccg3s.fsf@kamboji.qca.qualcomm.com>
References: <1420716572-23826-1-git-send-email-michal.kazior@tieto.com>
	<87vbkccg3s.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 12 Jan 2015 14:10:41 +0100
Message-ID: <CA+BoTQk6W1+qi3PY4PjG209L+SZsFc6ktd=eQMKqhrSYpi2AUw@mail.gmail.com> (sfid-20150112_141046_498642_E0968CED)
Subject: Re: [PATCH] ath10k: add additional fw build version to info print
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12 January 2015 at 13:56, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
[...]
>>  void ath10k_print_driver_info(struct ath10k *ar)
>>  {
>> -     ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d\n",
>> +     ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d cal %s max_sta %d build %u.%u.%u.%u\n",
[...]
>
> So now we print two different firmware versions to the user? That's just
> confusing. It's ok to print this build id in debug level, but not in
> info level. From user's point of view we should have only one firmware
> version.

I guess we shouldn't be printing htt version then too. Nevertheless I
understand your concern.


> I would rather make sure that ATH10K_FW_IE_FW_VERSION always contains
> the correct version string and then developers map whatever they need
> from that string.

Right. Let's drop this for now then.


Michał
