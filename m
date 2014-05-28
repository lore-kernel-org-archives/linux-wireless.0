Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:24346 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbaE1Ejq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 00:39:46 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/3] mwifiex: set TDLS link for newly created RA list
Date: Tue, 27 May 2014 21:39:33 -0700
Message-ID: <1401251974-18738-2-git-send-email-bzhao@marvell.com> (sfid-20140528_063950_475334_234FAEF8)
In-Reply-To: <1401251974-18738-1-git-send-email-bzhao@marvell.com>
References: <1401251974-18738-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Current implementation sets tdls_link flag only while restoring
packets from TDLS queue. If traffic to peer starts after TDLS is
setup, there is no way to set TDLS link flag to true. Do this
while creating RA list and we confirm that there exist a TDLS
peer for which setup is complete.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 6d9738a..d3671d0 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -163,6 +163,7 @@ void mwifiex_ralist_add(struct mwifiex_private *priv, const u8 *ra)
 		if (!mwifiex_queuing_ra_based(priv)) {
 			if (mwifiex_get_tdls_link_status(priv, ra) ==
 			    TDLS_SETUP_COMPLETE) {
+				ra_list->tdls_link = true;
 				ra_list->is_11n_enabled =
 					mwifiex_tdls_peer_11n_enabled(priv, ra);
 			} else {
-- 
1.8.2.3

