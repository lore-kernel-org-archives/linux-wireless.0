Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:38655 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab3HFG5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 02:57:42 -0400
Received: by mail-bk0-f50.google.com with SMTP id ik8so4534bkc.37
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 23:57:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iozkf5w0.fsf@kamboji.qca.qualcomm.com>
References: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
	<CA+BoTQkD5grL_5dJDgkwo40ET1zax56oN=ZGFxnyGqboQShbgQ@mail.gmail.com>
	<87iozkf5w0.fsf@kamboji.qca.qualcomm.com>
Date: Tue, 6 Aug 2013 08:57:40 +0200
Message-ID: <CA+BoTQkCQMZaicJpcrJGk+vz7kwMgcQcLS6PUn_4c65PJ4gRTA@mail.gmail.com> (sfid-20130806_085745_942393_3DEC7432)
Subject: Re: [PATCH v2] ath10k: add SoC power save option to PCI features map
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Bartosz Markowski <bartosz.markowski@tieto.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 August 2013 18:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 2 August 2013 09:58, Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
>>> Unify the PCI options location.
>>>
>>> By default the SoC PS option is disabled to boost the
>>> performance and due to poor stability on early HW revisions.
>>> In future we can remove the module parameter and turn on/off
>>> the PS for given hardware.
>>>
>>> This change also makes the pci module parameter for SoC PS static.
>>>
>>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>>
>> Hmm.. I'm worried about pci wake/sleep locking:
>>
>>  (a) pci_wake() (awake count =1)
>>  (a) do something
>>  Now, if pci_sleep() and pci_wake() happen simultaneously/are
>> preempted splitting primitive operations to:
>>  (a) pci_sleep(): decrease awake count (=0)
>>  (b) pci_wake(): increase awake count (=1), iowrite, wait for awake, return
>>  (a) pci_sleep(): iowrite(). return
>>  The flow in (b) now thinks the device is awake, but it's not
>> guaranteed to be anymore because it has been put to sleep by (a).
>
> Yeah, there's a race alright. I wonder if I have ever seen a proper use
> of a atomic variable in a wireless driver :)
>
> But this doesn't prevent taking this patch as the race has existed since
> the beginning, right?

I don't have anything against it. I just noticed the race and thought
it's good to point out the issue.


Pozdrawiam / Best regards,
Michał Kazior.
