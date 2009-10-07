Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48380 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZJGVQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 17:16:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
Date: Wed,  7 Oct 2009 17:07:52 -0400
Message-Id: <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should prevent this build error reported by Randy...

net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
make[3]: *** [net/wireless/wext-priv.o] Error 1

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 614bdce..d3ecca3 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -12,9 +12,11 @@ config WEXT_PROC
 
 config WEXT_SPY
 	bool
+	depends on WEXT_CORE
 
 config WEXT_PRIV
 	bool
+	depends on WEXT_CORE
 
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
-- 
1.6.2.5

