Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:49021 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKZWbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 17:31:05 -0500
Received: by qyk4 with SMTP id 4so967751qyk.13
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 14:31:03 -0800 (PST)
Message-ID: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com> (sfid-20081126_233110_621920_E110BF5A)
Date: Wed, 26 Nov 2008 23:31:03 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_31144_21387733.1227738663297"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_Part_31144_21387733.1227738663297
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

(Patch also available as an attachment in case Gmail decides to linewrap it=
.)

Currently we always wait for an ACK even if IEEE80211_TX_CTL_NO_ACK is set.
This is just the opposite of what other drivers do.
Change both RTL8187L and RTL8187B to skip waiting for an ACK when no
ACK was requested.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 9fd23b5..7f12d9f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -230,7 +230,10 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 =09=09hdr->flags =3D cpu_to_le32(flags);
 =09=09hdr->len =3D 0;
 =09=09hdr->rts_duration =3D rts_dur;
-=09=09hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
+=09=09if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+=09=09=09hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
+=09=09else
+=09=09=09hdr->retry =3D 0;
 =09=09buf =3D hdr;

 =09=09ep =3D 2;
@@ -248,7 +251,10 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 =09=09memset(hdr, 0, sizeof(*hdr));
 =09=09hdr->flags =3D cpu_to_le32(flags);
 =09=09hdr->rts_duration =3D rts_dur;
-=09=09hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
+=09=09if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+=09=09=09hdr->retry =3D cpu_to_le32(info->control.rates[0].count << 8);
+=09=09else
+=09=09=09hdr->retry =3D 0;
 =09=09hdr->tx_duration =3D
 =09=09=09ieee80211_generic_frame_duration(dev, priv->vif,
 =09=09=09=09=09=09=09 skb->len, txrate);
--=20
1.5.4.5

------=_Part_31144_21387733.1227738663297
Content-Type: application/octet-stream;
 name=0001-rtl8187-Do-not-wait-for-an-ACK-when-IEEE80211_TX_CT.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fo0jvadp0
Content-Disposition: attachment;
 filename=0001-rtl8187-Do-not-wait-for-an-ACK-when-IEEE80211_TX_CT.patch

RnJvbSBjOGQ0ODMwNmE0ODZjMjI2ZTJhYTBkNjJmYjQzMTYzODdiMmIwYTdmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiByb290IDxyb290QE5SM0RNYWluLk5SM0Q+CkRhdGU6IFdlZCwg
MjYgTm92IDIwMDggMjM6MTc6MDAgKzAxMDAKU3ViamVjdDogW1JGQ10gcnRsODE4NzogRG8gbm90
IHdhaXQgZm9yIGFuIEFDSyB3aGVuIElFRUU4MDIxMV9UWF9DVExfTk9fQUNLIGlzIHNldApNSU1F
LVZlcnNpb246IDEuMApDb250ZW50LVR5cGU6IHRleHQvcGxhaW47IGNoYXJzZXQ9dXRmLTgKQ29u
dGVudC1UcmFuc2Zlci1FbmNvZGluZzogOGJpdAoKQ3VycmVudGx5IHdlIGFsd2F5cyB3YWl0IGZv
ciBhbiBBQ0sgZXZlbiBpZiBJRUVFODAyMTFfVFhfQ1RMX05PX0FDSyBpcyBzZXQuClRoaXMgaXMg
anVzdCB0aGUgb3Bwb3NpdGUgb2Ygd2hhdCBvdGhlciBkcml2ZXJzIGRvLgpDaGFuZ2UgYm90aCBS
VEw4MTg3TCBhbmQgUlRMODE4N0IgdG8gc2tpcCB3YWl0aW5nIGZvciBhbiBBQ0sgd2hlbiBubyBB
Q0sgd2FzIHJlcXVlc3RlZC4KClNpZ25lZC1vZmYtYnk6IEfDoWJvciBTdGVmYW5payA8bmV0cm9s
bGxlci4zZEBnbWFpbC5jb20+Ci0tLQogZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsODE4eC9ydGw4
MTg3X2Rldi5jIHwgICAxMCArKysrKysrKy0tCiAxIGZpbGVzIGNoYW5nZWQsIDggaW5zZXJ0aW9u
cygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9y
dGw4MTh4L3J0bDgxODdfZGV2LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGw4MTh4L3J0bDgx
ODdfZGV2LmMKaW5kZXggOWZkMjNiNS4uN2YxMmQ5ZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQv
d2lyZWxlc3MvcnRsODE4eC9ydGw4MTg3X2Rldi5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L3J0bDgxOHgvcnRsODE4N19kZXYuYwpAQCAtMjMwLDcgKzIzMCwxMCBAQCBzdGF0aWMgaW50IHJ0
bDgxODdfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQog
CQloZHItPmZsYWdzID0gY3B1X3RvX2xlMzIoZmxhZ3MpOwogCQloZHItPmxlbiA9IDA7CiAJCWhk
ci0+cnRzX2R1cmF0aW9uID0gcnRzX2R1cjsKLQkJaGRyLT5yZXRyeSA9IGNwdV90b19sZTMyKGlu
Zm8tPmNvbnRyb2wucmF0ZXNbMF0uY291bnQgPDwgOCk7CisJCWlmICghKGluZm8tPmZsYWdzICYg
SUVFRTgwMjExX1RYX0NUTF9OT19BQ0spKQorCQkJaGRyLT5yZXRyeSA9IGNwdV90b19sZTMyKGlu
Zm8tPmNvbnRyb2wucmF0ZXNbMF0uY291bnQgPDwgOCk7CisJCWVsc2UKKwkJCWhkci0+cmV0cnkg
PSAwOwogCQlidWYgPSBoZHI7CiAKIAkJZXAgPSAyOwpAQCAtMjQ4LDcgKzI1MSwxMCBAQCBzdGF0
aWMgaW50IHJ0bDgxODdfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqZGV2LCBzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiKQogCQltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhkcikpOwogCQloZHItPmZsYWdzID0g
Y3B1X3RvX2xlMzIoZmxhZ3MpOwogCQloZHItPnJ0c19kdXJhdGlvbiA9IHJ0c19kdXI7Ci0JCWhk
ci0+cmV0cnkgPSBjcHVfdG9fbGUzMihpbmZvLT5jb250cm9sLnJhdGVzWzBdLmNvdW50IDw8IDgp
OworCQlpZiAoIShpbmZvLT5mbGFncyAmIElFRUU4MDIxMV9UWF9DVExfTk9fQUNLKSkKKwkJCWhk
ci0+cmV0cnkgPSBjcHVfdG9fbGUzMihpbmZvLT5jb250cm9sLnJhdGVzWzBdLmNvdW50IDw8IDgp
OworCQllbHNlCisJCQloZHItPnJldHJ5ID0gMDsKIAkJaGRyLT50eF9kdXJhdGlvbiA9CiAJCQlp
ZWVlODAyMTFfZ2VuZXJpY19mcmFtZV9kdXJhdGlvbihkZXYsIHByaXYtPnZpZiwKIAkJCQkJCQkg
c2tiLT5sZW4sIHR4cmF0ZSk7Ci0tIAoxLjUuNC41Cgo=
------=_Part_31144_21387733.1227738663297--
