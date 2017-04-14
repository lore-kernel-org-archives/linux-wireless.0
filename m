Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35650 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755161AbdDNVvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 17:51:49 -0400
Received: by mail-pg0-f46.google.com with SMTP id 72so39469527pge.2
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2017 14:51:49 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 3/4] mwifiex: pcie: clear outstanding work when resetting
Date: Fri, 14 Apr 2017 14:51:19 -0700
Message-Id: <20170414215120.145038-3-briannorris@chromium.org> (sfid-20170414_235227_064153_88B50663)
In-Reply-To: <20170414215120.145038-1-briannorris@chromium.org>
References: <20170414215120.145038-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we shut down the device (i.e., during 'reset'), we cancel any
outstanding work, but we don't clear any work-related flags. This can
cause problems if, e.g., we begin to queue a new firmware dump or card
reset while the other one is in progress. That might leave work_flags
with a stale value, and we might begin one of these *after* we've
completely reset the device. That doesn't make sense, because all
firmware context will have been lost by then.

This fixes some forms of cascading failures, where I:

(a) force a firmware dump (cat /sys/kernel/debug/mwifiex/mlan0/device_dump)
(b) run a Wifi scan in parallel (iw mlan0 scan)
(c) the scan times out due to (a) hogging the interface
(d) the command timeout triggers another firmware dump and a reset [*]
(e) the 2nd firmware dump flag persists across the reset
(f) as soon as the interface comes back up, we trigger the pending
    firmware dump
(g) subsequent commands time out again, while we are processing the
    firmware dump; return to (d)

[*] Note that automatic card_reset() support is not yet implemented for
the mwifiex PCIe driver, so we won't hit *exactly* this behavior yet.
But we can see similarly-confusing behaviors today.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
This might qualify as 4.11 material (bugfix), though it's probably not too
widely triggered yet.

 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index 99e8a5cfda1b..bacac2949f10 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -371,6 +371,8 @@ static void mwifiex_pcie_reset_notify(struct pci_dev *pdev, bool prepare)
 		 */
 		mwifiex_shutdown_sw(adapter);
 		adapter->surprise_removed = true;
+		clear_bit(MWIFIEX_IFACE_WORK_DEVICE_DUMP, &card->work_flags);
+		clear_bit(MWIFIEX_IFACE_WORK_CARD_RESET, &card->work_flags);
 	} else {
 		/* Kernel stores and restores PCIe function context before and
 		 * after performing FLR respectively. Reconfigure the software
-- 
2.12.2.762.g0e3151a226-goog
