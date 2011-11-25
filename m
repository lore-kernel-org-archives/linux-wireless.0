Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54508 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab1KYEJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 23:09:55 -0500
Message-ID: <1322194177.2839.292.camel@deadeye> (sfid-20111125_051000_666473_41296414)
Subject: [PATCH v3] x86: Add amilo-rfkill driver for some Fujitsu-Siemens
 Amilo laptops
From: Ben Hutchings <ben@decadent.org.uk>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Martin =?UTF-8?Q?Ve=C4=8De=C5=99a?= <ja@marvec.org>,
	Alejandro Vidal Mata <alex14@gmail.com>,
	Javier Vidal Mata <javitu@gmail.com>,
	Tino Schmidt <mailtinoshomepage@gmx.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	631664@bugs.debian.org
Date: Fri, 25 Nov 2011 04:09:37 +0000
In-Reply-To: <20111122193044.GE5163@srcf.ucam.org>
References: <1321211202.18929.295.camel@deadeye>
	 <20111122193044.GE5163@srcf.ucam.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KcDdLacUKEREeWQYA/z7"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KcDdLacUKEREeWQYA/z7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

An rfkill driver based on the fsaa1655g and fsam7440 drivers for
Fujitsu-Siemens Amilo A1655 and M7440 models found at:

http://sourceforge.net/projects/fsaa1655g/
http://sourceforge.net/projects/fsam7440/

This adds DMI matching, replaces the procfs files with rfkill devices,
and uses the proper functions to write to the i8042 safely.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
Changes from v2:
- Use i8042 functions rather than direct inb()/outb()

Changes from v1:
- Remove module parameter and call to rfkill_init_sw_state()
- Correct Martin's name in copyright banner

On Tue, 2011-11-22 at 19:30 +0000, Matthew Garrett wrote:
> On Sun, Nov 13, 2011 at 07:06:42PM +0000, Ben Hutchings wrote:
> > +#define A1655_STATE_PORT	0x64
> > +#define A1655_COMMAND_PORT	0x64
> > +#define A1655_DATA_PORT		0x60
>=20
> You'll need to synchronise with the i8042 driver here, otherwise things=
=20
> could go horribly wrong.
[...]

You're right, and doing that is rather simpler.

Ben.

 drivers/platform/x86/Kconfig        |    7 ++
 drivers/platform/x86/Makefile       |    1 +
 drivers/platform/x86/amilo-rfkill.c |  173 +++++++++++++++++++++++++++++++=
++++
 3 files changed, 181 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/x86/amilo-rfkill.c

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7f43cf8..cb2c255 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -143,6 +143,13 @@ config FUJITSU_LAPTOP_DEBUG
=20
 	  If you are not sure, say N here.
=20
+config AMILO_RFKILL
+	tristate "Fujitsu-Siemens Amilo rfkill support"
+	depends on RFKILL
+	---help---
+	  This is a driver for enabling wifi on some Fujitsu-Siemens Amilo
+	  laptops.
+
 config TC1100_WMI
 	tristate "HP Compaq TC1100 Tablet WMI Extras (EXPERIMENTAL)"
 	depends on !X86_64
diff --git a/drivers/platform/x86/Makefile b/drivers/platform/x86/Makefile
index 293a320..3acbaad 100644
--- a/drivers/platform/x86/Makefile
+++ b/drivers/platform/x86/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_ACER_WMI)		+=3D acer-wmi.o
 obj-$(CONFIG_ACERHDF)		+=3D acerhdf.o
 obj-$(CONFIG_HP_ACCEL)		+=3D hp_accel.o
 obj-$(CONFIG_HP_WMI)		+=3D hp-wmi.o
+obj-$(CONFIG_AMILO_RFKILL)	+=3D amilo-rfkill.o
 obj-$(CONFIG_TC1100_WMI)	+=3D tc1100-wmi.o
 obj-$(CONFIG_SONY_LAPTOP)	+=3D sony-laptop.o
 obj-$(CONFIG_IDEAPAD_LAPTOP)	+=3D ideapad-laptop.o
diff --git a/drivers/platform/x86/amilo-rfkill.c b/drivers/platform/x86/ami=
lo-rfkill.c
new file mode 100644
index 0000000..19170bb
--- /dev/null
+++ b/drivers/platform/x86/amilo-rfkill.c
@@ -0,0 +1,173 @@
+/*
+ * Support for rfkill on some Fujitsu-Siemens Amilo laptops.
+ * Copyright 2011 Ben Hutchings.
+ *
+ * Based in part on the fsam7440 driver, which is:
+ * Copyright 2005 Alejandro Vidal Mata & Javier Vidal Mata.
+ * and on the fsaa1655g driver, which is:
+ * Copyright 2006 Martin Ve=C4=8De=C5=99a.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/dmi.h>
+#include <linux/i8042.h>
+#include <linux/io.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/rfkill.h>
+
+/*
+ * These values were obtained from disassembling and debugging the
+ * PM.exe program installed in the Fujitsu-Siemens AMILO A1655G
+ */
+#define A1655_WIFI_COMMAND	0x10C5
+#define A1655_WIFI_ON		0x25
+#define A1655_WIFI_OFF		0x45
+
+static int amilo_a1655_rfkill_set_block(void *data, bool blocked)
+{
+	u8 param =3D blocked ? A1655_WIFI_OFF : A1655_WIFI_ON;
+	int rc;
+
+	i8042_lock_chip();
+	rc =3D i8042_command(&param, A1655_WIFI_COMMAND);
+	i8042_unlock_chip();
+	return rc;
+}
+
+static const struct rfkill_ops amilo_a1655_rfkill_ops =3D {
+	.set_block =3D amilo_a1655_rfkill_set_block
+};
+
+/*
+ * These values were obtained from disassembling the PM.exe program
+ * installed in the Fujitsu-Siemens AMILO M 7440
+ */
+#define M7440_PORT1		0x118f
+#define M7440_PORT2		0x118e
+#define M7440_RADIO_ON1		0x12
+#define M7440_RADIO_ON2		0x80
+#define M7440_RADIO_OFF1	0x10
+#define M7440_RADIO_OFF2	0x00
+
+static int amilo_m7440_rfkill_set_block(void *data, bool blocked)
+{
+	u8 val1 =3D blocked ? M7440_RADIO_OFF1 : M7440_RADIO_ON1;
+	u8 val2 =3D blocked ? M7440_RADIO_OFF2 : M7440_RADIO_ON2;
+
+	outb(val1, M7440_PORT1);
+	outb(val2, M7440_PORT2);
+
+	/* Check whether the state has changed correctly */
+	if (inb(M7440_PORT1) !=3D val1 || inb(M7440_PORT2) !=3D val2)
+		return -EIO;
+
+	return 0;
+}
+
+static const struct rfkill_ops amilo_m7440_rfkill_ops =3D {
+	.set_block =3D amilo_m7440_rfkill_set_block
+};
+
+static const struct dmi_system_id __devinitdata amilo_rfkill_id_table[] =
=3D {
+	{
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_BOARD_NAME, "AMILO A1655"),
+		},
+		.driver_data =3D (void *)&amilo_a1655_rfkill_ops
+	},
+	{
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+			DMI_MATCH(DMI_BOARD_NAME, "AMILO M7440"),
+		},
+		.driver_data =3D (void *)&amilo_m7440_rfkill_ops
+	},
+	{}
+};
+
+static struct platform_device *amilo_rfkill_pdev;
+static struct rfkill *amilo_rfkill_dev;
+
+static int __devinit amilo_rfkill_probe(struct platform_device *device)
+{
+	const struct dmi_system_id *system_id =3D
+		dmi_first_match(amilo_rfkill_id_table);
+	int rc;
+
+	amilo_rfkill_dev =3D rfkill_alloc(KBUILD_MODNAME, &device->dev,
+					RFKILL_TYPE_WLAN,
+					system_id->driver_data, NULL);
+	if (!amilo_rfkill_dev)
+		return -ENOMEM;
+
+	rc =3D rfkill_register(amilo_rfkill_dev);
+	if (rc)
+		goto fail;
+
+	return 0;
+
+fail:
+	rfkill_destroy(amilo_rfkill_dev);
+	return rc;
+}
+
+static int amilo_rfkill_remove(struct platform_device *device)
+{
+	rfkill_unregister(amilo_rfkill_dev);
+	rfkill_destroy(amilo_rfkill_dev);
+	return 0;
+}
+
+static struct platform_driver amilo_rfkill_driver =3D {
+	.driver =3D {
+		.name	=3D KBUILD_MODNAME,
+		.owner	=3D THIS_MODULE,
+	},
+	.probe	=3D amilo_rfkill_probe,
+	.remove	=3D amilo_rfkill_remove,
+};
+
+static int __init amilo_rfkill_init(void)
+{
+	int rc;
+
+	if (dmi_first_match(amilo_rfkill_id_table) =3D=3D NULL)
+		return -ENODEV;
+
+	rc =3D platform_driver_register(&amilo_rfkill_driver);
+	if (rc)
+		return rc;
+
+	amilo_rfkill_pdev =3D platform_device_register_simple(KBUILD_MODNAME, -1,
+							    NULL, 0);
+	if (IS_ERR(amilo_rfkill_pdev)) {
+		rc =3D PTR_ERR(amilo_rfkill_pdev);
+		goto fail;
+	}
+
+	return 0;
+
+fail:
+	platform_driver_unregister(&amilo_rfkill_driver);
+	return rc;
+}
+
+static void __exit amilo_rfkill_exit(void)
+{
+	platform_device_unregister(amilo_rfkill_pdev);
+	platform_driver_unregister(&amilo_rfkill_driver);
+}
+
+MODULE_AUTHOR("Ben Hutchings <ben@decadent.org.uk>");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(dmi, amilo_rfkill_id_table);
+
+module_init(amilo_rfkill_init);
+module_exit(amilo_rfkill_exit);
--=20
1.7.7.3

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-KcDdLacUKEREeWQYA/z7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATs8VAee/yOyVhhEJAQpTBxAAlUPa+hinC8o8IrYxIPK9TO8avowYkZy0
URMErfRzPYzN7xz8d3nE0i/kjr/NcmaeA51hGyw/coPrM5aS9nb85S77FZ0iddLc
qSvdlmh7i9Asln4rZQGv6EUe/hTfKNZcLt3S5VjPEy/55VZnpV5AGtuSOEgYFIes
1MrDjm+/VuDwH9AAb0Y5ed7P5iqfv1KosZqeWA9tnJOQbff5T6ZYls+PKT2EH2X+
4R+fns8Faw5NlDOya45rl+9o0QBFnmnlVRBOFR20sK46l7cReh7dZt0Pl3NdGkQB
bF2B+8KM47bZ9Gy4Q6uSCdzZQFjth3KN7qcCbEaYseaArqwDE7WPAN83r4kzSzCL
Z4lalOtyNuts97JKe3YewM4CCtUweKh0Z2aE0dga+6ozzPdmhwYVqxbnz7hSJLT9
GvlYTTQD0Le1M5Cxp5BWAFXalk5ieqC6/pf7dUeu5zU7Bq9wtRUIe7W88rVjzg11
uG6hnXAaorn+0hImKH5ZyaKpXBwT6RPnOrgboSBkvcjr9xb6SqU2N+mgLzTfTxu0
95odd4iRGqJ93EsX3k73Tl3QM6JwLVIZ6FNly83+D7wNLX1xzHP199aAf4KaHvn9
kUgWdBmZ/esUd7UjfMJy4lB/HUgTULqKvZaTygtXkg3OpHiWhpJo3zHKzL73LeAE
+q/3gJSr7NY=
=PoSF
-----END PGP SIGNATURE-----

--=-KcDdLacUKEREeWQYA/z7--
