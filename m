Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:43907 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYEMBQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 21:16:51 -0400
Date: Mon, 12 May 2008 21:16:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: mcgrof@gmail.com, jirislaby@gmail.com,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k: Fix loop variable initializations
Message-ID: <20080513011644.GA23252@hash.localnet> (sfid-20080513_031654_845493_8B3CF467)
References: <E1JvZ2x-0005kb-TH@hash.localnet> <40f31dec0805121618j4a2f8bedw78e2ce36d8158649@mail.gmail.com> <20080513001726.GA23128@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080513001726.GA23128@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2008 at 08:17:26PM -0400, Bob Copeland wrote:
> On Tue, May 13, 2008 at 02:18:48AM +0300, Nick Kossifidis wrote:
> > Why not doing a simple
> > rxs.flag = 0 ;
> > or a check of flags set by mac80211 at the start of the loop ?

Here's an updated version:

In ath5k_tasklet_rx, both status structures 'rxs' and 'rs' are
initialized at the top of the tasklet, but not within the loop.
If the loop is executed multiple times in the tasklet then the
variables may see changes from previous packets.

For TKIP, this results in 'Invalid Michael MIC' errors if two packets
are processed in the tasklet: rxs.flag gets set to RX_DECRYPTED by
mac80211 when it decrypts the first encrypted packet.  The subsequent
packet will have RX_DECRYPTED set upon entry to mac80211, so mac80211
will not try to decrypt it.

We currently initialize all but two fields in the structures, so fix
the other two.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    2 ++
 drivers/net/wireless/ath5k/hw.c   |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4e5c8fc..635b9ac 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1787,6 +1787,8 @@ ath5k_tasklet_rx(unsigned long data)
 
 	spin_lock(&sc->rxbuflock);
 	do {
+		rxs.flag = 0;
+
 		if (unlikely(list_empty(&sc->rxbuf))) {
 			ATH5K_WARN(sc, "empty rx buf pool\n");
 			break;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 5fb1ae6..77990b5 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -4119,6 +4119,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5210_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	rs->rs_status = 0;
+	rs->rs_phyerr = 0;
 
 	/*
 	 * Key table status
@@ -4145,7 +4146,7 @@ static int ath5k_hw_proc_5210_rx_status(struct ath5k_hw *ah,
 		if (rx_status->rx_status_1 &
 				AR5K_5210_RX_DESC_STATUS1_PHY_ERROR) {
 			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr = AR5K_REG_MS(rx_status->rx_status_1,
+			rs->rs_phyerr |= AR5K_REG_MS(rx_status->rx_status_1,
 					   AR5K_5210_RX_DESC_STATUS1_PHY_ERROR);
 		}
 
@@ -4193,6 +4194,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 	rs->rs_tstamp = AR5K_REG_MS(rx_status->rx_status_1,
 		AR5K_5212_RX_DESC_STATUS1_RECEIVE_TIMESTAMP);
 	rs->rs_status = 0;
+	rs->rs_phyerr = 0;
 
 	/*
 	 * Key table status
@@ -4215,7 +4217,7 @@ static int ath5k_hw_proc_5212_rx_status(struct ath5k_hw *ah,
 		if (rx_status->rx_status_1 &
 				AR5K_5212_RX_DESC_STATUS1_PHY_ERROR) {
 			rs->rs_status |= AR5K_RXERR_PHY;
-			rs->rs_phyerr = AR5K_REG_MS(rx_err->rx_error_1,
+			rs->rs_phyerr |= AR5K_REG_MS(rx_err->rx_error_1,
 					   AR5K_RX_DESC_ERROR1_PHY_ERROR_CODE);
 		}
 
-- 
1.5.4.2.182.gb3092


-- 
Bob Copeland %% www.bobcopeland.com 

