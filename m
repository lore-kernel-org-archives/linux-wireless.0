Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1LHJWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 04:22:08 -0500
Received: by bkbzv3 with SMTP id zv3so1360028bkb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 01:22:06 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH 1/2] ieee80211: Introduce ieee80211_has_frags
Date: Thu,  8 Dec 2011 10:21:53 +0100
Message-Id: <1323336114-31203-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111208_102213_524691_E6445E9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 include/linux/ieee80211.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 17f2a76..18326eb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -544,6 +544,15 @@ static inline int ieee80211_is_qos_nullfunc(__le16 fc)
 	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
 }
 
+/**
+ * ieee80211_has_frag - check if IEEE80211_SCTL_FRAG is set
+ * @seq_ctrl: frame sequence control bytes in little-endian byteorder
+ */
+static inline int ieee80211_has_frag(__le16 seq_ctrl)
+{
+	return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) != 0;
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
-- 
1.7.7

