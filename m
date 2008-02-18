Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:55108 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbYBRRtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2008 12:49:12 -0500
Received: from localhost (perninha.conectiva.com.br [127.0.0.1])
	by perninha.conectiva.com.br (Postfix) with ESMTP id C29563A987
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 14:49:09 -0300 (BRT)
Received: from perninha.conectiva.com.br ([127.0.0.1])
	by localhost (perninha.conectiva.com.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id L3Mbp5asmZqK for <linux-wireless@vger.kernel.org>;
	Mon, 18 Feb 2008 14:49:09 -0300 (BRT)
Received: from fox.conectiva (fox.conectiva [10.0.2.195])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 5924D3A985
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 14:49:09 -0300 (BRT)
Received: from gotham.conectiva (gotham.conectiva [10.0.2.23])
	by fox.conectiva (Postfix) with ESMTP id F3FA62F208
	for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2008 14:49:08 -0300 (BRT)
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Subject: Build problem when using linux/wireless.h header
Date: Mon, 18 Feb 2008 14:49:01 -0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200802181449.03719.herton@mandriva.com.br> (sfid-20080218_174919_220100_D5CA8064)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An error when building airpwn (airpwn.sf.net) was reported to me:

In file included from airpwn.c:36:
/usr/include/linux/wireless.h:886: error: 'IFNAMSIZ' undeclared here (not in a 
function)
airpwn.c: In function 'process_ip_packet':
airpwn.c:482: warning: ignoring return value of 'write', declared with 
attribute warn_unused_result
airpwn.c:483: warning: ignoring return value of 'write', declared with 
attribute warn_unused_result
airpwn.c:484: warning: ignoring return value of 'write', declared with 
attribute warn_unused_result
make[1]: *** [airpwn.o] Error 1

This is on a system with sanitized kernel headers installed. airpwn uses 
<linux/wireless.h>. The problem here is that wireless.h have:

#ifdef __KERNEL__
#include <linux/types.h>                /* for "caddr_t" et al          */
#include <linux/socket.h>               /* for "struct sockaddr" et al  */
#include <linux/if.h>                   /* for IFNAMSIZ and co... */
#endif  /* __KERNEL__ */

This when exported to user space is removed, but they are needed later on, 
otherwise you get build problems when using this header. One can say that the 
program including wireless.h should include manually the required headers, 
but doesn't seem very nice. Also wireless-tools include a copy of wireless.h, 
seems an unecessary duplication. So what about doing this:

- Don't export wireless.h from kernel to user space, since wireless-tools 
already provide it.
- Patch wireless-tools to include missing headers like this patch:

diff -p -up wireless_tools.29/wireless.21.h.orig wireless_tools.29/wireless.21.h
--- wireless_tools.29/wireless.21.h.orig	2008-02-18 13:19:47.000000000 -0300
+++ wireless_tools.29/wireless.21.h	2008-02-18 13:20:44.000000000 -0300
@@ -76,6 +76,10 @@
 #include <linux/types.h>		/* for "caddr_t" et al		*/
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/if.h>			/* for IFNAMSIZ and co... */
+#else
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <net/if.h>
 #endif	/* __KERNEL__ */
 
 /***************************** VERSION *****************************/
diff -p -up wireless_tools.29/wireless.22.h.orig wireless_tools.29/wireless.22.h
--- wireless_tools.29/wireless.22.h.orig	2008-02-18 13:19:53.000000000 -0300
+++ wireless_tools.29/wireless.22.h	2008-02-18 13:21:00.000000000 -0300
@@ -76,6 +76,10 @@
 #include <linux/types.h>		/* for "caddr_t" et al		*/
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/if.h>			/* for IFNAMSIZ and co... */
+#else
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <net/if.h>
 #endif	/* __KERNEL__ */
 
 /***************************** VERSION *****************************/

--
[]'s
Herton
