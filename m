Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62747 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755135AbZHJPuh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 11:50:37 -0400
Received: by yxe5 with SMTP id 5so3908784yxe.33
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 08:50:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090810150455.GB2733@tuxdriver.com>
References: <AuPdDySr74O.A.5LC.Pj1fKB@chimera> <20090810150455.GB2733@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 10 Aug 2009 08:50:17 -0700
Message-ID: <43e72e890908100850v1cbb4252j3136245ba4d316b6@mail.gmail.com>
Subject: Re: wireless regressions -- Re: 2.6.31-rc5-git5: Reported regressions
	from 2.6.30
To: "John W. Linville" <linville@tuxdriver.com>,
	Fabio Comolli <fabio.comolli@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2009 at 8:04 AM, John W. Linville<linville@tuxdriver.com> wrote:
> On Sun, Aug 09, 2009 at 10:36:49PM +0200, Rafael J. Wysocki wrote:
>> This message contains a list of some regressions from 2.6.30, for which there
>> are no fixes in the mainline I know of.  If any of them have been fixed already,
>> please let me know.
>
> Wireless-related ones...

Some notes on some of these.

>> Unresolved regressions
>> ----------------------
>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13947
>> Subject               : Libertas: Association request to the driver failed
>> Submitter     : Daniel Mack <daniel@caiaq.de>
>> Date          : 2009-08-07 19:11 (3 days old)
>> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
>> References    : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
>> Handled-By    : Roel Kluin <roel.kluin@gmail.com>
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13943
>> Subject               : WARNING: at net/mac80211/mlme.c:2292 with ath5k
>> Submitter     : Fabio Comolli <fabio.comolli@gmail.com>
>> Date          : 2009-08-06 20:15 (4 days old)
>> References    : http://marc.info/?l=linux-kernel&m=124958978600600&w=4

As I noted earlier this comes from the fact that a driver or mac80211
is queuing work onto the mac80211 workqueue when we already ran the
mac80211 suspend callbacks and we haven't yet resumed. There have been
several fixes for these, for both drivers and mac80211. We've already
pushed them to wireless-testing but I do not recall which ones have
been propagated to 2.6.31 as fixes.

So we have two options, we either treat all these as real issues for
2.6.31 and try to backport all related fixes, or we downgrade this
warning to just bail out. The problem with debugging these issues
as-is on 2.6.31 is that the caller which queued the work remains
invisible to the trace from the warning -- the warning comes from the
workqueue callback not the routine which ran queue_work(). This was
recently changed in wireless-testing and we now issue the warnings
from the callers of queue_work() for the mac80211 workqueue so we
*can* easily see the root cause to the issue and easily fix this.

We can surely fix this issue alone but we're sure bound to see this
warning later from other buggy drivers/mac80211 on 2.6.31 so we do
need to address how we want to address this issue as a whole for
2.6.31.

Fabio to help iron out this issue can you please use wireless-testing,
use IBSS as you were and go through the suspend-resume cycle to see if
you see a new warning with ath5k.

>> Regressions with patches
>> ------------------------
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13948
>> Subject               : ath5k broken after suspend-to-ram
>> Submitter     : Johannes Stezenbach <js@sig21.net>
>> Date          : 2009-08-07 21:51 (3 days old)
>> References    : http://marc.info/?l=linux-kernel&m=124968192727854&w=4
>> Handled-By    : Nick Kossifidis <mickflemm@gmail.com>
>> Patch         : http://patchwork.kernel.org/patch/38550/

This bug report status is now RESOLVED PATCH_ALREADY_AVAILABLE .

  Luis
