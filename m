Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:47910 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZDMTyp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 15:54:45 -0400
Received: by fxm2 with SMTP id 2so2131175fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 12:54:43 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 13 Apr 2009 21:54:27 +0200
Message-ID: <69e28c910904131254q5f7a933aqc5614c4e0900ec17@mail.gmail.com> (sfid-20090413_215450_820711_9C96B8AB)
Subject: [PATCH] rtl8187: Remove the "8187B chip detected" message when
	probing RTL8187B cards
To: John Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: multipart/mixed; boundary=000e0cd28e9ce43d1404677515f9
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--000e0cd28e9ce43d1404677515f9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This message appears to be nothing more than a leftover of the
experimental-8187B era. Also, we print the HW type in the hwaddr line,
making this message reduntant. And it's definitely not important
enough to be a KERN_WARNING.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

---
Patch also available as attachment in case Gmail linewraps it.

rtl8187_dev.c |    3 ---
1 file changed, 3 deletions(-)
---

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c~
b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index fd81884..d6d4001 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c~
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1470,9 +1470,6 @@ static int __devinit rtl8187_probe(struct
usb_interface *intf,
 		(*channel++).hw_value =3D txpwr >> 8;
 	}

-	if (priv->is_rtl8187b)
-		printk(KERN_WARNING "rtl8187: 8187B chip detected.\n");
-
 	/*
 	 * XXX: Once this driver supports anything that requires
 	 *	beacons it must implement IEEE80211_TX_CTL_ASSIGN_SEQ.

--000e0cd28e9ce43d1404677515f9
Content-Type: text/x-patch; charset=US-ASCII; name="rtl8187-remove-8187b-warning.patch"
Content-Disposition: attachment;
	filename="rtl8187-remove-8187b-warning.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fthl22z00

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bDgxOHgvcnRsODE4N19kZXYuY34g
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGw4MTh4L3J0bDgxODdfZGV2LmMKaW5kZXggZmQ4MTg4
NC4uZDZkNDAwMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcnRsODE4eC9ydGw4
MTg3X2Rldi5jfgorKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGw4MTh4L3J0bDgxODdfZGV2
LmMKQEAgLTE0NzAsOSArMTQ3MCw2IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IHJ0bDgxODdfcHJv
YmUoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYsCiAJCSgqY2hhbm5lbCsrKS5od192YWx1ZSA9
IHR4cHdyID4+IDg7CiAJfQogCi0JaWYgKHByaXYtPmlzX3J0bDgxODdiKQotCQlwcmludGsoS0VS
Tl9XQVJOSU5HICJydGw4MTg3OiA4MTg3QiBjaGlwIGRldGVjdGVkLlxuIik7Ci0KIAkvKgogCSAq
IFhYWDogT25jZSB0aGlzIGRyaXZlciBzdXBwb3J0cyBhbnl0aGluZyB0aGF0IHJlcXVpcmVzCiAJ
ICoJYmVhY29ucyBpdCBtdXN0IGltcGxlbWVudCBJRUVFODAyMTFfVFhfQ1RMX0FTU0lHTl9TRVEu
Cg==
--000e0cd28e9ce43d1404677515f9--
