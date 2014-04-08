Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:44384 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaDHGc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 02:32:59 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so447733wgg.26
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2014 23:32:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87bnwdnslk.fsf@kamboji.qca.qualcomm.com>
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-3-git-send-email-michal.kazior@tieto.com>
	<87bnwdnslk.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 8 Apr 2014 08:32:58 +0200
Message-ID: <CA+BoTQ=-vrJ_tize+uwCp5jgM7pvPZ0s9bGUK42Ko1TCHzmfzg@mail.gmail.com> (sfid-20140408_083327_493834_709C59D9)
Subject: Re: [PATCH v2 2/2] ath10k: refactor radar detection code
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 April 2014 16:04, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> If 20MHz CAC completed successfully then
>> subsequent CAC with wider bandwidth (40Mhz, 80Mhz)
>> with identical control frequency did not start
>> monitor vdev making it impossible to detect any
>> radar pulses during intended CAC.
>>
>> It also was incorrect to assume ath10k_config() will
>> be called after CAC is finished. Theoretically for
>> non-HT channels nothing changes between CAC and
>> start_ap() (albeit in practice this can be
>> different). The incorrect assumption led to CAC
>> not being stopped on non-HT chandefs leading to
>> all Rx being drooped making it impossible for
>> clients to associate.
>>
>> While at it clean up the code a bit.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> @@ -858,6 +830,11 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
>>               return ret;
>>       }
>>
>> +     if (!WARN_ON(ar->num_started_vdevs == 0)) {
>
> Even though this is correct, I think it's still a bit evil. For example,
> I missed '!' the first time I looked at this. Even this is a line
> longer, I think it would be easier to read:
>
> WARN_ON(ar->num_started_vdevs == 0);
>
> if (ar->num_started_vdevs != 0) {
>         ...
> }

Sound reasonably.


Michał
