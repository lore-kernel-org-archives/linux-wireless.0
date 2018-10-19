Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10876ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C978920869
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:12:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AZlw566p";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VitM611l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C978920869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727197AbeJSRSF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:18:05 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55488 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbeJSRSF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:18:05 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 45F7D60A98; Fri, 19 Oct 2018 09:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539940372;
        bh=F78IDh8iEuhP6pNF1JfH11jEDeW/PE52KeqD4fGK724=;
        h=From:To:Cc:Subject:Date:From;
        b=AZlw566pLQe2eSOIYDAUxgeMfeKM/WxGsgAdtjcg639HK123jkfXlIbcuW6W743aI
         MnhHs8b9Tv3hVT3dGLd52mmy8BnKpTtrGCy9pDUtaJXQdya5sCg059XHQVOKEmTE7M
         CyK9zsdGBU4F8Q9Sxu2mhByAua8UnZ9bzwWYxBcg=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 541CF602D7;
        Fri, 19 Oct 2018 09:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539940371;
        bh=F78IDh8iEuhP6pNF1JfH11jEDeW/PE52KeqD4fGK724=;
        h=From:To:Cc:Subject:Date:From;
        b=VitM611l7xhV0WvZXNk3rcopa9NT5MXzWc0ST1EnNhx1XFlazcS9NmLgiyYlXn1Mp
         pdbV3rmsv6JvutXWE5vVbXwGpbF9p7YbWjVgnAP87BTeKxpch8Eibyxz+V3IJS/se3
         pw6HcxR7Vbg10/bQoLUyB1rfFtpqoWKEcUmV0HBQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 541CF602D7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] nl80211: Add support to notify radar event info received from STA
Date:   Fri, 19 Oct 2018 14:42:36 +0530
Message-Id: <1539940356-1335-1-git-send-email-srirrama@codeaurora.org>
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
 include/uapi/linux/nl80211.h |  7 ++++++
 net/wireless/nl80211.c       | 52 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index dc6d5a1..192b358 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1036,6 +1036,11 @@
  * @NL80211_CMD_GET_FTM_RESPONDER_STATS: Retrieve FTM responder statistics, in
  *	the %NL80211_ATTR_FTM_RESPONDER_STATS attribute.
  *
+ * @NL80211_CMD_NOTIFY_RADAR: Notify the kernel that a radar signal was
+ *	detected and reported by a neighboring device on the channel
+ *	indicated by %NL80211_ATTR_WIPHY_FREQ and other attributes
+ *	determining the width and type.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1250,6 +1255,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_GET_FTM_RESPONDER_STATS,
 
+	NL80211_CMD_NOTIFY_RADAR,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9a20c66a..cb462a9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7920,6 +7920,50 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
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
+	if (dfs_region == NL80211_DFS_UNSET)
+		return -EINVAL;
+
+	err = nl80211_parse_chandef(rdev, info, &chandef);
+	if (err)
+		return err;
+
+	err = cfg80211_chandef_dfs_required(wiphy, &chandef, wdev->iftype);
+	if (err < 0)
+		return err;
+
+	if (err == 0)
+		return -EINVAL;
+
+	/* Do not process this notification if radar is already detected
+	 * by kernel on this channel
+	 */
+	if (chandef.chan->dfs_state == NL80211_DFS_UNAVAILABLE)
+		return -EINVAL;
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
@@ -14035,6 +14079,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
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

