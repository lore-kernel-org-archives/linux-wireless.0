Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:37457 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755221AbZBXXtV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 18:49:21 -0500
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 25 Feb 2009 00:49:18 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
Message-ID: <20090224234918.227050@gmx.net> (sfid-20090225_004937_531802_A458FBB8)
MIME-Version: 1.0
Subject: [PATCH] zd1211rw: Implement get_tsf()
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements get_tsf() of ieee80211_ops in the zd1211rw driver=
=2E

Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
---
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.c b/drivers/net/wire=
less/zd1211rw/zd_chip.c
index f151914..2c813d8 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zd1211rw/zd_chip.c
@@ -1616,3 +1616,24 @@ int zd_chip_set_multicast_hash(struct zd_chip *c=
hip,
=20
 	return zd_iowrite32a(chip, ioreqs, ARRAY_SIZE(ioreqs));
 }
+
+u64 zd_chip_get_tsf(struct zd_chip *chip)
+{
+	int r;
+	static const zd_addr_t aw_pt_bi_addr[] =3D
+		{ CR_TSF_LOW_PART, CR_TSF_HIGH_PART };
+	u32 values[2];
+	u64 tsf;
+
+	mutex_lock(&chip->mutex);
+	r =3D zd_ioread32v_locked(chip, values, (const zd_addr_t *)aw_pt_bi_a=
ddr,
+	                        ARRAY_SIZE(aw_pt_bi_addr));
+	mutex_unlock(&chip->mutex);
+	if (r)
+		return 0;
+
+	tsf =3D values[1];
+	tsf =3D (tsf << 32) | values[0];
+
+	return tsf;
+}
diff --git a/drivers/net/wireless/zd1211rw/zd_chip.h b/drivers/net/wire=
less/zd1211rw/zd_chip.h
index f8c061a..ee42751 100644
--- a/drivers/net/wireless/zd1211rw/zd_chip.h
+++ b/drivers/net/wireless/zd1211rw/zd_chip.h
@@ -950,4 +950,6 @@ static inline void zd_mc_add_addr(struct zd_mc_hash=
 *hash, u8 *addr)
 int zd_chip_set_multicast_hash(struct zd_chip *chip,
 	                       struct zd_mc_hash *hash);
=20
+u64 zd_chip_get_tsf(struct zd_chip *chip);
+
 #endif /* _ZD_CHIP_H */
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wirel=
ess/zd1211rw/zd_mac.c
index 7579af2..1dd58ce 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -935,6 +935,12 @@ static void zd_op_bss_info_changed(struct ieee8021=
1_hw *hw,
 	}
 }
=20
+static u64 zd_op_get_tsf(struct ieee80211_hw *hw)
+{
+	struct zd_mac *mac =3D zd_hw_mac(hw);
+	return zd_chip_get_tsf(&mac->chip);
+}
+
 static const struct ieee80211_ops zd_ops =3D {
 	.tx			=3D zd_op_tx,
 	.start			=3D zd_op_start,
@@ -945,6 +951,7 @@ static const struct ieee80211_ops zd_ops =3D {
 	.config_interface	=3D zd_op_config_interface,
 	.configure_filter	=3D zd_op_configure_filter,
 	.bss_info_changed	=3D zd_op_bss_info_changed,
+	.get_tsf		=3D zd_op_get_tsf,
 };
=20
 struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf)

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
