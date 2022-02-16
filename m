Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3186C433F5
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Feb 2022 19:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiBPTnF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Feb 2022 14:43:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbiBPTnE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Feb 2022 14:43:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FB9DB872;
        Wed, 16 Feb 2022 11:42:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388096185D;
        Wed, 16 Feb 2022 19:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4F9C004E1;
        Wed, 16 Feb 2022 19:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040570;
        bh=EpzO/qjFt4Dx1JWZ/24how7avVB7hBpk4SufEDsrHI4=;
        h=Date:From:To:Cc:Subject:From;
        b=c2FzKYUeXpvxpDysxrigYpGK3Mc7OPWQGEdNS1xMC5/CXFlGqk2lkOBupZXG067EA
         OWDBJkKwgbOUAi1Z61+D2TnXdM20/6rH9Ssc24DQxCNEKJVNHBd2zzh4UmAj9OUclE
         NIAafAqG8Ded2JUyL8TQTowzQ5CuxX9j/FGKG0rGMyG0iD7yCOqv7p6eOsxJddmC4y
         L+ys5UcznUjC72mI8uFKxnG/nXryjmqz6/rL1X0GoMs0cE34ly+dzEB3Y9uMPrzrgO
         L7k10uPIhJU2+vNUqZaKmhGfOjx+UMW44QK0vbrPWKf6lhnc0lO+VqbOqkB1iZ44wc
         4/jkmy9qa58Ug==
Date:   Wed, 16 Feb 2022 13:50:30 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] iwlwifi: mei: Replace zero-length array with
 flexible-array member
Message-ID: <20220216195030.GA904170@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There is a regular need in the kernel to provide a way to declare
having a dynamically sized set of trailing elements in a structure.
Kernel code should always use “flexible array members”[1] for these
cases. The older style of one-element or zero-length arrays should
no longer be used[2].

[1] https://en.wikipedia.org/wiki/Flexible_array_member
[2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays

Link: https://github.com/KSPP/linux/issues/78
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mei/sap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/sap.h b/drivers/net/wireless/intel/iwlwifi/mei/sap.h
index 11e3009121cc..be1456dea484 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/sap.h
+++ b/drivers/net/wireless/intel/iwlwifi/mei/sap.h
@@ -298,7 +298,7 @@ struct iwl_sap_hdr {
 	__le16 type;
 	__le16 len;
 	__le32 seq_num;
-	u8 payload[0];
+	u8 payload[];
 };
 
 /**
-- 
2.27.0

