Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro-out-1112.google.com ([72.14.202.178]:44004 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752236AbXJaBoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 21:44:20 -0400
Received: by ro-out-1112.google.com with SMTP id p4so1679465roc
        for <linux-wireless@vger.kernel.org>; Tue, 30 Oct 2007 18:44:19 -0700 (PDT)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 29 Oct 2007 14:46:17 -0700
Subject: [PATCH 2/7] o80211s: (rtnetlinkr) add new message types for mesh path table
Message-ID: <4727ddf1.0e578c0a.2568.ffffb05a@mx.google.com> (sfid-20071031_014423_192164_7A4BBF63)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/rtnetlink.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 5bf6182..f7ae721 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -100,6 +100,13 @@ enum {
 	RTM_NEWNDUSEROPT = 68,
 #define RTM_NEWNDUSEROPT RTM_NEWNDUSEROPT
 
+	RTM_NEWMESHPATH = 72,
+#define RTM_NEWMESHPATH RTM_NEWMESHPATH
+	RTM_DELMESHPATH,
+#define RTM_DELMESHPATH RTM_DELMESHPATH
+	RTM_GETMESHPATH,
+#define RTM_GETMESHPATH RTM_GETMESHPATH
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
@@ -135,7 +142,24 @@ struct rtattr
 #define RTA_PAYLOAD(rta) ((int)((rta)->rta_len) - RTA_LENGTH(0))
 
 
+/******************************************************************************
+ * 		Definitions used for mesh path table administration.
+ ****/
+
+struct mpmsg{
+	unsigned int mpm_flags;
+	int ifa_index;
+};
+
+enum mpattr_type_t
+{
+	MPA_UNSPEC,
+	MPA_DST,
+	MPA_NEXT_HOP,
+	__MPA_MAX,
+};
 
+#define MPA_MAX (__MPA_MAX - 1)
 
 /******************************************************************************
  *		Definitions used in routing table administration.
-- 
1.5.2.5



