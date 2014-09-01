Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46002 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752521AbaIAHb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:31:58 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 10/17] mwifiex: use firmware API revision from GET_HW_SPEC response
Date: Mon, 1 Sep 2014 18:28:58 +0530
Message-ID: <1409576345-13717-11-git-send-email-patila@marvell.com> (sfid-20140901_093204_552391_CCBFD43D)
In-Reply-To: <1409576345-13717-1-git-send-email-patila@marvell.com>
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Newer firmware returns API revision in GET_HW_SPEC command
response. We will make use of it instead of parsing this
information from FW release number.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 7 +++++++
 drivers/net/wireless/mwifiex/fw.h     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 720e519..fcc70ae 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1552,6 +1552,13 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 						adapter->key_api_major_ver,
 						adapter->key_api_minor_ver);
 					break;
+				case FW_API_VER_ID:
+					adapter->fw_api_ver =
+							api_rev->major_ver;
+					dev_dbg(adapter->dev,
+						"Firmware api version %d\n",
+						adapter->fw_api_ver);
+					break;
 				default:
 					dev_warn(adapter->dev,
 						 "Unknown api_id: %d\n",
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index adc47f3..6a703ea 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -846,6 +846,7 @@ struct host_cmd_ds_802_11_ps_mode_enh {
 
 enum API_VER_ID {
 	KEY_API_VER_ID = 1,
+	FW_API_VER_ID = 2,
 };
 
 struct hw_spec_api_rev {
-- 
1.8.1.4

