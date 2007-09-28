Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60034
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbXI1NjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 09:39:09 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: Error in compilation of b43
Date: Fri, 28 Sep 2007 15:36:32 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <46FC854B.2010500@lwfinger.net> <1190979092.5021.37.camel@johannes.berg> <46FD0342.3020401@lwfinger.net>
In-Reply-To: <46FD0342.3020401@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200709281536.32384.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 September 2007 15:36:02 Larry Finger wrote:
> Johannes Berg wrote:
> > On Thu, 2007-09-27 at 23:38 -0500, Larry Finger wrote:
> >=20
> >> drivers/net/wireless/b43/rfkill.c:112: error: implicit declaration=
 of function =E2=80=98rfkill_get_led_name=E2=80=99
> >> drivers/net/wireless/b43/rfkill.c:112: warning: return makes point=
er from integer without a cast
> >>
> >> I assume that I missed some critical patch. Can you tell me which =
one it is?
> >=20
> > Looks like "[PATCH] rfkill: Add support for an rfkill LED" might be=
 it.
>=20
> That patch fixed the implicit declaration of rfkill_get_led_name, but=
 I still get the other error
>=20
> In file included from drivers/net/wireless/b43/rfkill.c:25:
> drivers/net/wireless/b43/rfkill.h:17: error: field =E2=80=98notify_wo=
rk=E2=80=99 has incomplete type
> drivers/net/wireless/b43/rfkill.c: In function =E2=80=98b43_notify_rf=
kill_press=E2=80=99:
> drivers/net/wireless/b43/rfkill.c:31: warning: type defaults to =E2=80=
=98int=E2=80=99 in declaration of =E2=80=98__mptr=E2=80=99
> drivers/net/wireless/b43/rfkill.c:31: warning: initialization from in=
compatible pointer type

The workqueue is removed by the other patch I just sent.

--=20
Greetings Michael.
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
