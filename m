Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fopen.at ([151.236.7.194]:47718 "EHLO fopen.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989AbbDPJWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 05:22:13 -0400
From: Florian Achleitner <flo@fopen.at>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: [PATCH] mwifiex: Trigger a card reset on "DNLD_CMD: host to card failed".
Date: Thu, 16 Apr 2015 11:14:48 +0200
Message-ID: <2350188.9S0zOEq5AR@r90b40zn> (sfid-20150416_112216_708595_BD94C4E5)
In-Reply-To: <3169170.GKjfvNuGRf@r90b40zn>
References: <3169170.GKjfvNuGRf@r90b40zn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever this problem occurs, the driver can not continue. Thus,
trigger a card reset to restart the module firmware. Other firmware
communication issues are resolved by this last resort.
Also dump registers, to eventually allow some diagnostics.

Signed-off-by: Florian Achleitner <flo@fopen.at>
---

This works well at least for us.

 drivers/net/wireless/mwifiex/cmdevt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c5a14ff..410f4f2 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -233,6 +233,12 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
                spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
                adapter->dbg.num_cmd_host_to_card_failure++;
+
+               if (adapter->if_ops.fw_dump)
+                       adapter->if_ops.fw_dump(adapter);
+
+               if (adapter->if_ops.card_reset)
+                       adapter->if_ops.card_reset(adapter);
                return -1;
        }
 
-- 
2.1.0


