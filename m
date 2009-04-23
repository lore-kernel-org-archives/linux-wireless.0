Return-path: <linux-wireless-owner@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Received: from sous-sol.org ([216.99.217.87]:48253 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755369AbZDWH1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 03:27:46 -0400
Message-Id: <20090423072153.855925852@sous-sol.org> (sfid-20090423_092758_754947_FD9BD118)
Date: Thu, 23 Apr 2009 00:20:29 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Ivo van Doorn <ivdoorn@gmail.com>,
	Arnaud Patard <apatard@mandriva.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [patch 009/100] rt2x00: Fix SLAB corruption during rmmod
References: <20090423072020.428683652@sous-sol.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know=
=2E
---------------------

=46rom: Gertjan van Wingerde <gwingerde@gmail.com>

At rmmod stage, the code path is the following one :

rt2x00lib_remove_dev
=C2=A0 -> =C2=A0rt2x00lib_uninitialize()
=C2=A0 =C2=A0 =C2=A0 =C2=A0 -> rt2x00rfkill_unregister()
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-> rfkill_unregister()
=C2=A0 =C2=A0 =C2=A0 =C2=A0 -> rt2x00rfkill_free()
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-> rfkill_free()

The problem is that rfkill_free should not be called after rfkill_regis=
ter
otherwise put_device(&rfkill->dev) will be called 2 times. This patch
fixes this by only calling rt2x00rfkill_free() when rt2x00rfkill_regist=
er()
hasn't been called or has failed.

This patch is for 2.6.29 only. The code in question has completely disa=
ppeared
in 2.6.30 and does not contain this bug.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Tested-by: Arnaud Patard <apatard@mandriva.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/rt2x00/rt2x00.h       |    3 -
 drivers/net/wireless/rt2x00/rt2x00dev.c    |    2=20
 drivers/net/wireless/rt2x00/rt2x00lib.h    |   10 ---
 drivers/net/wireless/rt2x00/rt2x00rfkill.c |   86 +++++++++++++-------=
---------
 4 files changed, 40 insertions(+), 61 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -687,8 +687,7 @@ struct rt2x00_dev {
 	 */
 #ifdef CONFIG_RT2X00_LIB_RFKILL
 	unsigned long rfkill_state;
-#define RFKILL_STATE_ALLOCATED		1
-#define RFKILL_STATE_REGISTERED		2
+#define RFKILL_STATE_REGISTERED		1
 	struct rfkill *rfkill;
 	struct delayed_work rfkill_work;
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1105,7 +1105,6 @@ int rt2x00lib_probe_dev(struct rt2x00_de
 	 * Register extra components.
 	 */
 	rt2x00leds_register(rt2x00dev);
-	rt2x00rfkill_allocate(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
=20
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
@@ -1137,7 +1136,6 @@ void rt2x00lib_remove_dev(struct rt2x00_
 	 * Free extra components
 	 */
 	rt2x00debug_deregister(rt2x00dev);
-	rt2x00rfkill_free(rt2x00dev);
 	rt2x00leds_unregister(rt2x00dev);
=20
 	/*
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -260,8 +260,6 @@ static inline void rt2x00crypto_rx_inser
 #ifdef CONFIG_RT2X00_LIB_RFKILL
 void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
 #else
 static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
@@ -270,14 +268,6 @@ static inline void rt2x00rfkill_register
 static inline void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00de=
v)
 {
 }
-
-static inline void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
-{
-}
-
-static inline void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
-{
-}
 #endif /* CONFIG_RT2X00_LIB_RFKILL */
=20
 /*
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -94,14 +94,50 @@ static void rt2x00rfkill_poll(struct wor
 			   &rt2x00dev->rfkill_work, RFKILL_POLL_INTERVAL);
 }
=20
+static int rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
+{
+	struct device *dev =3D wiphy_dev(rt2x00dev->hw->wiphy);
+
+	rt2x00dev->rfkill =3D rfkill_allocate(dev, RFKILL_TYPE_WLAN);
+	if (!rt2x00dev->rfkill)
+		return -ENOMEM;
+
+	rt2x00dev->rfkill->name =3D rt2x00dev->ops->name;
+	rt2x00dev->rfkill->data =3D rt2x00dev;
+	rt2x00dev->rfkill->toggle_radio =3D rt2x00rfkill_toggle_radio;
+	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags)) {
+		rt2x00dev->rfkill->get_state =3D rt2x00rfkill_get_state;
+		rt2x00dev->rfkill->state =3D
+			rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
+			    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
+	} else {
+		rt2x00dev->rfkill->state =3D RFKILL_STATE_UNBLOCKED;
+	}
+
+	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
+
+	return 0;
+}
+
+static void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
+{
+	rfkill_free(rt2x00dev->rfkill);
+	rt2x00dev->rfkill =3D NULL;
+}
+
 void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
-	    test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
+	if (test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
+		return;
+
+	if (rt2x00rfkill_allocate(rt2x00dev)) {
+		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
 		return;
+	}
=20
 	if (rfkill_register(rt2x00dev->rfkill)) {
 		ERROR(rt2x00dev, "Failed to register rfkill handler.\n");
+		rt2x00rfkill_free(rt2x00dev);
 		return;
 	}
=20
@@ -117,8 +153,7 @@ void rt2x00rfkill_register(struct rt2x00
=20
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
-	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
+	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
=20
 	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
@@ -127,46 +162,3 @@ void rt2x00rfkill_unregister(struct rt2x
=20
 	__clear_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state);
 }
-
-void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev)
-{
-	struct device *dev =3D wiphy_dev(rt2x00dev->hw->wiphy);
-
-	if (test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
-		return;
-
-	rt2x00dev->rfkill =3D rfkill_allocate(dev, RFKILL_TYPE_WLAN);
-	if (!rt2x00dev->rfkill) {
-		ERROR(rt2x00dev, "Failed to allocate rfkill handler.\n");
-		return;
-	}
-
-	__set_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state);
-
-	rt2x00dev->rfkill->name =3D rt2x00dev->ops->name;
-	rt2x00dev->rfkill->data =3D rt2x00dev;
-	rt2x00dev->rfkill->toggle_radio =3D rt2x00rfkill_toggle_radio;
-	if (test_bit(CONFIG_SUPPORT_HW_BUTTON, &rt2x00dev->flags)) {
-		rt2x00dev->rfkill->get_state =3D rt2x00rfkill_get_state;
-		rt2x00dev->rfkill->state =3D
-			rt2x00dev->ops->lib->rfkill_poll(rt2x00dev) ?
-			    RFKILL_STATE_SOFT_BLOCKED : RFKILL_STATE_UNBLOCKED;
-	} else {
-		rt2x00dev->rfkill->state =3D RFKILL_STATE_UNBLOCKED;
-	}
-
-	INIT_DELAYED_WORK(&rt2x00dev->rfkill_work, rt2x00rfkill_poll);
-
-	return;
-}
-
-void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev)
-{
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state))
-		return;
-
-	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
-
-	rfkill_free(rt2x00dev->rfkill);
-	rt2x00dev->rfkill =3D NULL;
-}

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
