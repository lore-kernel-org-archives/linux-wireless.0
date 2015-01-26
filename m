Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:40405 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755183AbbAZR1j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 12:27:39 -0500
Date: Mon, 26 Jan 2015 18:26:17 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] b43: Fix locking FIXME in beacon update top half
Message-ID: <20150126182617.521f58b5@wiggum> (sfid-20150126_182742_736687_D91A0195)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1_TWoUe2oJfBtPyaZQjRKIY"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/1_TWoUe2oJfBtPyaZQjRKIY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

b43 has a FIXME about locking in the mac80211 set-beacon-int callback for a=
 long time.
As it turns out there actually is a tiny race window that could result in
a use-after-free bug of the 'current_beacon' memory.
Nobody ever reported this, so it probably never happened.

Fix this by adding a spin lock that protects the current_beacon access.
We must not be in atomic context while accessing hardware (due to SDIO),
so the beacon update bottom half has to clone the skb and release the lock
before writing it to hardware.

Let's all hope that this stops the troll who is trying to submit incorrect
fixes for this issue repeatedly.
And let's hope that I'm not a troll, too, who just hides even more evil code
in an even more complex attempt to fix the issue.

Signed-off-by: Michael Buesch <m@bues.ch>
Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

---

Index: linux/drivers/net/wireless/b43/b43.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/net/wireless/b43/b43.h
+++ linux/drivers/net/wireless/b43/b43.h
@@ -941,6 +941,7 @@ struct b43_wl {
 	bool beacon1_uploaded;
 	bool beacon_templates_virgin; /* Never wrote the templates? */
 	struct work_struct beacon_update_trigger;
+	spinlock_t beacon_lock;
=20
 	/* The current QOS parameters for the 4 queues. */
 	struct b43_qos_params qos_params[B43_QOS_QUEUE_NUM];
Index: linux/drivers/net/wireless/b43/main.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/drivers/net/wireless/b43/main.c
+++ linux/drivers/net/wireless/b43/main.c
@@ -1601,12 +1601,26 @@ static void b43_write_beacon_template(st
 	unsigned int rate;
 	u16 ctl;
 	int antenna;
-	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(dev->wl->current_beac=
on);
+	struct ieee80211_tx_info *info;
+	unsigned long flags;
+	struct sk_buff *beacon_skb;
=20
-	bcn =3D (const struct ieee80211_mgmt *)(dev->wl->current_beacon->data);
-	len =3D min_t(size_t, dev->wl->current_beacon->len,
-		  0x200 - sizeof(struct b43_plcp_hdr6));
+	spin_lock_irqsave(&dev->wl->beacon_lock, flags);
+	info =3D IEEE80211_SKB_CB(dev->wl->current_beacon);
 	rate =3D ieee80211_get_tx_rate(dev->wl->hw, info)->hw_value;
+	/* Clone the beacon, so it cannot go away, while we write it to hw. */
+	beacon_skb =3D skb_clone(dev->wl->current_beacon, GFP_ATOMIC);
+	spin_unlock_irqrestore(&dev->wl->beacon_lock, flags);
+
+	if (!beacon_skb) {
+		b43dbg(dev->wl, "Could not upload beacon. "
+		       "Failed to clone beacon skb.");
+		return;
+	}
+
+	bcn =3D (const struct ieee80211_mgmt *)(beacon_skb->data);
+	len =3D min_t(size_t, beacon_skb->len,
+		    0x200 - sizeof(struct b43_plcp_hdr6));
=20
 	b43_write_template_common(dev, (const u8 *)bcn,
 				  len, ram_offset, shm_size_offset, rate);
@@ -1674,6 +1688,8 @@ static void b43_write_beacon_template(st
 				B43_SHM_SH_DTIMPER, 0);
 	}
 	b43dbg(dev->wl, "Updated beacon template at 0x%x\n", ram_offset);
+
+	dev_kfree_skb_any(beacon_skb);
 }
=20
 static void b43_upload_beacon0(struct b43_wldev *dev)
@@ -1790,13 +1806,13 @@ static void b43_beacon_update_trigger_wo
 	mutex_unlock(&wl->mutex);
 }
=20
-/* Asynchronously update the packet templates in template RAM.
- * Locking: Requires wl->mutex to be locked. */
+/* Asynchronously update the packet templates in template RAM. */
 static void b43_update_templates(struct b43_wl *wl)
 {
-	struct sk_buff *beacon;
+	struct sk_buff *beacon, *old_beacon;
+	unsigned long flags;
=20
-	/* This is the top half of the ansynchronous beacon update.
+	/* This is the top half of the asynchronous beacon update.
 	 * The bottom half is the beacon IRQ.
 	 * Beacon update must be asynchronous to avoid sending an
 	 * invalid beacon. This can happen for example, if the firmware
@@ -1810,12 +1826,17 @@ static void b43_update_templates(struct
 	if (unlikely(!beacon))
 		return;
=20
-	if (wl->current_beacon)
-		dev_kfree_skb_any(wl->current_beacon);
+	spin_lock_irqsave(&wl->beacon_lock, flags);
+	old_beacon =3D wl->current_beacon;
 	wl->current_beacon =3D beacon;
 	wl->beacon0_uploaded =3D false;
 	wl->beacon1_uploaded =3D false;
+	spin_unlock_irqrestore(&wl->beacon_lock, flags);
+
 	ieee80211_queue_work(wl->hw, &wl->beacon_update_trigger);
+
+	if (old_beacon)
+		dev_kfree_skb_any(old_beacon);
 }
=20
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
@@ -5094,7 +5115,6 @@ static int b43_op_beacon_set_tim(struct
 {
 	struct b43_wl *wl =3D hw_to_b43_wl(hw);
=20
-	/* FIXME: add locking */
 	b43_update_templates(wl);
=20
 	return 0;
@@ -5584,6 +5604,7 @@ static struct b43_wl *b43_wireless_init(
 	wl->hw =3D hw;
 	mutex_init(&wl->mutex);
 	spin_lock_init(&wl->hardirq_lock);
+	spin_lock_init(&wl->beacon_lock);
 	INIT_WORK(&wl->beacon_update_trigger, b43_beacon_update_trigger_work);
 	INIT_WORK(&wl->txpower_adjust_work, b43_phy_txpower_adjust_work);
 	INIT_WORK(&wl->tx_work, b43_tx_work);

--Sig_/1_TWoUe2oJfBtPyaZQjRKIY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxni5AAoJEPUyvh2QjYsOZMgQAIZeOmhbq0LMyRh62E1EwsDt
LEtHqbv2jeooA+gvDVLsGpoBDIQ0zHr1jw0HzXhUL7UnIVxTp/JMxImR+qfMBC3O
h/VvC0XiuKOI37e//GzDDmRaHtlCvKWuefCgDRsCLUc6FgtLubkkDsygTF3xVyyp
G8/JGprzGBmuZXZsc96AxaN+gal7K2KnQM/3gxdlC5d6bXhXN/xPUJezxtYNWyI5
poCHhr2yi2q7QsJbfNTHiNzt//BBQlTzxsB4/Lluzes/+PqsDYPWgMFucwawiG3X
0QyaPWS2h1UUQFZrPkf+den6XE3r3FecsTJEqWIFA+CqVKTVBhyo5GySmTW7opP0
xScY8U4KlDKywRcrhkGxOHc73HufAspQZWvGd95ys/q6a0m+x077ObL0cmGXiCbZ
LruXdYtxYf6uPI0qW0p+TFFaeVTcpx4GKep4R3u/Y4qyPB5llvy+RJ2l10mWw5eR
iFqEhIWgpseZOKlD4XBfTZbL/qmEtiEfCLv4tTqomKWh5ghhmtRly38++XAVSZoJ
5hwKsauL8lhJDg2nA2SY07MdaIGHtKJTqdkdFA5K3gCcwnHm7piNzi8I0bIvg0jE
g9sFqC7KQAaTRLXvQ/EVXn/JBIlSmmq76YtqGBBofY3wbORNKknn/tyfc2TD1jF8
Qnb0XP5yFc1Ai16YXpJd
=4lQJ
-----END PGP SIGNATURE-----

--Sig_/1_TWoUe2oJfBtPyaZQjRKIY--
