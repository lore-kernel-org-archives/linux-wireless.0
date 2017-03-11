Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:36051 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755440AbdCKBjb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 20:39:31 -0500
Received: by mail-pg0-f41.google.com with SMTP id g2so27469431pge.3
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 17:39:30 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 0/4] mwifiex: several bugfixes
Date: Fri, 10 Mar 2017 17:39:20 -0800
Message-Id: <20170311013924.73348-1-briannorris@chromium.org> (sfid-20170311_024038_519954_E409551E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been stressing a few aspects of this driver on 4.11-rc1, and I've noticed
several bugs. The first 3 are probably bugfix material for the current cycle
IMO, and the 4th is some more cleanup that matches the patterns introduced in
the 1st bugfix.

I have more patches coming sometime, but they're mostly just refactoring and
cleaning up things at the moment (no further bugfixes yet), so I thought I'd
send this stack out first.

Regards,
Brian

Brian Norris (4):
  mwifiex: pcie: don't leak DMA buffers when removing
  mwifiex: set adapter->dev before starting to use mwifiex_dbg()
  mwifiex: uninit wakeup info when removing device
  mwifiex: pcie: de-duplicate buffer allocation code

 drivers/net/wireless/marvell/mwifiex/main.c |  11 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c | 195 ++++++++++++----------------
 2 files changed, 92 insertions(+), 114 deletions(-)

-- 
2.12.0.246.ga2ecc84866-goog
