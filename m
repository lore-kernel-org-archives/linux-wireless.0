Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:43907 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751445Ab2KFN6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2012 08:58:10 -0500
Date: Tue, 6 Nov 2012 19:23:15 +0530
From: Nishant Sarmukadam <nishants@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: [PATCH] mwl8k: Set packet timestamp to 0 when life time expiry is
 not used
Message-ID: <20121106135311.GA8464@markyou.marvell.com> (sfid-20121106_145813_949976_C91BE70A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set tx packet timestamp to 0 in following scenarios:-
- All packets in STA mode
- Mgmt packets in AP mode
- Eapol packets in AP mode

In STA mode, this field is unused in the firmware. In AP
mode, we should not be expiring mgmt and eapol frames.
Setting timestamp to 0 will ensure that.

Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index a4d3dcb..3db4950 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2033,6 +2033,8 @@ mwl8k_txq_xmit(struct ieee80211_hw *hw,
 	if (priv->ap_fw && ieee80211_is_data(wh->frame_control) && !eapol_frame)
 		tx->timestamp = cpu_to_le32(ioread32(priv->regs +
 						MWL8K_HW_TIMER_REGISTER));
+	else
+		tx->timestamp = 0;
 
 	wmb();
 	tx->status = cpu_to_le32(MWL8K_TXD_STATUS_FW_OWNED | txstatus);
-- 
1.7.9.2

