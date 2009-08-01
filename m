Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:45216 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbZHACjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 22:39:41 -0400
From: Bing Zhao <bzhao@marvell.com>
To: libertas-dev@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: [PATCH] libertas: Fix WEP association failure with open source wpa_supplicant 0.5.10
Date: Fri, 31 Jul 2009 20:02:19 -0700
Message-Id: <1249095739-7908-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Maithili Hinge <maithili@marvell.com>

From: Maithili Hinge <maithili@marvell.com>

Add code to handle IW_AUTH_PRIVACY_INVOKED and IW_AUTH_RX_UNENCRYPTED_EAPOL
cases in lbs_set_auth() function in libertas code.

Signed-off-by: Maithili Hinge <maithili@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/libertas/wext.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
index e96451c..be837a0 100644
--- a/drivers/net/wireless/libertas/wext.c
+++ b/drivers/net/wireless/libertas/wext.c
@@ -1728,6 +1728,8 @@ static int lbs_set_auth(struct net_device *dev,
 	}
 
 	switch (dwrq->flags & IW_AUTH_INDEX) {
+	case IW_AUTH_PRIVACY_INVOKED:
+	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 	case IW_AUTH_TKIP_COUNTERMEASURES:
 	case IW_AUTH_CIPHER_PAIRWISE:
 	case IW_AUTH_CIPHER_GROUP:
-- 
1.5.3.4
