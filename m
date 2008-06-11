Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:23089 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468AbYFKUFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 16:05:25 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3251662wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 13:05:24 -0700 (PDT)
Message-ID: <69e28c910806111305k6b32390ey1d44d5c2b7639241@mail.gmail.com> (sfid-20080611_220531_052007_542A8985)
Date: Wed, 11 Jun 2008 22:05:24 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: Make packet injection work in iwl3945
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>, "Tomas Winkler" <tomasw@gmail.com>,
	ipw3945-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_24866_23224476.1213214724612"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_24866_23224476.1213214724612
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

We currently forbid injecting packets in monitor mode for iwl3945, but
it's done in an unsafe way, that can result in various issues. This
patch enables injecting packets in monitor mode. The patch is also
available as an attachment in case Gmail decides to corrupt it.

John, please apply to 2.6.27. You might also want to apply it to
2.6.26, but it's not tested there.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---
diff -ru8p compat-wireless-2008-06-04.orig/drivers/net/wireless/iwlwifi/iwl=
3945-base.c
compat-wireless-2008-06-04/drivers/net/wireless/iwlwifi/iwl3945-base.c
--- compat-wireless-2008-06-04.orig/drivers/net/wireless/iwlwifi/iwl3945-ba=
se.c=092008-06-04
06:10:49.000000000 +0200
+++ compat-wireless-2008-06-04/drivers/net/wireless/iwlwifi/iwl3945-base.c=
=092008-06-04
22:34:32.000000000 +0200
@@ -2532,16 +2532,19 @@ static int iwl3945_get_sta_id(struct iwl
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
@@ -2571,21 +2574,16 @@ static int iwl3945_tx_skb(struct iwl3945
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
 =09if ((ieee80211_get_tx_rate(priv->hw, info)->hw_value & 0xFF) =3D=3D
IWL_INVALID_RATE) {
 =09=09IWL_ERROR("ERROR: No TX rate available.\n");
 =09=09goto drop_unlock;
 =09}

 =09unicast =3D !is_multicast_ether_addr(hdr->addr1);
 =09id =3D 0;

@@ -2595,24 +2593,16 @@ static int iwl3945_tx_skb(struct iwl3945
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
@@ -6334,17 +6324,17 @@ static void iwl3945_bg_request_scan(stru
 =09=09IWL_WARNING("Invalid scan band count\n");
 =09=09goto done;
 =09}

 =09/* select Rx antennas */
 =09scan->flags |=3D iwl3945_get_antenna_flags(priv);

 =09if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR)
-=09=09scan->filter_flags =3D RXON_FILTER_PROMISC_MSK;
+=09=09scan->filter_flags |=3D RXON_FILTER_PROMISC_MSK |
RXON_FILTER_CTL2HOST_MSK | RXON_FILTER_ACCEPT_GRP_MSK;

 =09if (direct_mask)
 =09=09scan->channel_count =3D
 =09=09=09iwl3945_get_channels_for_scan(
 =09=09=09=09priv, band, 1, /* active */
 =09=09=09=09direct_mask,
 =09=09=09=09(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 =09else
@@ -6660,38 +6650,33 @@ static void iwl3945_mac_stop(struct ieee
 =09=09 * RXON_FILTER_ASSOC_MSK BIT
 =09=09 */
 =09=09mutex_lock(&priv->mutex);
 =09=09iwl3945_scan_cancel_timeout(priv, 100);
 =09=09cancel_delayed_work(&priv->post_associate);
 =09=09mutex_unlock(&priv->mutex);
 =09}

 =09iwl3945_down(priv);

 =09flush_workqueue(priv->workqueue);
 =09free_irq(priv->pci_dev->irq, priv);
 =09pci_disable_msi(priv->pci_dev);
 =09pci_save_state(priv->pci_dev);
 =09pci_disable_device(priv->pci_dev);

 =09IWL_DEBUG_MAC80211("leave\n");
 }

 static int iwl3945_mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 =09struct iwl3945_priv *priv =3D hw->priv;

 =09IWL_DEBUG_MAC80211("enter\n");

-=09if (priv->iw_mode =3D=3D IEEE80211_IF_TYPE_MNTR) {
-=09=09IWL_DEBUG_MAC80211("leave - monitor\n");
-=09=09return -1;
-=09}
-
 =09IWL_DEBUG_TX("dev->xmit(%d bytes) at rate 0x%02x\n", skb->len,
 =09=09     ieee80211_get_tx_rate(hw, IEEE80211_SKB_CB(skb))->bitrate);

 =09if (iwl3945_tx_skb(priv, skb))
 =09=09dev_kfree_skb_any(skb);

 =09IWL_DEBUG_MAC80211("leave\n");
 =09return 0;

------=_Part_24866_23224476.1213214724612
Content-Type: text/x-diff; name=iwlinject6-3945.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fhccpich0
Content-Disposition: attachment; filename=iwlinject6-3945.diff

ZGlmZiAtcnU4cCBjb21wYXQtd2lyZWxlc3MtMjAwOC0wNi0wNC5vcmlnL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvaXdsMzk0NS1iYXNlLmMgY29tcGF0LXdpcmVsZXNzLTIwMDgtMDYtMDQv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wzOTQ1LWJhc2UuYwotLS0gY29tcGF0LXdp
cmVsZXNzLTIwMDgtMDYtMDQub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5
NDUtYmFzZS5jCTIwMDgtMDYtMDQgMDY6MTA6NDkuMDAwMDAwMDAwICswMjAwCisrKyBjb21wYXQt
d2lyZWxlc3MtMjAwOC0wNi0wNC9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bDM5NDUt
YmFzZS5jCTIwMDgtMDYtMDQgMjI6MzQ6MzIuMDAwMDAwMDAwICswMjAwCkBAIC0yNTMyLDE2ICsy
NTMyLDE5IEBAIHN0YXRpYyBpbnQgaXdsMzk0NV9nZXRfc3RhX2lkKHN0cnVjdCBpd2wKIAkJCXJl
dHVybiBzdGFfaWQ7CiAKIAkJSVdMX0RFQlVHX0RST1AoIlN0YXRpb24gJXMgbm90IGluIHN0YXRp
b24gbWFwLiAiCiAJCQkgICAgICAgIkRlZmF1bHRpbmcgdG8gYnJvYWRjYXN0Li4uXG4iLAogCQkJ
ICAgICAgIHByaW50X21hYyhtYWMsIGhkci0+YWRkcjEpKTsKIAkJaXdsMzk0NV9wcmludF9oZXhf
ZHVtcChJV0xfRExfRFJPUCwgKHU4ICopIGhkciwgc2l6ZW9mKCpoZHIpKTsKIAkJcmV0dXJuIHBy
aXYtPmh3X3NldHRpbmcuYmNhc3Rfc3RhX2lkOwogCX0KKwkvKiBJZiB3ZSBhcmUgaW4gbW9uaXRv
ciBtb2RlLCB1c2UgQkNBU1QgKi8KKwljYXNlIElFRUU4MDIxMV9JRl9UWVBFX01OVFI6CisJCXJl
dHVybiBwcml2LT5od19zZXR0aW5nLmJjYXN0X3N0YV9pZDsKIAlkZWZhdWx0OgogCQlJV0xfV0FS
TklORygiVW5rbm93biBtb2RlIG9mIG9wZXJhdGlvbjogJWQiLCBwcml2LT5pd19tb2RlKTsKIAkJ
cmV0dXJuIHByaXYtPmh3X3NldHRpbmcuYmNhc3Rfc3RhX2lkOwogCX0KIH0KIAogLyoKICAqIHN0
YXJ0IFJFUExZX1RYIGNvbW1hbmQgcHJvY2VzcwpAQCAtMjU3MSwyMSArMjU3NCwxNiBAQCBzdGF0
aWMgaW50IGl3bDM5NDVfdHhfc2tiKHN0cnVjdCBpd2wzOTQ1CiAJaW50IHJjOwogCiAJc3Bpbl9s
b2NrX2lycXNhdmUoJnByaXYtPmxvY2ssIGZsYWdzKTsKIAlpZiAoaXdsMzk0NV9pc19yZmtpbGwo
cHJpdikpIHsKIAkJSVdMX0RFQlVHX0RST1AoIkRyb3BwaW5nIC0gUkYgS0lMTFxuIik7CiAJCWdv
dG8gZHJvcF91bmxvY2s7CiAJfQogCi0JaWYgKCFwcml2LT52aWYpIHsKLQkJSVdMX0RFQlVHX0RS
T1AoIkRyb3BwaW5nIC0gIXByaXYtPnZpZlxuIik7Ci0JCWdvdG8gZHJvcF91bmxvY2s7Ci0JfQot
CiAJaWYgKChpZWVlODAyMTFfZ2V0X3R4X3JhdGUocHJpdi0+aHcsIGluZm8pLT5od192YWx1ZSAm
IDB4RkYpID09IElXTF9JTlZBTElEX1JBVEUpIHsKIAkJSVdMX0VSUk9SKCJFUlJPUjogTm8gVFgg
cmF0ZSBhdmFpbGFibGUuXG4iKTsKIAkJZ290byBkcm9wX3VubG9jazsKIAl9CiAKIAl1bmljYXN0
ID0gIWlzX211bHRpY2FzdF9ldGhlcl9hZGRyKGhkci0+YWRkcjEpOwogCWlkID0gMDsKIApAQCAt
MjU5NSwyNCArMjU5MywxNiBAQCBzdGF0aWMgaW50IGl3bDM5NDVfdHhfc2tiKHN0cnVjdCBpd2wz
OTQ1CiAJaWYgKGllZWU4MDIxMV9pc19hdXRoKGZjKSkKIAkJSVdMX0RFQlVHX1RYKCJTZW5kaW5n
IEFVVEggZnJhbWVcbiIpOwogCWVsc2UgaWYgKGllZWU4MDIxMV9pc19hc3NvY19yZXF1ZXN0KGZj
KSkKIAkJSVdMX0RFQlVHX1RYKCJTZW5kaW5nIEFTU09DIGZyYW1lXG4iKTsKIAllbHNlIGlmIChp
ZWVlODAyMTFfaXNfcmVhc3NvY19yZXF1ZXN0KGZjKSkKIAkJSVdMX0RFQlVHX1RYKCJTZW5kaW5n
IFJFQVNTT0MgZnJhbWVcbiIpOwogI2VuZGlmCiAKLQkvKiBkcm9wIGFsbCBkYXRhIGZyYW1lIGlm
IHdlIGFyZSBub3QgYXNzb2NpYXRlZCAqLwotCWlmICgoIWl3bDM5NDVfaXNfYXNzb2NpYXRlZChw
cml2KSB8fAotCSAgICAgKChwcml2LT5pd19tb2RlID09IElFRUU4MDIxMV9JRl9UWVBFX1NUQSkg
JiYgIXByaXYtPmFzc29jX2lkKSkgJiYKLQkgICAgKChmYyAmIElFRUU4MDIxMV9GQ1RMX0ZUWVBF
KSA9PSBJRUVFODAyMTFfRlRZUEVfREFUQSkpIHsKLQkJSVdMX0RFQlVHX0RST1AoIkRyb3BwaW5n
IC0gIWl3bDM5NDVfaXNfYXNzb2NpYXRlZFxuIik7Ci0JCWdvdG8gZHJvcF91bmxvY2s7Ci0JfQot
CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcHJpdi0+bG9jaywgZmxhZ3MpOwogCiAJaGRyX2xl
biA9IGllZWU4MDIxMV9nZXRfaGRybGVuKGZjKTsKIAogCS8qIEZpbmQgKG9yIGNyZWF0ZSkgaW5k
ZXggaW50byBzdGF0aW9uIHRhYmxlIGZvciBkZXN0aW5hdGlvbiBzdGF0aW9uICovCiAJc3RhX2lk
ID0gaXdsMzk0NV9nZXRfc3RhX2lkKHByaXYsIGhkcik7CiAJaWYgKHN0YV9pZCA9PSBJV0xfSU5W
QUxJRF9TVEFUSU9OKSB7CiAJCURFQ0xBUkVfTUFDX0JVRihtYWMpOwpAQCAtNjMzNCwxNyArNjMy
NCwxNyBAQCBzdGF0aWMgdm9pZCBpd2wzOTQ1X2JnX3JlcXVlc3Rfc2NhbihzdHJ1CiAJCUlXTF9X
QVJOSU5HKCJJbnZhbGlkIHNjYW4gYmFuZCBjb3VudFxuIik7CiAJCWdvdG8gZG9uZTsKIAl9CiAK
IAkvKiBzZWxlY3QgUnggYW50ZW5uYXMgKi8KIAlzY2FuLT5mbGFncyB8PSBpd2wzOTQ1X2dldF9h
bnRlbm5hX2ZsYWdzKHByaXYpOwogCiAJaWYgKHByaXYtPml3X21vZGUgPT0gSUVFRTgwMjExX0lG
X1RZUEVfTU5UUikKLQkJc2Nhbi0+ZmlsdGVyX2ZsYWdzID0gUlhPTl9GSUxURVJfUFJPTUlTQ19N
U0s7CisJCXNjYW4tPmZpbHRlcl9mbGFncyB8PSBSWE9OX0ZJTFRFUl9QUk9NSVNDX01TSyB8IFJY
T05fRklMVEVSX0NUTDJIT1NUX01TSyB8IFJYT05fRklMVEVSX0FDQ0VQVF9HUlBfTVNLOwogCiAJ
aWYgKGRpcmVjdF9tYXNrKQogCQlzY2FuLT5jaGFubmVsX2NvdW50ID0KIAkJCWl3bDM5NDVfZ2V0
X2NoYW5uZWxzX2Zvcl9zY2FuKAogCQkJCXByaXYsIGJhbmQsIDEsIC8qIGFjdGl2ZSAqLwogCQkJ
CWRpcmVjdF9tYXNrLAogCQkJCSh2b2lkICopJnNjYW4tPmRhdGFbbGUxNl90b19jcHUoc2Nhbi0+
dHhfY21kLmxlbildKTsKIAllbHNlCkBAIC02NjYwLDM4ICs2NjUwLDMzIEBAIHN0YXRpYyB2b2lk
IGl3bDM5NDVfbWFjX3N0b3Aoc3RydWN0IGllZWUKIAkJICogUlhPTl9GSUxURVJfQVNTT0NfTVNL
IEJJVAogCQkgKi8KIAkJbXV0ZXhfbG9jaygmcHJpdi0+bXV0ZXgpOwogCQlpd2wzOTQ1X3NjYW5f
Y2FuY2VsX3RpbWVvdXQocHJpdiwgMTAwKTsKIAkJY2FuY2VsX2RlbGF5ZWRfd29yaygmcHJpdi0+
cG9zdF9hc3NvY2lhdGUpOwogCQltdXRleF91bmxvY2soJnByaXYtPm11dGV4KTsKIAl9CiAKIAlp
d2wzOTQ1X2Rvd24ocHJpdik7CiAKIAlmbHVzaF93b3JrcXVldWUocHJpdi0+d29ya3F1ZXVlKTsK
IAlmcmVlX2lycShwcml2LT5wY2lfZGV2LT5pcnEsIHByaXYpOwogCXBjaV9kaXNhYmxlX21zaShw
cml2LT5wY2lfZGV2KTsKIAlwY2lfc2F2ZV9zdGF0ZShwcml2LT5wY2lfZGV2KTsKIAlwY2lfZGlz
YWJsZV9kZXZpY2UocHJpdi0+cGNpX2Rldik7CiAKIAlJV0xfREVCVUdfTUFDODAyMTEoImxlYXZl
XG4iKTsKIH0KIAogc3RhdGljIGludCBpd2wzOTQ1X21hY190eChzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IHNrX2J1ZmYgKnNrYikKIHsKIAlzdHJ1Y3QgaXdsMzk0NV9wcml2ICpwcml2
ID0gaHctPnByaXY7CiAKIAlJV0xfREVCVUdfTUFDODAyMTEoImVudGVyXG4iKTsKIAotCWlmIChw
cml2LT5pd19tb2RlID09IElFRUU4MDIxMV9JRl9UWVBFX01OVFIpIHsKLQkJSVdMX0RFQlVHX01B
QzgwMjExKCJsZWF2ZSAtIG1vbml0b3JcbiIpOwotCQlyZXR1cm4gLTE7Ci0JfQotCiAJSVdMX0RF
QlVHX1RYKCJkZXYtPnhtaXQoJWQgYnl0ZXMpIGF0IHJhdGUgMHglMDJ4XG4iLCBza2ItPmxlbiwK
IAkJICAgICBpZWVlODAyMTFfZ2V0X3R4X3JhdGUoaHcsIElFRUU4MDIxMV9TS0JfQ0Ioc2tiKSkt
PmJpdHJhdGUpOwogCiAJaWYgKGl3bDM5NDVfdHhfc2tiKHByaXYsIHNrYikpCiAJCWRldl9rZnJl
ZV9za2JfYW55KHNrYik7CiAKIAlJV0xfREVCVUdfTUFDODAyMTEoImxlYXZlXG4iKTsKIAlyZXR1
cm4gMDs=
------=_Part_24866_23224476.1213214724612--
