Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:48771 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1HLHUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 03:20:08 -0400
From: Nishant Sarmukadam <nishants@marvell.com>
To: linux-wireless@vger.kernel.org, buytenh@wantstofly.org
Cc: nishants@marvell.com
Subject: [PATCH] mwl8k: Traffic to clients gets affected when one client leaves a cyrpto bss
Date: Fri, 12 Aug 2011 12:20:21 +0530
Message-Id: <1313131821-31322-1-git-send-email-nishants@marvell.com> (sfid-20110812_092012_437265_685D6004)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a client disassociates from a crypto enabled bss, data traffic to
other clients connected to the bss is stalled. This was due to a boolean
variable used to keep track if HW crypto is enabled i.e. if set key has
been called to add a key.  This flag was being reset every time delete
key was called e.g when a station leaves the bss. Once the flag is
reset, rx status flags were not being set for connected clients which
disrupts traffic to these clients. Fix this issue by not resetting the
flag since we do not need to reset this flag during the life time of the
bss.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index da36dbf..771280a 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4097,9 +4097,6 @@ static int mwl8k_set_key(struct ieee80211_hw *hw,
 
 		if (rc)
 			goto out;
-
-		mwl8k_vif->is_hw_crypto_enabled = false;
-
 	}
 out:
 	return rc;
-- 
1.6.0.3

