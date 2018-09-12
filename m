Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32848 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbeILOiq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 10:38:46 -0400
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
Subject: [PATCH v2 1/3] clk: x86: add "ether_clk" alias for Bay Trail / Cherry Trail
Date: Wed, 12 Sep 2018 11:34:54 +0200
Message-Id: <20180912093456.23400-2-hdegoede@redhat.com> (sfid-20180912_113508_786748_CEAB7868)
In-Reply-To: <20180912093456.23400-1-hdegoede@redhat.com>
References: <20180912093456.23400-1-hdegoede@redhat.com>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit d31fd43c0f9a ("clk: x86: Do not gate clocks enabled by the
firmware") causes all unclaimed PMC clocks on Cherry Trail devices to be on
all the time, resulting on the device not being able to reach S0i2 or S0i3
when suspended.

The reason for this commit is that on some Bay Trail / Cherry Trail devices
the ethernet controller uses pmc_plt_clk_4. This commit adds an "ether_clk"
alias, so that the relevant ethernet drivers can try to (optionally) use
this, without needing X86 specific code / hacks, thus fixing ethernet on
these devices without breaking S0i3 support.

This commit uses clkdev_hw_create() to create the alias, mirroring the code
for the already existing "mclk" alias for pmc_plt_clk_3.

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
 drivers/clk/x86/clk-pmc-atom.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/clk/x86/clk-pmc-atom.c b/drivers/clk/x86/clk-pmc-atom.c
index 08ef69945ffb..75151901ff7d 100644
--- a/drivers/clk/x86/clk-pmc-atom.c
+++ b/drivers/clk/x86/clk-pmc-atom.c
@@ -55,6 +55,7 @@ struct clk_plt_data {
 	u8 nparents;
 	struct clk_plt *clks[PMC_CLK_NUM];
 	struct clk_lookup *mclk_lookup;
+	struct clk_lookup *ether_clk_lookup;
 };
 
 /* Return an index in parent table */
@@ -351,11 +352,20 @@ static int plt_clk_probe(struct platform_device *pdev)
 		goto err_unreg_clk_plt;
 	}
 
+	data->ether_clk_lookup = clkdev_hw_create(&data->clks[4]->hw,
+						  "ether_clk", NULL);
+	if (!data->ether_clk_lookup) {
+		err = -ENOMEM;
+		goto err_drop_mclk;
+	}
+
 	plt_clk_free_parent_names_loop(parent_names, data->nparents);
 
 	platform_set_drvdata(pdev, data);
 	return 0;
 
+err_drop_mclk:
+	clkdev_drop(data->mclk_lookup);
 err_unreg_clk_plt:
 	plt_clk_unregister_loop(data, i);
 	plt_clk_unregister_parents(data);
@@ -369,6 +379,7 @@ static int plt_clk_remove(struct platform_device *pdev)
 
 	data = platform_get_drvdata(pdev);
 
+	clkdev_drop(data->ether_clk_lookup);
 	clkdev_drop(data->mclk_lookup);
 	plt_clk_unregister_loop(data, PMC_CLK_NUM);
 	plt_clk_unregister_parents(data);
-- 
2.19.0.rc0
