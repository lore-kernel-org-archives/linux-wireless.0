Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35172 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751640AbdFWOK4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jun 2017 10:10:56 -0400
Received: by mail-pf0-f195.google.com with SMTP id s66so7532066pfs.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jun 2017 07:10:56 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 12/17] rsi: update autorate request command frame
Date: Fri, 23 Jun 2017 19:37:31 +0530
Message-Id: <1498226856-6305-13-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170623_161100_064003_F26B9E96)
In-Reply-To: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1498226856-6305-1-git-send-email-amit.karwar@redpinesignals.com>
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
index 538a962..875e323 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1203,6 +1203,9 @@ static int rsi_send_auto_rate_request(struct rsi_common *common)
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
