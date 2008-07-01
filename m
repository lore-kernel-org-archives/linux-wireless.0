Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:35284 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbYGAKik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:38:40 -0400
From: Michael Buesch <mb@bu3sch.de>
To: drago01 <drago01@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Date: Tue, 1 Jul 2008 12:38:18 +0200
Cc: "Adel Gadllah" <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <200807011227.15805.mb@bu3sch.de> <f6ca9fed0807010333s61d035e0m13e2d6b81ef63a9b@mail.gmail.com>
In-Reply-To: <f6ca9fed0807010333s61d035e0m13e2d6b81ef63a9b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807011238.18600.mb@bu3sch.de> (sfid-20080701_123843_537466_23A38988)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 July 2008 12:33:17 drago01 wrote:
> On Tue, Jul 1, 2008 at 12:27 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > On Tuesday 01 July 2008 11:55:11 Adel Gadllah wrote:
> >> Hi,
> >> The attached patch removes the input device dependency and replaces
> >> the polldev by a timer.
> >> The timer polls the device and sets the rfkill state.
> >> I build tested the patch only because I don't have access to the
> >> hardware, hence the RFC.
> >> Can someone with the access to the hardware test and verify this?
> >> If it works I will submit a similar patch for b43legacy.
> >>
> >> -----------------------
> >> This patch removes the dependency on the input device and replaces the
> >> polldev with a timer for polling the rfkill state.
> >
> >
> > I'm pretty sure this will generate a lot of bugreports complaining that
> > rfkill silently broke, as the userspace is not setup correctly.
> 
> OK, so how to proceed? Just leave the input device?

No well. This probably is the right way to go. However I just wanted to
say that I'm pretty sure it will generate lots of bugreports that I
will ignore. ;)

But I am wondering _why_ we need to turn all this upside down.
What's so bad about having an input device in the kernel? What's the
advantage of having userspace do the work?

-- 
Greetings Michael.
