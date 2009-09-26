Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:36410 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZIZSyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:22 -0400
Date: Sat, 26 Sep 2009 20:51:14 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	mingo@elte.hu, linux-wireless@vger.kernel.org
Subject: [PATCH 3/9] Add bound checks in wext for copy_from_user
Message-ID: <20090926205114.4ec62382@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 3/9] Add bound checks in wext for copy_from_user
CC: linux-wireless@vger.kernel.org

The wireless extensions have a copy_from_user to a local stack
array "essid", but both me and gcc have failed to find where
the bounds for this copy are located in the code.

This patch adds some basic sanity checks for the copy length
to make sure that we don't overflow the stack buffer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 5b4a0ce..34beae6 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -773,10 +773,13 @@ static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
 			essid_compat = 1;
 		else if (IW_IS_SET(cmd) && (iwp->length != 0)) {
 			char essid[IW_ESSID_MAX_SIZE + 1];
+			unsigned int len;
+			len = iwp->length * descr->token_size;
 
-			err = copy_from_user(essid, iwp->pointer,
-					     iwp->length *
-					     descr->token_size);
+			if (len > IW_ESSID_MAX_SIZE)
+				return -EFAULT;
+
+			err = copy_from_user(essid, iwp->pointer, len);
 			if (err)
 				return -EFAULT;
 



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
