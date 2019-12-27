Return-Path: <SRS0=Wd/x=2R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0F9EC2D0C6
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Dec 2019 18:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A58DF20722
	for <linux-wireless@archiver.kernel.org>; Fri, 27 Dec 2019 18:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577470705;
	bh=m3YkXNtADal+FxT5+G8XsLoAk5H/L8pRwhFC/xDTCPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Z/M7wwxW1Lxy1Ipo6RzNp+qII9cDBxKpdV1zKBsDdmxHGEX3h1l8QDtM5a5Rtosgt
	 EQC2nhlCacpgtu7sS7TWnA/gpk1AP5xnMrO0SxWO8wosQUgITfeMNIFMUIoy8hiJPu
	 YCjNEDWyqALKF+gwUtyMYTCBaFnZvq4AVvYirNhk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728141AbfL0SSV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:39778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfL0SPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Dec 2019 13:15:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E5921744;
        Fri, 27 Dec 2019 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470507;
        bh=m3YkXNtADal+FxT5+G8XsLoAk5H/L8pRwhFC/xDTCPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eptMlGIXlkMQNFcOqnF64tjPAydLwSCrPIFyxKpesLjvP8Ar9IaL6y2EGKcWPQiCo
         go3AG2ycXLf3LvMQZ4uHq6vywkT2jpaMwcV6bknxirSszDrTL/beh3eHfc5vzVX32J
         O6uVHf1rfem80LEZeB/7TASRhHs8iXaJhB8PXYWc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 25/38] rfkill: Fix incorrect check to avoid NULL pointer dereference
Date:   Fri, 27 Dec 2019 13:14:22 -0500
Message-Id: <20191227181435.7644-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181435.7644-1-sashal@kernel.org>
References: <20191227181435.7644-1-sashal@kernel.org>
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
index 884027f62783..87c35844d7d9 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -940,10 +940,13 @@ static void rfkill_sync_work(struct work_struct *work)
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

