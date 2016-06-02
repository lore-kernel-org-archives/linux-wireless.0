Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33995 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932892AbcFBPRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 11:17:43 -0400
Received: by mail-pa0-f68.google.com with SMTP id x1so3567358pav.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2016 08:17:43 -0700 (PDT)
From: Dibyajyoti Ghosh <dibyajyotig@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: WiFi Mailing List <linux-wireless@vger.kernel.org>,
	Dibyajyoti Ghosh <dibyajyotig@gmail.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Prasun Maiti <prasunmaiti87@gmail.com>
Subject: [PATCH] Support for 32 bit iwpriv on 64 bits kernels
Date: Thu,  2 Jun 2016 20:51:43 +0530
Message-Id: <1464880903-13116-1-git-send-email-dibyajyotig@gmail.com> (sfid-20160602_171747_578378_55F11DF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds pointer conversion from 32 bit to 64 bit and vice versa,
if the ioctl is issued from 32 bit iwpriv to 64 bit Kernel.

Signed-off-by: Dibyajyoti Ghosh <dibyajyotig@gmail.com>
---
 wireless_tools.29/iwpriv.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/wireless_tools.29/iwpriv.c b/wireless_tools.29/iwpriv.c
index 4172fe2..a0b1b02 100644
--- a/wireless_tools.29/iwpriv.c
+++ b/wireless_tools.29/iwpriv.c
@@ -243,6 +243,7 @@ iw_usage(void)
   fprintf(stderr, "Usage: iwpriv interface [private-command [private-arguments]]\n");
 }
 
+#include<stdio.h>
 /************************* SETTING ROUTINES **************************/
 
 /*------------------------------------------------------------------*/
@@ -259,12 +260,20 @@ set_private_cmd(int		skfd,		/* Socket */
 		int		priv_num)	/* Number of descriptions */
 {
   struct iwreq	wrq;
+  struct compat_iw_point {
+    __u64 pointer;
+    __u16 length;
+    __u16 flags;
+  };
   u_char	buffer[4096];	/* Only that big in v25 and later */
   int		i = 0;		/* Start with first command arg */
   int		k;		/* Index in private description table */
   int		temp;
   int		subcmd = 0;	/* sub-ioctl index */
   int		offset = 0;	/* Space for sub-ioctl index */
+  FILE		*in;
+  char 		buff[4];
+  int		kspace, uspace;
 
   /* Check if we have a token index.
    * Do it now so that sub-ioctl takes precedence, and so that we
@@ -457,6 +466,26 @@ set_private_cmd(int		skfd,		/* Socket */
 	}
     }
 
+  in = popen("getconf LONG_BIT", "r");
+  fgets(buff, sizeof(buff), in);
+  pclose(in);
+  kspace = atoi(buff);
+  uspace = sizeof(char *) * 8;
+
+  struct compat_iw_point *iwp_compat = (struct compat_iw_point *)&wrq.u.data;
+  __u16 len = wrq.u.data.length;
+  __u16 flags = wrq.u.data.flags;
+
+  /* If 32 bit app is running on 64 bit kernel
+   * convert 32 bit iw_point type payload to 64 bit
+   */
+  if(uspace == 32 && kspace == 64)
+    {
+      iwp_compat->pointer = (__u64)((__u32)wrq.u.data.pointer);
+      iwp_compat->length = len;
+      iwp_compat->flags = flags;
+    }
+
   /* Perform the private ioctl */
   if(ioctl(skfd, priv[k].cmd, &wrq) < 0)
     {
@@ -465,6 +494,18 @@ set_private_cmd(int		skfd,		/* Socket */
       return(-1);
     }
 
+  /* If 32 bit app is running on 64 bit kernel, convert the
+   * 64 bit result back to 32 bit to fit the app
+   */
+  if(uspace == 32 && kspace == 64)
+    {
+      flags = iwp_compat->flags;
+      len = iwp_compat->length;
+      wrq.u.data.pointer = (__u32)iwp_compat->pointer;
+      wrq.u.data.length = iwp_compat->length;
+      wrq.u.data.flags = iwp_compat->flags;
+    }
+
   /* If we have to get some data */
   if((priv[k].get_args & IW_PRIV_TYPE_MASK) &&
      (priv[k].get_args & IW_PRIV_SIZE_MASK))
-- 
1.9.1

