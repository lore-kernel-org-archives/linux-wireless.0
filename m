Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59150 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1LHMME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 07:12:04 -0500
Received: by bkbzv3 with SMTP id zv3so1544409bkb.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Dec 2011 04:12:02 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCHv2 1/2] ieee80211: Introduce ieee80211_is_first_frag
Date: Thu,  8 Dec 2011 13:11:54 +0100
Message-Id: <1323346315-31917-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111208_131208_575478_1A8555F0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---

 include/linux/ieee80211.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 17f2a76..210e2c3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -544,6 +544,15 @@ static inline int ieee80211_is_qos_nullfunc(__le16 fc)
 	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
 }
 
+/**
+ * ieee80211_is_first_frag - check if IEEE80211_SCTL_FRAG is not set
+ * @seq_ctrl: frame sequence control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_first_frag(__le16 seq_ctrl)
+{
+	return (seq_ctrl & cpu_to_le16(IEEE80211_SCTL_FRAG)) == 0;
+}
+
 struct ieee80211s_hdr {
 	u8 flags;
 	u8 ttl;
-- 
1.7.7

