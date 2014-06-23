Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:44337 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbaFWMRt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 08:17:49 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so6951804wes.27
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 05:17:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403524278.4418.19.camel@jlt4.sipsolutions.net>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<1400769683.4174.25.camel@jlt4.sipsolutions.net>
	<CA+BoTQk=DU=-HzVo-XsQTpCt6CS7aXxQMy5hTyQ7qC56ebBLZQ@mail.gmail.com>
	<1403524278.4418.19.camel@jlt4.sipsolutions.net>
Date: Mon, 23 Jun 2014 14:17:43 +0200
Message-ID: <CA+BoTQ=fpkOZXVgJt-OWdgSFX1_sO1g1E=J-7NnOb+e6a30FVA@mail.gmail.com> (sfid-20140623_141754_068459_9E594827)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 June 2014 13:51, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
>>  [worker]
>>  complete_all()
>>  device_release_driver()
>>  dev_lock()
>>  {already held, yield}
>>  [syscall]
>>  free(internal structures)
>>  dev_unlock()
>>  return
>>  [worker]
>>  {woken up, but dev->driver == NULL so no callbacks}
>>  dev_unlock()
>>  return
>>
>> The driver code section may not be reachable anymore upon worker
>> returning from the device_release_driver() call, right? Also since
>> ath10k uses an internal worker it also means the work_struct would be
>> already freed by the syscall flow (i.e. worker would run after driver
>> has supposedly been cleaned up..). Even if ath10k was to use
>> request_firmware_nowait(), which allocates a temporary work_struct,
>> the unreachable code section still remains a problem.
>>
>> Or maybe this isn't really a problem and/or I'm missing something?
>
> Yeah, hmm, this looks like a problem. I guess we didn't really consider
> module unload in such detail ...
>
> I guess this would crash upon return from device_release_driver()? I
> guess if that's the last thing then maybe we'd actually get a tail-call
> optimisation, but we don't want to rely on that of course!
>
> Seems like to fix it we just need to get a module reference though? Can
> a module put() itself though? Hmmm.

It seems some drivers use module_put(THIS_MODULE) and
__module_get(THIS_MODULE), e.g. tun/tap driver.

But does this bump up the module refcount in such a way that an
in-progress rmmod will wait/block until the refcount reaches 0?


Michał
