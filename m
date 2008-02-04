Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:44294 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbYBDVXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:23:40 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1548589rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:23:39 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 10:48:57 -0800
Subject: [PATCH 01/13] o11s: (rtnetlink) add commands for mesh tables manipulation
Message-ID: <47a7825b.06538c0a.3bce.5ec1@mx.google.com> (sfid-20080204_212408_298998_A7C8CED4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the necessary commands for mesh peer link table and mesh path
table manipulation.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/rtnetlink.h |   66 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 4e81836..345a27b 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -100,6 +100,20 @@ enum {
 	RTM_NEWNDUSEROPT = 68,
 #define RTM_NEWNDUSEROPT RTM_NEWNDUSEROPT
 
+	RTM_NEWMESHPATH = 76,
+#define RTM_NEWMESHPATH RTM_NEWMESHPATH
+	RTM_DELMESHPATH,
+#define RTM_DELMESHPATH RTM_DELMESHPATH
+	RTM_GETMESHPATH,
+#define RTM_GETMESHPATH RTM_GETMESHPATH
+
+	RTM_NEWMESHPEERLINK = 80,
+#define RTM_NEWMESHPEERLINK RTM_NEWMESHPEERLINK
+	RTM_DELMESHPEERLINK,
+#define RTM_DELMESHPEERLINK RTM_DELMESHPEERLINK
+	RTM_GETMESHPEERLINK,
+#define RTM_GETMESHPEERLINK RTM_GETMESHPEERLINK
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
@@ -135,7 +149,59 @@ struct rtattr
 #define RTA_PAYLOAD(rta) ((int)((rta)->rta_len) - RTA_LENGTH(0))
 
 
+/******************************************************************************
+ * 		Definitions used for mesh path table administration.
+ ****/
+
+struct mpmsg
+{
+	unsigned int mpm_flags;
+	int ifa_index;
+};
+
+enum mpattr_type_t
+{
+	MPA_UNSPEC,
+	MPA_DST,
+	MPA_NEXT_HOP,
+	MPA_FRAME_QLEN,
+	MPA_DSN,
+	MPA_METRIC,
+	MPA_LIFETIME,
+	MPA_FLAGS,
+	MPA_DISCOVERY_TIMEOUT,
+	MPA_DISCOVERY_RETRIES,
+	__MPA_MAX,
+};
+
+#define MPA_MAX (__MPA_MAX - 1)
+
+/******************************************************************************
+ * 		Definitions used for mesh peer link table administration.
+ ****/
+
+/* mpl_flags */
+#define MPL_F_CREATE	0x100
+#define MPL_F_OPEN	0x200	/* Start the mesh peer link establishment */
+#define MPL_F_BLOCK	0x400 	/* Block all traffic from this peer */
+
+struct mplmsg
+{
+	unsigned int mplm_flags;
+	int ifa_index;
+};
+
+enum mplattr_type_t
+{
+	MPLA_UNSPEC,
+	MPLA_PEER_ADDR,
+	MPLA_STATE,
+	MPLA_LLID,
+	MPLA_PLID,
+	__MPLA_MAX,
+};
 
+#define MPLA_MAX (__MPLA_MAX - 1)
 
 /******************************************************************************
  *		Definitions used in routing table administration.
-- 
1.5.2.5



