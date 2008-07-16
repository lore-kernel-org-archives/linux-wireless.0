Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound-mail-03.bluehost.com ([69.89.21.13]:41168 "HELO
	outbound-mail-03.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755931AbYGPTr7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 15:47:59 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Date: Wed, 16 Jul 2008 12:41:02 -0700
Cc: "Pavel Roskin" <proski@gnu.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com> <200807161141.59385.jbarnes@virtuousgeek.org> <40f31dec0807161227n4254b8adobbbcfdde540704fd@mail.gmail.com>
In-Reply-To: <40f31dec0807161227n4254b8adobbbcfdde540704fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200807161241.04387.jbarnes@virtuousgeek.org> (sfid-20080716_214803_082710_D55AC797)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, July 16, 2008 12:27 pm Nick Kossifidis wrote:
> 2008/7/16 Jesse Barnes <jbarnes@virtuousgeek.org>:
> > On Wednesday, July 16, 2008 10:35 am Pavel Roskin wrote:
> >> On Wed, 2008-07-16 at 09:31 -0700, Jesse Barnes wrote:
> >> > On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
> >> > > It's ok for now, but have in mind that on my upcoming patch series
> >> > > i'm disabling msi (commented out) since it results no interrupts on
> >> > > pci-e cards (seems there is a bug in kernel's msi implementation).
> >> >
> >> > Hm, would be good to get details here.  MSI is being used by other
> >> > drivers successfully...
> >>
> >> That's true, but no driver uses the same interrupt handler with and
> >> without MSI.  Either it's different handlers or the handler checks if
> >> MSI is enabled and does something differently.
> >
> > Yeah, using MSI on your device can mean that you have to make some
> > changes (like on Intel graphics you have to disable regular interrupts or
> > bad things happen), but you can still share the handler or at least most
> > of it in some cases.
>
> Is there documentation for this somewhere ? Msi documentation
> (MSI-HOWTO.txt) doesn't say anything about a different interrupt
> handler etc.

Matthew just rewrote MSI-HOWTO as part of his rework of the MSI code.  It 
might be more helpful now (see 
http://kerneltrap.org/mailarchive/linux-kernel/2008/7/1).

>
> >> Checks is any interrupts are pending are different for MSI.  It may be
> >> not hard to do (it's probably easier than for real interrupts), but it
> >> has to be figured out.  Somebody has to do it right.  Until MSI is
> >> supported by the interrupt handler, it should not be enabled by the
> >> driver, or we get a non-functioning driver for AR5006.
> >
> > Sure, that's fine.  I just wanted to make sure that there weren't some
> > weird generic MSI problems.
>
> I was referring to this post...
> http://lkml.org/lkml/2008/6/24/150

Yeah, that's a real bug on x86; I don't know how widespread its effects are 
though.  I'll ping Ingo & Thomas again.

Jesse
