Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:40225 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab1BLSn5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 13:43:57 -0500
Subject: [PATCH 4/4] zd1211rw: add unlikely to ZD_ASSERT
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sat, 12 Feb 2011 20:43:51 +0200
Message-ID: <20110212184351.2062.10473.stgit@fate.lan>
In-Reply-To: <20110212184254.2062.33710.stgit@fate.lan>
References: <20110212184254.2062.33710.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Case assert is violated should be quite unlikely.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_def.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_def.h b/drivers/net/wireless/zd1211rw/zd_def.h
index 6ac597f..5463ca9 100644
--- a/drivers/net/wireless/zd1211rw/zd_def.h
+++ b/drivers/net/wireless/zd1211rw/zd_def.h
@@ -45,7 +45,7 @@ typedef u16 __nocast zd_addr_t;
 #ifdef DEBUG
 #  define ZD_ASSERT(x) \
 do { \
-	if (!(x)) { \
+	if (unlikely(!(x))) { \
 		pr_debug("%s:%d ASSERT %s VIOLATED!\n", \
 			__FILE__, __LINE__, __stringify(x)); \
 		dump_stack(); \

