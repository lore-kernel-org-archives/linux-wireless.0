Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab2J3IHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:07:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/4] iwlwifi: clarify NOCOPY/DUP documentation
Date: Tue, 30 Oct 2012 09:07:43 +0100
Message-Id: <1351584463-11469-5-git-send-email-johannes@sipsolutions.net> (sfid-20121030_090733_696604_BE6502C3)
In-Reply-To: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net>
References: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clarify the documentation to indicate that these
flags can only be used at the end, i.e. after them
a copy TFD (no flags set) is invalid.

Reported-by: Inbal Hacohen <inbal.hacohen@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 76c5237..47bbe39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -225,10 +225,13 @@ struct iwl_device_cmd {
  *	ring. The transport layer doesn't map the command's buffer to DMA, but
  *	rather copies it to an previously allocated DMA buffer. This flag tells
  *	the transport layer not to copy the command, but to map the existing
- *	buffer. This can save memcpy and is worth with very big comamnds.
+ *	buffer (that is passed in) instead. This saves the memcpy and allows
+ *	commands that are bigger than the fixed buffer to be submitted.
+ *	Note that a TFD entry after a NOCOPY one cannot be a normal copied one.
  * @IWL_HCMD_DFL_DUP: Only valid without NOCOPY, duplicate the memory for this
  *	chunk internally and free it again after the command completes. This
  *	can (currently) be used only once per command.
+ *	Note that a TFD entry after a DUP one cannot be a normal copied one.
  */
 enum iwl_hcmd_dataflag {
 	IWL_HCMD_DFL_NOCOPY	= BIT(0),
-- 
1.7.10.4

