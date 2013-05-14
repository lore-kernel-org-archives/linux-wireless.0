Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:35436 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab3ENBP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:15:26 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Daniel Drake <dsd@laptop.org>, Paul Fox <pgf@laptop.org>,
	Tim Shepard <shep@laptop.org>,
	Jason Abele <jabele@chromium.org>,
	John Rhodes <jrhodes@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 07/17] mwifiex: replace spin_lock_irqsave with spin_lock and fix warn_on
Date: Mon, 13 May 2013 18:14:51 -0700
Message-ID: <1368494101-23651-8-git-send-email-bzhao@marvell.com> (sfid-20130514_031528_951535_ACCCAF7C)
In-Reply-To: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
References: <1368494101-23651-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

We see this WARN_ON during PCIe unload:
WARNING: at kernel/smp.c:382 smp_call_function_many+0x66/0x1e1()

This happens because we are doing PCI iounmap operations while
holding spinlock via spin_lock_irqsave(). Holding spinlock this
way causes disabling IRQs and hence PCI iounmap shows warning on
irqs_disabled() check.

Use non-irq variant of spin_lock i.e. spin_lock() instead.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/init.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 1343725f..c7f11c0 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -687,7 +687,6 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 	int ret = -EINPROGRESS;
 	struct mwifiex_private *priv;
 	s32 i;
-	unsigned long flags;
 	struct sk_buff *skb;
 
 	/* mwifiex already shutdown */
@@ -722,7 +721,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 		}
 	}
 
-	spin_lock_irqsave(&adapter->mwifiex_lock, flags);
+	spin_lock(&adapter->mwifiex_lock);
 
 	if (adapter->if_ops.data_complete) {
 		while ((skb = skb_dequeue(&adapter->usb_rx_data_q))) {
@@ -738,7 +737,7 @@ mwifiex_shutdown_drv(struct mwifiex_adapter *adapter)
 
 	mwifiex_adapter_cleanup(adapter);
 
-	spin_unlock_irqrestore(&adapter->mwifiex_lock, flags);
+	spin_unlock(&adapter->mwifiex_lock);
 
 	/* Notify completion */
 	ret = mwifiex_shutdown_fw_complete(adapter);
-- 
1.8.2.3

