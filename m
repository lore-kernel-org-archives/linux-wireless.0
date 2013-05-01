Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36255 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761484Ab3EAPRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 11:17:36 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 5/7] rt2x00: rt2800lib: use rt2x00dev->bcn->winfo_size
Date: Wed,  1 May 2013 17:17:33 +0200
Message-Id: <1367421455-18463-6-git-send-email-juhosg@openwrt.org> (sfid-20130501_171757_802343_1F1E065B)
In-Reply-To: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
References: <1367421455-18463-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon data queue is initialized already when
the rt2800_clear_beacon_register() function is called.

Fetch the size of the TXWI descriptor from that
instead of using the winfo_size field of the data
queue descriptor.

The two values are the same, and the use of the
rt2x00dev->bcn->winfo_size value allows us to
get rid of a superfluous pointer dereference.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index b52d70c..bddfd6d 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -840,7 +840,7 @@ static inline void rt2800_clear_beacon_register(struct rt2x00_dev *rt2x00dev,
 						unsigned int beacon_base)
 {
 	int i;
-	const int txwi_desc_size = rt2x00dev->ops->bcn->winfo_size;
+	const int txwi_desc_size = rt2x00dev->bcn->winfo_size;
 
 	/*
 	 * For the Beacon base registers we only need to clear
-- 
1.7.10

