Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9ACC65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 04:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44C2B20849
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 04:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1544675895;
	bh=ic+QJbmaIqyAFdfYuJINzyeHf5N+45gyInksvKsQMc0=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=VUYRVHEhm2wUTkDfIO0XFTZV6eg6k2vJagCNtkvistbkoLEhR3wYPMJgSUlaIGvZT
	 n3w4GvjYrQL7mDqOL6axzDZBV8Ytoimmx4nihk9ZpIJ3QyH01ELRA11oSUwhWmFpM8
	 MZlPx8DWyAdB6XnQVIK2cb2HEdtxqw2/BESkkmMo=
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44C2B20849
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbeLMEiH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Dec 2018 23:38:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729229AbeLMEdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Dec 2018 23:33:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B19720672;
        Thu, 13 Dec 2018 04:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1544675581;
        bh=ic+QJbmaIqyAFdfYuJINzyeHf5N+45gyInksvKsQMc0=;
        h=From:To:Cc:Subject:Date:From;
        b=RcCHRBLRY0vsk1SaxZuJMmi7FRYK+lPJELvxGitsL+yT3QFK3pBzfhnt21X+l95+l
         4NSEuUANIDAg24FSUjpb5n9hraFZ347Q9ltJ4IScW3KeadejEMCc1/6sOD19giK+eL
         bQDms3KsKY90hRhBCHKpR+UL4sXjh2AEa6Oz3818=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/23] mac80211_hwsim: fix module init error paths for netlink
Date:   Wed, 12 Dec 2018 23:32:37 -0500
Message-Id: <20181213043259.76643-1-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit 05cc09de4c017663a217630682041066f2f9a5cd ]

There is no unregister netlink notifier and family on error paths
in init_mac80211_hwsim(). Also there is an error path where
hwsim_class is not destroyed.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 62759361eb49 ("mac80211-hwsim: Provide multicast event for HWSIM_CMD_NEW_RADIO")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mac80211_hwsim.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 05413176a5d6..aad5228e3ade 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3195,16 +3195,16 @@ static int __init init_mac80211_hwsim(void)
 	if (err)
 		return err;
 
+	err = hwsim_init_netlink();
+	if (err)
+		goto out_unregister_driver;
+
 	hwsim_class = class_create(THIS_MODULE, "mac80211_hwsim");
 	if (IS_ERR(hwsim_class)) {
 		err = PTR_ERR(hwsim_class);
-		goto out_unregister_driver;
+		goto out_exit_netlink;
 	}
 
-	err = hwsim_init_netlink();
-	if (err < 0)
-		goto out_unregister_driver;
-
 	for (i = 0; i < radios; i++) {
 		struct hwsim_new_radio_params param = { 0 };
 
@@ -3310,6 +3310,8 @@ static int __init init_mac80211_hwsim(void)
 	free_netdev(hwsim_mon);
 out_free_radios:
 	mac80211_hwsim_free();
+out_exit_netlink:
+	hwsim_exit_netlink();
 out_unregister_driver:
 	platform_driver_unregister(&mac80211_hwsim_driver);
 	return err;
-- 
2.19.1

