Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:45962 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbXKJC0C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 21:26:02 -0500
Received: by wa-out-1112.google.com with SMTP id v27so794827wah
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2007 18:26:01 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 9 Nov 2007 14:57:14 -0800
Subject: [PATCH 1/4] o80211s: (rtnetlinkr) add new message types for mesh path table
Message-ID: <473516b8.20f8720a.68ab.ffffe079@mx.google.com> (sfid-20071110_022610_115509_8BA75EB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the first patch of a series starting mesh wireless support (802.11s) for
wireless network cards with drivers using the mac80211 stack.

It is still in an early stage of development but some functionality (static
forwarding) is quite solid and we would like the code to be integrated in the
kernel the sooner the better. Please point out any section of the code that
could pose a problem towards integration. The patches apply against current
wireless-2.6/everything (439a85fe).

I'm resending this patches after including the suggestions from the first
attempt (thanks to Johannes Berg and Dan Williams for the comments).

For more information, please visit: http://o11s.org/devel

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 include/linux/rtnetlink.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 5bf6182..bb39524 100644
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



