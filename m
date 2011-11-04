Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1KDJUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 05:20:18 -0400
Subject: Re: A new driver is going to be released
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CAMG6FYjGDhts2K3gYSeh0HACkFgSxxXZYdRCHrYp=2W3LceoyQ@mail.gmail.com> (sfid-20111104_101035_860741_ABCAE9E8)
References: <CAMG6FYiNW-1ijghpgQ6R_9HujVEp8d53DQ-vjfJrw_hZamM8Jw@mail.gmail.com>
	 <4EB33B67.6080806@lwfinger.net> <1320372088.29008.0.camel@dcbw.foobar.com>
	 <CAMG6FYgD9DDa+eJgALi3LLF1yQO3ujaxAskpEf1kvcJ19rYwxA@mail.gmail.com>
	 <1320394336.3969.0.camel@jlt3.sipsolutions.net>
	 <CAMG6FYjGDhts2K3gYSeh0HACkFgSxxXZYdRCHrYp=2W3LceoyQ@mail.gmail.com>
	 (sfid-20111104_101035_860741_ABCAE9E8)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Nov 2011 10:20:12 +0100
Message-ID: <1320398412.3969.18.camel@jlt3.sipsolutions.net> (sfid-20111104_102022_348671_FA1B571C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-04 at 10:10 +0100, Dmitry Tarnyagin wrote:
> Hi Johannes,
> 
> >> Correct. But I would move it to drivers/net/wireless during submission.
> >
> > A word of caution: don't attempt that in its current state.
> >
> Thank you for caution. CONFIG_CW1200_USE_STE_EXTENSIONS,
> CONFIG_WAKELOCK and HAS_PUT_TASK_STRUCT will be removed
> of course, API will be aligned with 3.1. But I'm a bit curious what else could
> prevent from submission to drivers/net/wireless? I do not see obvious problems
> with code. Could you please give a short advise what should be fixed then if you
> see problems?

Well there is a ton of stuff like compat code too. Also, for example the
worker thread is pretty strange -- kthread_create() is essentially
deprecated, and having a thread to handle interrupts is weird to start
with.

johannes

