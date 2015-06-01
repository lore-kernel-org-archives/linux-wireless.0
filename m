Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33729 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbFAGgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 02:36:08 -0400
Received: by wgez8 with SMTP id z8so105348656wge.0
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2015 23:36:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOiWkA_i8mSx_DtW-Z8mdSiqMZcUXJp0nwCrZGkEZDWBUb3cVg@mail.gmail.com>
References: <CAOiWkA_i8mSx_DtW-Z8mdSiqMZcUXJp0nwCrZGkEZDWBUb3cVg@mail.gmail.com>
Date: Mon, 1 Jun 2015 08:36:06 +0200
Message-ID: <CA+BoTQnfXGLSvbx+hLfi_2w90-LgC3Uba0ZcO+Pt7J3FcEE9wg@mail.gmail.com> (sfid-20150601_083615_997610_485248FC)
Subject: Re: system hang with backports-20150511/20150525
From: Michal Kazior <michal.kazior@tieto.com>
To: Marty Faltesek <mfaltesek@google.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Martin Faltesek <martin.faltesek@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ath10k list

On 1 June 2015 at 03:37, Marty Faltesek <mfaltesek@google.com> wrote:
> Starting with backports-20150511, and continuing with
> backports-20150525, we see frequent system hangs. backports-20150424
> had no issue.

I don't see such binary releases on
https://backports.wiki.kernel.org/index.php/Main_Page
Hence I don't know what kernel you've backported the drivers from and
I can't compare anything.

Can you provide more details, please?


> After the freeze, the console is non-responsive, as well as the
> network stack (ssh/ping does not work). Using sysrq, I can see log
> messages continuing from ath10k_pci after the freeze, along with some
> other threads as well.

You probably refer to:

[ 1026.951643] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0,
skipped old beacon
[ 1026.951674] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0,
skipped old beacon
[ 1026.951698] ath10k_pci 0000:01:00.0: SWBA overrun on vdev 0,
skipped old beacon

What's puzzling to me are these timestamps. SWBA events are generated
by firmware (and sent to host) every beacon interval which is ~100ms
in most cases. In your case however I can see a burst of at least 10
SWBA events within 1ms. Either top(irq) or bottom(tasklet) got stuck
for some time.

It could be useful if you could enable ath10k debugging with
debug_mask=0xffffff3f (this could generate a lot of messages if you're
running traffic through ath10k).


> mac80211/ath10k/cfg80211 are the only modules in use from backports,
> so it seems like a deadlock  could possibly be with mac80211 or
> ath10k.
>
> LOCKDEP didn't reveal anything.

You might want to try tune /proc/sys/kernel/hung_task_timeout_secs
down (e.g. 5 or 10 seconds) and see what happens when you hit the
problem.


> Using a 3.2.26 kernel on ARM. AP mode. No encryption.
>
> I've collected ftrace events for sched mac80211 net napi cfg80211
> workqueue, which are included in the dmesg you can find here because
> of its size:
>
> http://tinyurl.com/dmesg-ftrace
>
> In the logs, the last timestamp that my test script wrote is:
>
> [ 1021.291495] hbeat0352
>
> I've captured  ftrace events before and after 1021.291495.

Your dmesg looks really messy and I'm worried if SWBA events really
came in a burst or not.


Michał
