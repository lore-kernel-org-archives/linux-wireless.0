Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:48685 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZD2WLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 18:11:05 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 75CCDD1A833
	for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2009 00:10:59 +0200 (CEST)
Subject: Re: [PATCH 3/5] rt2x00: Fix the interval for rfkill and link_tuner.
From: Alban browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
In-Reply-To: <a32f33a40904281318r7b26e5c2ja5ebefe19ecaa089@mail.gmail.com>
References: <200904261608.30384.IvDoorn@gmail.com>
	 <200904261608.50411.IvDoorn@gmail.com>
	 <200904261609.11447.IvDoorn@gmail.com>
	 <20090428185709.GA3321@tuxdriver.com>
	 <a32f33a40904281318r7b26e5c2ja5ebefe19ecaa089@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Date: Thu, 30 Apr 2009 00:09:32 +0200
Message-Id: <1241042973.14263.489.camel@argos.server.maison> (sfid-20090430_001112_989497_34DD6F8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le mardi 28 avril 2009 =E0 22:18 +0200, Ivo Van Doorn a =E9crit :
> On Tue, Apr 28, 2009 at 8:57 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Sun, Apr 26, 2009 at 04:09:11PM +0200, Ivo van Doorn wrote:
> >> From: Alban Browaeys <prahal@yahoo.com>
> >>
> >> extra parenthesis made the value an argument and the value of the
> >> define empty. This was triggering those very fast.
> >>
> >> Signed-off-by: Alban Browaeys <prahal@yahoo.com>
> >> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> >
> > ???
> >
> > If that were so, wouldn't that have caused compile-time errors?
>=20
> I've CCed Alban so he can explain the issue he experienced..
>=20
> For me this patch is just a style-fix, because those
> parenthesis were useless anyway.

Right this is only style change. Not that when I sent it I thought :
#define A (x)
was like:
#define A(X)()

thus the patch and the comment.

Thankfully it does not hurt though it does not help either . My getting
the issue fixed was that I had EV_KEY  instead of EV_SW for the rfkill
switch. I mixed the results of this test and the one about this patch.

By the way I found out that I had rfkill-input loaded for no good reaso=
n
(only because the debian eeepc acpi support package load it at boot).
If one load it at the same time as rt2800pci crash follows next rfkill
switch.=20
That could be due to the init of the rfkill-input module that register =
a
handler to input subsystem. Its connect operation triggers a start whic=
h
itself triggers the EV_SW,and swbit code of its device. Thus it would
explain that the device is shut down at registration of the
input_register_polled_device. =20
=20

This is minor as on eeepc the status is always on (when off the device
is out of power and thus no status is available) and the rfkill for wla=
n
is already managed by eeepc-laptop platform driver.
One only need not have rfkill-input loaded which is the default on
debian and may be required by other uses .

Regards,
Alban

PS: sorry for the mistake and the time I took to tell about it. Finding
out the real culprit of the crash/invalid behaviour (crash is new ...
reproducible though) took time.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
