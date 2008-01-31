Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:38241 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760392AbYAaQdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 11:33:40 -0500
Date: Thu, 31 Jan 2008 10:59:01 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: ath5k: reset for 5424-based card
Message-ID: <20080131155901.GA7997@hash.localnet> (sfid-20080131_163344_023830_F9E7B80A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I have the following device (0x168c:001c) which comes with certain MacBooks:

02:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.11 b/g
Wireless PCI Express Adapter (rev 01)

The current driver from merged-upstream of a few days ago doesn't seem to 
work for this card.  In ath5k_hw_nic_wakeup, it dies after the nic reset
and any MMIO accesses from then on return -1 (needs a hard reboot to fix).

I dumped a trace of the working madwifi driver using mmio-trace and saw that
it only sets the bottom two bits when doing AR5K_RESET_CTL.  So, the patch 
below indeed makes probe work for the card.  

It isn't perfect after that; it can associate with an AP but appears to reset
constantly so it's not really usable.

I'd love to get this working generally; if needed I can try out patches,
supply traces, or, given enough direction, contribute some code...

diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 3a4bf40..3fa0621 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -359,7 +359,7 @@ static int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 	/* ...reset chipset and PCI device */
 	if (ah->ah_single_chip == false && ath5k_hw_nic_reset(ah,
-				AR5K_RESET_CTL_CHIP | AR5K_RESET_CTL_PCI)) {
+				AR5K_RESET_CTL_BASEBAND | AR5K_RESET_CTL_PCU)) {
 		ATH5K_ERR(ah->ah_sc, "failed to reset the MAC Chip + PCI\n");
 		return -EIO;
 	}

-- 
Bob Copeland %% www.bobcopeland.com 

