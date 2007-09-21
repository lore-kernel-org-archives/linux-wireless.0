Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:63701 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762267AbXIUVF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:05:59 -0400
Received: by ug-out-1314.google.com with SMTP id z38so590159ugc
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 14:05:57 -0700 (PDT)
Date: Fri, 21 Sep 2007 17:07:01 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/5] Wireless: Add regdomain support to cfg80211
Message-ID: <20070921210701.GH31768@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pgaa2uWPnPrfixyx"
In-Reply-To: <20070921204606.GD31768@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--Pgaa2uWPnPrfixyx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch makes cfg80211 provide an interface for defining
a central regulatory domain all cfg80211 wireless drivers
should adhere to.

Now when cfg80211 starts up and you will see this:

ieee80211_regdomains: regulatory domain WORLD created
Regulatory Domain:      WORLD   Regulatory Domain ID:   0x03
        IEEE 802.11g    2GHz    ISM subband
        max_ir_ptmp:    20 dBm  max_eirp_ptmp:  20 dBm
        max_ir_ptp:     0 dBm   max_eirp_ptp:   0 dBm
        max_antenna_gain:       6 dBi
        Environment capability: Indoor & Outdoor
                Channel Freq (MHz)
                5       2432
                6       2437
                7       2442

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 include/net/cfg80211.h |   72 ++++++++++++++++++++++++++
 net/wireless/Kconfig   |    1 +
 net/wireless/core.c    |  133 ++++++++++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 206 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1459d12..34fd74b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5,11 +5,13 @@
 #include <linux/skbuff.h>
 #include <linux/nl80211.h>
 #include <net/genetlink.h>
+#include <net/ieee80211_regdomains.h>
=20
 /*
  * 802.11 configuration in-kernel interface
  *
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
  */
=20
 /**
@@ -117,6 +119,73 @@ extern int ieee80211_radiotap_iterator_next(
 struct wiphy;
=20
 /**
+ * enum regdom_set_by - the different ways by which the central regulatory
+ *   domain can be set
+ *
+ * @REG_SET_BY_INIT: indicates regdomain was set by regdomain_init()
+ * @REG_SET_BY_DRIVER: indicates regdomain was set by a driver=20
+ * 	through cfg80211_set_regdomain(). This type of settings is ignored if
+ * 	the regdomain was already set by userspace (%REG_SET_BY_USER). If
+ * 	userspace never set the regdomain and two drivers are found trying to
+ * 	set the regdomain to two different regdomains then the world regulatory
+ * 	domain will be set by cfg80211_set_regdomain().
+ * @REG_SET_BY_USER: indicates regdomain was set by userspace.
+ * @REG_SET_BY_80211D: indicates an 802.11d frame was received with a valid
+ * 	country information element to which the wireless stack is going to
+ * 	adhere to.
+ * @REG_SET_BY_CONFLICT: indicates a conflict was found and regdomain was=
=20
+ * 	therefore set to the world regulatory domain by=20
+ * 	cfg80211_set_regdomain().
+ */
+enum regdom_set_by {
+	REG_SET_BY_INIT =3D 1,
+	REG_SET_BY_DRIVER,
+	REG_SET_BY_USER,
+	REG_SET_BY_80211D,
+	REG_SET_BY_CONFLICT
+};
+
+/**
+ * struct cfg80211_regdomain_settings - central regulatory domain settings
+ *
+ * @regdomain: central regulatory domain, an &ieee80211_regdomain
+ *
+ * @country: country to which this regulatory domain corresponds in the=20
+ * 	last setting. This must be a valid ISO3166-1 country or one of the=20
+ * 	accepted exceptions, such as 00 for the world regulatory domain or=20
+ * 	UK for the United Kingdom.
+ *
+ * @set_by: tells us who set last the regualtory domain. This can be any o=
f=20
+ * 	%regdom_set_by
+ *
+ * @wiphy: wiphy of driver who last set the regdomain, if set by=20
+ * 	driver. This used to determine conflicts of driver regulatory domains=
=20
+ * 	settings if more than one wirless card is present and to simply keep
+ * 	record if a driver set the regulatory domain which driver set it.
+ *
+ * This structure defines the cfg80211 central wireless regulatory domain
+ * structure which all cfg80211 drivers should adhere to. It is initialize=
d to
+ * the world regulatory domain by cfg80211 by default (%REG_SET_BY_INIT). =
If a
+ * wireless driver present has a built-in regulatory domain set either in =
the
+ * EEPROM or firmware it can inform cfg80211 about this and change the=20
+ * regulatory domain as such (%REG_SET_BY_DRIVER). If a second wireless ca=
rd
+ * is present and if there is a conflict between regulatory domains then t=
he
+ * world regulatory domain is set (%REG_SET_BY_CONFLICT). The regulatory d=
omain
+ * can also be changed by receiving an 802.11d frame with a valid country =
code
+ * (%REG_SET_BY_80211D). Finally, If the regulatory domain was set by user=
space
+ * (%REG_SET_BY_USER) then driver specific setting of regulatory domains=
=20
+ * (%REG_SET_BY_DRIVER) and 802.11d frames for changing the regulatory dom=
ain
+ * (%REG_SET_BY_80211D) will be ignored.
+ */
+struct cfg80211_regdomain_settings {
+	struct ieee80211_regdomain *regdomain;
+	enum regdom_set_by set_by;
+	struct wiphy *wiphy;
+	char country[ISOCOUNTRYSIZ2];
+};
+
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -183,6 +252,9 @@ struct cfg80211_ops {
 			   struct key_params *params);
 };
=20
+extern int cfg80211_set_regdomain(char *country, u32,
+				enum regdom_set_by set_by,
+				struct wiphy *wiphy_reg_set);
=20
 /* helper functions specific to nl80211 */
 extern void *nl80211hdr_put(struct sk_buff *skb, u32 pid,
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index c60ee87..0505347 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,5 +1,6 @@
 config CFG80211
         tristate "Improved wireless configuration API"
+	select IEEE80211_REGDOMAINS
=20
 config NL80211
 	bool "nl80211 new netlink interface support"
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 2f3f7b6..c2f773b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -2,6 +2,7 @@
  * This is the linux wireless configuration interface.
  *
  * Copyright 2006, 2007		Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2007		Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
  */
=20
 #include <linux/if.h>
@@ -34,6 +35,14 @@ LIST_HEAD(cfg80211_drv_list);
 DEFINE_MUTEX(cfg80211_drv_mutex);
 static int wiphy_counter;
=20
+/* All cfg80211 drivers adhere to this */
+struct cfg80211_regdomain_settings cfg80211_regdomain;
+EXPORT_SYMBOL(cfg80211_regdomain);
+/* Since the regulatory domain may be set by different events we protect i=
ts
+ * structure */
+DEFINE_MUTEX(cfg80211_regdomain_mutex);
+EXPORT_SYMBOL(cfg80211_regdomain_mutex);
+
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
=20
@@ -335,12 +344,135 @@ static struct notifier_block cfg80211_netdev_notifie=
r =3D {
 	.notifier_call =3D cfg80211_netdev_notifier_call,
 };
=20
+int cfg80211_set_regdomain(char *country, u32 regdomain_id,
+	enum regdom_set_by set_by,=20
+	struct wiphy *wiphy_reg_set)
+{
+	struct ieee80211_regdomain *old_reg, *new_reg;
+	int r =3D 0;
+	enum regdom_set_by old_set_by;
+	int needs_freeing =3D 0;
+
+	mutex_lock(&cfg80211_regdomain_mutex);
+	old_reg =3D cfg80211_regdomain.regdomain;
+	old_set_by =3D cfg80211_regdomain.set_by;
+
+	switch (cfg80211_regdomain.set_by) {
+	case 0:
+		switch (set_by) {
+		case REG_SET_BY_INIT:
+			/* XXX: Test this first */
+			cfg80211_regdomain.set_by =3D REG_SET_BY_INIT;
+			break;
+		default:
+			/* Should not happen unless later we support clearing=20
+			 * of set_by before calling this routine */
+			r =3D -EOPNOTSUPP;
+			goto unlock_and_exit;
+		}
+		break;
+	case REG_SET_BY_INIT:
+		switch (set_by) {
+		case REG_SET_BY_INIT:
+			/* Should never happen */
+			r =3D -EOPNOTSUPP;
+			goto unlock_and_exit;
+		case REG_SET_BY_DRIVER:
+			if (wiphy_reg_set =3D=3D NULL) {
+				r =3D-EINVAL;
+				goto unlock_and_exit;
+			}
+			/* XXX: This is not handled yet */
+			r =3D -EOPNOTSUPP; /* Not handled yet */
+			goto unlock_and_exit;
+		case REG_SET_BY_USER:
+			printk("Userspace changed regulatory domain\n");
+			/* XXX don't free until we know for sure we set
+			 * a new regdomain, then free it and arrange pointers */
+			needs_freeing =3D 1;
+			cfg80211_regdomain.set_by =3D REG_SET_BY_USER;
+			break;
+		default:
+			BUG();
+		}
+		break;
+	case REG_SET_BY_USER:
+		switch (set_by) {
+		case REG_SET_BY_USER:
+			printk("Userspace changed regulatory domain\n");
+			needs_freeing =3D 1;
+			cfg80211_regdomain.set_by =3D REG_SET_BY_USER;
+			break;
+		default:
+			r =3D -EOPNOTSUPP; /* Not handled yet */
+			goto unlock_and_exit;
+		}
+		break;
+	default:
+		r =3D -EOPNOTSUPP; /* Not handled yet */
+		goto unlock_and_exit;
+		break;
+	}
+
+	/* This does all the work */
+	r =3D regdomain_build(regdomain_id, &new_reg);
+	if(r) {
+		cfg80211_regdomain.set_by =3D  old_set_by;
+		goto unlock_and_exit;
+	}
+
+	if (needs_freeing) {
+		free_regdomain(old_reg);
+		cfg80211_regdomain.regdomain =3D NULL;
+	}
+
+	strcpy(cfg80211_regdomain.country, country);
+	cfg80211_regdomain.country[ISOCOUNTRYSIZ2] =3D '\0';
+	/* Lastly, update pointer */
+	cfg80211_regdomain.regdomain =3D new_reg;
+	mutex_unlock(&cfg80211_regdomain_mutex);
+	print_regdomain(cfg80211_regdomain.regdomain);
+
+	return 0;
+
+unlock_and_exit:
+	mutex_unlock(&cfg80211_regdomain_mutex);
+	return r;
+}
+EXPORT_SYMBOL(cfg80211_set_regdomain);
+
+static int regdomain_init(void)
+{
+	int r;
+	char country[ISOCOUNTRYSIZ2] =3D DEFAULT_REG_ISO3166_1;
+	u32 regdomain_id =3D 0; /* Initialize just to shut up GCC */
+
+	country[ISOCOUNTRYSIZ2] =3D '\0';
+
+	memset(&cfg80211_regdomain, 0,=20
+		sizeof(struct cfg80211_regdomain_settings));
+
+	r =3D iso3166_to_reg(country, &regdomain_id);
+	if (r)
+		return r;
+	r =3D cfg80211_set_regdomain(country, regdomain_id,=20
+		REG_SET_BY_INIT, NULL);
+	if (r)
+		return r;
+
+	return 0;
+}
+
 static int cfg80211_init(void)
 {
 	int err =3D wiphy_sysfs_init();
 	if (err)
 		goto out_fail_sysfs;
=20
+	err =3D regdomain_init();
+	if (err)
+		goto out_fail_sysfs;
+
 	err =3D register_netdevice_notifier(&cfg80211_netdev_notifier);
 	if (err)
 		goto out_fail_notifier;
@@ -367,6 +499,7 @@ static void cfg80211_exit(void)
 	debugfs_remove(ieee80211_debugfs_dir);
 	nl80211_exit();
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
+	free_regdomain(cfg80211_regdomain.regdomain);
 	wiphy_sysfs_exit();
 }
 module_exit(cfg80211_exit);
--=20
1.5.2.4


--Pgaa2uWPnPrfixyx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG9DJ1at1JN+IKUl4RAmz8AJ9LcZJfNt73jotjVWJqGJoH+QWXsACfTpXY
ThYl+uqoBQReOiHuGTMi1gY=
=rreb
-----END PGP SIGNATURE-----

--Pgaa2uWPnPrfixyx--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
