Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:38702 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbbLPVno (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 16:43:44 -0500
Received: by mail-wm0-f53.google.com with SMTP id l126so57584366wml.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 13:43:43 -0800 (PST)
From: Ola Olsson <ola1olsson@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ola Olsson <ola1olsson@gmail.com>,
	Ola Olsson <ola.olsson@sonymobile.com>
Subject: [PATCH] Print warnings for missing cfg80211_ops implementations
Date: Wed, 16 Dec 2015 22:43:35 +0100
Message-Id: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com> (sfid-20151216_224347_439904_45A880BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print a warning whenever an expected callback function
lacks implementation.

Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
---
 net/wireless/core.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index b091551..3a9c41b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -352,6 +352,16 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	WARN_ON(ops->add_station && !ops->del_station);
 	WARN_ON(ops->add_mpath && !ops->del_mpath);
 	WARN_ON(ops->join_mesh && !ops->leave_mesh);
+	WARN_ON(ops->start_p2p_device && !ops->stop_p2p_device);
+	WARN_ON(ops->start_ap && !ops->stop_ap);
+	WARN_ON(ops->join_ocb && !ops->leave_ocb);
+	WARN_ON(ops->suspend && !ops->resume);
+	WARN_ON(ops->sched_scan_start && !ops->sched_scan_stop);
+	WARN_ON(ops->remain_on_channel && !ops->cancel_remain_on_channel);
+	WARN_ON(ops->tdls_channel_switch && !ops->tdls_cancel_channel_switch);
+	WARN_ON(ops->add_tx_ts && !ops->del_tx_ts);
+	WARN_ON(ops->set_tx_power && !ops->get_tx_power);
+	WARN_ON(ops->set_antenna && !ops->get_antenna);
 
 	alloc_size = sizeof(*rdev) + sizeof_priv;
 
-- 
1.7.9.5

