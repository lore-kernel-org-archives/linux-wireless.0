Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58639 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab3IJTXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 15:23:54 -0400
Message-ID: <1378841057.4223.38.camel@porter.coelho.fi> (sfid-20130910_212401_436569_69E393B0)
Subject: Re: [PATCH 03/12] wlcore: disable elp sleep while in plt mode
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 10 Sep 2013 22:24:17 +0300
In-Reply-To: <CAB3XZEdNkEAsC8mz_jpz8UmjnK_pBwfGSChZQLGiuhtd0Q9Wnw@mail.gmail.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-3-git-send-email-eliad@wizery.com>
	 <1378794898.4799.37.camel@porter.coelho.fi>
	 <CAB3XZEdNkEAsC8mz_jpz8UmjnK_pBwfGSChZQLGiuhtd0Q9Wnw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-10 at 16:04 +0200, Eliad Peller wrote:
> On Tue, Sep 10, 2013 at 9:34 AM, Luca Coelho <luca@coelho.fi> wrote:
> > On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
> >> From: Yair Shapira <yair.shapira@ti.com>
> >>
> >> We now disable elp sleep during plt mode to allow normal operation of
> >> plt tools such as calibrator.
> >>
> >> Having elp_sleep enabled during plt mode is actually not required and
> >> in fact it disrupt plt operations such as rx statistics etc.
> >>
> >> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
> >> ---
> >
> > I also had a comment internally about this one.  Why do we need this?
> > AFAICT this would never happen in real life, since the firmware is not
> > even loaded at this point.  Is there any real life situation where we
> > try to go into ELP while in PLT mode?
> >
> i'm not familiar with the whole plt process, but i guess some flows
> might indeed end up in elp (e.g. via wl1271_cmd_interrogate(), in
> order to read statistics)

Well, I don't think this would ever happen.  The PLT stuff is a
completely different firmware and, really, if it tries to go into ELP
mode it is a bug.

In any case, there probably is a bug somewhere if this was implemented
at all.  And applying it won't really hurt.  I'm just nagging because it
would be nice to know what caused this to become necessary.

--
Luca.

