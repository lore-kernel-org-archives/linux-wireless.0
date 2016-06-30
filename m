Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35640 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbcF3WV6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 18:21:58 -0400
Received: by mail-pf0-f179.google.com with SMTP id c2so33518418pfa.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 15:21:22 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
	Doug Anderson <dianders@chromium.org>,
	Brian Norris <computersforpeace@gmail.com>,
	Stephen Barber <smbarber@chromium.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>
Subject: [PATCH] mwifiex: mask PCIe interrupts before removal
Date: Thu, 30 Jun 2016 15:21:02 -0700
Message-Id: <1467325262-82799-1-git-send-email-briannorris@chromium.org> (sfid-20160701_002243_111414_943E928D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCIe driver didn't mask the host interrupts before trying to tear
down. This causes lockups at reboot or rmmod when using MSI-X on 8997,
since the MSI handler gets confused and locks up the system.

Also tested on 8897, which does not support MSI-X (and wasn't
experiencing this same bug). No regressions seen there.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 0c7937eb6b77..af98371dc2af 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -440,6 +440,11 @@ static int mwifiex_pcie_disable_host_int(struct mwifiex_adapter *adapter)
 	return 0;
 }
 
+static void mwifiex_pcie_disable_host_int_noerr(struct mwifiex_adapter *adapter)
+{
+	WARN_ON(mwifiex_pcie_disable_host_int(adapter));
+}
+
 /*
  * This function enables the host interrupt.
  *
@@ -2945,6 +2950,7 @@ static struct mwifiex_if_ops pcie_ops = {
 	.register_dev =			mwifiex_register_dev,
 	.unregister_dev =		mwifiex_unregister_dev,
 	.enable_int =			mwifiex_pcie_enable_host_int,
+	.disable_int =			mwifiex_pcie_disable_host_int_noerr,
 	.process_int_status =		mwifiex_process_int_status,
 	.host_to_card =			mwifiex_pcie_host_to_card,
 	.wakeup =			mwifiex_pm_wakeup_card,
-- 
2.8.0.rc3.226.g39d4020

