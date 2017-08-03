Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33162 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbdHCJNi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 05:13:38 -0400
Received: by mail-pg0-f65.google.com with SMTP id u185so968846pgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 02:13:37 -0700 (PDT)
From: Xinming Hu <huxinming820@gmail.com>
To: Linux Wireless <linux-wireless@vger.kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/2] mwifiex: wrapper wps ie in pass through tlv
Date: Thu,  3 Aug 2017 09:13:28 +0000
Message-Id: <1501751608-12829-2-git-send-email-huxinming820@gmail.com> (sfid-20170803_111341_073857_103E86C4)
In-Reply-To: <1501751608-12829-1-git-send-email-huxinming820@gmail.com>
References: <1501751608-12829-1-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch wrapper wps ie in pass through tlv, so that
firmware could parse correctly.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/join.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/join.c b/drivers/net/wireless/marvell/mwifiex/join.c
index b89596c..d87aeff 100644
--- a/drivers/net/wireless/marvell/mwifiex/join.c
+++ b/drivers/net/wireless/marvell/mwifiex/join.c
@@ -253,7 +253,7 @@ static int mwifiex_get_common_rates(struct mwifiex_private *priv, u8 *rate1,
 			    priv->wps_ie_len, *buffer);
 
 		/* Wrap the generic IE buffer with a pass through TLV type */
-		ie_header.type = cpu_to_le16(TLV_TYPE_MGMT_IE);
+		ie_header.type = cpu_to_le16(TLV_TYPE_PASSTHROUGH);
 		ie_header.len = cpu_to_le16(priv->wps_ie_len);
 		memcpy(*buffer, &ie_header, sizeof(ie_header));
 		*buffer += sizeof(ie_header);
-- 
1.9.1
