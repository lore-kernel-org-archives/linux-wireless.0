Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885Ab2GILsh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 07:48:37 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RHEL6 PATCH] iwlwifi: remove spurious warning
Date: Mon,  9 Jul 2012 13:48:29 +0200
Message-Id: <1341834509-11601-1-git-send-email-sgruszka@redhat.com> (sfid-20120709_134840_393170_84B78296)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BZ#837754

Description:
Some devices do not set SEQ_RX_FRAME flags for few commands that should
not be reclaimed. It was supposed to be fixed in firmware, but it was
not.

Upstream change also add possibility to configure which commands should
not be reclaimed, but that option is not used - only original 6 commands
are configured. So I did not backport that part, because it make things
somewhat (not necessarily) complex.

Upstream:
commit d663ee73f62903aed334eca25832a76c4a7e4c1c
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Sat Mar 10 13:00:07 2012 -0800

    iwlwifi: abstract out missing SEQ_RX_FRAME workaround

Testing:
Compiled only.
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index 1daf01e..80e9328 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -449,17 +449,6 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 		else
 			cmd = NULL;
 
-		/* warn if this is cmd response / notification and the uCode
-		 * didn't set the SEQ_RX_FRAME for a frame that is
-		 * uCode-originated
-		 * If you saw this code after the second half of 2012, then
-		 * please remove it
-		 */
-		WARN(pkt->hdr.cmd != REPLY_TX && reclaim == false &&
-		     (!(pkt->hdr.sequence & SEQ_RX_FRAME)),
-		     "reclaim is false, SEQ_RX_FRAME unset: %s\n",
-		     get_cmd_string(pkt->hdr.cmd));
-
 		err = iwl_rx_dispatch(priv(trans), rxb, cmd);
 
 		/*
-- 
1.7.1

