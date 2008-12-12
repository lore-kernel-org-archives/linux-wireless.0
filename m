Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:62572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbYLLWcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:32:39 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1578824rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:32:38 -0800 (PST)
Message-ID: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com> (sfid-20081212_233243_152618_26CBFAA2)
Date: Fri, 12 Dec 2008 23:32:38 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and F_TX_NOSEQ Radiotap TX flags
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_27832_32783571.1229121158894"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_27832_32783571.1229121158894
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Honor the 2 new flags in the "TX Flags" Radiotap field, introduced in
the previous commit.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---

Patch also available as an attachment in case Gmail decides to damage it.

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 155a204..141099a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -143,6 +143,8 @@ typedef unsigned __bitwise__ ieee80211_tx_result;
 #define IEEE80211_TX_FRAGMENTED=09=09BIT(0)
 #define IEEE80211_TX_UNICAST=09=09BIT(1)
 #define IEEE80211_TX_PS_BUFFERED=09BIT(2)
+#define IEEE80211_TX_MON_NO_SEQ=09=09BIT(3)
+#define IEEE80211_TX_MON_NO_ACK=09=09BIT(4)

 struct ieee80211_tx_data {
 =09struct sk_buff *skb;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0855cac..d08a25e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -614,14 +614,12 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 =09 * number, if we have no matching interface then we
 =09 * neither assign one ourselves nor ask the driver to.
 =09 */
-=09if (unlikely(!info->control.vif))
+=09if (unlikely(!info->control.vif ||
+=09=09     tx->flags & IEEE80211_TX_MON_NO_SEQ ||
+=09=09     ieee80211_is_ctl(hdr->frame_control)) ||
+=09=09     ieee80211_hdrlen(hdr->frame_control) < 24)
 =09=09return TX_CONTINUE;

-=09if (unlikely(ieee80211_is_ctl(hdr->frame_control)))
-=09=09return TX_CONTINUE;
-
-=09if (ieee80211_hdrlen(hdr->frame_control) < 24)
-=09=09return TX_CONTINUE;

 =09/*
 =09 * Anything but QoS data that has a sequence number field
@@ -913,13 +911,17 @@ __ieee80211_parse_tx_radiotap(struct
ieee80211_tx_data *tx,
 =09=09=09if (*iterator.this_arg & IEEE80211_RADIOTAP_F_FRAG)
 =09=09=09=09tx->flags |=3D IEEE80211_TX_FRAGMENTED;
 =09=09=09break;
-
+=09=09case IEEE80211_RADIOTAP_TX_FLAGS:
+=09=09=09if (*iterator.this_arg & IEEE80211_RADIOTAP_F_TX_NOACK)
+=09=09=09=09tx->flags |=3D IEEE80211_TX_MON_NO_ACK;
+=09=09=09if (*iterator.this_arg & IEEE80211_RADIOTAP_F_TX_NOSEQ)
+=09=09=09=09tx->flags |=3D IEEE80211_TX_MON_NO_SEQ;
+=09=09=09break;
 =09=09/*
 =09=09 * Please update the file
 =09=09 * Documentation/networking/mac80211-injection.txt
 =09=09 * when parsing new fields here.
 =09=09 */
-
 =09=09default:
 =09=09=09break;
 =09=09}
@@ -1000,6 +1002,9 @@ __ieee80211_tx_prepare(struct ieee80211_tx_data *tx,
 =09=09info->flags &=3D ~IEEE80211_TX_CTL_NO_ACK;
 =09}

+=09if (tx->flags & IEEE80211_TX_MON_NO_ACK)
+=09=09info->flags |=3D IEEE80211_TX_CTL_NO_ACK;
+
 =09if (tx->flags & IEEE80211_TX_FRAGMENTED) {
 =09=09if ((tx->flags & IEEE80211_TX_UNICAST) &&
 =09=09    skb->len + FCS_LEN > local->fragmentation_threshold &&

------=_Part_27832_32783571.1229121158894
Content-Type: application/octet-stream;
 name=0002-mac80211-make-use-of-the-new-no-ack-and-no-seq-renumbering-tx-flags.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fones71w0
Content-Disposition: attachment;
 filename=0002-mac80211-make-use-of-the-new-no-ack-and-no-seq-renumbering-tx-flags.patch

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9pZWVlODAyMTFfaS5oIGIvbmV0L21hYzgwMjExL2ll
ZWU4MDIxMV9pLmgKaW5kZXggMTU1YTIwNC4uMTQxMDk5YSAxMDA2NDQKLS0tIGEvbmV0L21hYzgw
MjExL2llZWU4MDIxMV9pLmgKKysrIGIvbmV0L21hYzgwMjExL2llZWU4MDIxMV9pLmgKQEAgLTE0
Myw2ICsxNDMsOCBAQCB0eXBlZGVmIHVuc2lnbmVkIF9fYml0d2lzZV9fIGllZWU4MDIxMV90eF9y
ZXN1bHQ7CiAjZGVmaW5lIElFRUU4MDIxMV9UWF9GUkFHTUVOVEVECQlCSVQoMCkKICNkZWZpbmUg
SUVFRTgwMjExX1RYX1VOSUNBU1QJCUJJVCgxKQogI2RlZmluZSBJRUVFODAyMTFfVFhfUFNfQlVG
RkVSRUQJQklUKDIpCisjZGVmaW5lIElFRUU4MDIxMV9UWF9NT05fTk9fU0VRCQlCSVQoMykKKyNk
ZWZpbmUgSUVFRTgwMjExX1RYX01PTl9OT19BQ0sJCUJJVCg0KQogCiBzdHJ1Y3QgaWVlZTgwMjEx
X3R4X2RhdGEgewogCXN0cnVjdCBza19idWZmICpza2I7CmRpZmYgLS1naXQgYS9uZXQvbWFjODAy
MTEvdHguYyBiL25ldC9tYWM4MDIxMS90eC5jCmluZGV4IDA4NTVjYWMuLmQwOGEyNWUgMTAwNjQ0
Ci0tLSBhL25ldC9tYWM4MDIxMS90eC5jCisrKyBiL25ldC9tYWM4MDIxMS90eC5jCkBAIC02MTQs
MTQgKzYxNCwxMiBAQCBpZWVlODAyMTFfdHhfaF9zZXF1ZW5jZShzdHJ1Y3QgaWVlZTgwMjExX3R4
X2RhdGEgKnR4KQogCSAqIG51bWJlciwgaWYgd2UgaGF2ZSBubyBtYXRjaGluZyBpbnRlcmZhY2Ug
dGhlbiB3ZQogCSAqIG5laXRoZXIgYXNzaWduIG9uZSBvdXJzZWx2ZXMgbm9yIGFzayB0aGUgZHJp
dmVyIHRvLgogCSAqLwotCWlmICh1bmxpa2VseSghaW5mby0+Y29udHJvbC52aWYpKQorCWlmICh1
bmxpa2VseSghaW5mby0+Y29udHJvbC52aWYgfHwKKwkJICAgICB0eC0+ZmxhZ3MgJiBJRUVFODAy
MTFfVFhfTU9OX05PX1NFUSB8fAorCQkgICAgIGllZWU4MDIxMV9pc19jdGwoaGRyLT5mcmFtZV9j
b250cm9sKSkgfHwKKwkJICAgICBpZWVlODAyMTFfaGRybGVuKGhkci0+ZnJhbWVfY29udHJvbCkg
PCAyNCkKIAkJcmV0dXJuIFRYX0NPTlRJTlVFOwogCi0JaWYgKHVubGlrZWx5KGllZWU4MDIxMV9p
c19jdGwoaGRyLT5mcmFtZV9jb250cm9sKSkpCi0JCXJldHVybiBUWF9DT05USU5VRTsKLQotCWlm
IChpZWVlODAyMTFfaGRybGVuKGhkci0+ZnJhbWVfY29udHJvbCkgPCAyNCkKLQkJcmV0dXJuIFRY
X0NPTlRJTlVFOwogCiAJLyoKIAkgKiBBbnl0aGluZyBidXQgUW9TIGRhdGEgdGhhdCBoYXMgYSBz
ZXF1ZW5jZSBudW1iZXIgZmllbGQKQEAgLTkxMywxMyArOTExLDE3IEBAIF9faWVlZTgwMjExX3Bh
cnNlX3R4X3JhZGlvdGFwKHN0cnVjdCBpZWVlODAyMTFfdHhfZGF0YSAqdHgsCiAJCQlpZiAoKml0
ZXJhdG9yLnRoaXNfYXJnICYgSUVFRTgwMjExX1JBRElPVEFQX0ZfRlJBRykKIAkJCQl0eC0+Zmxh
Z3MgfD0gSUVFRTgwMjExX1RYX0ZSQUdNRU5URUQ7CiAJCQlicmVhazsKLQorCQljYXNlIElFRUU4
MDIxMV9SQURJT1RBUF9UWF9GTEFHUzoKKwkJCWlmICgqaXRlcmF0b3IudGhpc19hcmcgJiBJRUVF
ODAyMTFfUkFESU9UQVBfRl9UWF9OT0FDSykKKwkJCQl0eC0+ZmxhZ3MgfD0gSUVFRTgwMjExX1RY
X01PTl9OT19BQ0s7CisJCQlpZiAoKml0ZXJhdG9yLnRoaXNfYXJnICYgSUVFRTgwMjExX1JBRElP
VEFQX0ZfVFhfTk9TRVEpCisJCQkJdHgtPmZsYWdzIHw9IElFRUU4MDIxMV9UWF9NT05fTk9fU0VR
OworCQkJYnJlYWs7CiAJCS8qCiAJCSAqIFBsZWFzZSB1cGRhdGUgdGhlIGZpbGUKIAkJICogRG9j
dW1lbnRhdGlvbi9uZXR3b3JraW5nL21hYzgwMjExLWluamVjdGlvbi50eHQKIAkJICogd2hlbiBw
YXJzaW5nIG5ldyBmaWVsZHMgaGVyZS4KIAkJICovCi0KIAkJZGVmYXVsdDoKIAkJCWJyZWFrOwog
CQl9CkBAIC0xMDAwLDYgKzEwMDIsOSBAQCBfX2llZWU4MDIxMV90eF9wcmVwYXJlKHN0cnVjdCBp
ZWVlODAyMTFfdHhfZGF0YSAqdHgsCiAJCWluZm8tPmZsYWdzICY9IH5JRUVFODAyMTFfVFhfQ1RM
X05PX0FDSzsKIAl9CiAKKwlpZiAodHgtPmZsYWdzICYgSUVFRTgwMjExX1RYX01PTl9OT19BQ0sp
CisJCWluZm8tPmZsYWdzIHw9IElFRUU4MDIxMV9UWF9DVExfTk9fQUNLOworCiAJaWYgKHR4LT5m
bGFncyAmIElFRUU4MDIxMV9UWF9GUkFHTUVOVEVEKSB7CiAJCWlmICgodHgtPmZsYWdzICYgSUVF
RTgwMjExX1RYX1VOSUNBU1QpICYmCiAJCSAgICBza2ItPmxlbiArIEZDU19MRU4gPiBsb2NhbC0+
ZnJhZ21lbnRhdGlvbl90aHJlc2hvbGQgJiYK
------=_Part_27832_32783571.1229121158894--
