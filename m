Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:63355 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYG3Ba3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 21:30:29 -0400
Received: by qw-out-2122.google.com with SMTP id 3so56140qwe.37
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 18:30:27 -0700 (PDT)
Date: Tue, 29 Jul 2008 21:30:25 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 5/6] rfkill: query EV_SW states when rfkill-input
	(re)?connects to a input device
Message-ID: <20080730013024.GB22649@anvil.corenet.prv> (sfid-20080730_033034_752815_A41B4958)
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> <1216685902-9373-6-git-send-email-hmh@hmh.eng.br> <20080729205315.GB10188@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20080729205315.GB10188@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 29, 2008 at 04:53:15PM -0400, John W. Linville wrote:
> On Mon, Jul 21, 2008 at 09:18:21PM -0300, Henrique de Moraes Holschuh=
 wrote:
> > Every time a new input device that is capable of one of the rfkill =
EV_SW events
> > (currently only SW_RFKILL_ALL) is connected to rfkill-input, we mus=
t check the
> > states of the input EV_SW switches and take action.  Otherwise, we =
will ignore
> > the initial switch state.
> >=20
> > We also need to re-check the states of the EV_SW switches after a d=
evice that
> > was under an exclusive grab is released back to us, since we got no=
 input
> > events from that device while it was grabbed.
> >=20
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
>=20
>   CC [M]  net/rfkill/rfkill-input.o
> net/rfkill/rfkill-input.c: In function =E2=80=98rfkill_start=E2=80=99=
:
> net/rfkill/rfkill-input.c:201: warning: passing argument 2 of =E2=80=98=
constant_test_bit=E2=80=99 from incompatible pointer type
> net/rfkill/rfkill-input.c:201: warning: passing argument 2 of =E2=80=98=
variable_test_bit=E2=80=99 from incompatible pointer type
> net/rfkill/rfkill-input.c:202: warning: passing argument 2 of =E2=80=98=
constant_test_bit=E2=80=99 from incompatible pointer type
> net/rfkill/rfkill-input.c:202: warning: passing argument 2 of =E2=80=98=
variable_test_bit=E2=80=99 from incompatible pointer type
> net/rfkill/rfkill-input.c:203: warning: passing argument 2 of =E2=80=98=
constant_test_bit=E2=80=99 from incompatible pointer type
> net/rfkill/rfkill-input.c:203: warning: passing argument 2 of =E2=80=98=
variable_test_bit=E2=80=99 from incompatible pointer type
>=20
> Don't you need an index for those evbit, swbit, and sw arrays?

No, we just need to drop the &:

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index 827f178..e5b6955 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -198,10 +198,10 @@ static void rfkill_start(struct input_handle *han=
dle)
 	 * just fine (which event_lock will also avoid). */
 	spin_lock_irq(&handle->dev->event_lock);
=20
-	if (test_bit(EV_SW, &handle->dev->evbit)) {
-		if (test_bit(SW_RFKILL_ALL, &handle->dev->swbit))
+	if (test_bit(EV_SW, handle->dev->evbit)) {
+		if (test_bit(SW_RFKILL_ALL, handle->dev->swbit))
 			rfkill_schedule_evsw_rfkillall(test_bit(SW_RFKILL_ALL,
-							&handle->dev->sw));
+							handle->dev->sw));
 		/* add resync for further EV_SW events here */
 	}
=20

--=20
Dmitry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
