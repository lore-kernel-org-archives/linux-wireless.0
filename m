Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:60581 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758202AbZJBUtw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:52 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/13] iwlagn: fix compile warning in iwl5000_gain_computation
Date: Fri,  2 Oct 2009 13:44:07 -0700
Message-Id: <1254516247-4085-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

The return type of abs() was recently changed from int to long. With
min()'s type checking we thus need to make sure that values of the same
type are compared.

This fixes:

    CC [M]  drivers/net/wireless/iwlwifi/iwl-5000.o
drivers/net/wireless/iwlwifi/iwl-5000.c: In function ‘iwl5000_gain_computation’:
drivers/net/wireless/iwlwifi/iwl-5000.c:320: warning: comparison of distinct pointer types lacks a cast

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reported-by: Marcel Holtmann <marcel@holtmann.org>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 98baf8a..8cc3d50 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -283,7 +283,7 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 			(s32)average_noise[i])) / 1500;
 		/* bound gain by 2 bits value max, 3rd bit is sign */
 		data->delta_gain_code[i] =
-			min(abs(delta_g), CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
+			min(abs(delta_g), (long) CHAIN_NOISE_MAX_DELTA_GAIN_CODE);
 
 		if (delta_g < 0)
 			/* set negative sign */
-- 
1.5.6.3

