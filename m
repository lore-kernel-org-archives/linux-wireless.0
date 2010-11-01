Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:40911 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181Ab0KAVbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 17:31:00 -0400
Subject: Re: [PATCH 2/2] wl1271: add recover testmode command
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTin+RQ8zjbQKFcZJjoVcT=GkuMYTYEbt47TFuAC6@mail.gmail.com>
References: <1288181398-2358-1-git-send-email-eliad@wizery.com>
	 <1288181398-2358-2-git-send-email-eliad@wizery.com>
	 <1288617893.20937.10.camel@chilepepper>
	 <AANLkTi=jyGZ+LLZ2cDiF7CFC1h_WbzwmOOLQkSpOaLAz@mail.gmail.com>
	 <AANLkTin+RQ8zjbQKFcZJjoVcT=GkuMYTYEbt47TFuAC6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Nov 2010 23:42:25 +0200
Message-ID: <1288647745.21112.76.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-01 at 22:21 +0100, ext Gábor Stefanik wrote:
> On Mon, Nov 1, 2010 at 9:59 PM, Eliad Peller <eliad@wizery.com> wrote:
> >>> add RECOVER testmode command.
> >>> this command triggers a recovery sequence (by enqueueing a recovery_work).
> >>>
> >>> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >>> ---
> >>
> >> So, the point of this patch is to allow hardware recovery from the
> >> userspace? In what kind of scenario do you need this?
> >>
> >
> > yes.
> > it's mainly for testing (or if we want to recover manually for some reason).
> > this is why i implemented it as a testmode command.
> 
> Isn't testmode for features used during regulatory testing, that the
> user should be unable to access to ensure further regulatory
> compliance?

Not exactly, it's just an interface to be used during production (and
possibly R&D) tests.  In the specific case of wl12xx, we use it for
production-line testing and for calibration and testing during R&D.

A normal user shouldn't use this by default (all distros and device
manufacturers should have it disabled in the kernel), but there's no way
to prevent a hacker from enabling it in a custom kernel.

In any case, I'm not sure I really like this idea of a HW recovery test
command.  This should really be done automatically by the driver and,
with Juuso's implementation plus the watchdog, we shouldn't really need
it.

-- 
Cheers,
Luca.

