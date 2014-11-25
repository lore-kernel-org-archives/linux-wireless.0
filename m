Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:23104 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbaKYOoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 09:44:20 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/5] mwifiex: fix sparse warning
Date: Tue, 25 Nov 2014 06:43:02 -0800
Message-ID: <1416926586-19286-2-git-send-email-akarwar@marvell.com> (sfid-20141125_154431_039039_F8C1DDA5)
In-Reply-To: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
References: <1416926586-19286-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes following sparse warnings:

drivers/net/wireless/mwifiex/util.c:152:19: warning: cast from restricted __le16
drivers/net/wireless/mwifiex/util.c:152:19: warning: restricted __le16 degrades to integer

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index a113ef8..b1768fb 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -149,7 +149,7 @@ mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 	u8 category, action_code;
 	struct ieee80211_hdr *ieee_hdr = (void *)payload;
 
-	stype =  (cpu_to_le16(ieee_hdr->frame_control) & IEEE80211_FCTL_STYPE);
+	stype = (le16_to_cpu(ieee_hdr->frame_control) & IEEE80211_FCTL_STYPE);
 
 	switch (stype) {
 	case IEEE80211_STYPE_ACTION:
-- 
1.8.1.4

