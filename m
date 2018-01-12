Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35464 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965287AbeALVIo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 16:08:44 -0500
Received: by mail-pg0-f65.google.com with SMTP id d6so5356691pgv.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jan 2018 13:08:44 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Ganapathi Bhat <gbhat@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Ellie Reeves <ellierevves@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        James Cao <jcao@marvell.com>,
        Brian Norris <briannorris@chromium.org>,
        stable@vger.kernel.org, Xinming Hu <huxm@marvell.com>
Subject: [PATCH 2/2] mwifiex: resolve reset vs. remove()/shutdown() deadlocks
Date: Fri, 12 Jan 2018 13:08:37 -0800
Message-Id: <20180112210837.112628-2-briannorris@chromium.org> (sfid-20180112_221003_822420_677558DC)
In-Reply-To: <20180112210837.112628-1-briannorris@chromium.org>
References: <20180112210837.112628-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit b014e96d1abb ("PCI: Protect pci_error_handlers->reset_notify()
usage with device_lock()") resolves races between driver reset and
removal, but it introduces some new deadlock problems. If we see a
timeout while we've already started suspending, removing, or shutting
down the driver, we might see:

(a) a worker thread, running mwifiex_pcie_work() ->
    mwifiex_pcie_card_reset_work() -> pci_reset_function()
(b) a removal thread, running mwifiex_pcie_remove() ->
    mwifiex_free_adapter() -> mwifiex_unregister() ->
    mwifiex_cleanup_pcie() -> cancel_work_sync(&card->work)

Unfortunately, mwifiex_pcie_remove() already holds the device lock that
pci_reset_function() is now requesting, and so we see a deadlock.

It's necessary to cancel and synchronize our outstanding work before
tearing down the driver, so we can't have this work wait indefinitely
for the lock.

It's reasonable to only "try" to reset here, since this will mostly
happen for cases where it's already difficult to reset the firmware
anyway (e.g., while we're suspending or powering off the system). And if
reset *really* needs to happen, we can always try again later.

Fixes: b014e96d1abb ("PCI: Protect pci_error_handlers->reset_notify() usage with device_lock()")
Cc: <stable@vger.kernel.org>
Cc: Xinming Hu <huxm@marvell.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index f666cb2ea7e0..97a6199692ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2786,7 +2786,10 @@ static void mwifiex_pcie_card_reset_work(struct mwifiex_adapter *adapter)
 {
 	struct pcie_service_card *card = adapter->card;
 
-	pci_reset_function(card->dev);
+	/* We can't afford to wait here; remove() might be waiting on us. If we
+	 * can't grab the device lock, maybe we'll get another chance later.
+	 */
+	pci_try_reset_function(card->dev);
 }
 
 static void mwifiex_pcie_work(struct work_struct *work)
-- 
2.16.0.rc1.238.g530d649a79-goog
