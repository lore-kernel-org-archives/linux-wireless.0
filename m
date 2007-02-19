Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:48358 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbXBSBoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Feb 2007 20:44:15 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HIxYH-0006C6-S4
	for linux-wireless@vger.kernel.org; Sun, 18 Feb 2007 20:42:49 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Use offsetof() instead of own equivalent
To: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Date: Sun, 18 Feb 2007 20:44:06 -0500
Message-ID: <20070219014406.8677.62357.stgit@dl.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The original macros result in gcc 4.2 warning about "cast from pointer
to integer of different size" on 64-bit systems.

Use of offsetof() on fields in substructures is widespread throughout
the kernel code and should work whether offsetof() is defined using
__compiler_offsetof() or a cast.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/hostap/hostap_common.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_common.h b/drivers/net/wireless/hostap/hostap_common.h
index 0162400..b31e6a0 100644
--- a/drivers/net/wireless/hostap/hostap_common.h
+++ b/drivers/net/wireless/hostap/hostap_common.h
@@ -368,9 +368,9 @@ enum {
 
 #define PRISM2_HOSTAPD_MAX_BUF_SIZE 1024
 #define PRISM2_HOSTAPD_RID_HDR_LEN \
-((int) (&((struct prism2_hostapd_param *) 0)->u.rid.data))
+offsetof(struct prism2_hostapd_param, u.rid.data)
 #define PRISM2_HOSTAPD_GENERIC_ELEMENT_HDR_LEN \
-((int) (&((struct prism2_hostapd_param *) 0)->u.generic_elem.data))
+offsetof(struct prism2_hostapd_param, u.generic_elem.data)
 
 /* Maximum length for algorithm names (-1 for nul termination) used in ioctl()
  */

