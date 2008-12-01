Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:50837 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYLALL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:11:27 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1259158nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 03:11:26 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 2/3] Mark constant the generated key tables for libgcrypt.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 12:11:23 +0100
Message-ID: <20081201111123.20833.93890.stgit@localhost> (sfid-20081201_121130_567287_44358F3D)
In-Reply-To: <20081201111021.20833.42515.stgit@localhost>
References: <20081201111021.20833.42515.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since they are never modified, mark the key tables constant so they
are emitted in .rodata.

Note that even though they are probably also never modified, the
OpenSSL tables generate warnings when they are marked constant, as
such they are untouched.
---

 utils/key2pub.py |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/utils/key2pub.py b/utils/key2pub.py
index 8cd9596..bc1d33d 100755
--- a/utils/key2pub.py
+++ b/utils/key2pub.py
@@ -50,7 +50,7 @@ static struct pubkey keys[] = {
 def print_gcrypt(name, val):
     while val[0] == '\0':
         val = val[1:]
-    sys.stdout.write('static __u8 %s[%d] = {\n' % (name, len(val)))
+    sys.stdout.write('static const __u8 %s[%d] = {\n' % (name, len(val)))
     idx = 0
     for v in val:
         if not idx:
@@ -67,7 +67,7 @@ def print_gcrypt(name, val):
 def print_gcrypt_keys(n):
     sys.stdout.write(r'''
 struct key_params {
-	__u8 *e, *n;
+	const __u8 *e, *n;
 	__u32 len_e, len_n; 
 };
 
@@ -76,7 +76,7 @@ struct key_params {
 	.n = _n, .len_n = sizeof(_n),	\
 }
 
-static struct key_params keys[] = {
+static const struct key_params keys[] = {
 ''')
     for n in xrange(n + 1):
         sys.stdout.write('	KEYS(e_%d, n_%d),\n' % (n, n))

