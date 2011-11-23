Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:57210 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758416Ab1KWGfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 01:35:37 -0500
Date: Wed, 23 Nov 2011 09:34:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] ath6kl: use a larger buffer for debug output
Message-ID: <20111123063450.GA3363@mwanda> (sfid-20111123_073542_341202_E28D166B)
References: <20111118140906.GA9685@elgon.mountain>
 <1321625461.10266.57.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
In-Reply-To: <1321625461.10266.57.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The return value of snprintf() is the number of bytes which would
have been copied if there was enough space, but we want the number of
bytes actually copied.  The scnprintf() function does this.

Also in theory, a %u can take take 10 digits so we may as well make
the buffer larger as well.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2:  I didn't know about the scnprintf() function before.  Thanks
Johannes.

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless=
/ath/ath6kl/debug.c
index 9eff0d0..eb808b4 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1551,10 +1551,10 @@ static ssize_t ath6kl_listen_int_read(struct file *=
file,
 						size_t count, loff_t *ppos)
 {
 	struct ath6kl *ar =3D file->private_data;
-	char buf[16];
+	char buf[32];
 	int len;
=20
-	len =3D snprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
+	len =3D scnprintf(buf, sizeof(buf), "%u %u\n", ar->listen_intvl_t,
 					ar->listen_intvl_b);
=20
 	return simple_read_from_buffer(user_buf, count, ppos, buf, len);

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzJQJAAoJEOnZkXI/YHqRgj4QAIcJRbrQqwFGjVk8nFfadHRZ
NEn/ahbcspLv09hJlMMq65kgGXO32afxuUU9hZronwc0H5M17w8YvWdJXwcyJWA1
4dnb0ucXf1xhvYk5UP/aBJVRtA2A6/WW4rsfTI3JY+B6Ymndccp4ok5rfdkc6v2G
h+pzoULmou01WVKZWtdOECUPIkANYDOE4TJbd0TpzFmxFPXTTPbwUVVyCWtMg/I0
iG6EKLE+kYsqEUCdVrPU1+xki2wqs6On67Zrhc4Q8TlOAPG8XKpHI992UPI6R0Ku
3d4w0pzxVddHJy7P6wEJGG87MXZWzSrD7wg+V57Gtk8RX6NOowBNdAta60l3jai/
dizMG58Bs9YAbK1fDdwBfHMJSEMTiiCNaxU+Q3vhsBLxDwCnVjwg5rz+bovaHAqf
KzFjHBoy9ROZ9gx3WDhL955Z6u52OajMCCFabHjfiPesg7RK/82FZ0vGrAx4/BtJ
EFl8MelpGfqzHR80+RGGLlI+baRAEeP4S9gnm1jE67OxKWZmLMPPsZugTEY6JRNW
XSWbRoI5n6+hSDObvWnrIDZZM9RuLss7ZqeiY4dsnf+wrLq6j6GjEYxwn4bznxq2
LT1enw9se54L8fXvRbCaGaGm+74yiWPGcserDItKvW+poTqcGwqqNKmC9IJePbXH
5FK4RGbIa3NjjbuiPrdq
=jOmf
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
