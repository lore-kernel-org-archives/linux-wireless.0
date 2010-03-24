Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39547 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab0CXVaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 17:30:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: fix build error for CONFIG_IWLAGN=n
Date: Wed, 24 Mar 2010 17:23:19 -0400
Message-Id: <1269465799-19060-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <4BAA73D2.1000301@oracle.com>
References: <4BAA73D2.1000301@oracle.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_good_ack_health':
drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: 'struct iwl_priv' has no member named '_agn'

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-rx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b6a64d8..2fa30df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -621,6 +621,7 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 #define BA_TIMEOUT_CNT (5)
 #define BA_TIMEOUT_MAX (16)
 
+#if defined(CONFIG_IWLAGN) || defined(CONFIG_IWLAGN_MODULE)
 /**
  * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
  *
@@ -670,6 +671,7 @@ bool iwl_good_ack_health(struct iwl_priv *priv,
 	return rc;
 }
 EXPORT_SYMBOL(iwl_good_ack_health);
+#endif
 
 /**
  * iwl_good_plcp_health - checks for plcp error.
-- 
1.6.2.5

