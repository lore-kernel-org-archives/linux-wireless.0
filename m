Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:43947 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbZDATSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2009 15:18:20 -0400
Received: by ey-out-2122.google.com with SMTP id 4so53237eyf.37
        for <linux-wireless@vger.kernel.org>; Wed, 01 Apr 2009 12:18:16 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: stable@kernel.org
Subject: [PATCH] rt2x00: Fix SLAB corruption during rmmod
Date: Wed, 1 Apr 2009 21:18:11 +0200
Cc: Arnaud Patard <apatard@mandriva.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200904012118.12391.IvDoorn@gmail.com> (sfid-20090401_211825_416755_7CD63706)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Tested-by: Arnaud Patard <apatard@mandriva.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
This patch is for 2.6.29 only. The code in question has completely disa=
ppeared
in 2.6.30 and does not contain this bug.
---
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireles=
s/rt2x00/rt2x00.h
index 39ecf3b..820fdb2 100644
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
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wire=
less/rt2x00/rt2x00dev.c
index 87c0f2c..e694bb7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1105,7 +1105,6 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00=
dev)
 	 * Register extra components.
 	 */
 	rt2x00leds_register(rt2x00dev);
-	rt2x00rfkill_allocate(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
=20
 	set_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
@@ -1137,7 +1136,6 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x=
00dev)
 	 * Free extra components
 	 */
 	rt2x00debug_deregister(rt2x00dev);
-	rt2x00rfkill_free(rt2x00dev);
 	rt2x00leds_unregister(rt2x00dev);
=20
 	/*
diff --git a/drivers/net/wireless/rt2x00/rt2x00lib.h b/drivers/net/wire=
less/rt2x00/rt2x00lib.h
index 86cd26f..49309d4 100644
--- a/drivers/net/wireless/rt2x00/rt2x00lib.h
+++ b/drivers/net/wireless/rt2x00/rt2x00lib.h
@@ -260,8 +260,6 @@ static inline void rt2x00crypto_rx_insert_iv(struct=
 sk_buff *skb,
 #ifdef CONFIG_RT2X00_LIB_RFKILL
 void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev);
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_allocate(struct rt2x00_dev *rt2x00dev);
-void rt2x00rfkill_free(struct rt2x00_dev *rt2x00dev);
 #else
 static inline void rt2x00rfkill_register(struct rt2x00_dev *rt2x00dev)
 {
@@ -270,14 +268,6 @@ static inline void rt2x00rfkill_register(struct rt=
2x00_dev *rt2x00dev)
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
diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/w=
ireless/rt2x00/rt2x00rfkill.c
index 3298cae..08ffc6d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
+++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
@@ -94,14 +94,50 @@ static void rt2x00rfkill_poll(struct work_struct *w=
ork)
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
@@ -117,8 +153,7 @@ void rt2x00rfkill_register(struct rt2x00_dev *rt2x0=
0dev)
=20
 void rt2x00rfkill_unregister(struct rt2x00_dev *rt2x00dev)
 {
-	if (!test_bit(RFKILL_STATE_ALLOCATED, &rt2x00dev->rfkill_state) ||
-	    !test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
+	if (!test_bit(RFKILL_STATE_REGISTERED, &rt2x00dev->rfkill_state))
 		return;
=20
 	cancel_delayed_work_sync(&rt2x00dev->rfkill_work);
@@ -127,46 +162,3 @@ void rt2x00rfkill_unregister(struct rt2x00_dev *rt=
2x00dev)
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
