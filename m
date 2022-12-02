Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FFBBC4332F
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Dec 2022 10:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbiLBKae (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiLBKad (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Dec 2022 05:30:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2411EEE8
        for <linux-wireless@vger.kernel.org>; Fri,  2 Dec 2022 02:30:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 351D762245
        for <linux-wireless@vger.kernel.org>; Fri,  2 Dec 2022 10:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090CDC433C1;
        Fri,  2 Dec 2022 10:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669977031;
        bh=CfgyzpxmSmzWgIJtr6+lsNS9AutZwLfpv3tLyzOCSis=;
        h=From:To:Cc:Subject:Date:From;
        b=Q1EWW03Alvg9kwkss5etZrV15t6vHoC5FTGJwnmA4/jo0AsGEj8zHEGpDeBzTssY4
         XOogjolP6t9IKglOEDyyAHVBQVdbnKzavtK0FCcW4NWgqpZT1pA6Sqkb3jcD8rU98x
         l7mqiTKGo1AVY2pOm/PH0e3ri0BcQlRP/ZQOIttXqCrDD5D7NnGic1MJRMh8BfG08j
         BJmxtPKstwTFCaUhhTLDHQAJaMG7yZTA4iqZyzcqHa6j1bGE6Sfue7MKYH6if9IqL3
         6IhYYhMjmV8Xl3OcN45VriZnq0csHJmqDqIqlLOYBLMUc+Z85AcFOlHxVTg2SP33ui
         IT42alFOLQy7g==
From:   Kalle Valo <kvalo@kernel.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: ath10k: fix QCOM_SMEM dependency
Date:   Fri,  2 Dec 2022 12:30:27 +0200
Message-Id: <20221202103027.25974-1-kvalo@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

Nathan noticed that when HWSPINLOCK is disabled there's a Kconfig warning:

  WARNING: unmet direct dependencies detected for QCOM_SMEM
    Depends on [n]: (ARCH_QCOM [=y] || COMPILE_TEST [=n]) && HWSPINLOCK [=n]
    Selected by [m]:
    - ATH10K_SNOC [=m] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_ATH [=y] && ATH10K [=m] && (ARCH_QCOM [=y] || COMPILE_TEST [=n])

The problem here is that QCOM_SMEM depends on HWSPINLOCK so we cannot select
QCOM_SMEM and instead we neeed to use 'depends on'.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/all/Y4YsyaIW+CPdHWv3@dev-arch.thelio-3990X/
Fixes: 4d79f6f34bbb ("wifi: ath10k: Store WLAN firmware version in SMEM image table")
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
---
 drivers/net/wireless/ath/ath10k/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/Kconfig b/drivers/net/wireless/ath/ath10k/Kconfig
index e0a51dad8e42..e6ea884cafc1 100644
--- a/drivers/net/wireless/ath/ath10k/Kconfig
+++ b/drivers/net/wireless/ath/ath10k/Kconfig
@@ -44,7 +44,7 @@ config ATH10K_SNOC
 	tristate "Qualcomm ath10k SNOC support"
 	depends on ATH10K
 	depends on ARCH_QCOM || COMPILE_TEST
-	select QCOM_SMEM
+	depends on QCOM_SMEM
 	select QCOM_SCM
 	select QCOM_QMI_HELPERS
 	help

base-commit: e9ab0b2e680b069437f54bf4076310f636af05e6
-- 
2.30.2

