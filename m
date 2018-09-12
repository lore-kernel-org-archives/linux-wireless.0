Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726221AbeILOin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 10:38:43 -0400
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
Subject: [PATCH v2 0/3] r8169 (x86) clk fixes to fix S0ix not being reached
Date: Wed, 12 Sep 2018 11:34:53 +0200
Message-Id: <20180912093456.23400-1-hdegoede@redhat.com> (sfid-20180912_113505_878628_6F1D28C2)
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

This series adds code to the r8169 ethernet driver to get and enable an
external clock if present, avoiding the need for a hack in the
clk-pmc-atom driver where that clock was left on continuesly causing x86
some devices to not reach deep power saving states (S0ix) when suspended
causing to them to quickly drain their battery while suspended.

The 3 commits in this series need to be merged in order to avoid
regressions while bisecting. The clk-pmc-atom driver does not see much
changes (it was last touched over a year ago). So the clk maintainers
have agreed with merging all 3 patches through the net tree.
All 3 patches have Stephen Boyd's Acked-by for this purpose.

This v2 of the series only had some minor tweaks done to the commit
messages and is ready for merging through the net tree now.

Thanks & Regards,

Hans
