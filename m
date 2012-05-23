Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53633 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab2EWOWy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 10:22:54 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len for STA
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
	<87wr436utp.fsf@purkki.adurom.net>
	<CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
	<87mx4z6u4n.fsf@purkki.adurom.net>
	<CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
Date: Wed, 23 May 2012 17:22:52 +0300
In-Reply-To: <CA+XVXfc3R8CrMfercPpRfYGjvKDdDkwJax+oLiaMrQQPwLCc0Q@mail.gmail.com>
	(Arik Nemtsov's message of "Wed, 23 May 2012 14:13:25 +0300")
Message-ID: <87ipfn6koz.fsf@purkki.adurom.net> (sfid-20120523_162258_322286_A3CB76BC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> On Wed, May 23, 2012 at 1:59 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> We want to change this in wlcore. We've encountered compatibility
>>> problems with some APs when we set ACs other than VO to U-APSD mode.
>>
>> Sounds like a hack to do this in the driver. Why can't mac80211 do it?
>
> Well it may be an issue specific to our HW. We didn't want to change
> the default behavior of all other mac80211 drivers.

I would prefer to consider all drivers first. But as you are not even
describing the problem and which APs are broken it's difficult for
anyone comment. Being verbose in the commit log doesn't hurt, quite the
opposite.

> I'm not sure what you mean by "hack" here.

Wikipedia has a good description:

"a kludge (or often a "hack") is a solution to a problem, doing a task,
or fixing a system that is inefficient, inelegant, or even unfathomable,
but which nevertheless (more or less) works."

I'm sure the solution you propose works but it's not elegant.

> We just enable the driver to override a default value, which is used
> by mac80211.

You are moving logic from mac80211 to the driver but it should be the
opposite, the driver should be dumb and mac80211 should control
everything. Didn't we have a similar discussion last year when talking
about controlling dynamic power save?

I would have expected to see a user space interface for controlling
these parameters, but not a driver interface.

-- 
Kalle Valo
