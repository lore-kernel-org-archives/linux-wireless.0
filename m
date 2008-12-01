Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:27867 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYLAKbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:31:17 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1007903eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:31:16 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 4/5] Don't use recursive make for verify target.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 11:31:15 +0100
Message-ID: <20081201103114.18024.65370.stgit@localhost> (sfid-20081201_113120_077548_84EE48EF)
In-Reply-To: <20081201103016.18024.80454.stgit@localhost>
References: <20081201103016.18024.80454.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

=46rom: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>

This makes the build more parallel since regdbdump.o build and link
can happen in parallel with the keys generation and the build of the
rest of the units.

Signed-off-by: Diego E. 'Flameeyes' Petten=C3=B2 <flameeyes@gmail.com>
---

 Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 4ac8495..a8c0a45 100644
--- a/Makefile
+++ b/Makefile
@@ -7,8 +7,7 @@ PUBKEY_DIR=3Dpubkeys
=20
 CFLAGS +=3D -Wall -g
=20
-all: crda intersect
-	$(Q)$(MAKE) --no-print-directory -f Makefile verify
+all: crda intersect verify
=20
 ifeq ($(USE_OPENSSL),1)
 CFLAGS +=3D -DUSE_OPENSSL `pkg-config --cflags openssl`

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
