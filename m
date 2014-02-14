Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36679 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaBNJDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 04:03:35 -0500
Date: Fri, 14 Feb 2014 12:03:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>, Avinash Patil <patila@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: memory corruption in mwifiex_tdls_add_vht_capab()
Message-ID: <20140214090312.GB13684@elgon.mountain> (sfid-20140214_100350_855962_BFCEC43B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a typo here because the names are confusingly similar.  The
intent was sizeof(struct ieee80211_vht_cap) (size 12) but sizeof(struct
ieee80211_ht_cap) (size 32) was used.

Anway, it's cleaner to just specify the variable instead of the type.

Fixes: 5f6d5983394f ('mwifiex: add VHT support for TDLS')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 5efd456af571..9d6849f60603 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -180,7 +180,7 @@ static int mwifiex_tdls_add_vht_capab(struct mwifiex_private *priv,
 	memset(&vht_cap, 0, sizeof(struct ieee80211_vht_cap));
 
 	mwifiex_fill_vht_cap_tlv(priv, &vht_cap, priv->curr_bss_params.band);
-	memcpy(pos, &vht_cap, sizeof(struct ieee80211_ht_cap));
+	memcpy(pos, &vht_cap, sizeof(vht_cap));
 
 	return 0;
 }
