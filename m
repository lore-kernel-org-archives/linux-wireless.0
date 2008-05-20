Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:49830 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbYETRCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 13:02:00 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1839699wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 10:01:59 -0700 (PDT)
Message-ID: <69e28c910805201001r78d13ec5v4c7cf933edd39c10@mail.gmail.com> (sfid-20080520_190210_550502_8012E346)
Date: Tue, 20 May 2008 13:01:58 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: Fix packet injection in iwl3945 and iwl4965
Cc: "Tomas Winkler" <tomasw@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_2473_9074128.1211302919284"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_2473_9074128.1211302919284
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This patch fixes packet injection on iwlwifi devices (iwl3945 and
iwl4965). Tested with packetspammer and aireplay-ng, also works in
monitor-while-associated mode. If possible, please apply to 2.6.26,
else to 2.6.27. The patch is also available as an attachment, in case
Gmail decides to word-wrap or whitespace-damage the inline version.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
---

diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/=
iwl3945-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl3945-ba=
se.c=092008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl3945-base.c=
=092008-05-20
11:31:15.513173847 -0400
@@ -2542,16 +2542,19 @@ static int iwl3945_get_sta_id(struct iwl
 =09=09=09return sta_id;

 =09=09IWL_DEBUG_DROP("Station %s not in station map. "
 =09=09=09       "Defaulting to broadcast...\n",
 =09=09=09       print_mac(mac, hdr->addr1));
 =09=09iwl3945_print_hex_dump(IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 =09=09return priv->hw_setting.bcast_sta_id;
 =09}
+=09/* If we are in monitor mode, use BCAST */
+=09case IEEE80211_IF_TYPE_MNTR:
+=09=09return priv->hw_setting.bcast_sta_id;
 =09default:
 =09=09IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 =09=09return priv->hw_setting.bcast_sta_id;
 =09}
 }

 /*
  * start REPLY_TX command process
@@ -2579,21 +2582,16 @@ static int iwl3945_tx_skb(struct iwl3945
 =09int rc;

 =09spin_lock_irqsave(&priv->lock, flags);
 =09if (iwl3945_is_rfkill(priv)) {
 =09=09IWL_DEBUG_DROP("Dropping - RF KILL\n");
 =09=09goto drop_unlock;
 =09}

-=09if (!priv->vif) {
-=09=09IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-=09=09goto drop_unlock;
-=09}
-
 =09if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
 =09=09IWL_ERROR("ERROR: No TX rate available.\n");
 =09=09goto drop_unlock;
 =09}

 =09unicast =3D !is_multicast_ether_addr(hdr->addr1);
 =09id =3D 0;

@@ -2603,24 +2601,16 @@ static int iwl3945_tx_skb(struct iwl3945
 =09if (ieee80211_is_auth(fc))
 =09=09IWL_DEBUG_TX("Sending AUTH frame\n");
 =09else if (ieee80211_is_assoc_request(fc))
 =09=09IWL_DEBUG_TX("Sending ASSOC frame\n");
 =09else if (ieee80211_is_reassoc_request(fc))
 =09=09IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

-=09/* drop all data frame if we are not associated */
-=09if ((!iwl3945_is_associated(priv) ||
-=09     ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id))=
 &&
-=09    ((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA)) {
-=09=09IWL_DEBUG_DROP("Dropping - !iwl3945_is_associated\n");
-=09=09goto drop_unlock;
-=09}
-
 =09spin_unlock_irqrestore(&priv->lock, flags);

 =09hdr_len =3D ieee80211_get_hdrlen(fc);

 =09/* Find (or create) index into station table for destination station */
 =09sta_id =3D iwl3945_get_sta_id(priv, hdr);
 =09if (sta_id =3D=3D IWL_INVALID_STATION) {
 =09=09DECLARE_MAC_BUF(mac);
@@ -6692,21 +6682,16 @@ static void iwl3945_mac_stop(struct ieee

 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 =09=09      struct ieee80211_tx_control *ctl)
 {
 =09struct iwl3945_priv *priv =3D hw->priv;

 =09IWL_DEBUG_MAC80211("enter\n");

-=09if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
-=09=09IWL_DEBUG_MAC80211("leave - monitor\n");
-=09=09return -1;
-=09}
-
 =09IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 =09=09     ctl->tx_rate->bitrate);

 =09if (iwl3945_tx_skb(priv, skb, ctl))
 =09=09dev_kfree_skb_any(skb);

 =09IWL_DEBUG_MAC80211("leave\n");
 =09return 0;
diff -rp -U 8 compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/=
iwl4965-base.c
compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c
--- compat-wireless-2008-05-20.orig/drivers/net/wireless/iwlwifi/iwl4965-ba=
se.c=092008-05-20
05:05:29.000000000 -0400
+++ compat-wireless-2008-05-20/drivers/net/wireless/iwlwifi/iwl4965-base.c=
=092008-05-20
11:31:54.278205087 -0400
@@ -1746,16 +1746,19 @@ static int iwl4965_get_sta_id(struct iwl
 =09=09=09return sta_id;

 =09=09IWL_DEBUG_DROP("Station %s not in station map. "
 =09=09=09       "Defaulting to broadcast...\n",
 =09=09=09       print_mac(mac, hdr->addr1));
 =09=09iwl_print_hex_dump(priv, IWL_DL_DROP, (u8 *) hdr, sizeof(*hdr));
 =09=09return priv->hw_params.bcast_sta_id;

+=09/* If we are in monitor mode, use BCAST */
+=09case IEEE80211_IF_TYPE_MNTR:
+=09=09return priv->hw_params.bcast_sta_id;
 =09default:
 =09=09IWL_WARNING("Unknown mode of operation: %d", priv->iw_mode);
 =09=09return priv->hw_params.bcast_sta_id;
 =09}
 }

 /*
  * start REPLY_TX command process
@@ -1784,21 +1787,16 @@ static int iwl4965_tx_skb(struct iwl_pri
 =09int rc;

 =09spin_lock_irqsave(&priv->lock, flags);
 =09if (iwl_is_rfkill(priv)) {
 =09=09IWL_DEBUG_DROP("Dropping - RF KILL\n");
 =09=09goto drop_unlock;
 =09}

-=09if (!priv->vif) {
-=09=09IWL_DEBUG_DROP("Dropping - !priv->vif\n");
-=09=09goto drop_unlock;
-=09}
-
 =09if ((ctl->tx_rate->hw_value & 0xFF) =3D=3D IWL_INVALID_RATE) {
 =09=09IWL_ERROR("ERROR: No TX rate available.\n");
 =09=09goto drop_unlock;
 =09}

 =09unicast =3D !is_multicast_ether_addr(hdr->addr1);
 =09id =3D 0;

@@ -1808,25 +1806,16 @@ static int iwl4965_tx_skb(struct iwl_pri
 =09if (ieee80211_is_auth(fc))
 =09=09IWL_DEBUG_TX("Sending AUTH frame\n");
 =09else if (ieee80211_is_assoc_request(fc))
 =09=09IWL_DEBUG_TX("Sending ASSOC frame\n");
 =09else if (ieee80211_is_reassoc_request(fc))
 =09=09IWL_DEBUG_TX("Sending REASSOC frame\n");
 #endif

-=09/* drop all data frame if we are not associated */
-=09if (((fc & IEEE80211_FCTL_FTYPE) =3D=3D IEEE80211_FTYPE_DATA) &&
-=09   (!iwl_is_associated(priv) ||
-=09    ((priv->iw_mode =3D=3D IEEE80211_IF_TYPE_STA) && !priv->assoc_id) |=
|
-=09    !priv->assoc_station_added)) {
-=09=09IWL_DEBUG_DROP("Dropping - !iwl_is_associated\n");
-=09=09goto drop_unlock;
-=09}
-
 =09spin_unlock_irqrestore(&priv->lock, flags);

 =09hdr_len =3D ieee80211_get_hdrlen(fc);

 =09/* Find (or create) index into station table for destination station */
 =09sta_id =3D iwl4965_get_sta_id(priv, hdr);
 =09if (sta_id =3D=3D IWL_INVALID_STATION) {
 =09=09DECLARE_MAC_BUF(mac);
@@ -5110,21 +5099,16 @@ static void iwl4965_mac_stop(struct ieee

 static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb,
 =09=09      struct ieee80211_tx_control *ctl)
 {
 =09struct iwl_priv *priv =3D hw->priv;

 =09IWL_DEBUG_MAC80211("enter\n");

-=09if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
-=09=09IWL_DEBUG_MAC80211("leave - monitor\n");
-=09=09return -1;
-=09}
-
 =09IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 =09=09     ctl->tx_rate->bitrate);

 =09if (iwl4965_tx_skb(priv, skb, ctl))
 =09=09dev_kfree_skb_any(skb);

 =09IWL_DEBUG_MAC80211("leave\n");
 =09return 0;

------=_Part_2473_9074128.1211302919284
Content-Type: text/x-diff; name=iwlinject2.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fggqgh7g0
Content-Disposition: attachment; filename=iwlinject2.diff

ZGlmZiAtcnAgLVUgOCBjb21wYXQtd2lyZWxlc3MtMjAwOC0wNS0yMC5vcmlnL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2l3bHdpZmkvaXdsMzk0NS1iYXNlLmMgY29tcGF0LXdpcmVsZXNzLTIwMDgtMDUt
MjAvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wzOTQ1LWJhc2UuYwotLS0gY29tcGF0
LXdpcmVsZXNzLTIwMDgtMDUtMjAub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3
bDM5NDUtYmFzZS5jCTIwMDgtMDUtMjAgMDU6MDU6MjkuMDAwMDAwMDAwIC0wNDAwCisrKyBjb21w
YXQtd2lyZWxlc3MtMjAwOC0wNS0yMC9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5
NDUtYmFzZS5jCTIwMDgtMDUtMjAgMTE6MzE6MTUuNTEzMTczODQ3IC0wNDAwCkBAIC0yNTQyLDE2
ICsyNTQyLDE5IEBAIHN0YXRpYyBpbnQgaXdsMzk0NV9nZXRfc3RhX2lkKHN0cnVjdCBpd2wKIAkJ
CXJldHVybiBzdGFfaWQ7CiAKIAkJSVdMX0RFQlVHX0RST1AoIlN0YXRpb24gJXMgbm90IGluIHN0
YXRpb24gbWFwLiAiCiAJCQkgICAgICAgIkRlZmF1bHRpbmcgdG8gYnJvYWRjYXN0Li4uXG4iLAog
CQkJICAgICAgIHByaW50X21hYyhtYWMsIGhkci0+YWRkcjEpKTsKIAkJaXdsMzk0NV9wcmludF9o
ZXhfZHVtcChJV0xfRExfRFJPUCwgKHU4ICopIGhkciwgc2l6ZW9mKCpoZHIpKTsKIAkJcmV0dXJu
IHByaXYtPmh3X3NldHRpbmcuYmNhc3Rfc3RhX2lkOwogCX0KKwkvKiBJZiB3ZSBhcmUgaW4gbW9u
aXRvciBtb2RlLCB1c2UgQkNBU1QgKi8KKwljYXNlIElFRUU4MDIxMV9JRl9UWVBFX01OVFI6CisJ
CXJldHVybiBwcml2LT5od19zZXR0aW5nLmJjYXN0X3N0YV9pZDsKIAlkZWZhdWx0OgogCQlJV0xf
V0FSTklORygiVW5rbm93biBtb2RlIG9mIG9wZXJhdGlvbjogJWQiLCBwcml2LT5pd19tb2RlKTsK
IAkJcmV0dXJuIHByaXYtPmh3X3NldHRpbmcuYmNhc3Rfc3RhX2lkOwogCX0KIH0KIAogLyoKICAq
IHN0YXJ0IFJFUExZX1RYIGNvbW1hbmQgcHJvY2VzcwpAQCAtMjU3OSwyMSArMjU4MiwxNiBAQCBz
dGF0aWMgaW50IGl3bDM5NDVfdHhfc2tiKHN0cnVjdCBpd2wzOTQ1CiAJaW50IHJjOwogCiAJc3Bp
bl9sb2NrX2lycXNhdmUoJnByaXYtPmxvY2ssIGZsYWdzKTsKIAlpZiAoaXdsMzk0NV9pc19yZmtp
bGwocHJpdikpIHsKIAkJSVdMX0RFQlVHX0RST1AoIkRyb3BwaW5nIC0gUkYgS0lMTFxuIik7CiAJ
CWdvdG8gZHJvcF91bmxvY2s7CiAJfQogCi0JaWYgKCFwcml2LT52aWYpIHsKLQkJSVdMX0RFQlVH
X0RST1AoIkRyb3BwaW5nIC0gIXByaXYtPnZpZlxuIik7Ci0JCWdvdG8gZHJvcF91bmxvY2s7Ci0J
fQotCiAJaWYgKChjdGwtPnR4X3JhdGUtPmh3X3ZhbHVlICYgMHhGRikgPT0gSVdMX0lOVkFMSURf
UkFURSkgewogCQlJV0xfRVJST1IoIkVSUk9SOiBObyBUWCByYXRlIGF2YWlsYWJsZS5cbiIpOwog
CQlnb3RvIGRyb3BfdW5sb2NrOwogCX0KIAogCXVuaWNhc3QgPSAhaXNfbXVsdGljYXN0X2V0aGVy
X2FkZHIoaGRyLT5hZGRyMSk7CiAJaWQgPSAwOwogCkBAIC0yNjAzLDI0ICsyNjAxLDE2IEBAIHN0
YXRpYyBpbnQgaXdsMzk0NV90eF9za2Ioc3RydWN0IGl3bDM5NDUKIAlpZiAoaWVlZTgwMjExX2lz
X2F1dGgoZmMpKQogCQlJV0xfREVCVUdfVFgoIlNlbmRpbmcgQVVUSCBmcmFtZVxuIik7CiAJZWxz
ZSBpZiAoaWVlZTgwMjExX2lzX2Fzc29jX3JlcXVlc3QoZmMpKQogCQlJV0xfREVCVUdfVFgoIlNl
bmRpbmcgQVNTT0MgZnJhbWVcbiIpOwogCWVsc2UgaWYgKGllZWU4MDIxMV9pc19yZWFzc29jX3Jl
cXVlc3QoZmMpKQogCQlJV0xfREVCVUdfVFgoIlNlbmRpbmcgUkVBU1NPQyBmcmFtZVxuIik7CiAj
ZW5kaWYKIAotCS8qIGRyb3AgYWxsIGRhdGEgZnJhbWUgaWYgd2UgYXJlIG5vdCBhc3NvY2lhdGVk
ICovCi0JaWYgKCghaXdsMzk0NV9pc19hc3NvY2lhdGVkKHByaXYpIHx8Ci0JICAgICAoKHByaXYt
Pml3X21vZGUgPT0gSUVFRTgwMjExX0lGX1RZUEVfU1RBKSAmJiAhcHJpdi0+YXNzb2NfaWQpKSAm
JgotCSAgICAoKGZjICYgSUVFRTgwMjExX0ZDVExfRlRZUEUpID09IElFRUU4MDIxMV9GVFlQRV9E
QVRBKSkgewotCQlJV0xfREVCVUdfRFJPUCgiRHJvcHBpbmcgLSAhaXdsMzk0NV9pc19hc3NvY2lh
dGVkXG4iKTsKLQkJZ290byBkcm9wX3VubG9jazsKLQl9Ci0KIAlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZwcml2LT5sb2NrLCBmbGFncyk7CiAKIAloZHJfbGVuID0gaWVlZTgwMjExX2dldF9oZHJs
ZW4oZmMpOwogCiAJLyogRmluZCAob3IgY3JlYXRlKSBpbmRleCBpbnRvIHN0YXRpb24gdGFibGUg
Zm9yIGRlc3RpbmF0aW9uIHN0YXRpb24gKi8KIAlzdGFfaWQgPSBpd2wzOTQ1X2dldF9zdGFfaWQo
cHJpdiwgaGRyKTsKIAlpZiAoc3RhX2lkID09IElXTF9JTlZBTElEX1NUQVRJT04pIHsKIAkJREVD
TEFSRV9NQUNfQlVGKG1hYyk7CkBAIC02NjkyLDIxICs2NjgyLDE2IEBAIHN0YXRpYyB2b2lkIGl3
bDM5NDVfbWFjX3N0b3Aoc3RydWN0IGllZWUKIAogc3RhdGljIGludCBpd2wzOTQ1X21hY190eChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IHNrX2J1ZmYgKnNrYiwKIAkJICAgICAgc3Ry
dWN0IGllZWU4MDIxMV90eF9jb250cm9sICpjdGwpCiB7CiAJc3RydWN0IGl3bDM5NDVfcHJpdiAq
cHJpdiA9IGh3LT5wcml2OwogCiAJSVdMX0RFQlVHX01BQzgwMjExKCJlbnRlclxuIik7CiAKLQlp
ZiAocHJpdi0+aXdfbW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQRV9NTlRSKSB7Ci0JCUlXTF9ERUJV
R19NQUM4MDIxMSgibGVhdmUgLSBtb25pdG9yXG4iKTsKLQkJcmV0dXJuIC0xOwotCX0KLQogCUlX
TF9ERUJVR19UWCgiZGV2LT54bWl0KCVkIGJ5dGVzKSBhdCByYXRlIDB4JTAyeFxuIiwgc2tiLT5s
ZW4sCiAJCSAgICAgY3RsLT50eF9yYXRlLT5iaXRyYXRlKTsKIAogCWlmIChpd2wzOTQ1X3R4X3Nr
Yihwcml2LCBza2IsIGN0bCkpCiAJCWRldl9rZnJlZV9za2JfYW55KHNrYik7CiAKIAlJV0xfREVC
VUdfTUFDODAyMTEoImxlYXZlXG4iKTsKIAlyZXR1cm4gMDsKZGlmZiAtcnAgLVUgOCBjb21wYXQt
d2lyZWxlc3MtMjAwOC0wNS0yMC5vcmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXds
NDk2NS1iYXNlLmMgY29tcGF0LXdpcmVsZXNzLTIwMDgtMDUtMjAvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9pd2w0OTY1LWJhc2UuYwotLS0gY29tcGF0LXdpcmVsZXNzLTIwMDgtMDUtMjAu
b3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFzZS5jCTIwMDgtMDUt
MjAgMDU6MDU6MjkuMDAwMDAwMDAwIC0wNDAwCisrKyBjb21wYXQtd2lyZWxlc3MtMjAwOC0wNS0y
MC9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDQ5NjUtYmFzZS5jCTIwMDgtMDUtMjAg
MTE6MzE6NTQuMjc4MjA1MDg3IC0wNDAwCkBAIC0xNzQ2LDE2ICsxNzQ2LDE5IEBAIHN0YXRpYyBp
bnQgaXdsNDk2NV9nZXRfc3RhX2lkKHN0cnVjdCBpd2wKIAkJCXJldHVybiBzdGFfaWQ7CiAKIAkJ
SVdMX0RFQlVHX0RST1AoIlN0YXRpb24gJXMgbm90IGluIHN0YXRpb24gbWFwLiAiCiAJCQkgICAg
ICAgIkRlZmF1bHRpbmcgdG8gYnJvYWRjYXN0Li4uXG4iLAogCQkJICAgICAgIHByaW50X21hYyht
YWMsIGhkci0+YWRkcjEpKTsKIAkJaXdsX3ByaW50X2hleF9kdW1wKHByaXYsIElXTF9ETF9EUk9Q
LCAodTggKikgaGRyLCBzaXplb2YoKmhkcikpOwogCQlyZXR1cm4gcHJpdi0+aHdfcGFyYW1zLmJj
YXN0X3N0YV9pZDsKIAorCS8qIElmIHdlIGFyZSBpbiBtb25pdG9yIG1vZGUsIHVzZSBCQ0FTVCAq
LworCWNhc2UgSUVFRTgwMjExX0lGX1RZUEVfTU5UUjoKKwkJcmV0dXJuIHByaXYtPmh3X3BhcmFt
cy5iY2FzdF9zdGFfaWQ7CiAJZGVmYXVsdDoKIAkJSVdMX1dBUk5JTkcoIlVua25vd24gbW9kZSBv
ZiBvcGVyYXRpb246ICVkIiwgcHJpdi0+aXdfbW9kZSk7CiAJCXJldHVybiBwcml2LT5od19wYXJh
bXMuYmNhc3Rfc3RhX2lkOwogCX0KIH0KIAogLyoKICAqIHN0YXJ0IFJFUExZX1RYIGNvbW1hbmQg
cHJvY2VzcwpAQCAtMTc4NCwyMSArMTc4NywxNiBAQCBzdGF0aWMgaW50IGl3bDQ5NjVfdHhfc2ti
KHN0cnVjdCBpd2xfcHJpCiAJaW50IHJjOwogCiAJc3Bpbl9sb2NrX2lycXNhdmUoJnByaXYtPmxv
Y2ssIGZsYWdzKTsKIAlpZiAoaXdsX2lzX3Jma2lsbChwcml2KSkgewogCQlJV0xfREVCVUdfRFJP
UCgiRHJvcHBpbmcgLSBSRiBLSUxMXG4iKTsKIAkJZ290byBkcm9wX3VubG9jazsKIAl9CiAKLQlp
ZiAoIXByaXYtPnZpZikgewotCQlJV0xfREVCVUdfRFJPUCgiRHJvcHBpbmcgLSAhcHJpdi0+dmlm
XG4iKTsKLQkJZ290byBkcm9wX3VubG9jazsKLQl9Ci0KIAlpZiAoKGN0bC0+dHhfcmF0ZS0+aHdf
dmFsdWUgJiAweEZGKSA9PSBJV0xfSU5WQUxJRF9SQVRFKSB7CiAJCUlXTF9FUlJPUigiRVJST1I6
IE5vIFRYIHJhdGUgYXZhaWxhYmxlLlxuIik7CiAJCWdvdG8gZHJvcF91bmxvY2s7CiAJfQogCiAJ
dW5pY2FzdCA9ICFpc19tdWx0aWNhc3RfZXRoZXJfYWRkcihoZHItPmFkZHIxKTsKIAlpZCA9IDA7
CiAKQEAgLTE4MDgsMjUgKzE4MDYsMTYgQEAgc3RhdGljIGludCBpd2w0OTY1X3R4X3NrYihzdHJ1
Y3QgaXdsX3ByaQogCWlmIChpZWVlODAyMTFfaXNfYXV0aChmYykpCiAJCUlXTF9ERUJVR19UWCgi
U2VuZGluZyBBVVRIIGZyYW1lXG4iKTsKIAllbHNlIGlmIChpZWVlODAyMTFfaXNfYXNzb2NfcmVx
dWVzdChmYykpCiAJCUlXTF9ERUJVR19UWCgiU2VuZGluZyBBU1NPQyBmcmFtZVxuIik7CiAJZWxz
ZSBpZiAoaWVlZTgwMjExX2lzX3JlYXNzb2NfcmVxdWVzdChmYykpCiAJCUlXTF9ERUJVR19UWCgi
U2VuZGluZyBSRUFTU09DIGZyYW1lXG4iKTsKICNlbmRpZgogCi0JLyogZHJvcCBhbGwgZGF0YSBm
cmFtZSBpZiB3ZSBhcmUgbm90IGFzc29jaWF0ZWQgKi8KLQlpZiAoKChmYyAmIElFRUU4MDIxMV9G
Q1RMX0ZUWVBFKSA9PSBJRUVFODAyMTFfRlRZUEVfREFUQSkgJiYKLQkgICAoIWl3bF9pc19hc3Nv
Y2lhdGVkKHByaXYpIHx8Ci0JICAgICgocHJpdi0+aXdfbW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQ
RV9TVEEpICYmICFwcml2LT5hc3NvY19pZCkgfHwKLQkgICAgIXByaXYtPmFzc29jX3N0YXRpb25f
YWRkZWQpKSB7Ci0JCUlXTF9ERUJVR19EUk9QKCJEcm9wcGluZyAtICFpd2xfaXNfYXNzb2NpYXRl
ZFxuIik7Ci0JCWdvdG8gZHJvcF91bmxvY2s7Ci0JfQotCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOwogCiAJaGRyX2xlbiA9IGllZWU4MDIxMV9nZXRfaGRybGVu
KGZjKTsKIAogCS8qIEZpbmQgKG9yIGNyZWF0ZSkgaW5kZXggaW50byBzdGF0aW9uIHRhYmxlIGZv
ciBkZXN0aW5hdGlvbiBzdGF0aW9uICovCiAJc3RhX2lkID0gaXdsNDk2NV9nZXRfc3RhX2lkKHBy
aXYsIGhkcik7CiAJaWYgKHN0YV9pZCA9PSBJV0xfSU5WQUxJRF9TVEFUSU9OKSB7CiAJCURFQ0xB
UkVfTUFDX0JVRihtYWMpOwpAQCAtNTExMCwyMSArNTA5OSwxNiBAQCBzdGF0aWMgdm9pZCBpd2w0
OTY1X21hY19zdG9wKHN0cnVjdCBpZWVlCiAKIHN0YXRpYyBpbnQgaXdsNDk2NV9tYWNfdHgoc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBza19idWZmICpza2IsCiAJCSAgICAgIHN0cnVj
dCBpZWVlODAyMTFfdHhfY29udHJvbCAqY3RsKQogewogCXN0cnVjdCBpd2xfcHJpdiAqcHJpdiA9
IGh3LT5wcml2OwogCiAJSVdMX0RFQlVHX01BQzgwMjExKCJlbnRlclxuIik7CiAKLQlpZiAocHJp
di0+aXdfbW9kZSA9PSBJRUVFODAyMTFfSUZfVFlQRV9NTlRSKSB7Ci0JCUlXTF9ERUJVR19NQUM4
MDIxMSgibGVhdmUgLSBtb25pdG9yXG4iKTsKLQkJcmV0dXJuIC0xOwotCX0KLQogCUlXTF9ERUJV
R19UWCgiZGV2LT54bWl0KCVkIGJ5dGVzKSBhdCByYXRlIDB4JTAyeFxuIiwgc2tiLT5sZW4sCiAJ
CSAgICAgY3RsLT50eF9yYXRlLT5iaXRyYXRlKTsKIAogCWlmIChpd2w0OTY1X3R4X3NrYihwcml2
LCBza2IsIGN0bCkpCiAJCWRldl9rZnJlZV9za2JfYW55KHNrYik7CiAKIAlJV0xfREVCVUdfTUFD
ODAyMTEoImxlYXZlXG4iKTsKIAlyZXR1cm4gMDsK
------=_Part_2473_9074128.1211302919284--
