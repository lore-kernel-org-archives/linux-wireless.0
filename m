Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36625 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbZDWRgU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:36:20 -0400
Received: by mail-fx0-f158.google.com with SMTP id 2so678146fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 10:36:19 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 19:36:04 +0200
Message-ID: <69e28c910904231036r131612e3vabdab0302659fb63@mail.gmail.com> (sfid-20090423_193622_742259_5B86ADA1)
Subject: [PATCH 2/5] mac80211: Fix handling of retry count of NO_ACK frames in
	PID
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: multipart/mixed; boundary=000e0cd297ba5d902e04683c51f0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd297ba5d902e04683c51f0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Make PID check for IEEE80211_TX_CTL_NO_ACK instead of
is_multicast_ether_addr when determining whether to use the lowest
rate, and set the retry count to 0 (total try count =3D 1) if
IEEE80211_TX_CTL_NO_ACK is set.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---
Patch also available as an attachment if Gmail linewraps it.

 rc80211_minstrel.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstre=
l.c
index 3824990..5196006 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -80,8 +80,7 @@ use_low_rate(struct sk_buff *skb)
 	fc =3D le16_to_cpu(hdr->frame_control);

 	return ((info->flags & IEEE80211_TX_CTL_NO_ACK) ||
-		(fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
-		is_multicast_ether_addr(hdr->addr1));
+		(fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA);
 }


@@ -245,7 +244,10 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *st=
a,

 	if (!sta || !mi || use_low_rate(skb)) {
 		ar[0].idx =3D rate_lowest_index(sband, sta);
-		ar[0].count =3D mp->max_retry;
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			ar[0].count =3D 1;
+		else
+			ar[0].count =3D mp->max_retry;
 		return;
 	}

--000e0cd297ba5d902e04683c51f0
Content-Type: text/x-patch; charset=US-ASCII; name="pid-fix-no-ack-retry-count.patch"
Content-Disposition: attachment; filename="pid-fix-no-ack-retry-count.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftvqffl60

IHJjODAyMTFfcGlkX2FsZ28uYyB8ICAgIDggKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3Jj
ODAyMTFfcGlkX2FsZ28uYyBiL25ldC9tYWM4MDIxMS9yYzgwMjExX3BpZF9hbGdvLmMKaW5kZXgg
YjE2ODAxYy4uMmIzM2UzYSAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3JjODAyMTFfcGlkX2Fs
Z28uYworKysgYi9uZXQvbWFjODAyMTEvcmM4MDIxMV9waWRfYWxnby5jCkBAIC0yODksMTMgKzI4
OSwxNSBAQCByYXRlX2NvbnRyb2xfcGlkX2dldF9yYXRlKHZvaWQgKnByaXYsIHN0cnVjdCBpZWVl
ODAyMTFfc3RhICpzdGEsCiAJCWluZm8tPmNvbnRyb2wucmF0ZXNbMF0uY291bnQgPQogCQkJdHhy
Yy0+aHctPmNvbmYuc2hvcnRfZnJhbWVfbWF4X3R4X2NvdW50OwogCi0JLyogU2VuZCBtYW5hZ2Vt
ZW50IGZyYW1lcyBhbmQgYnJvYWRjYXN0L211bHRpY2FzdCBkYXRhIHVzaW5nIGxvd2VzdAotCSAq
IHJhdGUuICovCisJLyogU2VuZCBtYW5hZ2VtZW50IGZyYW1lcyBhbmQgTk9fQUNLIGRhdGEgdXNp
bmcgbG93ZXN0IHJhdGUuICovCiAJZmMgPSBsZTE2X3RvX2NwdShoZHItPmZyYW1lX2NvbnRyb2wp
OwogCWlmICghc3RhIHx8ICFzcGluZm8gfHwKIAkgICAgKGZjICYgSUVFRTgwMjExX0ZDVExfRlRZ
UEUpICE9IElFRUU4MDIxMV9GVFlQRV9EQVRBIHx8Ci0JICAgIGlzX211bHRpY2FzdF9ldGhlcl9h
ZGRyKGhkci0+YWRkcjEpKSB7CisJICAgIGluZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9O
T19BQ0spIHsKIAkJaW5mby0+Y29udHJvbC5yYXRlc1swXS5pZHggPSByYXRlX2xvd2VzdF9pbmRl
eChzYmFuZCwgc3RhKTsKKwkJaWYgKGluZm8tPmZsYWdzICYgSUVFRTgwMjExX1RYX0NUTF9OT19B
Q0spCisJCQlpbmZvLT5jb250cm9sLnJhdGVzWzBdLmNvdW50ID0gMTsKKwogCQlyZXR1cm47CiAJ
fQogCg==
--000e0cd297ba5d902e04683c51f0--
