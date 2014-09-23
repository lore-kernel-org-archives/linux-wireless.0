Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51144 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbaIWVSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:18:10 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 08/10] ath10k: support CT firmware flag.
Date: Tue, 23 Sep 2014 14:17:23 -0700
Message-Id: <1411507045-18973-8-git-send-email-greearb@candelatech.com> (sfid-20140923_231816_868357_E3BE1421)
In-Reply-To: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
References: <1411507045-18973-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add placeholder so CT firmware can more easily co-exist with upstream
kernel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Patch is same as last time, different subsequent patch added
  in case that justifies this better.  I have more, such as
  tx-status (ie, tx rate) reporting, but those are on top of
  the 32-stations patch logic, so have to get that sorted out
  before I can post those.

  If nothing else, can we add a 'do-no-use = 5' feature flag so at least
  I can keep some backward/forward compatability with existing
  CT firwmare and kernels patchs to utilize it?

 drivers/net/wireless/ath/ath10k/core.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 601d573..0d1813c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -361,6 +361,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_WMI_10_2 = 4,
 
+	/* Firmware from Candela Technologies, enables more VIFs, etc */
+	ATH10K_FW_FEATURE_WMI_10X_CT = 5,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
-- 
1.7.11.7

