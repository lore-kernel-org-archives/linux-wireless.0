Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40478 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751258AbeDBMbm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Apr 2018 08:31:42 -0400
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
Subject: [PATCH 1/2] mwifiex: uap: filter duplicate ERP IE
Date: Mon, 2 Apr 2018 20:31:22 +0800
Message-ID: <1522672283-1860-1-git-send-email-huxm@marvell.com> (sfid-20180402_143300_036339_AC1A0786)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware parse and attach ERP IE from bss configuration,
do not set again from tail IE.

Signed-off-by: Xinming Hu <huxm@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/ie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/ie.c b/drivers/net/wireless/marvell/mwifiex/ie.c
index 922e3d6..b10baac 100644
--- a/drivers/net/wireless/marvell/mwifiex/ie.c
+++ b/drivers/net/wireless/marvell/mwifiex/ie.c
@@ -349,6 +349,7 @@ static int mwifiex_uap_parse_tail_ies(struct mwifiex_private *priv,
 		case WLAN_EID_SUPP_RATES:
 		case WLAN_EID_COUNTRY:
 		case WLAN_EID_PWR_CONSTRAINT:
+		case WLAN_EID_ERP_INFO:
 		case WLAN_EID_EXT_SUPP_RATES:
 		case WLAN_EID_HT_CAPABILITY:
 		case WLAN_EID_HT_OPERATION:
-- 
1.9.1
