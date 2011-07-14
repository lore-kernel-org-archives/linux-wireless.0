Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:53361 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab1GNDq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 23:46:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: put multicast/broadcast packets to the same RA
Date: Wed, 13 Jul 2011 20:51:57 -0700
Message-Id: <1310615519-32112-1-git-send-email-bzhao@marvell.com> (sfid-20110714_054630_723361_320BA21D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

For ad-hoc mode, RA is created for each peer connected. In case of
multicast traffic new RA will be created for each multicast
address. While processing Tx packets we have to go through this
RA list. We can avoid some RA nodes by sharing same RA for both
multicast and broadcast packets.

Therefore "memset(0xff)" is used to treat multicast packet as broadcast
one while choosing RA.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 67b2d0b..69e260b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -634,6 +634,8 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 			ra_list = NULL;
 	} else {
 		memcpy(ra, skb->data, ETH_ALEN);
+		if (ra[0] & 0x01)
+			memset(ra, 0xff, ETH_ALEN);
 		ra_list = mwifiex_wmm_get_queue_raptr(priv, tid_down, ra);
 	}
 
-- 
1.7.0.2

