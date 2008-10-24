Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:7737 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751555AbYJXGso (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:44 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/10] iwlwifi: Update reclaim flag
Date: Thu, 23 Oct 2008 23:48:58 -0700
Message-Id: <1224830938-1577-11-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084858_184697_45F1CC84)
In-Reply-To: <1224830938-1577-10-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-6-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-7-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-8-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-9-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-10-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <daniel.c.halperin@intel.com>

The reclaim flag should include REPLY_RX_MPDU_CMD in the list of commands
issued by uCode. This is for safety in case the SEQ_RX_FRAME bit is set
incorrectly.

Signed-off-by: Daniel Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9980c38..89450e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1392,6 +1392,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
 			(pkt->hdr.cmd != REPLY_RX_PHY_CMD) &&
 			(pkt->hdr.cmd != REPLY_RX) &&
+			(pkt->hdr.cmd != REPLY_RX_MPDU_CMD) &&
 			(pkt->hdr.cmd != REPLY_COMPRESSED_BA) &&
 			(pkt->hdr.cmd != STATISTICS_NOTIFICATION) &&
 			(pkt->hdr.cmd != REPLY_TX);
-- 
1.5.4.3

