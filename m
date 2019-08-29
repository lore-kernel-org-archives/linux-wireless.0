Return-Path: <SRS0=l8aR=WZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0364CC3A59F
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 21:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD2D4208C2
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Aug 2019 21:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbfH2Vzs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Aug 2019 17:55:48 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:3609 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbfH2Vzs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Aug 2019 17:55:48 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2019 17:55:47 EDT
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 29 Aug 2019 14:49:46 -0700
Received: from asinghal-linux.qualcomm.com ([10.234.220.60])
  by ironmsg03-sd.qualcomm.com with ESMTP; 29 Aug 2019 14:49:46 -0700
Received: by asinghal-linux.qualcomm.com (Postfix, from userid 73644)
        id 3DC8A36AC; Thu, 29 Aug 2019 14:49:46 -0700 (PDT)
From:   Amar Singhal <asinghal@codeaurora.org>
To:     jouni@codeaurora.org
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        jjohnson@codeaurora.org, rmanohar@codeaurora.org,
        Amar Singhal <asinghal@codeaurora.org>
Subject: [PATCH] cfg80211: Add new helper function for channels
Date:   Thu, 29 Aug 2019 14:49:41 -0700
Message-Id: <1567115381-7831-1-git-send-email-asinghal@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add new helper function to convert (chan_number, oper_class) pair to
frequency. Call this function ieee80211_channel_op_class_to_frequency.
This function would be very useful in the context of 6 GHz channels,
where channel number is not unique.

Signed-off-by: Amar Singhal <asinghal@codeaurora.org>
---
 include/net/cfg80211.h | 10 ++++++++++
 net/wireless/util.c    | 23 +++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6467b60..decafba 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4914,1 +4914,1 @@ static inline void *wdev_priv(struct wireless_dev *wdev)
 int ieee80211_channel_to_frequency(int chan, enum nl80211_band band);

 /**
+ * ieee80211_channel_op_class_to_frequency - convert
+ * (channel, operating class) to frequency
+ * @chan_num: channel number
+ * @global_op_class: global operating class
+ *
+ * Return: The corresponding frequency, or 0 if the conversion failed.
+ */
+int ieee80211_channel_op_class_to_frequency(u8 chan_num, u8 global_op_class);
+
+/**
  * ieee80211_frequency_to_channel - convert frequency to channel number
  * @freq: center frequency
  * Return: The corresponding channel, or 0 if the conversion failed.
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 9aba8d54..7f64b4a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -144,6 +144,29 @@ struct ieee80211_channel *ieee80211_get_channel(struct wiphy *wiphy, int freq)
 }
 EXPORT_SYMBOL(ieee80211_get_channel);

+int ieee80211_channel_op_class_to_frequency(u8 chan_num, u8 global_op_class)
+{
+	if (global_op_class >= 131 && global_op_class <= 135)
+		return (5940 + 5 * chan_num);
+	else if (global_op_class >= 115 && global_op_class <= 130)
+		return (5000 + 5 * chan_num);
+	else if (global_op_class >= 112 && global_op_class <= 113)
+		return (5000 + 5 * chan_num);
+	else if (global_op_class >= 109 && global_op_class <= 110)
+		return (4000 + 5 * chan_num);
+	else if (global_op_class >= 83 && global_op_class <= 84)
+		return (2407 + 5 * chan_num);
+	else if (global_op_class == 81)
+		return (2407 + 5 * chan_num);
+	else if (global_op_class == 82)
+		return (2414 + 5 * chan_num);
+	else if (global_op_class == 180)
+		return (56160 + 5 * chan_num);
+	else
+		return 0;
+}
+EXPORT_SYMBOL(ieee80211_channel_op_class_to_frequency);
+
 static void set_mandatory_flags_band(struct ieee80211_supported_band *sband)
 {
 	int i, want;
--
1.9.1
