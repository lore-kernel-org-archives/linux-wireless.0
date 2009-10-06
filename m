Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42495 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758253AbZJFVQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 17:16:42 -0400
Date: Tue, 6 Oct 2009 17:11:02 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Riffer <riffer@penny.prima.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Bleeding Edge b43 dated since 30 of september no longer
	working & today does not even compile.
Message-ID: <20091006211102.GC2911@tuxdriver.com>
References: <4ACB91E7.5010405@penny.prima.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4ACB91E7.5010405@penny.prima.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2009 at 08:52:23PM +0200, Riffer wrote:

> Another problem is that the archive from today can not be compiled:
> 
> /home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/main.o
> In file included from
> /home/riffer/bleeding/compat-wireless-2009-10-06/include/net/mac80211.h:22,
>                  from
> /home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/ath.h:22,
>                  from
> /home/riffer/bleeding/compat-wireless-2009-10-06/drivers/net/wireless/ath/main.c:20:
> /home/riffer/bleeding/compat-wireless-2009-10-06/include/net/cfg80211.h:1146:
> Fehler: »ETHTOOL_BUSINFO_LEN« ist hier nicht deklariert (nicht in einer
> Funktion)
> (translation:
> Error »ETHTOOL_BUSINFO_LEN« is not declared here (not in a function))

Odd that I didn't hit that, but whatever...does this fix it for you?

>From 463049630fa4c256025093ce94c66f9f4247b7c8 Mon Sep 17 00:00:00 2001
From: John W. Linville <linville@tuxdriver.com>
Date: Tue, 6 Oct 2009 16:55:28 -0400
Subject: [PATCH] cfg80211: fix compile error from missing ethtool.h

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/net/cfg80211.h |    1 +
 net/wireless/ethtool.h |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6f4862b..14915ea 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -18,6 +18,7 @@
 #include <linux/nl80211.h>
 #include <linux/if_ether.h>
 #include <linux/ieee80211.h>
+#include <linux/ethtool.h>
 #include <net/regulatory.h>
 
 /* remove once we remove the wext stuff */
diff --git a/net/wireless/ethtool.h b/net/wireless/ethtool.h
index 70cbee1..695ecad 100644
--- a/net/wireless/ethtool.h
+++ b/net/wireless/ethtool.h
@@ -1,8 +1,6 @@
 #ifndef __CFG80211_ETHTOOL__
 #define __CFG80211_ETHTOOL__
 
-#include <linux/ethtool.h>
-
 extern const struct ethtool_ops cfg80211_ethtool_ops;
 
 #endif /* __CFG80211_ETHTOOL__ */
-- 
1.6.2.5

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
