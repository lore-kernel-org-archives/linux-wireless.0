Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:50926 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZDNWew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2009 18:34:52 -0400
Received: by fg-out-1718.google.com with SMTP id 16so547003fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2009 15:34:51 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 15 Apr 2009 00:34:36 +0200
Message-ID: <69e28c910904141534w7ed9b36w817f1862ff015286@mail.gmail.com> (sfid-20090415_003456_665697_0A63AE97)
Subject: [PATCH RFC] mac80211: don't ask drivers to retry transmitting NO_ACK
	frames
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <hintak.leung@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd297ba6bd7c104678b70f6
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd297ba6bd7c104678b70f6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Set the total count of TX tries to 1 if IEEE80211_TX_CTL_NO_ACK is
set. This fixes a bug where mac80211 allowed the RC algo to request
drivers to forcibly retransmit NO_ACK (e.g. multicast) frames until
the excessive-retries limit is reached.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>

---
Patch also available as attachment in case Gmail linewraps it.

 tx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b47435d..751934b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -539,7 +539,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee80211_tx_data *tx)
 	if (tx->sta)
 		tx->sta->last_tx_rate =3D txrc.reported_rate;

-	if (unlikely(!info->control.rates[0].count))
+	if (unlikely(!info->control.rates[0].count) ||
+	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		info->control.rates[0].count =3D 1;

 	if (is_multicast_ether_addr(hdr->addr1)) {

--000e0cd297ba6bd7c104678b70f6
Content-Type: text/x-patch; charset=US-ASCII;
	name="mac80211-fix-tx-ctl-no-ack-retry-count.patch"
Content-Disposition: attachment;
	filename="mac80211-fix-tx-ctl-no-ack-retry-count.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ftj61jd30

IHR4LmMgfCAgICAzICsrLQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxl
dGlvbigtKQoKZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS90eC5jIGIvbmV0L21hYzgwMjExL3R4
LmMKaW5kZXggYjQ3NDM1ZC4uNzUxOTM0YiAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3R4LmMK
KysrIGIvbmV0L21hYzgwMjExL3R4LmMKQEAgLTUzOSw3ICs1MzksOCBAQCBpZWVlODAyMTFfdHhf
aF9yYXRlX2N0cmwoc3RydWN0IGllZWU4MDIxMV90eF9kYXRhICp0eCkKIAlpZiAodHgtPnN0YSkK
IAkJdHgtPnN0YS0+bGFzdF90eF9yYXRlID0gdHhyYy5yZXBvcnRlZF9yYXRlOwogCi0JaWYgKHVu
bGlrZWx5KCFpbmZvLT5jb250cm9sLnJhdGVzWzBdLmNvdW50KSkKKwlpZiAodW5saWtlbHkoIWlu
Zm8tPmNvbnRyb2wucmF0ZXNbMF0uY291bnQpIHx8CisJICAgIGluZm8tPmZsYWdzICYgSUVFRTgw
MjExX1RYX0NUTF9OT19BQ0spCiAJCWluZm8tPmNvbnRyb2wucmF0ZXNbMF0uY291bnQgPSAxOwog
CiAJaWYgKGlzX211bHRpY2FzdF9ldGhlcl9hZGRyKGhkci0+YWRkcjEpKSB7Cg==
--000e0cd297ba6bd7c104678b70f6--
