Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:51812 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752528AbZAHMpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 07:45:09 -0500
Date: Thu, 8 Jan 2009 14:44:58 +0200
From: Jouni Malinen <j@w1.fi>
To: Ahmad Ali Tabassam <ahmadthe8@yahoo.com>
Cc: johannes@sipsolutions.net, hostap@lists.shmoo.com,
	linux-wireless@vger.kernel.org
Subject: Re: [patch] vif_conf.patch failed to patch git wireless-testing
	(07-01-2009)
Message-ID: <20090108124458.GA21552@jm.kir.nu> (sfid-20090108_134515_859979_6FCF21DE)
References: <20090107112346.369581673@atheros.com> <20090107112707.370907962@atheros.com> <1231330118.3545.28.camel@johannes> <20090107122427.GA20019@jm.kir.nu> <1231332428.3545.33.camel@johannes> <20090107140956.GA22424@jm.kir.nu> <226823.3656.qm@web57008.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <226823.3656.qm@web57008.mail.re3.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2009 at 07:21:51AM -0800, Ahmad Ali Tabassam wrote:

> I want to enable userspace mlme for my client for wpa_supplicant 0.6.7 with client MLME. . But the http://w1.fi/wireless-testing/vif_conf.patch failed to be applied.  I have the latest wireless-testing git tree (07-01-09). The error is given below............any idea. does there any new pathch?

I updated the patches at http://w1.fi/wireless-testing/ now and the
version there seemed to work in my tests. However, you will now also
need to patch wpa_supplicant with the nl80211.h (see patch below) in
order to get the needed nl80211 command for enabling userspace MLME.


diff --git a/src/common/nl80211_copy.h b/src/common/nl80211_copy.h
index ee742bc..47f9531 100644
--- a/src/common/nl80211_copy.h
+++ b/src/common/nl80211_copy.h
@@ -133,6 +133,9 @@
  * @NL80211_CMD_SET_MESH_PARAMS: Set mesh networking properties for the
  *      interface identified by %NL80211_ATTR_IFINDEX
  *
+ * @NL80211_CMD_SET_VIF: Set virtual interface attributes for vif identified by
+ *	%NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -178,6 +181,8 @@ enum nl80211_commands {
 	NL80211_CMD_GET_MESH_PARAMS,
 	NL80211_CMD_SET_MESH_PARAMS,
 
+	NL80211_CMD_SET_VIF,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -190,6 +195,7 @@ enum nl80211_commands {
  * here
  */
 #define NL80211_CMD_SET_BSS NL80211_CMD_SET_BSS
+#define NL80211_CMD_SET_VIF NL80211_CMD_SET_VIF
 
 /**
  * enum nl80211_attrs - nl80211 netlink attributes
@@ -284,6 +290,11 @@ enum nl80211_commands {
  *	supported interface types, each a flag attribute with the number
  *	of the interface mode.
  *
+ * @NL80211_ATTR_VIF_DROP_UNENCRYPTED: whether unencrypted frames will be
+ *	dropped (u8, 0 or 1)
+ * @NL80211_ATTR_VIF_USERSPACE_MLME: whether userspace MLME is used
+ *	(u8, 0 or 1)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -348,6 +359,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_KEY_DEFAULT_MGMT,
 
+	NL80211_ATTR_VIF_DROP_UNENCRYPTED,
+	NL80211_ATTR_VIF_USERSPACE_MLME,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,

-- 
Jouni Malinen                                            PGP id EFC895FA
