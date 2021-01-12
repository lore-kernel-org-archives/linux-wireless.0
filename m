Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD70C433E6
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Jan 2021 13:25:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 734C3230F9
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Jan 2021 13:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbhALNZi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Jan 2021 08:25:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:55848 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbhALNZh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jan 2021 08:25:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EC221ACAC;
        Tue, 12 Jan 2021 13:24:55 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 1/2] iwlwifi: dbg: Don't touch the tlv data
Date:   Tue, 12 Jan 2021 14:24:48 +0100
Message-Id: <20210112132449.22243-2-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112132449.22243-1-tiwai@suse.de>
References: <20210112132449.22243-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The commit ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device
memory") added a termination of name string just to be sure, and this
seems causing a regression, a GPF triggered at firmware loading.
Basically we shouldn't modify the firmware data that may be provided
as read-only.

This patch drops the code that caused the regression and keep the tlv
data as is.

Fixes: ba8f6f4ae254 ("iwlwifi: dbg: add dumping special device memory")
BugLink: https://bugzilla.suse.com/show_bug.cgi?id=1180344
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210733
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

As an alternative fix, the debug print could be with the printf length
specifier to limit the size to IWL_FW_INIT_MAX_NAME, as found in the
bugzilla entries above, too.  I chose a simpler (partial) revert here
instead.

 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index a654147d3cd6..a80a35a7740f 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -180,13 +180,6 @@ static int iwl_dbg_tlv_alloc_region(struct iwl_trans *trans,
 	if (le32_to_cpu(tlv->length) < sizeof(*reg))
 		return -EINVAL;
 
-	/* For safe using a string from FW make sure we have a
-	 * null terminator
-	 */
-	reg->name[IWL_FW_INI_MAX_NAME - 1] = 0;
-
-	IWL_DEBUG_FW(trans, "WRT: parsing region: %s\n", reg->name);
-
 	if (id >= IWL_FW_INI_MAX_REGION_ID) {
 		IWL_ERR(trans, "WRT: Invalid region id %u\n", id);
 		return -EINVAL;
-- 
2.26.2

