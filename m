Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:51525 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbXISSws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 14:52:48 -0400
Date: Wed, 19 Sep 2007 11:50:28 -0700
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2.6.23] WE : Fix ESSID API
Message-ID: <20070919185028.GA22011@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi,

	The hack introduced one year ago to support the old ESSID API
is proving even more problematic than I first though. It does not
work, and therefore it need to be removed.

	First problem : you can not read an ESSID with 32
char. Philippe Teuwen was the first one to report that, followed by
the MadWifi team :
                http://madwifi.org/ticket/930
	This is trivial to test. You just set an ESSID with 32
character using iwconfig, and you will see that iwconfig won't display
it back.
	More info :
		http://marc.info/?t=118401941300001&r=1&w=2

	Second problem : a spurious NUL character is always appended
to the ESSID. Johannes ask me to change iwconfig to display non-ascii
characters in ESSID, and this bug is preventing this change.
	If you use a version of iwconfig aware of non-ASCII
characters (30.pre1), this is what it will display :
---------------------------------------------------
eth0      IEEE 802.11b  ESSID:"my_essid\x00"
---------------------------------------------------
	Supporting non-ASCII characters in ESSID is getting more and
more important, as more an more network out there are starting to use
them. The painful API change started 18 months ago was designed to
enable that, but unfortunately this is not yet the possible.
	More info :
		http://marc.info/?t=118958503300003&r=1&w=2

	The patch was tested for weeks on 2.6.22, and tested quickly
on 2.6.23-rc6. I also have a patch for 2.6.20/2.6.21.

	In my personal opinion, this patch is totally safe and should
go ASAP in the kernel and in the stable series. However, I understand
that you are not confortable with it, therefore a compromise would be
to push it in 2.6.24-pre1, and once it has baked enough in 2.6.24-pre,
to push it to the stable series (2.6.20 - not applicable to 2.6.16).

	Johannes : would you mind adding your own comments ?

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

