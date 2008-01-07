Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45237 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbYAGQY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 11:24:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Alejandro Riveira =?utf-8?q?Fern=C3=A1ndez?= <ariveira@gmail.com>
Subject: Re: Linux 2.6.24-rc7
Date: Mon, 7 Jan 2008 17:24:03 +0100
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <20080107171415.19826ea4@Varda>
In-Reply-To: <20080107171415.19826ea4@Varda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801071724.03936.mb@bu3sch.de> (sfid-20080107_162530_204088_BC48B53A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 January 2008 17:14:15 Alejandro Riveira Fern=C3=A1ndez wro=
te:
> El Sun, 6 Jan 2008 14:19:16 -0800 (PST)
> Linus Torvalds <torvalds@linux-foundation.org> escribi=C3=B3:
>=20
> >=20
> > It's been two weeks since rc6, but let's face it, with xmas and new=
 years=20
> > (and birthdays) in between, there hasn't actually been a lot of wor=
king=20
> > days, and the incremental patch from -rc6 is about half the size of=
 the=20
> > one from rc5->rc6.
> >=20
> > And I'll be charitable and claim it's because it's all stabilizing,=
 and=20
> > not because we've all been in a drunken stupor over the holidays.
> >=20
> > The shortlog (appended below) is short and fairly informative. It's=
 all=20
> > really just a lot of rather small changes. The diffstat shows a lot=
 of=20
> > one- and two-liners, with just a few drivers (and the Cell platform=
)=20
> > getting a bit more attention, and the SLUB support of /proc/slabinf=
o=20
> > showing up as a blip.
> >=20
> > Both git trees and tar-balls/patches pushed out, should be mirrorin=
g out=20
> > within minutes. So there are no excuses to not try it out, and see =
if your=20
> > favorite regression has been fixed.
> >=20
> > 		Linus
> >=20
>   Booted with it and I see=20
>=20
>  [   37.043998]                                                      =
                                                        =20
> [   37.043999] Call Trace:                                           =
                                                       =20
> [   37.044001]  <IRQ>  [<ffffffff80227fe3>] enqueue_task+0x13/0x30   =
                                                       =20
> [   37.044040]  [<ffffffff88178cbe>] :mac80211:__ieee80211_rx+0xc7e/0=
xd30                                                   =20
> [   37.044044]  [<ffffffff80228062>] activate_task+0x32/0x50         =
                                                       =20
> [   37.044073]  [<ffffffff8816a28b>] :mac80211:ieee80211_tasklet_hand=
ler+0xbb/0x120                                         =20
> [   37.044086]  [<ffffffff80238d08>] tasklet_action+0x48/0xb0        =
                                                       =20
> [   37.044091]  [<ffffffff80238c09>] __do_softirq+0x69/0xe0          =
                                                       =20
> [   37.044097]  [<ffffffff8020ce2c>] call_softirq+0x1c/0x30          =
                                                       =20
> [   37.044101]  [<ffffffff8020efe5>] do_softirq+0x35/0x90            =
                                                       =20
> [   37.044105]  [<ffffffff80238aa5>] irq_exit+0x95/0xa0              =
                                                       =20
> [   37.044108]  [<ffffffff8020f0c0>] do_IRQ+0x80/0x100               =
                                                       =20
> [   37.044111]  [<ffffffff8020a840>] default_idle+0x0/0x40           =
                                                       =20
> [   37.044115]  [<ffffffff8020c181>] ret_from_intr+0x0/0xa           =
                                                       =20
> [   37.044117]  <EOI>  [<ffffffff8020a869>] default_idle+0x29/0x40   =
                                                       =20
> [   37.044130]  [<ffffffff8020a8f5>] cpu_idle+0x75/0xc0              =
                                                       =20
> [   37.044146]                                                       =
                                                       =20

Can you post the lines above this?
This might be a WARN_ON_ONCE() triggering, for which fixes are on their=
 way into
the wireless-2.6 tree.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
