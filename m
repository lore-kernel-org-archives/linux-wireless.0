Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:39613 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYLALLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:11:33 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1015296eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 03:11:32 -0800 (PST)
From: Diego 'Flameeyes' =?utf-8?q?Petten=C3=B2?= <flameeyes@gmail.com>
Subject: [crda PATCH 3/3] Avoid implicit declaration of memset() with OpenSSL.
To: linux-wireless@vger.kernel.org
Date: Mon, 01 Dec 2008 12:11:31 +0100
Message-ID: <20081201111131.20833.81819.stgit@localhost> (sfid-20081201_121136_382134_2851788B)
In-Reply-To: <20081201111021.20833.42515.stgit@localhost>
References: <20081201111021.20833.42515.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building the libgcrypt-based code, string.h is included through
libgcrypt itself, but when building with OpenSSL it's missing.

Include it explicitly so that it's always safe.
---

 reglib.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/reglib.c b/reglib.c
index c173818..2f10d23 100644
--- a/reglib.c
+++ b/reglib.c
@@ -1,5 +1,6 @@
 #include <errno.h>
 #include <stdio.h>
+#include <string.h>
 #include <arpa/inet.h>
 #include "reglib.h"
 

