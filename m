Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZFRWVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:21:40 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:21:43 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 01/23] cfg80211: add wrapper function to get wiphy from priv pointer
Date: Thu, 18 Jun 2009 23:21:13 +0100
Message-Id: <1245363695-8289-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 90f9bfa..dba7874 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1059,6 +1059,17 @@ static inline void *wiphy_priv(struct wiphy *wiphy)
 }
 
 /**
+ * priv_to_wiphy - return the wiphy containing the priv
+ *
+ * @priv: a pointer previously returned by wiphy_priv
+ */
+static inline struct wiphy *priv_to_wiphy(void *priv)
+{
+	BUG_ON(!priv);
+	return container_of(priv, struct wiphy, priv);
+}
+
+/**
  * set_wiphy_dev - set device pointer for wiphy
  *
  * @wiphy: The wiphy whose device to bind
-- 
1.6.0.6

