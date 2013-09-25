Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22630 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3IYI5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 04:57:43 -0400
Date: Wed, 25 Sep 2013 11:57:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: potential integer underflow in
 mwifiex_ret_wmm_get_status()
Message-ID: <20130925085729.GC6661@elgon.mountain> (sfid-20130925_105749_749028_2DDEF1CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If "resp_len" gets set to negative then it counts as a high positive
value.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I spotted this reviewing the int => bool changes, but I don't have the
hardware and can't test it.

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 2e8f9cd..3c6ee3a 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -772,6 +772,8 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
 			break;
 		}
 
+		if (resp_len < tlv_len + sizeof(tlv_hdr->header))
+			break;
 		curr += (tlv_len + sizeof(tlv_hdr->header));
 		resp_len -= (tlv_len + sizeof(tlv_hdr->header));
 	}
