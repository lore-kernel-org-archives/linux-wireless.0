Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:43909 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1JGG4h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 02:56:37 -0400
Received: by vws1 with SMTP id 1so2875853vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 23:56:36 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 7 Oct 2011 08:56:36 +0200
Message-ID: <CAFED-j=0-J_H0g3tZoDAX2q8VVFzYfs2n3im07vWkKC_wdh_bA@mail.gmail.com> (sfid-20111007_085640_732145_F397222C)
Subject: PATCH] mac80211: set no_cck also for hw_scan
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: multipart/mixed; boundary=20cf3079ba763923fc04aeaff125
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--20cf3079ba763923fc04aeaff125
Content-Type: text/plain; charset=ISO-8859-1

In case we are using hw_scan we should also
send no_cck information to lower layer.
---
 net/mac80211/scan.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 6f09eca..509d89e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -249,6 +249,7 @@ static bool ieee80211_prep_hw_scan(struct
ieee80211_local *local)
 	} while (!n_chans);

 	local->hw_scan_req->n_channels = n_chans;
+	local->hw_scan_req->no_cck = req->no_cck;

 	ielen = ieee80211_build_preq_ies(local, (u8 *)local->hw_scan_req->ie,
 					 req->ie, req->ie_len, band,
-- 
1.7.0.4

--20cf3079ba763923fc04aeaff125
Content-Type: application/octet-stream;
	name="0001-mac80211-set-no_cck-also-for-hw_scan.patch"
Content-Disposition: attachment;
	filename="0001-mac80211-set-no_cck-also-for-hw_scan.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtgtnof30

RnJvbSBhNzRjNDFkM2JhNWM1YTA1NTVkZmQwNzM5MWMzMmQ5MTA3MWMyYTE3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYW51c3ogRHppZWR6aWMgPGphbnVzei5kemllZHppY0B0aWV0
by5jb20+CkRhdGU6IEZyaSwgNyBPY3QgMjAxMSAwODo0ODo0NyArMDIwMApTdWJqZWN0OiBbUEFU
Q0hdIG1hYzgwMjExOiBzZXQgbm9fY2NrIGFsc28gZm9yIGh3X3NjYW4KCkluIGNhc2Ugd2UgYXJl
IHVzaW5nIGh3X3NjYW4gd2Ugc2hvdWxkIGFsc28Kc2VuZCBub19jY2sgaW5mb3JtYXRpb24gdG8g
bG93ZXIgbGF5ZXIuCi0tLQogbmV0L21hYzgwMjExL3NjYW4uYyB8ICAgIDEgKwogMSBmaWxlcyBj
aGFuZ2VkLCAxIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvbmV0
L21hYzgwMjExL3NjYW4uYyBiL25ldC9tYWM4MDIxMS9zY2FuLmMKaW5kZXggNmYwOWVjYS4uNTA5
ZDg5ZSAxMDA2NDQKLS0tIGEvbmV0L21hYzgwMjExL3NjYW4uYworKysgYi9uZXQvbWFjODAyMTEv
c2Nhbi5jCkBAIC0yNDksNiArMjQ5LDcgQEAgc3RhdGljIGJvb2wgaWVlZTgwMjExX3ByZXBfaHdf
c2NhbihzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCkKIAl9IHdoaWxlICghbl9jaGFucyk7
CiAKIAlsb2NhbC0+aHdfc2Nhbl9yZXEtPm5fY2hhbm5lbHMgPSBuX2NoYW5zOworCWxvY2FsLT5o
d19zY2FuX3JlcS0+bm9fY2NrID0gcmVxLT5ub19jY2s7CiAKIAlpZWxlbiA9IGllZWU4MDIxMV9i
dWlsZF9wcmVxX2llcyhsb2NhbCwgKHU4ICopbG9jYWwtPmh3X3NjYW5fcmVxLT5pZSwKIAkJCQkJ
IHJlcS0+aWUsIHJlcS0+aWVfbGVuLCBiYW5kLAotLSAKMS43LjAuNAoK
--20cf3079ba763923fc04aeaff125--
