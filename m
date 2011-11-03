Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54279 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1KCJkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 05:40:32 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Dai Shuibing <shuibing@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 3/3] ath6kl: Indicate WAPI IE from (Re)Association Request frame
Date: Thu, 3 Nov 2011 11:39:39 +0200
Message-ID: <1320313179-9259-4-git-send-email-jouni@qca.qualcomm.com> (sfid-20111103_104035_489361_6442C0AD)
In-Reply-To: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
References: <1320313179-9259-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dai Shuibing <shuibing@qca.qualcomm.com>

This is needed to know whether the STA requests WAPI to be used and if
so, with what AKM and cipher.

Signed-off-by: Dai Shuibing <shuibing@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index a800837..559539b 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -534,6 +534,18 @@ void ath6kl_connect_ap_mode_sta(struct ath6kl_vif *vif, u16 aid, u8 *mac_addr,
 				wpa_ie = pos; /* WPS IE */
 				break; /* overrides WPA/RSN IE */
 			}
+		} else if (pos[0] == 0x44 && wpa_ie == NULL) {
+			/*
+			 * Note: WAPI Parameter Set IE re-uses Element ID that
+			 * was officially allocated for BSS AC Access Delay. As
+			 * such, we need to be a bit more careful on when
+			 * parsing the frame. However, BSS AC Access Delay
+			 * element is not supposed to be included in
+			 * (Re)Association Request frames, so this should not
+			 * cause problems.
+			 */
+			wpa_ie = pos; /* WAPI IE */
+			break;
 		}
 		pos += 2 + pos[1];
 	}
-- 
1.7.4.1

