Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:45233 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935191AbZAOWk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 17:40:58 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Thu, 15 Jan 2009 23:41:02 +0100
Cc: linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <200901152042.42372.chunkeey@web.de> <496F9740.5010109@gmail.com>
In-Reply-To: <496F9740.5010109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200901152341.02130.chunkeey@web.de> (sfid-20090115_234117_205661_38CE16CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 15 January 2009 21:06:24 Artur Skawina wrote:
> Christian Lamparter wrote:
> > On Thursday 15 January 2009 20:12:03 Artur Skawina wrote:
> >>>> Upgraded to current wireless-testing/pending on the problematic =
box
> >>>> and almost immediately got [1]. No slab corruption this time (at=
 least
> >>>> not yet). Will switch to GFP_ATOMIC and retry w/ the new fw.
>=20
> >>> yes that's a bug, p54_set_tim must use GFP_ATOMIC, do you want to=
 post the patch?
> >> nah, too trivial :) fwiw i used this:
> > well, it should be "done", right? :-)
> >=20
> > just add "John W. Linville" <linville@tuxdriver.com>" to the cc,
> > change the subject line to "[PATCH] p54: set_tim must be atomic."
> > and put a Signed-off-by: your name <your@mail> in the mail body and=
 a "---" to seperate the commit message
> > and then the patch. And it will be in the next round of -rcX fixes.
>=20
> well, i really meant the 'too trivial' part and was hoping you'd do i=
t ;)
> ok, will resend.
>=20
well... I'm still looking for an explanation for your other problems:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
BUG kmalloc-4096: Poison overwritten
-----------------------------------------------------------------------=
------

=C2=A0 Object 0xddec18c0: =C2=A06b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk
=C2=A0 Object 0xddec18d0: =C2=A0>69< 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6=
b 6b 6b 6b ikkkkkkkkkkkkkkk
=C2=A0 Object 0xddec18e0: =C2=A06b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b =
6b 6b 6b kkkkkkkkkkkkkkkk

The odd thing is here that it's only a "single" bit in the object flipp=
ed and not more!
And we all have slub/slab debug options enabled as well (in fact, we ha=
d to fix the usbdriver for that,
see patch "p54usb: rewriting rx/tx routines to make use of usb_anchor's=
 facilities" )

can you check your RAM with memtest or something?

--------------------------
Disconnecting/reconnecting the wireless client resulted in this:
> mac80211-phy0: failed to remove key (0, 00:1b:fb:12:34:56) from hardw=
are (-12)
followed later, when killing hostapd, by:
> mac80211-phy0: failed to remove key (1, ff:ff:ff:ff:ff:ff) from hardw=
are (-12)

well, -12 is -ENOMEM. Well we can use GFP_KERNEL in p54_set_key so its =
unlikely that your "box"
doesn't have enough space, but your p54usb device 'itself' has no more =
room left... and
this is unlikely too, so it probably stalled/crashed.

We fixed a something like this before for the 2nd generation devices:
http://www.spinics.net/lists/linux-wireless/msg25692.html

However, I don't know if the net2280 chip on your device needs it or no=
t, but it should hurt if you try it.

Regards,
	Chr
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
