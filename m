Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:24177 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757359AbYCURKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2008 13:10:47 -0400
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Date: Fri, 21 Mar 2008 10:04:04 -0700
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Richard Purdie <rpurdie@rpsys.net>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	netdev@vger.kernel.org,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	video4linux-list@redhat.com,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	lm-sensors@lm-sensors.org
References: <20080316184349.GA28543@khazad-dum.debian.net> <20080321003604.GC20788@khazad-dum.debian.net> <20080320180802.426ad2d1.akpm@linux-foundation.org>
In-Reply-To: <20080320180802.426ad2d1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200803211004.05106.david-b@pacbell.net> (sfid-20080321_171051_913205_D67751AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 March 2008, Andrew Morton wrote:
> ./drivers/net/usb/pegasus.c
>=20
> =A0 Possibly buggy: deadlockable (I assume)

Looks just unecessary to me ... ethtool MII ops get called from
a task context, as I recall, and other drivers just rely on that.

- Dave

=3D=3D=3D=3D=3D=3D=3D=3D=3D CUT HERE
Remove superfluous in-atomic() check; ethtool MII ops are called
from task context.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/net/usb/pegasus.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- g26.orig/drivers/net/usb/pegasus.c	2008-03-21 08:53:28.000000000 -0=
700
+++ g26/drivers/net/usb/pegasus.c	2008-03-21 08:54:07.000000000 -0700
@@ -1128,12 +1128,8 @@ pegasus_get_settings(struct net_device *
 {
 	pegasus_t *pegasus;
=20
-	if (in_atomic())
-		return 0;
-
 	pegasus =3D netdev_priv(dev);
 	mii_ethtool_gset(&pegasus->mii, ecmd);
-
 	return 0;
 }
=20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
