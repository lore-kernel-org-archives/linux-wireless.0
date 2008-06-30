Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:59026 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbYF3Io3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 04:44:29 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: mcgrof@gmail.com, compat-masters@lists.madwifi.org
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] compat-wireless: fix compilation of mac80211
Date: Mon, 30 Jun 2008 11:44:25 +0300
Message-Id: <1214815465-529-1-git-send-email-tomas.winkler@intel.com> (sfid-20080630_104435_921266_8FE7D6FF)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fix the compilation of mac80211 if it's not enabled
in the target kernel.
compat-wireless everything is compiled as module

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 config.mk |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.mk b/config.mk
index 15d2100..f7dc697 100644
--- a/config.mk
+++ b/config.mk
@@ -14,7 +14,7 @@ include $(KLIB_BUILD)/.config
 endif
 
 # Wireless subsystem stuff
-CONFIG_MAC80211=y
+CONFIG_MAC80211=m
 
 # Enable QOS for 2.6.22, we'll do some hacks here to enable it.
 # You will need this for HT support (802.11n) and WME (802.11e).
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

