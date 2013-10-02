Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:55255 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3JBFfj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 01:35:39 -0400
Received: by mail-bk0-f54.google.com with SMTP id mz12so118277bkb.27
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 22:35:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8761th6ja6.fsf@kamboji.qca.qualcomm.com>
References: <1380292567-2363-1-git-send-email-michal.kazior@tieto.com>
	<1380292567-2363-3-git-send-email-michal.kazior@tieto.com>
	<8761th6ja6.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 2 Oct 2013 07:35:37 +0200
Message-ID: <CA+BoTQnjG9MnbPsLM-RtAwuGNp_ZAfbvwvR_zg1Ks0ZmUxAtrQ@mail.gmail.com> (sfid-20131002_073542_620011_6D355160)
Subject: Re: [PATCH 2/2] ath10k: fix scheduling while atomic bug
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 October 2013 18:35, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Recent WMI/HTC changes broke WEP with multiple
>> keys. If WMI had no HTC TX credits to submit
>> command for default wep index update it would
>> trigger a bug.
>>
>> This simply moves the wep key index update to a
>> worker.
>>
>> The key update may happen some time after first
>> frame with a different wep key has been sent (i.e.
>> some frames will be sent with old key). This was
>> the case before too as WMI commands were
>> asynchronous.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> This looks problematic. Basically you just delay sending the WMI
> command, but there's no guarantee that we actually have free credits at
> the time of transmission. So to me it looks like this fixes the issue
> just by luck.

One thing at a time.

This patch fixes 'scheduling while atomic' bug that was introduced
with recent HTC/WMI changes.

Multiple wep key handling had the same issue you point out before
HTC/WMI changes.

To fix the issue you mention we'd need to stop mac80211 queues, queue
frame(s) with a new key on internal queue, schedule a work. The work
should set new wep key index, send pending frames from internal queue
and wake mac80211 queues. This is a bit more complex than it sounds
though.


Michał
