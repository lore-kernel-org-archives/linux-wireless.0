Return-Path: <SRS0=bi0l=ZN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8BCC432C0
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 07:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0E7120872
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Nov 2019 07:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="oI43YhKq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUHz1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Nov 2019 02:55:27 -0500
Received: from [115.28.160.31] ([115.28.160.31]:50928 "EHLO
        mailbox.box.xen0n.name" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfKUHz0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Nov 2019 02:55:26 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2019 02:55:25 EST
Received: from localhost.localdomain (unknown [116.236.177.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 79071600D1;
        Thu, 21 Nov 2019 15:49:17 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=xen0n.name; s=mail;
        t=1574322557; bh=61PK4cNd4IzYo9MeLRd43DZ4yc5CWH8kI8rWD35qdpo=;
        h=From:To:Cc:Subject:Date:From;
        b=oI43YhKqrAiFX7IUn1ccCXwvViQZS+DPsgy6cCp0yytHc8u9ttAoOwq15rI9Y59aF
         Ec18y5IRjP7kgOgByOlhNfxGOcprWoyzFEB4WSZJX22LzCgnC27ocnGI8ig0i+fVAL
         jlK4E81RL3o9xgt0I2ujgprTVW84N3NDNHRztj6A=
From:   Wang Xuerui <git@xen0n.name>
To:     linux-wireless@vger.kernel.org
Cc:     Wang Xuerui <git@xen0n.name>, Gil Adam <gil.adam@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH] iwlwifi: mvm: fix interface bringup on non-ACPI configs
Date:   Thu, 21 Nov 2019 15:48:32 +0800
Message-Id: <20191121074832.6978-1-git@xen0n.name>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Previously the non-ACPI stub of iwl_mvm_ppag_init unconditionally
returned -ENOENT, that in turn blocked flow of iwl_mvm_up.

Take the precedent of iwl_mvm_sar_geo_init, make iwl_mvm_ppag_init no-op
on non-ACPI configs.

Fixes: 6ce1e5c0c207 ("iwlwifi: support per-platform antenna gain")
Cc: Gil Adam <gil.adam@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Wang Xuerui <git@xen0n.name>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index d9eb2b286438..04ac47b7cae9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1169,7 +1169,7 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 
 static int iwl_mvm_ppag_init(struct iwl_mvm *mvm)
 {
-	return -ENOENT;
+	return 0;
 }
 #endif /* CONFIG_ACPI */
 
-- 
2.21.0

