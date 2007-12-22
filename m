Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53133
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbXLVExn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 23:53:43 -0500
Date: Fri, 21 Dec 2007 20:53:42 -0800 (PST)
Message-Id: <20071221.205342.212121038.davem@davemloft.net> (sfid-20071222_045347_187344_2BC37A90)
To: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Subject: [WEXT 2/12]: Make adjust_priv_size() take a "struct iw_point *".
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


[WEXT]: Make adjust_priv_size() take a "struct iw_point *".

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/wireless/wext.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 677be28..3ca9c3a 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -526,9 +526,9 @@ static int get_priv_size(__u16 args)
 /*
  * Re-calculate the size of private arguments
  */
-static int adjust_priv_size(__u16 args, union iwreq_data *wrqu)
+static int adjust_priv_size(__u16 args, struct iw_point *iwp)
 {
-	int	num = wrqu->data.length;
+	int	num = iwp->length;
 	int	max = args & IW_PRIV_SIZE_MASK;
 	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
 
@@ -1008,7 +1008,7 @@ static int ioctl_private_call(struct net_device *dev, struct ifreq *ifr,
 			 * avoid leaking kernel bits outside. */
 			if (!(descr->get_args & IW_PRIV_SIZE_FIXED)) {
 				extra_size = adjust_priv_size(descr->get_args,
-							      &(iwr->u));
+							      &(iwr->u.data));
 			}
 
 			err = copy_to_user(iwr->u.data.pointer, extra,
-- 
1.5.4.rc1

