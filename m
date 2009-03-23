Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:39724 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758387AbZCWP5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 11:57:17 -0400
Received: by fxm2 with SMTP id 2so1863908fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 08:57:14 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH1/2] Fix return value handling
Date: Mon, 23 Mar 2009 16:57:24 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231313.10699.hs4233@mail.mn-solutions.de>
In-Reply-To: <200903231313.10699.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_kF7xJ1mUOPbcj87"
Message-Id: <200903231657.24399.marek.vasut@gmail.com> (sfid-20090323_165805_542487_2F1B272A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_kF7xJ1mUOPbcj87
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
here is a resend. One patch per mail.

--Boundary-00=_kF7xJ1mUOPbcj87
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="0001-Correct-return-value-of-firmware-loading-functions-h.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Correct-return-value-of-firmware-loading-functions-h.patch"

=46rom fd2e610a87a8372cbc513e336fa71e3438742c9d Mon Sep 17 00:00:00 2001
=46rom: Marek Vasut <marek.vasut@gmail.com>
Date: Mon, 23 Mar 2009 15:57:11 +0100
Subject: [PATCH 1/2] Firmware loading functions can return possitive values
 This is not a bug, but take it into consideration and handle it properly.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
=2D--
 drivers/net/wireless/libertas/if_cs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/l=
ibertas/if_cs.c
index 842a08d..3f02e6a 100644
=2D-- a/drivers/net/wireless/libertas/if_cs.c
+++ b/drivers/net/wireless/libertas/if_cs.c
@@ -867,9 +867,9 @@ static int if_cs_probe(struct pcmcia_device *p_dev)
=20
 	/* Load the firmware early, before calling into libertas.ko */
 	ret =3D if_cs_prog_helper(card);
=2D	if (ret =3D=3D 0)
+	if (ret >=3D 0)
 		ret =3D if_cs_prog_real(card);
=2D	if (ret)
+	if (ret < 0)
 		goto out2;
=20
 	/* Make this card known to the libertas driver */
=2D-=20
1.6.2


--Boundary-00=_kF7xJ1mUOPbcj87--
