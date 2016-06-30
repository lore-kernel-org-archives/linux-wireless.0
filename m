Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:35200 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbcF3Iba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 04:31:30 -0400
From: Prasun Maiti <prasunmaiti87@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2] mwifiex: Fix endianness for event TLV type TLV_BTCOEX_WL_SCANTIME
Date: Thu, 30 Jun 2016 14:01:23 +0530
Message-Id: <1467275483-24091-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160630_103154_107778_0A70F9A5)
In-Reply-To: <10cf2879532349d29143ecbac3b459b7@SC-EXCH04.marvell.com>
References: <10cf2879532349d29143ecbac3b459b7@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two members min_scan_time and max_scan_time of structure
"mwifiex_ie_types_btcoex_scan_time" are of two bytes each. The values
are assigned directtly from firmware without endian conversion handling.
So, wrong datas will get saved in big-endian systems.

This patch converts the values into cpu's byte order before assigning them
into the local members.

Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
---
Changes in v2:
	- Fixed the following sparse compilation warnings:
	* sta_event.c:477:55: warning: cast to restricted __le16
	* sta_event.c:478:55: warning: cast to restricted __le16

 drivers/net/wireless/marvell/mwifiex/fw.h        | 4 ++--
 drivers/net/wireless/marvell/mwifiex/sta_event.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 8e4145a..03d3edf 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1958,8 +1958,8 @@ struct mwifiex_ie_types_btcoex_scan_time {
 	struct mwifiex_ie_types_header header;
 	u8 coex_scan;
 	u8 reserved;
-	u16 min_scan_time;
-	u16 max_scan_time;
+	__le16 min_scan_time;
+	__le16 max_scan_time;
 } __packed;

 struct mwifiex_ie_types_btcoex_aggr_win_size {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 0104108..7dff452 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -474,8 +474,8 @@ void mwifiex_bt_coex_wlan_param_update_event(struct mwifiex_private *priv,
 			scantlv =
 			    (struct mwifiex_ie_types_btcoex_scan_time *)tlv;
 			adapter->coex_scan = scantlv->coex_scan;
-			adapter->coex_min_scan_time = scantlv->min_scan_time;
-			adapter->coex_max_scan_time = scantlv->max_scan_time;
+			adapter->coex_min_scan_time = le16_to_cpu(scantlv->min_scan_time);
+			adapter->coex_max_scan_time = le16_to_cpu(scantlv->max_scan_time);
 			break;

 		default:
--
1.9.1

