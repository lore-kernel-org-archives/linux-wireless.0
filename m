Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:26814 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577AbXIUVQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:16:50 -0400
Received: by an-out-0708.google.com with SMTP id d31so151635and
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 14:16:49 -0700 (PDT)
Date: Fri, 21 Sep 2007 17:17:58 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/5] Wireless: add wireless configfs module - v2
Message-ID: <20070921211757.GJ31768@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rn7IEEq3VEzCw+ji"
In-Reply-To: <20070921204606.GD31768@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Rn7IEEq3VEzCw+ji
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Oops, this patch actually adds congifs_wireless.c ;)

This patch adds a wireless configfs module. Currently we only add
support for changing the central regulatory domain. The idea is not to
replace nl80211 interface but to supplement it and also to give home
for a place for configuring wireless kobjects. We can move add_interface /
remove_interface from sysfs to configfs, for example.

Example usage of using wireles configfs:

mkdir /config/

modprobe configfs_wireless
mount -t configfs none /config
echo US > /config/wireless/country
dmesg -c

You will see:

Userspace changed regulatory domain
ieee80211_regdomains: regulatory domain FCC1A created
Regulatory Domain:      FCC1A   Regulatory Domain ID:   0x10
        IEEE 802.11g    2GHz    ISM subband
        max_ir_ptmp:    30 dBm  max_ir_ptp:     30 dBm
        max_eirp_ptmp:  36 dBm  max_eirp_ptp:   255 dBm
        max_antenna_gain:       6 dBi
        Environment capability: Indoor & Outdoor
                Channel Freq (MHz)
                1       2412
                2       2417
                3       2422
                4       2427
                5       2432
                6       2437
                7       2442
                8       2447
                9       2452
                10      2457
                11      2462
---
 net/wireless/Kconfig  |   11 +++++++++++
 net/wireless/Makefile |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 0505347..59e47ce 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -15,6 +15,17 @@ config NL80211
=20
          If unsure, say Y.
=20
+config CONFIGFS_WIRELESS
+	depends CFG80211 && IEEE80211_REGDOMAINS
+	tristate "Configfs interface for configuring central wireless settings"
+	---help---
+	 You can configure central wireless settings through this subsystem.
+	 It currently only has an ISO3166-1 alpha2 country regulatory domain
+	 settings used to define frequency and power regulatory restrictions
+	 for all wireless cards.
+	=20
+	 If unsure, you can safely say Y.
+
 config IEEE80211_REGDOMAINS
 	tristate "Central IEEE 802.11 regulatory domain agent"
 	select ISO3166_1
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 74c1059..b3f5daa 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_WIRELESS_EXT) +=3D wext.o
 obj-$(CONFIG_CFG80211) +=3D cfg80211.o
+obj-$(CONFIG_CONFIGFS_WIRELESS) +=3D configfs_wireless.o
=20
 cfg80211-y +=3D core.o sysfs.o radiotap.o
 cfg80211-$(CONFIG_NL80211) +=3D nl80211.o
diff --git a/net/wireless/configfs_wireless.c b/net/wireless/configfs_wirel=
ess.c
new file mode 100644
index 0000000..78b5777
--- /dev/null
+++ b/net/wireless/configfs_wireless.c
@@ -0,0 +1,178 @@
+/*
+ * Copyright 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ *
+ * Based on configfs example
+ *
+ * configfs Copyright (C) 2005 Oracle.  All rights reserved.
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#include <linux/configfs.h>
+#include <net/ieee80211_regdomains.h>
+#include <net/cfg80211.h>
+
+/*
+ * Wireless configs subsystem
+ *
+ * You can use this to configure central wireless settings. Currently=20
+ * we only support an ISO3166-1 alpha2 country settting which defines
+ * the central regulatory domain.
+ *
+ */
+
+struct regdomain_settings {
+	struct configfs_subsystem subsys;
+        char country[ISOCOUNTRYSIZ2];
+};
+
+struct regdomain_settings_attribute {
+	struct configfs_attribute attr;
+	ssize_t (*show)(struct regdomain_settings *, char *);
+	ssize_t (*store)(struct regdomain_settings *, const char *, size_t);
+};
+
+static inline struct regdomain_settings *to_regdomain_settings(struct conf=
ig_item *item)
+{
+	return item ? container_of(to_configfs_subsystem(
+		to_config_group(item)), struct regdomain_settings, subsys) :=20
+		NULL;
+}
+
+static ssize_t country_read(struct regdomain_settings *reg,
+				      char *page)
+{
+	return snprintf(page, ISOCOUNTRYSIZ2+1, "%s\n", reg->country);
+}
+
+static ssize_t country_write(struct regdomain_settings *reg_settings,
+				       const char *page,
+				       size_t count)
+{
+	int r;
+	u32 regdomain_id =3D 0;
+	char alpha2[ISOCOUNTRYSIZ2];
+
+	memcpy(alpha2, page, ISOCOUNTRYSIZ2-1);
+	r =3D iso3166_to_reg(alpha2, &regdomain_id);
+	if(r)
+		return r;
+	r =3D cfg80211_set_regdomain(alpha2, regdomain_id,
+		REG_SET_BY_USER, NULL);
+	if (r)
+		return r;
+	memcpy(reg_settings->country, alpha2, ISOCOUNTRYSIZ2);
+	return count;
+}
+
+static struct regdomain_settings_attribute wireless_attr_country =3D {
+	.attr	=3D { .ca_owner =3D THIS_MODULE, .ca_name =3D "country", .ca_mode =
=3D S_IRUGO | S_IWUSR },
+	.show	=3D country_read,
+	.store	=3D country_write,
+};
+
+static struct configfs_attribute *wireless_attrs[] =3D {
+	&wireless_attr_country.attr,
+	NULL,
+};
+
+static ssize_t wireless_attr_show(struct config_item *item,
+				   struct configfs_attribute *attr,
+				   char *page)
+{
+	struct regdomain_settings *reg_settings =3D to_regdomain_settings(item);
+	struct regdomain_settings_attribute *childless_attr =3D
+		container_of(attr, struct regdomain_settings_attribute, attr);
+	ssize_t ret =3D 0;
+
+	if (childless_attr->show)
+		ret =3D childless_attr->show(reg_settings, page);
+	return ret;
+}
+
+static ssize_t wireless_attr_store(struct config_item *item,
+				    struct configfs_attribute *attr,
+				    const char *page, size_t count)
+{
+	struct regdomain_settings *reg_settings =3D to_regdomain_settings(item);
+	struct regdomain_settings_attribute *childless_attr =3D
+		container_of(attr, struct regdomain_settings_attribute, attr);
+	ssize_t ret =3D -EINVAL;
+
+	if (childless_attr->store)
+		ret =3D childless_attr->store(reg_settings, page, count);
+	return ret;
+}
+
+static struct configfs_item_operations wireless_item_ops =3D {
+	.show_attribute		=3D wireless_attr_show,
+	.store_attribute	=3D wireless_attr_store,
+};
+
+static struct config_item_type wireless_type =3D {
+	.ct_item_ops	=3D &wireless_item_ops,
+	.ct_attrs	=3D wireless_attrs,
+	.ct_owner	=3D THIS_MODULE,
+};
+
+static struct regdomain_settings wireless_subsys =3D {
+	.subsys =3D {
+		.su_group =3D {
+			.cg_item =3D {
+				.ci_namebuf =3D "wireless",
+				.ci_type =3D &wireless_type,
+			},
+		},
+	},
+};
+
+static int __init configfs_wireless_init(void)
+{
+	int ret =3D 0;
+	struct configfs_subsystem *subsys =3D &wireless_subsys.subsys;
+	config_group_init(&subsys->su_group);
+	mutex_init(&subsys->su_mutex);
+	ret =3D configfs_register_subsystem(subsys);
+	if (ret) {
+		printk(KERN_ERR "Error %d while registering wireless "
+			"subsystem %s\n", ret,
+		subsys->su_group.cg_item.ci_namebuf);
+		goto out_unregister;
+	}
+	return 0;
+out_unregister:
+	configfs_unregister_subsystem(subsys);
+	return ret;
+}
+
+static void __exit configfs_wireless_exit(void)
+{
+	configfs_unregister_subsystem(&wireless_subsys.subsys);
+}
+
+
+module_init(configfs_wireless_init);
+module_exit(configfs_wireless_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0");
+MODULE_DESCRIPTION("Central configfs interface for all wireless devices");
+MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>");

--Rn7IEEq3VEzCw+ji
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG9DUFat1JN+IKUl4RAgeLAJ9me4Ggvol5fCAXD/DBtY3KtJGZcACeNywr
PfP2koieJfUK286Lo0/ysV0=
=rYoz
-----END PGP SIGNATURE-----

--Rn7IEEq3VEzCw+ji--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
