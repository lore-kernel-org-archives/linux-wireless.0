Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:38361 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759947AbZFKVOp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 17:14:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: compat-wireless: ridiculous build speed
Date: Thu, 11 Jun 2009 23:14:29 +0200
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
References: <4A30CE70.4050605@web.de> <200906112305.33675.mb@bu3sch.de> <43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com>
In-Reply-To: <43e72e890906111410n3766ceb7t4b4efda05730c693@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906112314.29464.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 June 2009 23:10:52 Luis R. Rodriguez wrote:
> On Thu, Jun 11, 2009 at 2:05 PM, Michael Buesch<mb@bu3sch.de> wrote:
> > On Thursday 11 June 2009 20:48:13 Luis R. Rodriguez wrote:
> >> On Thu, Jun 11, 2009 at 2:29 AM, Jan Kiszka<jan.kiszka@web.de> wrote:
> >> > Hi,
> >> >
> >> > while watching compat-wireless-2009-06-11 doing baby-steps building all
> >> > its modules, I wonder what slows this down so horribly. No other
> >> > external module build package I know is that slow (I would say *at
> >> > least* one order of magnitude slower than normal). Is this really required?
> >> >
> >> > [ Hurray, it's finished! ]
> >>
> >> I think the many depmod -ae are the culprit. This is in place to
> >> account for all the crap of madwifi which may be present or older
> >> drivers which have been renamed.
> >>
> >> This could be improved. Patches are welcomed.
> >>
> >> Ps. Try building with make -j 2, etc.
> >
> > -j does not help. It will hardly build in parallel then.
> 
> It works swell for me. The only thing that does not build in parellel
> is the autoconf stuff but after its done with that step everything
> builds as expected with -j 2.
> 
> > There's something
> > that serializes most of it (implicitly).
> 
> You certain its just not the first part? I had written some patches to
> make the first autoconf step into another step to then allow make -j
> foo to work without a warning but that would involve another step. The
> -j option does work for me though.

Well, I never measured it, but I don't see any advantage when using -jX. Maybe
that is because forever equals forever+1.

What I do see, though, is that the per-cpu load is much higher when building the
kernel itself with the same -j parameter.

-- 
Greetings, Michael.
