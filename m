Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41571 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131AbcBBKAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 05:00:17 -0500
Date: Tue, 2 Feb 2016 13:00:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
	chunfan chen <jeffc@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: fix a reversed condition
Message-ID: <20160202100005.GA3040@mwanda> (sfid-20160202_110026_827443_A5A9A7ED)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NULL test here is reversed.

Fixes: 7d7f07d8c5d3 ('mwifiex: add wowlan net-detect support')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index fc8d8ca..489f7a9 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2196,7 +2196,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 
 			pmatch = adapter->nd_info->matches[idx];
 
-			if (!pmatch) {
+			if (pmatch) {
 				memset(pmatch, 0, sizeof(*pmatch));
 				if (chan_band_tlv) {
 					pmatch->n_channels = 1;
