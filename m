Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35009 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753681AbdGJMpr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 08:45:47 -0400
Received: by mail-pg0-f65.google.com with SMTP id d193so12604905pgc.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 05:45:28 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v2 12/17] rsi: update autorate request command frame
Date: Mon, 10 Jul 2017 18:10:43 +0530
Message-Id: <1499690448-9956-13-git-send-email-amitkarwar@gmail.com> (sfid-20170710_144559_588014_D7347176)
In-Reply-To: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
References: <1499690448-9956-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

When Short Gaurd Interval is enabled bit 9 is set in rate. Otherwise
it should not be set. Added missing 'else' case in this patch.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 3bffe31..77b6757 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1199,6 +1199,9 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
 			    conf_is_ht40(&common->priv->hw->conf))
 				auto_rate->supported_rates[ii++] =
 					cpu_to_le16(rsi_mcsrates[kk] | BIT(9));
+			else
+				auto_rate->supported_rates[ii++] =
+					cpu_to_le16(rsi_mcsrates[kk]);
 			auto_rate->supported_rates[ii] =
 				cpu_to_le16(rsi_mcsrates[kk--]);
 		}
-- 
2.7.4
