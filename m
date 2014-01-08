Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52368 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757266AbaAHXqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 18:46:21 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: fix potential buffer overflow in dt configuration
Date: Wed, 8 Jan 2014 15:45:56 -0800
Message-ID: <1389224757-14339-1-git-send-email-bzhao@marvell.com> (sfid-20140109_004624_880853_6534FC9C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If cfgdata length exceeds the command buffer size we will end up
getting buffer overflow problem. Fix it by checking the buffer
size less the command header length.

Reviewed-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sta_cmd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 9c2404c..9208a88 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1170,8 +1170,9 @@ int mwifiex_dnld_dt_cfgdata(struct mwifiex_private *priv,
 		    strncmp(prop->name, prefix, len))
 			continue;
 
-		/* property header is 6 bytes */
-		if (prop && prop->value && prop->length > 6) {
+		/* property header is 6 bytes, data must fit in cmd buffer */
+		if (prop && prop->value && prop->length > 6 &&
+		    prop->length <= MWIFIEX_SIZE_OF_CMD_BUFFER - S_DS_GEN) {
 			ret = mwifiex_send_cmd_sync(priv, HostCmd_CMD_CFG_DATA,
 						    HostCmd_ACT_GEN_SET, 0,
 						    prop);
-- 
1.8.2.3

