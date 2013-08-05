Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58650 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3HEQkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 12:40:37 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Bartosz Markowski <bartosz.markowski@tieto.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH v2] ath10k: add SoC power save option to PCI features map
References: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
	<CA+BoTQkD5grL_5dJDgkwo40ET1zax56oN=ZGFxnyGqboQShbgQ@mail.gmail.com>
Date: Mon, 5 Aug 2013 19:40:14 +0300
In-Reply-To: <CA+BoTQkD5grL_5dJDgkwo40ET1zax56oN=ZGFxnyGqboQShbgQ@mail.gmail.com>
	(Michal Kazior's message of "Mon, 5 Aug 2013 15:31:31 +0200")
Message-ID: <87iozkf5w0.fsf@kamboji.qca.qualcomm.com> (sfid-20130805_184040_855366_49B7726C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 2 August 2013 09:58, Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
>> Unify the PCI options location.
>>
>> By default the SoC PS option is disabled to boost the
>> performance and due to poor stability on early HW revisions.
>> In future we can remove the module parameter and turn on/off
>> the PS for given hardware.
>>
>> This change also makes the pci module parameter for SoC PS static.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>
> Hmm.. I'm worried about pci wake/sleep locking:
>
>  (a) pci_wake() (awake count =1)
>  (a) do something
>  Now, if pci_sleep() and pci_wake() happen simultaneously/are
> preempted splitting primitive operations to:
>  (a) pci_sleep(): decrease awake count (=0)
>  (b) pci_wake(): increase awake count (=1), iowrite, wait for awake, return
>  (a) pci_sleep(): iowrite(). return
>  The flow in (b) now thinks the device is awake, but it's not
> guaranteed to be anymore because it has been put to sleep by (a).

Yeah, there's a race alright. I wonder if I have ever seen a proper use
of a atomic variable in a wireless driver :)

But this doesn't prevent taking this patch as the race has existed since
the beginning, right?

-- 
Kalle Valo
