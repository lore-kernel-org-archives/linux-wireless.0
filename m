Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.131]:38415 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932382AbdJZN3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Oct 2017 09:29:13 -0400
From: Jeffy Chen <jeffy.chen@rock-chips.com>
To: linux-kernel@vger.kernel.org, bhelgaas@google.com
Cc: linux-pm@vger.kernel.org, tony@atomide.com,
        shawn.lin@rock-chips.com, briannorris@chromium.org,
        rjw@rjwysocki.net, dianders@chromium.org,
        Jeffy Chen <jeffy.chen@rock-chips.com>,
        Xinming Hu <huxm@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Nishant Sarmukadam <nishants@marvell.com>,
        netdev@vger.kernel.org
Subject: [RFC PATCH v8 2/7] mwifiex: Disable wakeup irq handling for pcie
Date: Thu, 26 Oct 2017 21:28:35 +0800
Message-Id: <20171026132840.20946-3-jeffy.chen@rock-chips.com> (sfid-20171026_152932_516164_56C03DEE)
In-Reply-To: <20171026132840.20946-1-jeffy.chen@rock-chips.com>
References: <20171026132840.20946-1-jeffy.chen@rock-chips.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are going to handle the wakeup irq in the pci core.

Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
---

Changes in v8: None
Changes in v7: None
Changes in v6: None
Changes in v5: None
Changes in v3: None
Changes in v2: None

 drivers/net/wireless/marvell/mwifiex/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index ee40b739b289..ba081c16f85c 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1568,6 +1568,10 @@ static void mwifiex_probe_of(struct mwifiex_adapter *adapter)
 		goto err_exit;
 
 	adapter->dt_node = dev->of_node;
+
+	if (adapter->iface_type != MWIFIEX_PCIE)
+		goto err_exit;
+
 	adapter->irq_wakeup = irq_of_parse_and_map(adapter->dt_node, 0);
 	if (!adapter->irq_wakeup) {
 		dev_dbg(dev, "fail to parse irq_wakeup from device tree\n");
-- 
2.11.0
