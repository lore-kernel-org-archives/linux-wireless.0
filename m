Return-Path: <SRS0=Wd/x=2R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B298DC2D0DA
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Dec 2019 17:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8739B2176D
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Dec 2019 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577469104;
	bh=h5NfLAMahDeyBWLnNDHOkNGkRzHip58O6rBMQh4p7X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ryBHCczLi8ElbwGOdMnTutWEjH+QSXfD7jnDNq8E6DEx8J3kFuUIMqUdCWa1QeMD2
	 opPbA7WMH3lO8uLPU2QDTNWeaZBmdRVhkFUiiLzGyWaxZ7EXEogQQKaCEda07Hm9dH
	 4XUTdG3g/YSFy2xHLt3zDdpVRzI9yM6zj3P/pNfY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbfL0Rvk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Dec 2019 12:51:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:40822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbfL0RnW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:22 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA4121927;
        Fri, 27 Dec 2019 17:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468601;
        bh=h5NfLAMahDeyBWLnNDHOkNGkRzHip58O6rBMQh4p7X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZiBodEslWwXooQoAL+GORGsHxKD6a8vMljZJXWB8g/Tdc44xN55207ag91jj/vAz
         VYO1jyETIJpAd27F70kp9ew28HjzR6kBXtHxW/BHYDbe4UeXR4M4ZkG1xY0/PVbIJ0
         MRbGrYpXMNzpBS7A2APH3wob3/KGpiiWdRg86IvM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 122/187] rfkill: Fix incorrect check to avoid NULL pointer dereference
Date:   Fri, 27 Dec 2019 12:39:50 -0500
Message-Id: <20191227174055.4923-122-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 6fc232db9e8cd50b9b83534de9cd91ace711b2d7 ]

In rfkill_register, the struct rfkill pointer is first derefernced
and then checked for NULL. This patch removes the BUG_ON and returns
an error to the caller in case rfkill is NULL.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Link: https://lore.kernel.org/r/20191215153409.21696-1-pakki001@umn.edu
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 0bf9bf1ceb8f..6c089320ae4f 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1002,10 +1002,13 @@ static void rfkill_sync_work(struct work_struct *work)
 int __must_check rfkill_register(struct rfkill *rfkill)
 {
 	static unsigned long rfkill_no;
-	struct device *dev = &rfkill->dev;
+	struct device *dev;
 	int error;
 
-	BUG_ON(!rfkill);
+	if (!rfkill)
+		return -EINVAL;
+
+	dev = &rfkill->dev;
 
 	mutex_lock(&rfkill_global_mutex);
 
-- 
2.20.1

