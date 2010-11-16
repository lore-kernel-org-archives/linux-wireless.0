Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40346 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab0KPVOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 16:14:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <samuel.ortiz@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwmc3200wifi: clarify potentially undefined operation in iwm_scan_ssids
Date: Tue, 16 Nov 2010 16:08:56 -0500
Message-Id: <1289941736-2057-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/iwmc3200wifi/commands.o
drivers/net/wireless/iwmc3200wifi/commands.c: In function ‘iwm_scan_ssids’:
drivers/net/wireless/iwmc3200wifi/commands.c:911:15: warning: operation on ‘iwm->scan_id’ may be undefined

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwmc3200wifi/commands.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 330c7d9..50dee6a 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -908,7 +908,7 @@ int iwm_scan_ssids(struct iwm_priv *iwm, struct cfg80211_ssid *ssids,
 		return ret;
 	}
 
-	iwm->scan_id = iwm->scan_id++ % IWM_SCAN_ID_MAX;
+	iwm->scan_id = (iwm->scan_id + 1) % IWM_SCAN_ID_MAX;
 
 	return 0;
 }
-- 
1.7.3.2

