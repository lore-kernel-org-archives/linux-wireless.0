Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([23.128.96.9]:53888 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbeIRHS5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 03:18:57 -0400
Date: Mon, 17 Sep 2018 18:48:50 -0700 (PDT)
Message-Id: <20180917.184850.781321135177511686.davem@davemloft.net> (sfid-20180918_034857_936656_A7445AD5)
To: hdegoede@redhat.com
Cc: hkallweit1@gmail.com, mturquette@baylibre.com, sboyd@kernel.org,
        andriy.shevchenko@linux.intel.com,
        pierre-louis.bossart@linux.intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        js@sig21.net, carlo@endlessm.com, linux-clk@vger.kernel.org
Subject: Re: [PATCH v2 0/3] r8169 (x86) clk fixes to fix S0ix not being
 reached
From: David Miller <davem@davemloft.net>
In-Reply-To: <20180912093456.23400-1-hdegoede@redhat.com>
References: <20180912093456.23400-1-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>
Date: Wed, 12 Sep 2018 11:34:53 +0200

> This series adds code to the r8169 ethernet driver to get and enable an
> external clock if present, avoiding the need for a hack in the
> clk-pmc-atom driver where that clock was left on continuesly causing x86
> some devices to not reach deep power saving states (S0ix) when suspended
> causing to them to quickly drain their battery while suspended.
> 
> The 3 commits in this series need to be merged in order to avoid
> regressions while bisecting. The clk-pmc-atom driver does not see much
> changes (it was last touched over a year ago). So the clk maintainers
> have agreed with merging all 3 patches through the net tree.
> All 3 patches have Stephen Boyd's Acked-by for this purpose.
> 
> This v2 of the series only had some minor tweaks done to the commit
> messages and is ready for merging through the net tree now.

Thanks for all of that useful information.

Series applied, thanks.
