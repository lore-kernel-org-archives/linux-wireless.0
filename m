Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33122 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbcJXR5H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 13:57:07 -0400
Received: by mail-pf0-f173.google.com with SMTP id 128so103184065pfz.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 10:57:06 -0700 (PDT)
From: Rajat Jain <rajatja@google.com>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Xinming Hu <huxm@marvell.com>
Cc: Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@google.com>, rajatxjain@gmail.com
Subject: [PATCH 0/3] mwifiex: Make WoWLAN a common feature
Date: Mon, 24 Oct 2016 10:56:50 -0700
Message-Id: <1477331813-42151-1-git-send-email-rajatja@google.com> (sfid-20161024_195711_153337_18890AB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a Marvell card on the PCIe bus that needs to support
WoWLAN (wake-on-wireless-LAN) feature. This is a feature offered
by the "core" mwifiex card and is not specific to an interface
(pcie/sdio/usb).

Currently the code to parse the WowLAN pin, and activate it
resides only in sdio.c [mostly commit ce4f6f0c353b ("mwifiex: add
platform specific wakeup interrupt support")]. I started by
copying all that code & data structures in pcie.c/pcie.h but then
realized that the we should probably have it common since the
feature is not interface specific.

Further, I noticed that interface driver had no interest in
device trees since there are no properties specific to interfaces.
Currently the only properties needed, are the common ones needed
by the core mwifiex.

This patch set thus introduces mwifiex_probe_of() to parse the
common properties, and then moves the WowLAN specific code to the
common module so that all the interfaces can use it. Essentially
this is a single logical patch that has been split up into
multiple patches only for the reason of simplicity and code
reviews.

This is currently rebased on the top of Linus' tree with the
following 2 patches applied:
https://patchwork.kernel.org/patch/9362275/
https://patchwork.kernel.org/patch/9390225/

Rajat Jain (3):
  mwifiex: Allow mwifiex early access to device structure
  mwifiex: Introduce mwifiex_probe_of() to parse common properties
  mwifiex: Enable WoWLAN for both sdio and pcie

 drivers/net/wireless/marvell/mwifiex/main.c    | 58 ++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/main.h    | 28 ++++++++-
 drivers/net/wireless/marvell/mwifiex/pcie.c    |  8 ++-
 drivers/net/wireless/marvell/mwifiex/sdio.c    | 79 +++-----------------------
 drivers/net/wireless/marvell/mwifiex/sdio.h    |  8 ---
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c |  5 +-
 drivers/net/wireless/marvell/mwifiex/usb.c     |  3 +-
 7 files changed, 99 insertions(+), 90 deletions(-)

-- 
2.8.0.rc3.226.g39d4020
