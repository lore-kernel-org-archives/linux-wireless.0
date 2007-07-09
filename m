Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:58556 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbXGIWOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 18:14:06 -0400
Date: Mon, 9 Jul 2007 15:13:22 -0700
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6] WE : Fix get 32 char ESSID
Message-ID: <20070709221322.GA1381@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

	A little bug was introduced a few months ago that prevent
reading ESSID with 32 character. Philippe Teuwen was the first one to
report that, followed by the MadWifi team :
		http://madwifi.org/ticket/930
	The patch fix this bug by removing obsolete code. It also
reenable setting the full range of ESSID, including ESSID with a final
NUL which are valid. This was tested on 2.6.21 and 2.6.22.
	John : would you mind pushing that to 2.6.23 ? If you are
happy with it, I can provide backport patches for earlier kernels.
        Thanks...

        Jean

Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>

-----------------------------------------------------------

--- linux/net/wireless/wext.j1.c	2007-07-09 13:19:22.000000000 -0700
+++ linux/net/wireless/wext.c	2007-07-09 13:19:59.000000000 -0700
@@ -741,39 +741,11 @@ static int ioctl_standard_call(struct ne
 		int	extra_size;
 		int	user_length = 0;
 		int	err;
-		int	essid_compat = 0;
 
 		/* Calculate space needed by arguments. Always allocate
 		 * for max space. Easier, and won't last long... */
 		extra_size = descr->max_tokens * descr->token_size;
 
-		/* Check need for ESSID compatibility for WE < 21 */
-		switch (cmd) {
-		case SIOCSIWESSID:
-		case SIOCGIWESSID:
-		case SIOCSIWNICKN:
-		case SIOCGIWNICKN:
-			if (iwr->u.data.length == descr->max_tokens + 1)
-				essid_compat = 1;
-			else if (IW_IS_SET(cmd) && (iwr->u.data.length != 0)) {
-				char essid[IW_ESSID_MAX_SIZE + 1];
-
-				err = copy_from_user(essid, iwr->u.data.pointer,
-						     iwr->u.data.length *
-						     descr->token_size);
-				if (err)
-					return -EFAULT;
-
-				if (essid[iwr->u.data.length - 1] == '\0')
-					essid_compat = 1;
-			}
-			break;
-		default:
-			break;
-		}
-
-		iwr->u.data.length -= essid_compat;
-
 		/* Check what user space is giving us */
 		if (IW_IS_SET(cmd)) {
 			/* Check NULL pointer */
@@ -811,7 +783,6 @@ static int ioctl_standard_call(struct ne
 		}
 
 		/* Create the kernel buffer */
-		/*    kzalloc ensures NULL-termination for essid_compat */
 		extra = kzalloc(extra_size, GFP_KERNEL);
 		if (extra == NULL)
 			return -ENOMEM;
@@ -830,8 +801,6 @@ static int ioctl_standard_call(struct ne
 		/* Call the handler */
 		ret = handler(dev, &info, &(iwr->u), extra);
 
-		iwr->u.data.length += essid_compat;
-
 		/* If we have something to return to the user */
 		if (!ret && IW_IS_GET(cmd)) {
 			/* Check if there is enough buffer up there */

