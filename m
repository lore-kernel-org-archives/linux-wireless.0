Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:44998 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936850AbeE2SGJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 14:06:09 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [RFTv3 0/6] Runtime PM support for wlcore
Date: Tue, 29 May 2018 11:05:59 -0700
Message-Id: <20180529180605.73622-1-tony@atomide.com> (sfid-20180529_200649_947065_CB2E4A6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Here's the third version of wlcore runtime PM changes. Things
seem to be working for me just fine now after few fixes listed
below. Please do test again though, and then I'll post this
series and one more patch after v4.18-rc1 to enable runtime PM
autosuspend support. So hopefully we can have these merged early
on for v4.19.

For testing, please make sure you have also applied patch
"[PATCHv2] wlcore: sdio: Fix flakey SDIO runtime PM handling"
to avoid bogus errors.

Regards,

Tony

Changes since v2:

- Add fix "wclore: Fix timout errors after recovery" that is not needed
  before runtime PM conversion

- Add fix from Eyal for "wlcore: Use generic runtime pm calls for wowlan
  elp configuration" that is also not needed before runtime PM conversion

- Return early from wlcore_runtime_resume() on ELP timeout to avoid
  clearing WL1271_FLAG_IN_ELP bit

- Tag as RFT as we still need to do more testing and add runtime PM
  autosuspend support before merging

- Drop "wlcore: sdio: Warn about runtime PM suspend errors" that should
  no longer be needed

Changes since v1:

- Fix issues reported by Eyal for recovery

- Add few patches for enable/disable issues found when using runtime PM

- Remove unused ps.h includes


Eyal Reizer (1):
  wlcore: Use generic runtime pm calls for wowlan elp configuration

Tony Lindgren (5):
  wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()
  wlcore: Make sure PM calls are paired
  wlcore: Add support for runtime PM
  wlcore: Fix misplaced PM call for scan_complete_work()
  wclore: Fix timout errors after recovery

 drivers/net/wireless/ti/wl18xx/debugfs.c    |  26 +-
 drivers/net/wireless/ti/wlcore/acx.c        |   1 -
 drivers/net/wireless/ti/wlcore/cmd.c        |   9 +
 drivers/net/wireless/ti/wlcore/debugfs.c    |  79 ++--
 drivers/net/wireless/ti/wlcore/main.c       | 464 +++++++++++++-------
 drivers/net/wireless/ti/wlcore/ps.c         | 146 ------
 drivers/net/wireless/ti/wlcore/ps.h         |   3 -
 drivers/net/wireless/ti/wlcore/scan.c       |  12 +-
 drivers/net/wireless/ti/wlcore/sysfs.c      |  12 +-
 drivers/net/wireless/ti/wlcore/testmode.c   |  18 +-
 drivers/net/wireless/ti/wlcore/tx.c         |   9 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c |  27 +-
 drivers/net/wireless/ti/wlcore/wlcore.h     |   1 -
 drivers/net/wireless/ti/wlcore/wlcore_i.h   |   1 -
 14 files changed, 436 insertions(+), 372 deletions(-)

-- 
2.17.0
