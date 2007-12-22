Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53131
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752029AbXLVExN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 23:53:13 -0500
Date: Fri, 21 Dec 2007 20:53:13 -0800 (PST)
Message-Id: <20071221.205313.108820486.davem@davemloft.net> (sfid-20071222_045322_557402_1A1041AF)
To: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: [WEXT 1/12]: Remove inline from get_priv_size() and
 adjust_priv_size().
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[WEXT]: Remove inline from get_priv_size() and adjust_priv_size().

The compiler inlines when appropriate.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/wireless/wext.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 47e80cc..677be28 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -514,7 +514,7 @@ static int call_commit_handler(struct net_device *dev)
 /*
  * Calculate size of private arguments
  */
-static inline int get_priv_size(__u16	args)
+static int get_priv_size(__u16 args)
 {
 	int	num = args & IW_PRIV_SIZE_MASK;
 	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
@@ -526,8 +526,7 @@ static inline int get_priv_size(__u16	args)
 /*
  * Re-calculate the size of private arguments
  */
-static inline int adjust_priv_size(__u16		args,
-				   union iwreq_data *	wrqu)
+static int adjust_priv_size(__u16 args, union iwreq_data *wrqu)
 {
 	int	num = wrqu->data.length;
 	int	max = args & IW_PRIV_SIZE_MASK;
-- 
1.5.4.rc1

