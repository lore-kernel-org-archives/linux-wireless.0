Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:12963 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbYG3GQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 02:16:17 -0400
Received: by wf-out-1314.google.com with SMTP id 27so334175wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 23:16:16 -0700 (PDT)
Message-ID: <1197ff4c0807292316o53a904d2h5eaa1e8724b14b20@mail.gmail.com> (sfid-20080730_081621_927108_8139B319)
Date: Wed, 30 Jul 2008 14:16:16 +0800
From: YanBo <dreamfly281@gmail.com>
To: ath5k-devel@lists.ath5k.org
Subject: [RFC PATCH] ath5k:mesh support (enable send beacon)
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_41509_15142568.1217398576860"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_41509_15142568.1217398576860
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch enable Ath5k send mesh beacon and found each other, I tested it
between two Atheros cards AR5414/AR5413 and AR2413, it seemed they can send
beacon correctly and ping each other. The kernel I used is pulled from
wireless-testing tree. The HEAD is
a520bdbe7d344296482f9355e29b0018ea58760f (iwl-scan.c: fixup merge
damage in wireless-testing#master)

But in order to make the mesh works, below three patches need to be apply first
1. [ath5k-devel] [PATCH] ath5k: add Mesh Point support
http://marc.info/?l=linux-wireless&m=121632572409109&w=2
2. [ath5k-devel] [PATCH 1/3] Ath5k: fix beacon-update deadlock
http://marc.info/?l=linux-wireless&m=121681221413848&w=2
3. [PATCH] mac80211: fix mesh beaconing
http://marc.info/?l=linux-wireless&m=121735468220792&w=2

Something need to be notice:
1: In ath5k ADHOC mode the TSF will be dynamic adjusted, but in Mesh
mode, it is not be
done. In my opinion the mesh node need adjust TSF too (CMIIW).
2: The default beacon intval is 1000ms, we can change it in base.c
ath5k_config_interface() . ( or there is any command or tools can be
used to do this, I don't know :) )
3: After input "iw dev mesh station dump" it will trigger a lock
problem(attach is the warning info).
4: In my test after send 7 ping packets, the kernel will crash for
some reason. (After I get a serial console line, will report more
detail of it or send a patch if I can figure them out)


Signed-off-by: Li YanBo <dreamfly281@gmail.com>

drivers/net/wireless/ath5k/base.c |   31 +++++++++++++++++++++----------
1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index 16c19ce..a56a4d5 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1810,7 +1810,8 @@ accept:
 		ath5k_debug_dump_skb(sc, skb, "RX  ", 0);

 		/* check beacons in IBSS mode */
-		if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+		if (sc->opmode == IEEE80211_IF_TYPE_IBSS ||
+		    sc->opmode == IEEE80211_IF_TYPE_MESH_POINT)
 			ath5k_check_ibss_tsf(sc, skb, &rxs);

 		__ieee80211_rx(sc->hw, skb, &rxs);
@@ -1927,7 +1928,9 @@ ath5k_beacon_setup(struct ath5k_softc *sc,
struct ath5k_buf *bf)
 	ds = bf->desc;

 	flags = AR5K_TXDESC_NOACK;
-	if (sc->opmode == IEEE80211_IF_TYPE_IBSS && ath5k_hw_hasveol(ah)) {
+	if ((sc->opmode == IEEE80211_IF_TYPE_IBSS ||
+	     sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) &&
+	    ath5k_hw_hasveol(ah)) {
 		ds->ds_link = bf->daddr;	/* self-linked */
 		flags |= AR5K_TXDESC_VEOL;
 		/*
@@ -2154,7 +2157,8 @@ ath5k_beacon_config(struct ath5k_softc *sc)

 	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
 		sc->imask |= AR5K_INT_BMISS;
-	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+	} else if (sc->opmode == IEEE80211_IF_TYPE_IBSS ||
+		   sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) {
 		/*
 		 * In IBSS mode we use a self-linked tx descriptor and let the
 		 * hardware send the beacons automatically. We have to load it
@@ -2163,11 +2167,15 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 		 * timers in order to detect automatic TSF updates.
 		 */
 		ath5k_beaconq_config(sc);
-
-		sc->imask |= AR5K_INT_SWBA;
+		if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+			sc->imask |= AR5K_INT_SWBA;	

 		if (ath5k_hw_hasveol(ah))
 			ath5k_beacon_send(sc);
+
+		/* set the beacon timer */
+		if (sc->opmode == IEEE80211_IF_TYPE_MESH_POINT)
+			ath5k_beacon_update_timers(sc, 0);
 	}
 	/* TODO else AP */

@@ -2720,6 +2728,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 	case IEEE80211_IF_TYPE_MNTR:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		sc->opmode = conf->type;
 		break;
 	default:
@@ -2787,7 +2796,7 @@ ath5k_config_interface(struct ieee80211_hw *hw,
struct ieee80211_vif *vif,
 	}

 	if (conf->changed & IEEE80211_IFCC_BEACON &&
-	    vif->type == IEEE80211_IF_TYPE_IBSS) {
+	    (vif->type == IEEE80211_IF_TYPE_IBSS || ieee80211_vif_is_mesh(vif))) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 		if (!beacon) {
 			ret = -ENOMEM;
@@ -2916,7 +2925,8 @@ static void ath5k_configure_filter(struct
ieee80211_hw *hw,
 		test_bit(ATH_STAT_PROMISC, sc->status))
 		rfilt |= AR5K_RX_FILTER_PROM;
 	if (sc->opmode == IEEE80211_IF_TYPE_STA ||
-		sc->opmode == IEEE80211_IF_TYPE_IBSS) {
+	    sc->opmode == IEEE80211_IF_TYPE_IBSS ||
+	    sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) {
 		rfilt |= AR5K_RX_FILTER_BEACON;
 	}

@@ -3020,7 +3030,8 @@ ath5k_reset_tsf(struct ieee80211_hw *hw)
 	 * in IBSS mode we need to update the beacon timers too.
 	 * this will also reset the TSF if we call it with 0
 	 */
-	if (sc->opmode == IEEE80211_IF_TYPE_IBSS)
+	if (sc->opmode == IEEE80211_IF_TYPE_IBSS ||
+	    sc->opmode == IEEE80211_IF_TYPE_MESH_POINT)
 		ath5k_beacon_update_timers(sc, 0);
 	else
 		ath5k_hw_reset_tsf(sc->ah);
@@ -3034,8 +3045,8 @@ ath5k_beacon_update(struct ieee80211_hw *hw,
struct sk_buff *skb)

 	ath5k_debug_dump_skb(sc, skb, "BC  ", 1);

-
-	if (sc->opmode != IEEE80211_IF_TYPE_IBSS) {
+ 	if (sc->opmode != IEEE80211_IF_TYPE_IBSS &&
+ 	    sc->opmode != IEEE80211_IF_TYPE_MESH_POINT) {		
 		ret = -EIO;
 		goto end;
 	}

------=_Part_41509_15142568.1217398576860
Content-Type: text/plain; name=iw-trigger-lock-info.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fj9jaqil0
Content-Disposition: attachment; filename=iw-trigger-lock-info.txt

QWZ0ZXIgaW5wdXQgIml3IGRldiBtZXNoIHN0YXRpb24gZHVtcCIgaXQgd2lsbCB0cmlnZ2VyIGJl
bG93IHByb2JsZW0NClsgIDc2Mi45Njg2NzldID09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT0NClsgIDc2Mi45Njg2ODddIFsgSU5GTzogcG9zc2li
bGUgY2lyY3VsYXIgbG9ja2luZyBkZXBlbmRlbmN5IGRldGVjdGVkIF0NClsgIDc2Mi45Njg2OTFd
IDIuNi4yNi13bC0xNDIxMS1nMjk4NjUzNy1kaXJ0eSAjMzINClsgIDc2Mi45Njg2OTRdIC0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NClsgIDc2
Mi45Njg2OTddIGl3LzcxODggaXMgdHJ5aW5nIHRvIGFjcXVpcmUgbG9jazoNClsgIDc2Mi45Njg3
MDFdICAocnRubF9tdXRleCl7LS0uLn0sIGF0OiBbPGMwNGJiNDMwPl0gbmw4MDIxMV9kdW1wX3N0
YXRpb24rMHgxNDAvMHgxZTANClsgIDc2Mi45Njg3MTNdIA0KWyAgNzYyLjk2ODcxNF0gYnV0IHRh
c2sgaXMgYWxyZWFkeSBob2xkaW5nIGxvY2s6DQpbICA3NjIuOTY4NzE3XSAgKCZkcnYtPmRldmxp
c3RfbXR4KXstLS4ufSwgYXQ6IFs8YzA0YmIzOTA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweGEw
LzB4MWUwDQpbICA3NjIuOTY4NzI1XSANClsgIDc2Mi45Njg3MjZdIHdoaWNoIGxvY2sgYWxyZWFk
eSBkZXBlbmRzIG9uIHRoZSBuZXcgbG9jay4NClsgIDc2Mi45Njg3MjhdIA0KWyAgNzYyLjk2ODcz
MV0gDQpbICA3NjIuOTY4NzMxXSB0aGUgZXhpc3RpbmcgZGVwZW5kZW5jeSBjaGFpbiAoaW4gcmV2
ZXJzZSBvcmRlcikgaXM6DQpbICA3NjIuOTY4NzM1XSANClsgIDc2Mi45Njg3MzZdIC0+ICMxICgm
ZHJ2LT5kZXZsaXN0X210eCl7LS0uLn06DQpbICA3NjIuOTY4NzQyXSAgICAgICAgWzxjMDEzZDhm
Nj5dIGFkZF9sb2NrX3RvX2xpc3QrMHg0Ni8weGMwDQpbICA3NjIuOTY4NzU1XSAgICAgICAgWzxj
MDE0MTA0Yj5dIF9fbG9ja19hY3F1aXJlKzB4YmRiLzB4MTA2MA0KWyAgNzYyLjk2ODc2N10gICAg
ICAgIFs8YzA0YjkzODI+XSBjZmc4MDIxMV9uZXRkZXZfbm90aWZpZXJfY2FsbCsweDcyLzB4MTEw
DQpbICA3NjIuOTY4Nzc4XSAgICAgICAgWzxjMDEzZGEwZD5dIGdldF9sb2NrX3N0YXRzKzB4ZC8w
eDMwDQpbICA3NjIuOTY4Nzg5XSAgICAgICAgWzxjMDE0MTU1Nj5dIGxvY2tfYWNxdWlyZSsweDg2
LzB4YjANClsgIDc2Mi45Njg4MDBdICAgICAgICBbPGMwNGI5MzgyPl0gY2ZnODAyMTFfbmV0ZGV2
X25vdGlmaWVyX2NhbGwrMHg3Mi8weDExMA0KWyAgNzYyLjk2ODgxMV0gICAgICAgIFs8YzA0ZWVk
MTE+XSBtdXRleF9sb2NrX25lc3RlZCsweDkxLzB4MmEwDQpbICA3NjIuOTY4ODIzXSAgICAgICAg
WzxjMDRiOTM4Mj5dIGNmZzgwMjExX25ldGRldl9ub3RpZmllcl9jYWxsKzB4NzIvMHgxMTANClsg
IDc2Mi45Njg4MzRdICAgICAgICBbPGMwNGI5MzgyPl0gY2ZnODAyMTFfbmV0ZGV2X25vdGlmaWVy
X2NhbGwrMHg3Mi8weDExMA0KWyAgNzYyLjk2ODg0NV0gICAgICAgIFs8YzA0YjkzODI+XSBjZmc4
MDIxMV9uZXRkZXZfbm90aWZpZXJfY2FsbCsweDcyLzB4MTEwDQpbICA3NjIuOTY4ODU2XSAgICAg
ICAgWzxjMDEzODAxMD5dIG5vdGlmaWVyX2NhbGxfY2hhaW4rMHgzMC8weDYwDQpbICA3NjIuOTY4
ODY2XSAgICAgICAgWzxjMDEzODA4Nz5dIHJhd19ub3RpZmllcl9jYWxsX2NoYWluKzB4MTcvMHgy
MA0KWyAgNzYyLjk2ODg3N10gICAgICAgIFs8YzA0MTkwOWQ+XSByZWdpc3Rlcl9uZXRkZXZpY2Ur
MHgyNWQvMHgzOTANClsgIDc2Mi45Njg4ODldICAgICAgICBbPGMwNGJkZjYzPl0gaWVlZTgwMjEx
X3JlZ2lzdGVyX2h3KzB4MWIzLzB4MmQwDQpbICA3NjIuOTY4OTAwXSAgICAgICAgWzxmODg2NGYz
OT5dIGF0aDVrX3BjaV9wcm9iZSsweDgzOS8weGZkMCBbYXRoNWtdDQpbICA3NjIuOTY4OTIwXSAg
ICAgICAgWzxjMDI3NmFiYT5dIF9hdG9taWNfZGVjX2FuZF9sb2NrKzB4MmEvMHg0MA0KWyAgNzYy
Ljk2ODkzM10gICAgICAgIFs8YzAyODg0OTY+XSBwY2lfZGV2aWNlX3Byb2JlKzB4NTYvMHg4MA0K
WyAgNzYyLjk2ODk0NV0gICAgICAgIFs8YzAzMDQ4ODE+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4
ODEvMHgxNzANClsgIDc2Mi45Njg5NTddICAgICAgICBbPGMwMTNmZjkxPl0gdHJhY2VfaGFyZGly
cXNfb24rMHhiMS8weDE0MA0KWyAgNzYyLjk2ODk2OF0gICAgICAgIFs8YzAzMDQ5ZTI+XSBfX2Ry
aXZlcl9hdHRhY2grMHg3Mi8weDgwDQpbICA3NjIuOTY4OTc5XSAgICAgICAgWzxjMDMwM2Y0Yz5d
IGJ1c19mb3JfZWFjaF9kZXYrMHgzYy8weDYwDQpbICA3NjIuOTY4OTkwXSAgICAgICAgWzxjMDMw
NDZlNj5dIGRyaXZlcl9hdHRhY2grMHgxNi8weDIwDQpbICA3NjIuOTY5MDAxXSAgICAgICAgWzxj
MDMwNDk3MD5dIF9fZHJpdmVyX2F0dGFjaCsweDAvMHg4MA0KWyAgNzYyLjk2OTAxMV0gICAgICAg
IFs8YzAzMDQzOWY+XSBidXNfYWRkX2RyaXZlcisweGFmLzB4MjIwDQpbICA3NjIuOTY5MDIyXSAg
ICAgICAgWzxjMDI4ODNlMD5dIHBjaV9kZXZpY2VfcmVtb3ZlKzB4MC8weDQwDQpbICA3NjIuOTY5
MDMzXSAgICAgICAgWzxjMDMwNGI1ZD5dIGRyaXZlcl9yZWdpc3RlcisweDRkLzB4MTIwDQpbICA3
NjIuOTY5MDQ0XSAgICAgICAgWzxjMDI4MGI3Mj5dIF9fc3Bpbl9sb2NrX2luaXQrMHgzMi8weDcw
DQpbICA3NjIuOTY5MDU1XSAgICAgICAgWzxjMDI4ODZkYj5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZl
cisweDRiLzB4OTANClsgIDc2Mi45NjkwNjZdICAgICAgICBbPGY4ODc1MDFkPl0gMHhmODg3NTAx
ZA0KWyAgNzYyLjk2OTA3NV0gICAgICAgIFs8YzAxNDgzNjM+XSBzeXNfaW5pdF9tb2R1bGUrMHgx
MTMvMHgxOGIwDQpbICA3NjIuOTY5MDg3XSAgICAgICAgWzxjMDE0MDZmMz5dIF9fbG9ja19hY3F1
aXJlKzB4MjgzLzB4MTA2MA0KWyAgNzYyLjk2OTA5OF0gICAgICAgIFs8YzAyODQwOTA+XSBwY2lf
YnVzX3JlYWRfY29uZmlnX2J5dGUrMHgwLzB4ODANClsgIDc2Mi45NjkxMDldICAgICAgICBbPGMw
MTAzZDdkPl0gc3lzZW50ZXJfcGFzdF9lc3ArMHg2YS8weGIxDQpbICA3NjIuOTY5MTIxXSAgICAg
ICAgWzxmZmZmZmZmZj5dIDB4ZmZmZmZmZmYNClsgIDc2Mi45NjkxNDVdIA0KWyAgNzYyLjk2OTE0
Nl0gLT4gIzAgKHJ0bmxfbXV0ZXgpey0tLi59Og0KWyAgNzYyLjk2OTE1MV0gICAgICAgIFs8YzAx
M2UyMTA+XSBwcmludF9jaXJjdWxhcl9idWdfZW50cnkrMHg0MC8weDUwDQpbICA3NjIuOTY5MTYy
XSAgICAgICAgWzxjMDE0MGU1OD5dIF9fbG9ja19hY3F1aXJlKzB4OWU4LzB4MTA2MA0KWyAgNzYy
Ljk2OTE3NF0gICAgICAgIFs8YzA0YmIzOTA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweGEwLzB4
MWUwDQpbICA3NjIuOTY5MTg0XSAgICAgICAgWzxjMDEzZGEzYT5dIHB1dF9sb2NrX3N0YXRzKzB4
YS8weDIwDQpbICA3NjIuOTY5MTk1XSAgICAgICAgWzxjMDE0MTU1Nj5dIGxvY2tfYWNxdWlyZSsw
eDg2LzB4YjANClsgIDc2Mi45NjkyMDddICAgICAgICBbPGMwNGJiNDMwPl0gbmw4MDIxMV9kdW1w
X3N0YXRpb24rMHgxNDAvMHgxZTANClsgIDc2Mi45NjkyMTddICAgICAgICBbPGMwNGVlZDExPl0g
bXV0ZXhfbG9ja19uZXN0ZWQrMHg5MS8weDJhMA0KWyAgNzYyLjk2OTIyOV0gICAgICAgIFs8YzA0
YmI0MzA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweDE0MC8weDFlMA0KWyAgNzYyLjk2OTIzOV0g
ICAgICAgIFs8YzA0YmI0MzA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweDE0MC8weDFlMA0KWyAg
NzYyLjk2OTI1MF0gICAgICAgIFs8YzA0YmI0MzA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweDE0
MC8weDFlMA0KWyAgNzYyLjk2OTI1OF0gICAgICAgIFs8YzAxM2ZlMTg+XSBtYXJrX2hlbGRfbG9j
a3MrMHgzOC8weDcwDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDRlZWUzZj5dIG11dGV4X2xv
Y2tfbmVzdGVkKzB4MWJmLzB4MmEwDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDQyNzA5MD5d
IG5ldGxpbmtfZHVtcCsweDQwLzB4MWIwDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDQyNzBh
NT5dIG5ldGxpbmtfZHVtcCsweDU1LzB4MWIwDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDQy
OTJmMD5dIG5ldGxpbmtfZHVtcF9zdGFydCsweDEzMC8weDE1MA0KWyAgNzYyLjk2OTI1OF0gICAg
ICAgIFs8YzA0MmFkNzE+XSBnZW5sX3Jjdl9tc2crMHhjMS8weDFiMA0KWyAgNzYyLjk2OTI1OF0g
ICAgICAgIFs8YzA0YmIyZjA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweDAvMHgxZTANClsgIDc2
Mi45NjkyNThdICAgICAgICBbPGMwNDJhMmNmPl0gZ2VubF9yY3YrMHhmLzB4MzANClsgIDc2Mi45
NjkyNThdICAgICAgICBbPGMwNDJhMmNmPl0gZ2VubF9yY3YrMHhmLzB4MzANClsgIDc2Mi45Njky
NThdICAgICAgICBbPGMwNDJhY2IwPl0gZ2VubF9yY3ZfbXNnKzB4MC8weDFiMA0KWyAgNzYyLjk2
OTI1OF0gICAgICAgIFs8YzA0MjgxYTY+XSBuZXRsaW5rX3Jjdl9za2IrMHg2Ni8weDkwDQpbICA3
NjIuOTY5MjU4XSAgICAgICAgWzxjMDQyYTJkYj5dIGdlbmxfcmN2KzB4MWIvMHgzMA0KWyAgNzYy
Ljk2OTI1OF0gICAgICAgIFs8YzA0MjdmNTc+XSBuZXRsaW5rX3VuaWNhc3QrMHgyNDcvMHgyODAN
ClsgIDc2Mi45NjkyNThdICAgICAgICBbPGMwMjdkMzA4Pl0gY29weV9mcm9tX3VzZXIrMHgzOC8w
eDgwDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDQyODhlNT5dIG5ldGxpbmtfc2VuZG1zZysw
eDFlNS8weDI5MA0KWyAgNzYyLjk2OTI1OF0gICAgICAgIFs8YzA0MGM3NmQ+XSBzb2NrX3NlbmRt
c2crMHhjZC8weDEwMA0KWyAgNzYyLjk2OTI1OF0gICAgICAgIFs8YzAxMzQxMDA+XSBhdXRvcmVt
b3ZlX3dha2VfZnVuY3Rpb24rMHgwLzB4NDANClsgIDc2Mi45NjkyNThdICAgICAgICBbPGMwMTNm
ZjkxPl0gdHJhY2VfaGFyZGlycXNfb24rMHhiMS8weDE0MA0KWyAgNzYyLjk2OTI1OF0gICAgICAg
IFs8YzAyN2QzMDg+XSBjb3B5X2Zyb21fdXNlcisweDM4LzB4ODANClsgIDc2Mi45NjkyNThdICAg
ICAgICBbPGMwNDE0NzlhPl0gdmVyaWZ5X2lvdmVjKzB4MmEvMHg5MA0KWyAgNzYyLjk2OTI1OF0g
ICAgICAgIFs8YzA0MGM4Zjk+XSBzeXNfc2VuZG1zZysweDE1OS8weDI3MA0KWyAgNzYyLjk2OTI1
OF0gICAgICAgIFs8YzAxNDA2ZjM+XSBfX2xvY2tfYWNxdWlyZSsweDI4My8weDEwNjANClsgIDc2
Mi45NjkyNThdICAgICAgICBbPGMwMTA5NTFhPl0gbmF0aXZlX3NjaGVkX2Nsb2NrKzB4N2EvMHhi
MA0KWyAgNzYyLjk2OTI1OF0gICAgICAgIFs8YzAxMDk1MWE+XSBuYXRpdmVfc2NoZWRfY2xvY2sr
MHg3YS8weGIwDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDQwZGJmMj5dIHN5c19zb2NrZXRj
YWxsKzB4ODIvMHgyODANClsgIDc2Mi45NjkyNThdICAgICAgICBbPGMwMTAzZGI4Pl0gc3lzZW50
ZXJfcGFzdF9lc3ArMHhhNS8weGIxDQpbICA3NjIuOTY5MjU4XSAgICAgICAgWzxjMDEwM2RiOD5d
IHN5c2VudGVyX3Bhc3RfZXNwKzB4YTUvMHhiMQ0KWyAgNzYyLjk2OTI1OF0gICAgICAgIFs8YzAx
MDNkN2Q+XSBzeXNlbnRlcl9wYXN0X2VzcCsweDZhLzB4YjENClsgIDc2Mi45NjkyNThdICAgICAg
ICBbPGZmZmZmZmZmPl0gMHhmZmZmZmZmZg0KWyAgNzYyLjk2OTI1OF0gDQpbICA3NjIuOTY5MjU4
XSBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOg0KWyAgNzYyLjk2OTI1
OF0gDQpbICA3NjIuOTY5MjU4XSAzIGxvY2tzIGhlbGQgYnkgaXcvNzE4ODoNClsgIDc2Mi45Njky
NThdICAjMDogIChnZW5sX211dGV4KXstLS4ufSwgYXQ6IFs8YzA0MjcwOTA+XSBuZXRsaW5rX2R1
bXArMHg0MC8weDFiMA0KWyAgNzYyLjk2OTI1OF0gICMxOiAgKGNmZzgwMjExX2Rydl9tdXRleCl7
LS0uLn0sIGF0OiBbPGMwNGJiMzFlPl0gbmw4MDIxMV9kdW1wX3N0YXRpb24rMHgyZS8weDFlMA0K
WyAgNzYyLjk2OTI1OF0gICMyOiAgKCZkcnYtPmRldmxpc3RfbXR4KXstLS4ufSwgYXQ6IFs8YzA0
YmIzOTA+XSBubDgwMjExX2R1bXBfc3RhdGlvbisweGEwLzB4MWUwDQpbICA3NjIuOTY5MjU4XSAN
ClsgIDc2Mi45NjkyNThdIHN0YWNrIGJhY2t0cmFjZToNClsgIDc2Mi45NjkyNThdIFBpZDogNzE4
OCwgY29tbTogaXcgTm90IHRhaW50ZWQgMi42LjI2LXdsLTE0MjExLWcyOTg2NTM3LWRpcnR5ICMz
Mg0KWyAgNzYyLjk2OTI1OF0gIFs8YzAxM2ViNWE+XSBwcmludF9jaXJjdWxhcl9idWdfdGFpbCsw
eDdhLzB4OTANClsgIDc2Mi45NjkyNThdICBbPGMwMTQwZTU4Pl0gX19sb2NrX2FjcXVpcmUrMHg5
ZTgvMHgxMDYwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDRiYjM5MD5dIG5sODAyMTFfZHVtcF9zdGF0
aW9uKzB4YTAvMHgxZTANClsgIDc2Mi45NjkyNThdICBbPGMwMTNkYTNhPl0gcHV0X2xvY2tfc3Rh
dHMrMHhhLzB4MjANClsgIDc2Mi45NjkyNThdICBbPGMwMTQxNTU2Pl0gbG9ja19hY3F1aXJlKzB4
ODYvMHhiMA0KWyAgNzYyLjk2OTI1OF0gIFs8YzA0YmI0MzA+XSBubDgwMjExX2R1bXBfc3RhdGlv
bisweDE0MC8weDFlMA0KWyAgNzYyLjk2OTI1OF0gIFs8YzA0ZWVkMTE+XSBtdXRleF9sb2NrX25l
c3RlZCsweDkxLzB4MmEwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDRiYjQzMD5dIG5sODAyMTFfZHVt
cF9zdGF0aW9uKzB4MTQwLzB4MWUwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDRiYjQzMD5dIG5sODAy
MTFfZHVtcF9zdGF0aW9uKzB4MTQwLzB4MWUwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDRiYjQzMD5d
IG5sODAyMTFfZHVtcF9zdGF0aW9uKzB4MTQwLzB4MWUwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDEz
ZmUxOD5dIG1hcmtfaGVsZF9sb2NrcysweDM4LzB4NzANClsgIDc2Mi45NjkyNThdICBbPGMwNGVl
ZTNmPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHgxYmYvMHgyYTANClsgIDc2Mi45NjkyNThdICBbPGMw
NDI3MDkwPl0gbmV0bGlua19kdW1wKzB4NDAvMHgxYjANClsgIDc2Mi45NjkyNThdICBbPGMwNDI3
MGE1Pl0gbmV0bGlua19kdW1wKzB4NTUvMHgxYjANClsgIDc2Mi45NjkyNThdICBbPGMwNDI5MmYw
Pl0gbmV0bGlua19kdW1wX3N0YXJ0KzB4MTMwLzB4MTUwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDQy
YWQ3MT5dIGdlbmxfcmN2X21zZysweGMxLzB4MWIwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDRiYjJm
MD5dIG5sODAyMTFfZHVtcF9zdGF0aW9uKzB4MC8weDFlMA0KWyAgNzYyLjk2OTI1OF0gIFs8YzA0
MmEyY2Y+XSBnZW5sX3JjdisweGYvMHgzMA0KWyAgNzYyLjk2OTI1OF0gIFs8YzA0MmEyY2Y+XSBn
ZW5sX3JjdisweGYvMHgzMA0KWyAgNzYyLjk2OTI1OF0gIFs8YzA0MmFjYjA+XSBnZW5sX3Jjdl9t
c2crMHgwLzB4MWIwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDQyODFhNj5dIG5ldGxpbmtfcmN2X3Nr
YisweDY2LzB4OTANClsgIDc2Mi45NjkyNThdICBbPGMwNDJhMmRiPl0gZ2VubF9yY3YrMHgxYi8w
eDMwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDQyN2Y1Nz5dIG5ldGxpbmtfdW5pY2FzdCsweDI0Ny8w
eDI4MA0KWyAgNzYyLjk2OTI1OF0gIFs8YzAyN2QzMDg+XSBjb3B5X2Zyb21fdXNlcisweDM4LzB4
ODANClsgIDc2Mi45NjkyNThdICBbPGMwNDI4OGU1Pl0gbmV0bGlua19zZW5kbXNnKzB4MWU1LzB4
MjkwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDQwYzc2ZD5dIHNvY2tfc2VuZG1zZysweGNkLzB4MTAw
DQpbICA3NjIuOTY5MjU4XSAgWzxjMDEzNDEwMD5dIGF1dG9yZW1vdmVfd2FrZV9mdW5jdGlvbisw
eDAvMHg0MA0KWyAgNzYyLjk2OTI1OF0gIFs8YzAxM2ZmOTE+XSB0cmFjZV9oYXJkaXJxc19vbisw
eGIxLzB4MTQwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDI3ZDMwOD5dIGNvcHlfZnJvbV91c2VyKzB4
MzgvMHg4MA0KWyAgNzYyLjk2OTI1OF0gIFs8YzA0MTQ3OWE+XSB2ZXJpZnlfaW92ZWMrMHgyYS8w
eDkwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDQwYzhmOT5dIHN5c19zZW5kbXNnKzB4MTU5LzB4Mjcw
DQpbICA3NjIuOTY5MjU4XSAgWzxjMDE0MDZmMz5dIF9fbG9ja19hY3F1aXJlKzB4MjgzLzB4MTA2
MA0KWyAgNzYyLjk2OTI1OF0gIFs8YzAxMDk1MWE+XSBuYXRpdmVfc2NoZWRfY2xvY2srMHg3YS8w
eGIwDQpbICA3NjIuOTY5MjU4XSAgWzxjMDEwOTUxYT5dIG5hdGl2ZV9zY2hlZF9jbG9jaysweDdh
LzB4YjANClsgIDc2Mi45NjkyNThdICBbPGMwNDBkYmYyPl0gc3lzX3NvY2tldGNhbGwrMHg4Mi8w
eDI4MA0KWyAgNzYyLjk2OTI1OF0gIFs8YzAxMDNkYjg+XSBzeXNlbnRlcl9wYXN0X2VzcCsweGE1
LzB4YjENClsgIDc2Mi45NjkyNThdICBbPGMwMTAzZGI4Pl0gc3lzZW50ZXJfcGFzdF9lc3ArMHhh
NS8weGIxDQpbICA3NjIuOTY5MjU4XSAgWzxjMDEwM2Q3ZD5dIHN5c2VudGVyX3Bhc3RfZXNwKzB4
NmEvMHhiMQ0KWyAgNzYyLjk2OTI1OF0gID09PT09PT09PT09PT09PT09PT09PT09DQoNCg==
------=_Part_41509_15142568.1217398576860--
