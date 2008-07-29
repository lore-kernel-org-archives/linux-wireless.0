Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4036 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbYG3AQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 20:16:00 -0400
Date: Tue, 29 Jul 2008 16:53:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 5/6] rfkill: query EV_SW states when rfkill-input
	(re)?connects to a input device
Message-ID: <20080729205315.GB10188@tuxdriver.com> (sfid-20080730_021605_996522_C6B71674)
References: <1216685902-9373-1-git-send-email-hmh@hmh.eng.br> <1216685902-9373-6-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1216685902-9373-6-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 09:18:21PM -0300, Henrique de Moraes Holschuh w=
rote:
> Every time a new input device that is capable of one of the rfkill EV=
_SW events
> (currently only SW_RFKILL_ALL) is connected to rfkill-input, we must =
check the
> states of the input EV_SW switches and take action.  Otherwise, we wi=
ll ignore
> the initial switch state.
>=20
> We also need to re-check the states of the EV_SW switches after a dev=
ice that
> was under an exclusive grab is released back to us, since we got no i=
nput
> events from that device while it was grabbed.
>=20
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>

  CC [M]  net/rfkill/rfkill-input.o
net/rfkill/rfkill-input.c: In function =E2=80=98rfkill_start=E2=80=99:
net/rfkill/rfkill-input.c:201: warning: passing argument 2 of =E2=80=98=
constant_test_bit=E2=80=99 from incompatible pointer type
net/rfkill/rfkill-input.c:201: warning: passing argument 2 of =E2=80=98=
variable_test_bit=E2=80=99 from incompatible pointer type
net/rfkill/rfkill-input.c:202: warning: passing argument 2 of =E2=80=98=
constant_test_bit=E2=80=99 from incompatible pointer type
net/rfkill/rfkill-input.c:202: warning: passing argument 2 of =E2=80=98=
variable_test_bit=E2=80=99 from incompatible pointer type
net/rfkill/rfkill-input.c:203: warning: passing argument 2 of =E2=80=98=
constant_test_bit=E2=80=99 from incompatible pointer type
net/rfkill/rfkill-input.c:203: warning: passing argument 2 of =E2=80=98=
variable_test_bit=E2=80=99 from incompatible pointer type

Don't you need an index for those evbit, swbit, and sw arrays?

--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
