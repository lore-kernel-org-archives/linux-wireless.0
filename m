Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:48813 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZDWSG1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 14:06:27 -0400
Received: by fg-out-1718.google.com with SMTP id 16so41947fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 11:06:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910904231036r131612e3vabdab0302659fb63@mail.gmail.com>
References: <69e28c910904231036r131612e3vabdab0302659fb63@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 23 Apr 2009 20:06:06 +0200
Message-ID: <69e28c910904231106j7f74fe2fo471479c582985413@mail.gmail.com> (sfid-20090423_200630_591949_172AA745)
Subject: [PATCH 2/5 v2] mac80211: Fix handling of retry count of NO_ACK frames
	in PID
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: multipart/mixed; boundary=000e0cd24492c62ad604683cbc85
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd24492c62ad604683cbc85
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Make PID check for IEEE80211_TX_CTL_NO_ACK instead of
is_multicast_ether_addr when determining whether to use the lowest
rate, and set the retry count to 0 (total try count =3D 1) if
IEEE80211_TX_CTL_NO_ACK is set.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---
v2: I accidentally inlined the minstrel patch. The attachment is
identical to v1.
Patch also available as an attachment if Gmail linewraps it.

 rc80211_pid_algo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_alg=
o.c
index b16801c..2b33e3a 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -289,13 +289,15 @@ rate_control_pid_get_rate(void *priv, struct
ieee80211_sta *sta,
 		info->control.rates[0].count =3D
 			txrc->hw->conf.short_frame_max_tx_count;

-	/* Send management frames and broadcast/multicast data using lowest
-	 * rate. */
+	/* Send management frames and NO_ACK data using lowest rate. */
 	fc =3D le16_to_cpu(hdr->frame_control);
 	if (!sta || !spinfo ||
 	    (fc & IEEE80211_FCTL_FTYPE) !=3D IEEE80211_FTYPE_DATA ||
-	    is_multicast_ether_addr(hdr->addr1)) {
+	    info->flags & IEEE80211_TX_CTL_NO_ACK) {
 		info->control.rates[0].idx =3D rate_lowest_index(sband, sta);
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+			info->control.rates[0].count =3D 1;
+
 		return;
 	}

--000e0cd24492c62ad604683cbc85
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
--000e0cd24492c62ad604683cbc85--
