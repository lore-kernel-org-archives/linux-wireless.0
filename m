Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:33056 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab3A2Wkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 17:40:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tim Shepard <shep@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.8] mwifiex: fix incomplete scan in case of IE parsing error
Date: Tue, 29 Jan 2013 14:38:02 -0800
Message-Id: <1359499082-21096-1-git-send-email-bzhao@marvell.com> (sfid-20130129_234054_684192_B06DB678)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A scan request is split into multiple scan commands queued in
scan_pending_q. Each scan command will be sent to firmware and
its response is handlded one after another.

If any error is detected while parsing IE in command response
buffer the remaining data will be ignored and error is returned.

We should check if there is any more scan commands pending in
the queue before returning error. This ensures that we will call
cfg80211_scan_done if this is the last scan command, or send
next scan command in scan_pending_q to firmware.

Cc: "3.6+" <stable@vger.kernel.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/scan.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 9189a32..973a9d9 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1563,7 +1563,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
 			scan_rsp->number_of_sets);
 		ret = -1;
-		goto done;
+		goto check_next_scan;
 	}
 
 	bytes_left = le16_to_cpu(scan_rsp->bss_descript_size);
@@ -1634,7 +1634,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		if (!beacon_size || beacon_size > bytes_left) {
 			bss_info += bytes_left;
 			bytes_left = 0;
-			return -1;
+			ret = -1;
+			goto check_next_scan;
 		}
 
 		/* Initialize the current working beacon pointer for this BSS
@@ -1690,7 +1691,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 				dev_err(priv->adapter->dev,
 					"%s: bytes left < IE length\n",
 					__func__);
-				goto done;
+				goto check_next_scan;
 			}
 			if (element_id == WLAN_EID_DS_PARAMS) {
 				channel = *(current_ptr + sizeof(struct ieee_types_header));
@@ -1753,6 +1754,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		}
 	}
 
+check_next_scan:
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	if (list_empty(&adapter->scan_pending_q)) {
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -1813,7 +1815,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		}
 	}
 
-done:
 	return ret;
 }
 
-- 
1.7.0.2

