Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61076 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbaHNPvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 11:51:15 -0400
MIME-Version: 1.0
In-Reply-To: <53ECD8D0.4050709@lwfinger.net>
References: <CA+55aFxdt-9e9X0EYCu2Ku8sSTspUGPk5qKa72XH63zrkdPthw@mail.gmail.com>
	<53ECD8D0.4050709@lwfinger.net>
Date: Thu, 14 Aug 2014 09:51:14 -0600
Message-ID: <CA+55aFw1LWO+zxePYtUBi9YOWHPX+98xbM2h3j4pcN+6V0G1zA@mail.gmail.com> (sfid-20140814_175122_497241_7A55B4F7)
Subject: Re: Intel wireless microcode problem..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2014 at 9:42 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> There is a new firmware that seems to help the problem. You can get it from
> Emmanuel's git clone. As he wrote earlier

So quite frankly, this is *not* acceptable. We have regression
policies for the kernel, and this seems to be a kernel regression with
the currently released firmware. And I'm not downloading experimental
firmware while traveling with this laptop being my only way to work.

The warnings cause *so* much message log spam that the machine is
occasionally spending 5% of CPU time on systemd journaling, and
presumably filling up disk space too.

And the same way we don't tell people "update your buggy user space"
when we introduce kernel regressions, we don't tell people "try a new
firmware".

People who have old systems (old distributions, old firmware, old
hardware, old *anything*) that works with their previous kernel, are
supposed to be able to upgrade their kernel with no regressions.
That's the rules for the kernel, and that's what the rules have been
for a long time. Kernel developers - including wireless driver writers
- had better understand that rule. It's the absolute #1 rule when it
comes to kernel development. This is not something new and surprosing.

The insane amount of logging needs to be fixed. The wireless *works*,
but the logging is too verbose.

Now, maybe this isn't actually a kernel regression at all - maybe
triggered by the horrid internet I have while traveling - but I tried
twice, and when I booted into the regular Fedora kernel for testing
(oh, just noticed that it's 3.15.8, not 3.16-based), I didn't see this
kind of log spamming. So it looks like a regression to me, and we have
rules about regressions. And they are just about the ONLY hard rules
we have. But that regression rule really is very very important
indeed.

The wireless *works* with the current firmware, so all that is
required is to make sure that the kernel stops spamming the logs so
heavily. It would obviously be better to try to figure out *why* the
microcode error happens, and what changed in the kernel to trigger it,
but the "don't make the machine have trouble with the insane amount of
logs" is at least an acceptable workaround.

Ok?

               Linus
