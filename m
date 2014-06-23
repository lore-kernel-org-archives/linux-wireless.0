Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48121 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349AbaFWKTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 06:19:09 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3857540wib.13
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 03:19:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1400769683.4174.25.camel@jlt4.sipsolutions.net>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<1400769683.4174.25.camel@jlt4.sipsolutions.net>
Date: Mon, 23 Jun 2014 12:19:03 +0200
Message-ID: <CA+BoTQk=DU=-HzVo-XsQTpCt6CS7aXxQMy5hTyQ7qC56ebBLZQ@mail.gmail.com> (sfid-20140623_121914_682994_6AF4A993)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,


On 22 May 2014 16:41, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2014-05-22 at 16:12 +0200, Michal Kazior wrote:
>
>> As a side effect there's no way to propagate
>> registering errors to the pci subsystem but this
>> probably isn't really necessary.
>
> You should probably unbind if it fails - iwlwifi does that.

Hmm..

As it stands ath10k now deadlocks when firmware probing worker fails
and calls device_release_driver(). This indirectly hits pci remove()
callback which waits for the worker. Oops.

So I've taken a look how other driver do it so I can come up with a
solution - most of them seem use completions. After taking a closer
look I came to a conclusion this is inherently racy too. Consider the
following scenario:

 [syscall]
 insmod
 pci->probe()
 queue_work()
 return
 [worker]
 probe_fw()
 [syscall]
 rmmod
 dev_lock()
 pci->remove()
 wait_for_completion()
 [worker]
 complete_all()
 device_release_driver()
 dev_lock()
 {already held, yield}
 [syscall]
 free(internal structures)
 dev_unlock()
 return
 [worker]
 {woken up, but dev->driver == NULL so no callbacks}
 dev_unlock()
 return

The driver code section may not be reachable anymore upon worker
returning from the device_release_driver() call, right? Also since
ath10k uses an internal worker it also means the work_struct would be
already freed by the syscall flow (i.e. worker would run after driver
has supposedly been cleaned up..). Even if ath10k was to use
request_firmware_nowait(), which allocates a temporary work_struct,
the unreachable code section still remains a problem.

Or maybe this isn't really a problem and/or I'm missing something?


Michał
