Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:9841 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750827AbaILJKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 05:10:06 -0400
From: Avinash Patil <patila@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <akarwar@marvell.com>,
	<huxm@marvell.com>, <yangyang@marvell.com>, <cluo@marvell.com>,
	<maithili@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCHv2 01/16] mwifiex: set fw api info for backword compatibility
Date: Fri, 12 Sep 2014 20:08:45 +0530
Message-ID: <1410532740-3173-2-git-send-email-patila@marvell.com> (sfid-20140912_111012_464580_AE198623)
In-Reply-To: <1410532740-3173-1-git-send-email-patila@marvell.com>
References: <1410532740-3173-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we dont set FW API info here, for older FW releases where FW API
is not available in GET_HW_SPEC, API version would remain 0.
This may cause issues with 11ac if older FW is used with newer driver.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 985f6c2..fcc70ae 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1508,6 +1508,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	}
 
 	adapter->fw_release_number = le32_to_cpu(hw_spec->fw_release_number);
+	adapter->fw_api_ver = (adapter->fw_release_number >> 16) & 0xff;
 	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
 
 	if (le32_to_cpu(hw_spec->dot_11ac_dev_cap)) {
-- 
1.8.1.4

