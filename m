Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55439 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076Ab2CNPkp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:45 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 05/14] ath9k: optimize register access functions
Date: Wed, 14 Mar 2012 16:40:25 +0100
Message-Id: <1331739634-22318-5-git-send-email-nbd@openwrt.org> (sfid-20120314_164056_369494_0D0CA068)
In-Reply-To: <1331739634-22318-4-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By checking for NR_CPUS, the compiler can optimize out register access
serialization code on non-SMP kernels

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c   |    2 +-
 drivers/net/wireless/ath/ath9k/init.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6d9f43f..c55157a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -556,7 +556,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EIO;
 	}
 
-	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
+	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
 		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
 		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
 		     !ah->is_pciexpress)) {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2d3ad0c..ecd2d58 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -172,7 +172,7 @@ static void ath9k_iowrite32(void *hw_priv, u32 val, u32 reg_offset)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_ON) {
 		unsigned long flags;
 		spin_lock_irqsave(&sc->sc_serial_rw, flags);
 		iowrite32(val, sc->mem + reg_offset);
@@ -188,7 +188,7 @@ static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	u32 val;
 
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_ON) {
 		unsigned long flags;
 		spin_lock_irqsave(&sc->sc_serial_rw, flags);
 		val = ioread32(sc->mem + reg_offset);
@@ -219,7 +219,7 @@ static unsigned int ath9k_reg_rmw(void *hw_priv, u32 reg_offset, u32 set, u32 cl
 	unsigned long uninitialized_var(flags);
 	u32 val;
 
-	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
+	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_ON) {
 		spin_lock_irqsave(&sc->sc_serial_rw, flags);
 		val = __ath9k_reg_rmw(sc, reg_offset, set, clr);
 		spin_unlock_irqrestore(&sc->sc_serial_rw, flags);
-- 
1.7.3.2

