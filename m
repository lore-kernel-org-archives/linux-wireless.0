Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149Ab2BQUXy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:54 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Amit Beka <amit.beka@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 18/26] iwlwifi: send testmode hcmd reply with rx header
Date: Fri, 17 Feb 2012 11:13:46 -0800
Message-Id: <1329506034-1394-19-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212400_649377_7A3631DA)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amit Beka <amit.beka@intel.com>

When a host command is sent through testmode, the whole
reply (including rx header) is returned to the user, and not
only the payload of the rx.
Before this commit the length was buggy - the reply contained 4 bytes
after the end of the payload.

Signed-off-by: Amit Beka <amit.beka@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-testmode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-testmode.c b/drivers/net/wireless/iwlwifi/iwl-testmode.c
index ba5c63a..80955ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-testmode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-testmode.c
@@ -309,7 +309,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	}
 
 	/* The reply is in a page, that we cannot send to user space. */
-	memcpy(reply_buf, &(pkt->u), reply_len);
+	memcpy(reply_buf, &(pkt->hdr), reply_len);
 	iwl_free_pages(priv->shrd, cmd.reply_page);
 
 	NLA_PUT_U32(skb, IWL_TM_ATTR_COMMAND, IWL_TM_CMD_DEV2APP_UCODE_RX_PKT);
-- 
1.7.0.4

