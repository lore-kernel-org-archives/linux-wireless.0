Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758814AbYAUKjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 05:39:24 -0500
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 1/2] mac80211: fixing ieee80211_bar types
Date: Mon, 21 Jan 2008 12:39:11 +0200
Message-Id: <12009119602588-git-send-email-tomas.winkler@intel.com> (sfid-20080121_103928_528032_0C5ABF9C)
In-Reply-To: <12009119522429-git-send-email-tomas.winkler@intel.com>
References: <12009119522429-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch changes ieee80211_bar control and start_seq_num to
match the proper bitwise attribute expected from ieee 802.11 frame

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 include/linux/ieee80211.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4d5a4c9..5de6d91 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -237,8 +237,8 @@ struct ieee80211_bar {
 	__le16 duration;
 	__u8 ra[6];
 	__u8 ta[6];
-	__u16 control;
-	__u16 start_seq_num;
+	__le16 control;
+	__le16 start_seq_num;
 } __attribute__((packed));
 
 /**
-- 
1.5.2.2

