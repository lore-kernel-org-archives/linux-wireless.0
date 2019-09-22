Return-Path: <SRS0=EnK0=XR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55DFC49ED7
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Sep 2019 19:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A695F208C2
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Sep 2019 19:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569178853;
	bh=ZIaieDLicGUG3TmJV9/uGk86iXiemrKdvkHze4wayDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=V2y5kd5Zun7pw6Toc57jafaOOFriaunMYHc+44eALmgKXvnHJmlBA/yOIMrW5VkN1
	 kdtyQIYS5mjG7GNPnH0g5kUd+deuVmFFUKgfqktEWlIriMeRy96S/ylKE/uCt6f79M
	 i2Zer286khPIkIuw2oa71BSCUSevPoikYpfZswSQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439004AbfIVTAw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 22 Sep 2019 15:00:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395241AbfIVTAw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Sep 2019 15:00:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A27E1214D9;
        Sun, 22 Sep 2019 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178851;
        bh=ZIaieDLicGUG3TmJV9/uGk86iXiemrKdvkHze4wayDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVoOlOm6rIOZM6Vzz5VJ4hh93LUO4HMLQNqwSpP7SzsSPa1gCj3Oa1twbj2nk4c/C
         x6gf6lKZ6VOxRfgNg0Zuxsto2XEdNaqPEfHu1NlXcXku2u1nrC05n23apyfAjElueu
         R0O+y/k+OHalEU4K70M8gnWhCU0yvZlohX/UmFdo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Easton <kevin@guarana.org>,
        syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 55/60] libertas: Add missing sentinel at end of if_usb.c fw_table
Date:   Sun, 22 Sep 2019 14:59:28 -0400
Message-Id: <20190922185934.4305-55-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185934.4305-1-sashal@kernel.org>
References: <20190922185934.4305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kevin Easton <kevin@guarana.org>

[ Upstream commit 764f3f1ecffc434096e0a2b02f1a6cc964a89df6 ]

This sentinel tells the firmware loading process when to stop.

Reported-and-tested-by: syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Signed-off-by: Kevin Easton <kevin@guarana.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index a605d569f663a..9d147b11ee516 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -49,7 +49,8 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+	{ 0, NULL, NULL }
 };
 
 static struct usb_device_id if_usb_table[] = {
-- 
2.20.1

