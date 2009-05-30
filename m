Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:11165 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760595AbZE3RhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2009 13:37:07 -0400
Received: by ey-out-2122.google.com with SMTP id 22so243532eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2009 10:37:07 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC v2 01/23] cfg80211: add wrapper function to get wiphy from priv pointer
Date: Sat, 30 May 2009 18:36:35 +0100
Message-Id: <1243705017-8784-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
References: <1243705017-8784-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 include/net/cfg80211.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f20da7d..27c6ef6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1032,6 +1032,17 @@ static inline void *wiphy_priv(struct wiphy *wiphy)
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

