Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:61256 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbZDNSKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 14:10:12 -0400
Received: by fg-out-1718.google.com with SMTP id 16so514420fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 11:10:10 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 14 Apr 2009 20:09:55 +0200
Message-ID: <69e28c910904141109n4aa5cf20k39d1e75e33907977@mail.gmail.com> (sfid-20090414_201034_301771_08F469F4)
Subject: [PATCH] rtl8187: Disable TX retries if IEEE80211_TX_CTL_NO_ACK is set
To: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd29652d8d67b046787bd6b
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd29652d8d67b046787bd6b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Currently we always wait for an ACK even if IEEE80211_TX_CTL_NO_ACK is
set, and retry if no ACK is received. This means that if a multicast
packet is transmitted, it will always be retransmitted until the
excessive retries limit is reached, which AFAIK is against the IEEE
802.11 specification. Fix this by setting the retry limit to 0 if
IEEE80211_TX_CTL_NO_ACK is set.
This is also required for proper implementation of the proposed TX
Flags Radiotap field, specifically the No-ACK flag, which allows
userspace to transmit arbitrary packets without retrying or waiting
for an ACK.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
---
Patch is also available as an attachment if Gmail linewraps it.

 rtl8187_dev.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index fd81884..ec80e0b 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -258,7 +258,10 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 		hdr->flags =3D cpu_to_le32(flags);
 		hdr->len =3D 0;
 		hdr->rts_duration =3D rts_dur;
-		hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
+		if (!info->flags & IEEE80211_TX_CTL_NO_ACK))
+			hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
+		else
+			hdr->retry =3D 0;
 		buf =3D hdr;

 		ep =3D 2;
@@ -276,7 +279,10 @@ static int rtl8187_tx(struct ieee80211_hw *dev,
struct sk_buff *skb)
 		memset(hdr, 0, sizeof(*hdr));
 		hdr->flags =3D cpu_to_le32(flags);
 		hdr->rts_duration =3D rts_dur;
-		hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
+		if (!info->flags & IEEE80211_TX_CTL_NO_ACK))
+			hdr->retry =3D cpu_to_le32((info->control.rates[0].count - 1) << 8);
+		else
+			hdr->retry =3D 0;
 		hdr->tx_duration =3D
 			ieee80211_generic_frame_duration(dev, priv->vif,
 							 skb->len, txrate);

--000e0cd29652d8d67b046787bd6b
Content-Type: text/x-patch; charset=US-ASCII; name="rtl8187-honor-no-ack.patch"
Content-Disposition: attachment; filename="rtl8187-honor-no-ack.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftiwrkza0

IHJ0bDgxODdfZGV2LmMgfCAgIDEwICsrKysrKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcnRsODE4eC9ydGw4MTg3X2Rldi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsODE4eC9y
dGw4MTg3X2Rldi5jCmluZGV4IGZkODE4ODQuLmVjODBlMGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4N19kZXYuYworKysgYi9kcml2ZXJzL25ldC93aXJl
bGVzcy9ydGw4MTh4L3J0bDgxODdfZGV2LmMKQEAgLTI1OCw3ICsyNTgsMTAgQEAgc3RhdGljIGlu
dCBydGw4MTg3X3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmRldiwgc3RydWN0IHNrX2J1ZmYgKnNr
YikKIAkJaGRyLT5mbGFncyA9IGNwdV90b19sZTMyKGZsYWdzKTsKIAkJaGRyLT5sZW4gPSAwOwog
CQloZHItPnJ0c19kdXJhdGlvbiA9IHJ0c19kdXI7Ci0JCWhkci0+cmV0cnkgPSBjcHVfdG9fbGUz
MigoaW5mby0+Y29udHJvbC5yYXRlc1swXS5jb3VudCAtIDEpIDw8IDgpOworCQlpZiAoIWluZm8t
PmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9OT19BQ0spKQorCQkJaGRyLT5yZXRyeSA9IGNwdV90
b19sZTMyKChpbmZvLT5jb250cm9sLnJhdGVzWzBdLmNvdW50IC0gMSkgPDwgOCk7CisJCWVsc2UK
KwkJCWhkci0+cmV0cnkgPSAwOwogCQlidWYgPSBoZHI7CiAKIAkJZXAgPSAyOwpAQCAtMjc2LDcg
KzI3OSwxMCBAQCBzdGF0aWMgaW50IHJ0bDgxODdfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqZGV2
LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCQltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhkcikpOwog
CQloZHItPmZsYWdzID0gY3B1X3RvX2xlMzIoZmxhZ3MpOwogCQloZHItPnJ0c19kdXJhdGlvbiA9
IHJ0c19kdXI7Ci0JCWhkci0+cmV0cnkgPSBjcHVfdG9fbGUzMigoaW5mby0+Y29udHJvbC5yYXRl
c1swXS5jb3VudCAtIDEpIDw8IDgpOworCQlpZiAoIWluZm8tPmZsYWdzICYgSUVFRTgwMjExX1RY
X0NUTF9OT19BQ0spKQorCQkJaGRyLT5yZXRyeSA9IGNwdV90b19sZTMyKChpbmZvLT5jb250cm9s
LnJhdGVzWzBdLmNvdW50IC0gMSkgPDwgOCk7CisJCWVsc2UKKwkJCWhkci0+cmV0cnkgPSAwOwog
CQloZHItPnR4X2R1cmF0aW9uID0KIAkJCWllZWU4MDIxMV9nZW5lcmljX2ZyYW1lX2R1cmF0aW9u
KGRldiwgcHJpdi0+dmlmLAogCQkJCQkJCSBza2ItPmxlbiwgdHhyYXRlKTsK
--000e0cd29652d8d67b046787bd6b--
