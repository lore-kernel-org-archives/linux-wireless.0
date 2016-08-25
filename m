Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759781AbcHYP3o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 11:29:44 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 1/3] mwifiex: make "PCI-E is not the winner" print more informative
Date: Thu, 25 Aug 2016 17:05:16 +0200
Message-Id: <1472137518-10431-2-git-send-email-sgruszka@redhat.com> (sfid-20160825_173006_880260_836EBC13)
In-Reply-To: <1472137518-10431-1-git-send-email-sgruszka@redhat.com>
References: <1472137518-10431-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Printing ret and adapter->winner do not provide any useful information
as those are always 0 at point where the massage is printed. Print value
read from reg->fw_status register instead.

Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 453ab6a..8abbbfe 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2074,8 +2074,7 @@ mwifiex_check_winner_status(struct mwifiex_adapter *adapter)
 		adapter->winner = 1;
 	} else {
 		mwifiex_dbg(adapter, ERROR,
-			    "PCI-E is not the winner <%#x,%d>, exit dnld\n",
-			    ret, adapter->winner);
+			    "PCI-E is not the winner <%#x>", winner);
 	}
 
 	return ret;
-- 
1.8.3.1
