Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36435 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760549Ab1LPTTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:19:34 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 3/7] initvals: fix compiler error caused by a missing include
Date: Fri, 16 Dec 2011 20:19:21 +0100
Message-Id: <1324063165-4349-3-git-send-email-juhosg@openwrt.org> (sfid-20111216_201938_115838_8A5EB5A5)
In-Reply-To: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
References: <1324063165-4349-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[juhosg@idared initvals-tool]$ make all
gcc  -o initvals initvals.c
initvals.c: In function ‘ar9580_1p0_hw_print_initvals’:
initvals.c:476: error: ‘ar9580_1p0_modes_fast_clock’ undeclared (first use in this function)
initvals.c:476: error: (Each undeclared identifier is reported only once
initvals.c:476: error: for each function it appears in.)
<...>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 initvals.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/initvals.c b/initvals.c
index d8991aa..8ffd3fd 100644
--- a/initvals.c
+++ b/initvals.c
@@ -22,6 +22,7 @@ typedef long long unsigned int u64;
 #include "ar9002_initvals.h"
 #include "ar9003_2p2_initvals.h"
 #include "ar9485_initvals.h"
+#include "ar9580_1p0_initvals.h"
 
 #else
 
-- 
1.7.2.1

