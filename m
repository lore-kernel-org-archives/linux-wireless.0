Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:35948 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756570AbdGYBOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Jul 2017 21:14:12 -0400
Received: by mail-pf0-f177.google.com with SMTP id z129so13493132pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jul 2017 18:14:11 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 00/20] mwifiex: "reset" bugfixes and other refactorings
Date: Mon, 24 Jul 2017 18:13:16 -0700
Message-Id: <20170725011336.99993-1-briannorris@chromium.org> (sfid-20170725_031425_656837_B36320E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I've previously sent a stack of similar patches (with no cover letter),
starting at this patch:

[PATCH 01/14] mwifiex: pcie: properly synchronize, disable interrupts in driver callbacks
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1405062.html
https://patchwork.kernel.org/patch/9747263/

They fixed several bugs related to the "reset" codepath in this driver,
in which the driver tries to recover from a dead firmware, as well as making
various code improvements (e.g., refactorings, removing redunancy, improving
safety).

There were some valid criticisms of the first patch in that series (and some
real issues I hit with it later on in testing), and in the end, I believe
the concern there was not actually appearing in practice, so in order to
make some forward progress, I've dropped that patch (and related changes)
from this series. I've kept most of the rest and added a few bugfixes along
the way.

Thanks to Johannes for some brainstorming/ideas that yielded the patch
"mwifiex: unregister wiphy before freeing resources".

Regards,
Brian

Brian Norris (20):
  mwifiex: reunite copy-and-pasted remove/reset code
  mwifiex: reset interrupt status across device reset
  mwifiex: pcie: don't allow cmd buffer reuse after reset
  mwifiex: re-register wiphy across reset
  mwifiex: unregister wiphy before freeing resources
  mwifiex: don't short-circuit netdev notifiers on interface deletion
  mwifiex: fixup init_channel_scan_gap error case
  mwifiex: ensure "disable auto DS" struct is initialized
  mwifiex: fix misnomers in mwifiex_free_lock_list()
  mwifiex: make mwifiex_free_cmd_buffer() return void
  mwifiex: utilize netif_tx_{wake,stop}_all_queues()
  mwifiex: don't open-code ARRAY_SIZE()
  mwifiex: drop 'add_tail' param from mwifiex_insert_cmd_to_pending_q()
  mwifiex: pcie: remove unnecessary masks
  mwifiex: pcie: unify MSI-X / non-MSI-X interrupt process
  mwifiex: debugfs: allow card_reset() to cancel things
  mwifiex: pcie: disable device DMA before unmapping/freeing buffers
  mwifiex: pcie: remove unnecessary 'pdev' check
  mwifiex: keep mwifiex_cancel_pending_ioctl() static
  mwifiex: drop num CPU notice

 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   4 -
 drivers/net/wireless/marvell/mwifiex/cfp.c         |   4 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |  15 +--
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |   2 -
 drivers/net/wireless/marvell/mwifiex/init.c        |  32 ++----
 drivers/net/wireless/marvell/mwifiex/main.c        | 124 +++++++--------------
 drivers/net/wireless/marvell/mwifiex/main.h        |   7 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        | 100 +++--------------
 drivers/net/wireless/marvell/mwifiex/scan.c        |   5 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   8 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   5 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |   6 +-
 12 files changed, 87 insertions(+), 225 deletions(-)

-- 
2.14.0.rc0.284.gd933b75aa4-goog
