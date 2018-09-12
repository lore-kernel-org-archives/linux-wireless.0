Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbeILOit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 10:38:49 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Stezenbach <js@sig21.net>,
        Carlo Caione <carlo@endlessm.com>, linux-clk@vger.kernel.org
Subject: [PATCH v2 2/3] r8169: Get and enable optional ether_clk clock
Date: Wed, 12 Sep 2018 11:34:55 +0200
Message-Id: <20180912093456.23400-3-hdegoede@redhat.com> (sfid-20180912_113509_371314_8387C42D)
In-Reply-To: <20180912093456.23400-1-hdegoede@redhat.com>
References: <20180912093456.23400-1-hdegoede@redhat.com>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On some boards a platform clock is used as clock for the r8169 chip,
this commit adds support for getting and enabling this clock (assuming
it has an "ether_clk" alias set on it).

This is related to commit d31fd43c0f9a ("clk: x86: Do not gate clocks
enabled by the firmware") which is a previous attempt to fix this for some
x86 boards, but this causes all Cherry Trail SoC using boards to not reach
there lowest power states when suspending.

This commit (together with an atom-pmc-clk driver commit adding the alias)
fixes things properly by making the r8169 get the clock and enable it when
it needs it.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=193891#c102
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=196861
Cc: Johannes Stezenbach <js@sig21.net>
Cc: Carlo Caione <carlo@endlessm.com>
Reported-by: Johannes Stezenbach <js@sig21.net>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Tweaked the commit msg a bit
-Added: Stephen's Acked-by, Andy's Reviewed-by
---
 drivers/net/ethernet/realtek/r8169.c | 33 ++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index b08d51bf7a20..474229548731 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -13,6 +13,7 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/ethtool.h>
 #include <linux/phy.h>
@@ -665,6 +666,7 @@ struct rtl8169_private {
 
 	u16 event_slow;
 	const struct rtl_coalesce_info *coalesce_info;
+	struct clk *clk;
 
 	struct mdio_ops {
 		void (*write)(struct rtl8169_private *, int, int);
@@ -7254,6 +7256,11 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
 	}
 }
 
+static void rtl_disable_clk(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	const struct rtl_cfg_info *cfg = rtl_cfg_infos + ent->driver_data;
@@ -7274,6 +7281,32 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->msg_enable = netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 	tp->supports_gmii = cfg->has_gmii;
 
+	/* Get the *optional* external "ether_clk" used on some boards */
+	tp->clk = devm_clk_get(&pdev->dev, "ether_clk");
+	if (IS_ERR(tp->clk)) {
+		rc = PTR_ERR(tp->clk);
+		if (rc == -ENOENT) {
+			/* clk-core allows NULL (for suspend / resume) */
+			tp->clk = NULL;
+		} else if (rc == -EPROBE_DEFER) {
+			return rc;
+		} else {
+			dev_err(&pdev->dev, "failed to get clk: %d\n", rc);
+			return rc;
+		}
+	} else {
+		rc = clk_prepare_enable(tp->clk);
+		if (rc) {
+			dev_err(&pdev->dev, "failed to enable clk: %d\n", rc);
+			return rc;
+		}
+
+		rc = devm_add_action_or_reset(&pdev->dev, rtl_disable_clk,
+					      tp->clk);
+		if (rc)
+			return rc;
+	}
+
 	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 	rc = pcim_enable_device(pdev);
 	if (rc < 0) {
-- 
2.19.0.rc0
