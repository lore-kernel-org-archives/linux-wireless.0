Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:47557 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYJ2JfO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:35:14 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 533265000A
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 10:35:13 +0100 (CET)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wKCl9k9FsWZC for <linux-wireless@vger.kernel.org>;
	Wed, 29 Oct 2008 10:35:13 +0100 (CET)
Received: from lin01.mn-solutions.de (pD95FB62A.dip0.t-ipconnect.de [217.95.182.42])
	by mx51.mymxserver.com (Postfix) with ESMTP id BE08350006
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 10:35:07 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 889861E00D0
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 10:35:03 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] libertas: remove two libertas sparse warning
Date: Wed, 29 Oct 2008 10:35:02 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200810291035.02763.hs4233@mail.mn-solutions.de> (sfid-20081029_103520_268525_B4C6FECE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg detected this two sparse warnings:

drivers/net/wireless/libertas/cmd.c:609:16: warning: cast to restricted __le16
drivers/net/wireless/libertas/cmd.c:611:16: warning: cast to restricted __le16

... but cmd.minlevel is "s8", so we can access it directly and hope
for the sign-extension-code in the compiler to convert that to the
"s16" type.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>


---
Sent this to Linville, johill and Dan, but forgot the mailing list ;-/

Index: linux-wl/drivers/net/wireless/libertas/cmd.c
===================================================================
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c	2008-10-29 08:22:28.000000000 +0100
+++ linux-wl/drivers/net/wireless/libertas/cmd.c	2008-10-29 08:22:36.000000000 +0100
@@ -606,9 +606,9 @@ int lbs_get_tx_power(struct lbs_private 
 	if (ret == 0) {
 		*curlevel = le16_to_cpu(cmd.curlevel);
 		if (minlevel)
-			*minlevel = le16_to_cpu(cmd.minlevel);
+			*minlevel = cmd.minlevel;
 		if (maxlevel)
-			*maxlevel = le16_to_cpu(cmd.maxlevel);
+			*maxlevel = cmd.maxlevel;
 	}
 
 	lbs_deb_leave(LBS_DEB_CMD);
