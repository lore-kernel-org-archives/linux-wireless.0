Return-Path: <SRS0=oU4Q=ZI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457AEC432C3
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 18:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B08C2068E
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Nov 2019 18:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727674AbfKPSVn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:21:43 -0500
Received: from mail.adapt-ip.com ([173.164.178.19]:33178 "EHLO
        mail.adapt-ip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbfKPSVn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 13:21:43 -0500
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Nov 2019 13:21:42 EST
Received: from localhost (unknown [127.0.0.1])
        by mail.adapt-ip.com (Postfix) with ESMTP id 2157F2F0325;
        Sat, 16 Nov 2019 18:12:39 +0000 (UTC)
X-Virus-Scanned: amavisd-new at web.adapt-ip.com
Received: from mail.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OW_B6ukgdlOg; Sat, 16 Nov 2019 10:12:36 -0800 (PST)
Received: from tractor.ibsgaard.io (c-73-202-5-52.hsd1.ca.comcast.net [73.202.5.52])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: thomas@adapt-ip.com)
        by mail.adapt-ip.com (Postfix) with ESMTPSA id 0C4D42F031F;
        Sat, 16 Nov 2019 10:12:35 -0800 (PST)
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>
Subject: [PATCH 2/3] mac80211: expose HW conf flags through debugfs
Date:   Sat, 16 Nov 2019 10:12:32 -0800
Message-Id: <20191116181233.1037-4-thomas@adapt-ip.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116181233.1037-1-thomas@adapt-ip.com>
References: <20191116181233.1037-1-thomas@adapt-ip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is useful during testing to eg. check the currently
configured HW power save state.

Signed-off-by: Thomas Pedersen <thomas@adapt-ip.com>
---
 net/mac80211/debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 2e7f75938c51..7c530dd837e3 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -59,6 +59,8 @@ static const struct file_operations name## _ops = {			\
 	debugfs_create_file(#name, mode, phyd, local, &name## _ops);
 
 
+DEBUGFS_READONLY_FILE(hw_conf, "%x",
+		      local->hw.conf.flags);
 DEBUGFS_READONLY_FILE(user_power, "%d",
 		      local->user_power_level);
 DEBUGFS_READONLY_FILE(power, "%d",
@@ -434,6 +436,7 @@ void debugfs_hw_add(struct ieee80211_local *local)
 	DEBUGFS_ADD(hwflags);
 	DEBUGFS_ADD(user_power);
 	DEBUGFS_ADD(power);
+	DEBUGFS_ADD(hw_conf);
 	DEBUGFS_ADD_MODE(force_tx_status, 0600);
 
 	if (local->ops->wake_tx_queue)
-- 
2.20.1

