Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41558 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3GBWm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 18:42:27 -0400
From: greearb@candelatech.com
To: ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Fix crash when using v1 hardware.
Date: Tue,  2 Jul 2013 15:42:05 -0700
Message-Id: <1372804925-1701-1-git-send-email-greearb@candelatech.com> (sfid-20130703_004305_170746_A551C984)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I put a v1 NIC from an TP-LINK AC 1750 AP in
a 64-bit PC, and the OS crashes on bootup.  I'm not
sure how broken my hardware is (possibly completely non
functional), but at least with this patch it will no longer
crash the OS.  Not sure it ever got far enough to try,
but I also do not have firmware for the NIC.

With this patch I get this info on module load:

ath10k_pci 0000:05:00.0: BAR 0: assigned [mem 0xf4400000-0xf45fffff 64bit]
ath10k_pci 0000:05:00.0: BAR 0: error updating (0xf4400004 != 0xffffffff)
ath10k_pci 0000:05:00.0: BAR 0: error updating (high 0x000000 != 0xffffffff)
ath10k_pci 0000:05:00.0: Refused to change power state, currently in D3
ath10k: MSI-X interrupt handling (8 intrs)
ath10k: Unable to wakeup target
ath10k: target takes too long to wake up (awake count 1)
ath10k: src_ring ffff88020c0d0a00:  write_index is out of bounds: 4294967295  nentries_mask: 15.
ath10k: dest_ring ffff88020db2c000:  write_index is out of bounds: 4294967295  nentries_mask: 511.
ath10k: dest_ring ffff880210d56400:  write_index is out of bounds: 4294967295  nentries_mask: 31.
ath10k: src_ring ffff880210d57600:  write_index is out of bounds: 4294967295  nentries_mask: 31.
ath10k: src_ring ffff88020fe70000:  write_index is out of bounds: 4294967295  nentries_mask: 2047.
ath10k: src_ring ffff880212989b40:  write_index is out of bounds: 4294967295  nentries_mask: 1.
ath10k: dest_ring ffff880212989960:  write_index is out of bounds: 4294967295  nentries_mask: 1.
ath10k: Failed to get pcie state addr: -5
ath10k: early firmware event indicated
------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath10k/ce.c:771 ath10k_ce_per_engine_service+0x53/0x1b4 [ath10k_pci]()
....
(it hits the warning case about 5-6 times and then seems to quiesce OK).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/ce.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 61a8ac7..56669f8 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -756,13 +756,23 @@ void ath10k_ce_per_engine_service(struct ath10k *ar, unsigned int ce_id)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ce_state *ce_state = ar_pci->ce_id_to_state[ce_id];
-	u32 ctrl_addr = ce_state->ctrl_addr;
+	u32 ctrl_addr;
 	void *transfer_context;
 	u32 buf;
 	unsigned int nbytes;
 	unsigned int id;
 	unsigned int flags;
 
+	/* On v1 hardware at least, setup can fail, causing ce_id_state to
+	 * be cleaned up, but this method is still called a few times.  Check
+	 * for NULL here so we don't crash.  Probably a better fix is to stop
+	 * the ath10k_pci_ce_tasklet sooner.
+	 */
+	if (WARN_ONCE(!ce_state, "ce_id_to_state[%i] is NULL\n", ce_id))
+		return;
+
+	ctrl_addr = ce_state->ctrl_addr;
+
 	ath10k_pci_wake(ar);
 	spin_lock_bh(&ar_pci->ce_lock);
 
@@ -954,6 +964,16 @@ static int ath10k_ce_init_src_ring(struct ath10k *ar,
 
 	src_ring->write_index =
 		ath10k_ce_src_ring_write_index_get(ar, ctrl_addr);
+	/* Make sure the value above is sane.  Can get 0xFFFFFFFF
+	 * on a v1 board.
+	 */
+	if (src_ring->write_index > src_ring->nentries_mask) {
+		ath10k_err("src_ring %p:  write_index is out of bounds: %u  nentries_mask: %u.\n",
+			   src_ring, src_ring->write_index,
+			   src_ring->nentries_mask);
+		src_ring->write_index = 0;
+	}
+
 	ath10k_pci_sleep(ar);
 
 	src_ring->per_transfer_context = (void **)ptr;
@@ -1037,6 +1057,16 @@ static int ath10k_ce_init_dest_ring(struct ath10k *ar,
 	dest_ring->sw_index = ath10k_ce_dest_ring_read_index_get(ar, ctrl_addr);
 	dest_ring->write_index =
 		ath10k_ce_dest_ring_write_index_get(ar, ctrl_addr);
+	/* Make sure the value above is sane.  Can get 0xFFFFFFFF
+	 * on a v1 board.
+	 */
+	if (dest_ring->write_index > dest_ring->nentries_mask) {
+		ath10k_err("dest_ring %p:  write_index is out of bounds: %u  nentries_mask: %u.\n",
+			   dest_ring, dest_ring->write_index,
+			   dest_ring->nentries_mask);
+		dest_ring->write_index = 0;
+	}
+
 	ath10k_pci_sleep(ar);
 
 	dest_ring->per_transfer_context = (void **)ptr;
-- 
1.7.3.4

