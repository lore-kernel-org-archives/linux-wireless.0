Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:53504 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S965957AbeCHFyW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 00:54:22 -0500
From: Xinming Hu <huxm@marvell.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
CC: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>,
        Dmitry Torokhov <dtor@google.com>, <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Ellie Reeves <ellierevves@gmail.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH] mwifiex: correct antenna number with high bits reserved
Date: Thu, 8 Mar 2018 13:54:02 +0800
Message-ID: <1520488442-10729-1-git-send-email-huxm@marvell.com> (sfid-20180308_065439_716744_4B87FF53)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

High bits of antenna number are reserved in hardware spec,
using low 4 bits represent supported antenna.

Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index dcc529e..78a4a6a 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1526,7 +1526,8 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 
 	adapter->fw_release_number = le32_to_cpu(hw_spec->fw_release_number);
 	adapter->fw_api_ver = (adapter->fw_release_number >> 16) & 0xff;
-	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
+	adapter->number_of_antenna =
+			le16_to_cpu(hw_spec->number_of_antenna) & 0xf;
 
 	if (le32_to_cpu(hw_spec->dot_11ac_dev_cap)) {
 		adapter->is_hw_11ac_capable = true;
-- 
1.9.1
