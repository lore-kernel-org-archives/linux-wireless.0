Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49320 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbeILOiu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 10:38:50 -0400
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
Subject: [PATCH v2 3/3] clk: x86: Stop marking clocks as CLK_IS_CRITICAL
Date: Wed, 12 Sep 2018 11:34:56 +0200
Message-Id: <20180912093456.23400-4-hdegoede@redhat.com> (sfid-20180912_113516_451820_2480E41A)
In-Reply-To: <20180912093456.23400-1-hdegoede@redhat.com>
References: <20180912093456.23400-1-hdegoede@redhat.com>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit d31fd43c0f9a ("clk: x86: Do not gate clocks enabled by the
firmware"), which added the code to mark clocks as CLK_IS_CRITICAL, causes
all unclaimed PMC clocks on Cherry Trail devices to be on all the time,
resulting on the device not being able to reach S0i3 when suspended.

The reason for this commit is that on some Bay Trail / Cherry Trail devices
the r8169 ethernet controller uses pmc_plt_clk_4. Now that the clk-pmc-atom
driver exports an "ether_clk" alias for pmc_plt_clk_4 and the r8169 driver
has been modified to get and enable this clock (if present) the marking of
the clocks as CLK_IS_CRITICAL is no longer necessary.

This commit removes the CLK_IS_CRITICAL marking, fixing Cherry Trail
devices not being able to reach S0i3 greatly decreasing their battery
drain when suspended.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=193891#c102
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=196861
Cc: Johannes Stezenbach <js@sig21.net>
Cc: Carlo Caione <carlo@endlessm.com>
Reported-by: Johannes Stezenbach <js@sig21.net>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Tweaked the commit msg a bit
-Added: Stephen's Acked-by, Andy's Reviewed-by
---
 drivers/clk/x86/clk-pmc-atom.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/clk/x86/clk-pmc-atom.c b/drivers/clk/x86/clk-pmc-atom.c
index 75151901ff7d..d977193842df 100644
--- a/drivers/clk/x86/clk-pmc-atom.c
+++ b/drivers/clk/x86/clk-pmc-atom.c
@@ -187,13 +187,6 @@ static struct clk_plt *plt_clk_register(struct platform_device *pdev, int id,
 	pclk->reg = base + PMC_CLK_CTL_OFFSET + id * PMC_CLK_CTL_SIZE;
 	spin_lock_init(&pclk->lock);
 
-	/*
-	 * If the clock was already enabled by the firmware mark it as critical
-	 * to avoid it being gated by the clock framework if no driver owns it.
-	 */
-	if (plt_clk_is_enabled(&pclk->hw))
-		init.flags |= CLK_IS_CRITICAL;
-
 	ret = devm_clk_hw_register(&pdev->dev, &pclk->hw);
 	if (ret) {
 		pclk = ERR_PTR(ret);
-- 
2.19.0.rc0
