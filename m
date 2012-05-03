Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47866 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752138Ab2ECHXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 03:23:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 09/18] mwifiex: stop BSS in deauthentication handling
Date: Thu,  3 May 2012 00:22:31 -0700
Message-Id: <1336029760-22565-10-git-send-email-bzhao@marvell.com> (sfid-20120503_092345_193633_75DD5094)
In-Reply-To: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

While in AP mode, we should stop BSS in deauthentication handler.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/join.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index aeb0b3f..d6b4fb0 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1374,6 +1374,7 @@ static int mwifiex_deauthenticate_infra(struct mwifiex_private *priv, u8 *mac)
  *
  * In case of infra made, it sends deauthentication request, and
  * in case of ad-hoc mode, a stop network request is sent to the firmware.
+ * In AP mode, a command to stop bss is sent to firmware.
  */
 int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 {
@@ -1387,6 +1388,9 @@ int mwifiex_deauthenticate(struct mwifiex_private *priv, u8 *mac)
 		return mwifiex_send_cmd_sync(priv,
 					     HostCmd_CMD_802_11_AD_HOC_STOP,
 					     HostCmd_ACT_GEN_SET, 0, NULL);
+	case NL80211_IFTYPE_AP:
+		return mwifiex_send_cmd_sync(priv, HostCmd_CMD_UAP_BSS_STOP,
+					     HostCmd_ACT_GEN_SET, 0, NULL);
 	default:
 		break;
 	}
-- 
1.7.0.2

