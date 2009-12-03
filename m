Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:39035 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752144AbZLCKjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:39:13 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 2/4] iwmc3200wifi: Coex table command does not expect a response
Date: Thu,  3 Dec 2009 11:40:16 +0100
Message-Id: <3259e3798cc114c1d6da7e764ce9da739b4e88b4.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <4790a128344a09f0bdb2249c8ee831f254ca72ec.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
 <4790a128344a09f0bdb2249c8ee831f254ca72ec.1259835655.git.sameo@linux.intel.com>
In-Reply-To: <cover.1259835655.git.sameo@linux.intel.com>
References: <cover.1259835655.git.sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When sending the wiwi coexistence priority table, we should not tell the LMAC
that we want a response.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 6a22711..1a4b7fb 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -192,7 +192,7 @@ int iwm_send_prio_table(struct iwm_priv *iwm)
 
 	return iwm_send_lmac_ptrough_cmd(iwm, COEX_PRIORITY_TABLE_CMD,
 				&coex_table_cmd,
-				sizeof(struct iwm_coex_prio_table_cmd), 1);
+				sizeof(struct iwm_coex_prio_table_cmd), 0);
 }
 
 int iwm_send_init_calib_cfg(struct iwm_priv *iwm, u8 calib_requested)
-- 
1.6.3.3

