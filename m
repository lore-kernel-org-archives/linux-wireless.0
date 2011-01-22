Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50811 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1AWAD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 19:03:57 -0500
Received: by bwz15 with SMTP id 15so2636416bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 Jan 2011 16:03:56 -0800 (PST)
Message-Id: <ffb8e21e6d549c2b229e7a4177586b7923805a96.1295740096.git.chunkeey@googlemail.com>
In-Reply-To: <2137e711f16faed3f59698cbcb210a1e650dd34c.1295740096.git.chunkeey@googlemail.com>
References: <2137e711f16faed3f59698cbcb210a1e650dd34c.1295740096.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 23 Jan 2011 00:10:01 +0100
Subject: [PATCH 2/3] carl9170: enable wake-on-lan feature testing
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/fw.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 546b4e4..a4e5b44 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -264,6 +264,9 @@ static int carl9170_fw(struct ar9170 *ar, const __u8 *data, size_t len)
 			FIF_PROMISC_IN_BSS;
 	}
 
+	if (SUPP(CARL9170FW_WOL))
+		device_set_wakeup_enable(&ar->udev->dev, true);
+
 	ar->fw.vif_num = otus_desc->vif_num;
 	ar->fw.cmd_bufs = otus_desc->cmd_bufs;
 	ar->fw.address = le32_to_cpu(otus_desc->fw_address);
-- 
1.7.2.3

