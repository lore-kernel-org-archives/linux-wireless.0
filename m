Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55296 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXLJPqQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:46:16 -0500
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 40/48] libertas: set dev_addr on rtap device
Message-Id: <E1J1kpk-0006nL-6q@shinybook.infradead.org> (sfid-20071210_154639_909919_B1C80E13)
Date: Mon, 10 Dec 2007 10:46:16 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Sun, 9 Dec 2007 19:54:11 -0500

This lets us bring it up, because eth_validate_addr() succeeds instead
of returning -EINVAL. And finally monitor mode seems to (mostly) work.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 55dce8d..e9c6b4f 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1473,6 +1473,7 @@ int lbs_add_rtap(struct lbs_private *priv)
 	if (rtap_dev == NULL)
 		return -ENOMEM;
 
+	memcpy(rtap_dev->dev_addr, priv->current_addr, ETH_ALEN);
 	rtap_dev->type = ARPHRD_IEEE80211_RADIOTAP;
 	rtap_dev->open = lbs_rtap_open;
 	rtap_dev->stop = lbs_rtap_stop;
-- 
1.5.3.4

