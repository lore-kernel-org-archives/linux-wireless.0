Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36625 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbZDWRgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:36:17 -0400
Received: by fxm2 with SMTP id 2so678146fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 10:36:15 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 19:36:00 +0200
Message-ID: <69e28c910904231036g4598e93apa7e88737a054063b@mail.gmail.com> (sfid-20090423_193621_314754_F7A067EC)
Subject: [PATCH 1/5] mac80211: Fix handling of retry count of NO_ACK frames in
	minstrel
To: John Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>
Content-Type: multipart/mixed; boundary=000e0cd250481e9a0a04683c5138
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd250481e9a0a04683c5138
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Make the retry count zero (total try count =3D 1) for frames with
IEEE80211_TX_CTL_NO_ACK set.

Also remove the check for is_multicast_ether_addr in use_low_rate,
which is redundant because all multicasts have IEEE80211_TX_CTL_NO_ACK
set.

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

--000e0cd250481e9a0a04683c5138
Content-Type: text/x-patch; charset=US-ASCII; name="minstrel-fix-no-ack-retry-count.patch"
Content-Disposition: attachment;
	filename="minstrel-fix-no-ack-retry-count.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftvqdtz20

IHJjODAyMTFfbWluc3RyZWwuYyB8ICAgIDggKysrKystLS0KIDEgZmlsZSBjaGFuZ2VkLCA1IGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0L21hYzgwMjExL3Jj
ODAyMTFfbWluc3RyZWwuYyBiL25ldC9tYWM4MDIxMS9yYzgwMjExX21pbnN0cmVsLmMKaW5kZXgg
MzgyNDk5MC4uNTE5NjAwNiAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3JjODAyMTFfbWluc3Ry
ZWwuYworKysgYi9uZXQvbWFjODAyMTEvcmM4MDIxMV9taW5zdHJlbC5jCkBAIC04MCw4ICs4MCw3
IEBAIHVzZV9sb3dfcmF0ZShzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCWZjID0gbGUxNl90b19jcHUo
aGRyLT5mcmFtZV9jb250cm9sKTsKIAogCXJldHVybiAoKGluZm8tPmZsYWdzICYgSUVFRTgwMjEx
X1RYX0NUTF9OT19BQ0spIHx8Ci0JCShmYyAmIElFRUU4MDIxMV9GQ1RMX0ZUWVBFKSAhPSBJRUVF
ODAyMTFfRlRZUEVfREFUQSB8fAotCQlpc19tdWx0aWNhc3RfZXRoZXJfYWRkcihoZHItPmFkZHIx
KSk7CisJCShmYyAmIElFRUU4MDIxMV9GQ1RMX0ZUWVBFKSAhPSBJRUVFODAyMTFfRlRZUEVfREFU
QSk7CiB9CiAKIApAQCAtMjQ1LDcgKzI0NCwxMCBAQCBtaW5zdHJlbF9nZXRfcmF0ZSh2b2lkICpw
cml2LCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLAogCiAJaWYgKCFzdGEgfHwgIW1pIHx8IHVz
ZV9sb3dfcmF0ZShza2IpKSB7CiAJCWFyWzBdLmlkeCA9IHJhdGVfbG93ZXN0X2luZGV4KHNiYW5k
LCBzdGEpOwotCQlhclswXS5jb3VudCA9IG1wLT5tYXhfcmV0cnk7CisJCWlmIChpbmZvLT5mbGFn
cyAmIElFRUU4MDIxMV9UWF9DVExfTk9fQUNLKQorCQkJYXJbMF0uY291bnQgPSAxOworCQllbHNl
CisJCQlhclswXS5jb3VudCA9IG1wLT5tYXhfcmV0cnk7CiAJCXJldHVybjsKIAl9CiAK
--000e0cd250481e9a0a04683c5138--
