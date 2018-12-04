Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4F3C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 12:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E46520851
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 12:17:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F3QIlJb1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F3QIlJb1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E46520851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbeLDMRn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:17:43 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbeLDMRn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 07:17:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C9B7D60913; Tue,  4 Dec 2018 12:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543925861;
        bh=yAMHAzpC7VV35jfovuNSMbjh6y1OlkhBSzeHjU4w0og=;
        h=From:To:Cc:Subject:Date:From;
        b=F3QIlJb1LoipVqOXajZE/wzJxYB6370Pn5WRh9B6p78PDiYvsKKcDXNRSxtLWee6w
         Oxka+CYlT8208hlfdIovX0X4cd7rpvTe+/9isYRf46TPbEhoOvMZTjk0eNieruTalB
         lEumzG2vi1L15263brrB9cGpv5C3KEDJwnHaqKP0=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CB46060312;
        Tue,  4 Dec 2018 12:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543925861;
        bh=yAMHAzpC7VV35jfovuNSMbjh6y1OlkhBSzeHjU4w0og=;
        h=From:To:Cc:Subject:Date:From;
        b=F3QIlJb1LoipVqOXajZE/wzJxYB6370Pn5WRh9B6p78PDiYvsKKcDXNRSxtLWee6w
         Oxka+CYlT8208hlfdIovX0X4cd7rpvTe+/9isYRf46TPbEhoOvMZTjk0eNieruTalB
         lEumzG2vi1L15263brrB9cGpv5C3KEDJwnHaqKP0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CB46060312
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH v2] nl80211: Add support to notify radar event info received from STA
Date:   Tue,  4 Dec 2018 17:46:52 +0530
Message-Id: <1543925812-19416-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently radar detection and corresponding channel switch is handled
at the AP device. STA ignores these detected radar events since the
radar signal can be seen mostly by the AP as well. But in scenarios where
a radar signal is seen only at STA, notifying this event to the AP which
can trigger a channel switch can be useful.
Stations can report such radar events autonomously through Spectrum
management (Measurement Report) action frame to its AP. The userspace on
processing the report can notify the kernel with the use of the added
NL80211_CMD_NOTIFY_RADAR to indicate the detected event and inturn adding
the reported channel to NOL.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---

v2:
 - Added netlink error info
 - Return success if the radar event was already processed

 include/uapi/linux/nl80211.h |  7 +++++
 net/wireless/nl80211.c       | 62 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 51bd85b..8ff5d2a 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1060,6 +1060,11 @@
  *	the measurement completed, using the measurement cookie
  *	(%NL80211_ATTR_COOKIE).
  *
+ * @NL80211_CMD_NOTIFY_RADAR: Notify the kernel that a radar signal was
+ *	detected and reported by a neighboring device on the channel
+ *	indicated by %NL80211_ATTR_WIPHY_FREQ and other attributes
+ *	determining the width and type.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1278,6 +1283,8 @@ enum nl80211_commands {
 	NL80211_CMD_PEER_MEASUREMENT_RESULT,
 	NL80211_CMD_PEER_MEASUREMENT_COMPLETE,
 
+	NL80211_CMD_NOTIFY_RADAR,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5ec200e..f593498 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7981,6 +7981,60 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	return err;
 }
 
+static int nl80211_notify_radar_detection(struct sk_buff *skb,
+					  struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_chan_def chandef;
+	enum nl80211_dfs_regions dfs_region;
+	int err;
+
+	dfs_region = reg_get_dfs_region(wiphy);
+	if (dfs_region == NL80211_DFS_UNSET) {
+		GENL_SET_ERR_MSG(info,
+				 "DFS Region is not set. Unexpected Radar indication");
+		return -EINVAL;
+	}
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err) {
+		GENL_SET_ERR_MSG(info, "Unable to extract chandef info");
+		return err;
+	}
+
+	err = cfg80211_chandef_dfs_required(wiphy, &chandef, wdev->iftype);
+	if (err < 0) {
+		GENL_SET_ERR_MSG(info, "chandef is invalid");
+		return err;
+	}
+
+	if (err == 0) {
+		GENL_SET_ERR_MSG(info,
+				 "Unexpected Radar indication for chandef/iftype");
+		return -EINVAL;
+	}
+
+	/* Do not process this notification if radar is already detected
+	 * by kernel on this channel, and return success.
+	 */
+	if (chandef.chan->dfs_state == NL80211_DFS_UNAVAILABLE)
+		return 0;
+
+	cfg80211_set_dfs_state(wiphy, &chandef, NL80211_DFS_UNAVAILABLE);
+
+	cfg80211_sched_dfs_chan_update(rdev);
+
+	memcpy(&rdev->radar_chandef, &chandef, sizeof(chandef));
+
+	/* Propagate this notification to other radios as well */
+	queue_work(cfg80211_wq, &rdev->propagate_radar_detect_wk);
+
+	return 0;
+}
+
 static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -14066,6 +14120,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_NOTIFY_RADAR,
+		.doit = nl80211_notify_radar_detection,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
-- 
2.7.4

