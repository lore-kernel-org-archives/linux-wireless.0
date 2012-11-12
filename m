Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:53888 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab2KLV6v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:58:51 -0500
Received: by mail-ea0-f174.google.com with SMTP id o11so438703eaa.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:58:49 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 01/17] Removed dead functions
Date: Mon, 12 Nov 2012 23:58:15 +0200
Message-Id: <1352757511-26957-2-git-send-email-maxtram95@gmail.com> (sfid-20121112_225854_263558_4AA14A22)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180_core.c      |  185 -----------------------------------------------------
 r8180_rtl8225z2.c |   16 -----
 2 files changed, 201 deletions(-)

diff --git a/r8180_core.c b/r8180_core.c
index fd22b75..29c44c9 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -695,14 +695,6 @@ void rtl8180_RSSI_calc(struct net_device *dev, u8 *rssi, u8 *qual)
 	return;
 }
 
-void rtl8180_irq_enable(struct net_device *dev)
-{
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-
-	priv->irq_enabled = 1;
-	write_nic_word(dev, INTA_MASK, priv->irq_mask);
-}
-
 void rtl8180_irq_disable(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -724,7 +716,6 @@ void rtl8180_set_mode(struct net_device *dev, int mode)
 	write_nic_byte(dev, EPROM_CMD, ecmd);
 }
 
-void rtl8180_adapter_start(struct net_device *dev);
 void rtl8180_beacon_tx_enable(struct net_device *dev);
 
 void rtl8180_update_msr(struct net_device *dev)
@@ -771,57 +762,6 @@ void rtl8180_set_chan(struct net_device *dev, short ch)
 	priv->rf_set_chan(dev, priv->chan);
 }
 
-void rtl8180_rx_enable(struct net_device *dev)
-{
-	u8 cmd;
-	u32 rxconf;
-	/* for now we accept data, management & ctl frame*/
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-
-	rxconf = read_nic_dword(dev, RX_CONF);
-	rxconf = rxconf & ~MAC_FILTER_MASK;
-	rxconf = rxconf | (1<<ACCEPT_MNG_FRAME_SHIFT);
-	rxconf = rxconf | (1<<ACCEPT_DATA_FRAME_SHIFT);
-	rxconf = rxconf | (1<<ACCEPT_BCAST_FRAME_SHIFT);
-	rxconf = rxconf | (1<<ACCEPT_MCAST_FRAME_SHIFT);
-	if (dev->flags & IFF_PROMISC)
-		DMESG("NIC in promisc mode");
-
-	if (priv->ieee80211->iw_mode == IW_MODE_MONITOR || \
-	   dev->flags & IFF_PROMISC) {
-		rxconf = rxconf | (1<<ACCEPT_ALLMAC_FRAME_SHIFT);
-	} else {
-		rxconf = rxconf | (1<<ACCEPT_NICMAC_FRAME_SHIFT);
-	}
-
-	if (priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
-		rxconf = rxconf | (1<<ACCEPT_CTL_FRAME_SHIFT);
-		rxconf = rxconf | (1<<ACCEPT_ICVERR_FRAME_SHIFT);
-		rxconf = rxconf | (1<<ACCEPT_PWR_FRAME_SHIFT);
-	}
-
-	if (priv->crcmon == 1 && priv->ieee80211->iw_mode == IW_MODE_MONITOR)
-		rxconf = rxconf | (1<<ACCEPT_CRCERR_FRAME_SHIFT);
-
-	rxconf = rxconf & ~RX_FIFO_THRESHOLD_MASK;
-	rxconf = rxconf | (RX_FIFO_THRESHOLD_NONE << RX_FIFO_THRESHOLD_SHIFT);
-
-	rxconf = rxconf | (1<<RX_AUTORESETPHY_SHIFT);
-	rxconf = rxconf & ~MAX_RX_DMA_MASK;
-	rxconf = rxconf | (MAX_RX_DMA_2048<<MAX_RX_DMA_SHIFT);
-
-	rxconf = rxconf | RCR_ONLYERLPKT;
-
-	rxconf = rxconf & ~RCR_CS_MASK;
-
-	write_nic_dword(dev, RX_CONF, rxconf);
-
-	fix_rx_fifo(dev);
-
-	cmd = read_nic_byte(dev, CMD);
-	write_nic_byte(dev, CMD, cmd | (1<<CMD_RX_ENABLE_SHIFT));
-}
-
 void set_nic_txring(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -855,60 +795,6 @@ void rtl8180_conttx_disable(struct net_device *dev)
 	write_nic_dword(dev, TX_CONF, txconf);
 }
 
-void rtl8180_tx_enable(struct net_device *dev)
-{
-	u8 cmd;
-	u8 tx_agc_ctl;
-	u8 byte;
-	u32 txconf;
-	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
-
-	txconf = read_nic_dword(dev, TX_CONF);
-
-	byte = read_nic_byte(dev, CW_CONF);
-	byte &= ~(1<<CW_CONF_PERPACKET_CW_SHIFT);
-	byte &= ~(1<<CW_CONF_PERPACKET_RETRY_SHIFT);
-	write_nic_byte(dev, CW_CONF, byte);
-
-	tx_agc_ctl = read_nic_byte(dev, TX_AGC_CTL);
-	tx_agc_ctl &= ~(1<<TX_AGC_CTL_PERPACKET_GAIN_SHIFT);
-	tx_agc_ctl &= ~(1<<TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT);
-	tx_agc_ctl |= (1<<TX_AGC_CTL_FEEDBACK_ANT);
-	write_nic_byte(dev, TX_AGC_CTL, tx_agc_ctl);
-	write_nic_byte(dev, 0xec, 0x3f); /* Disable early TX */
-
-	txconf = txconf & ~(1<<TCR_PROBE_NOTIMESTAMP_SHIFT);
-
-	txconf = txconf & ~TX_LOOPBACK_MASK;
-	txconf = txconf | (TX_LOOPBACK_NONE<<TX_LOOPBACK_SHIFT);
-	txconf = txconf & ~TCR_DPRETRY_MASK;
-	txconf = txconf & ~TCR_RTSRETRY_MASK;
-	txconf = txconf | (priv->retry_data<<TX_DPRETRY_SHIFT);
-	txconf = txconf | (priv->retry_rts<<TX_RTSRETRY_SHIFT);
-	txconf = txconf & ~(1<<TX_NOCRC_SHIFT);
-
-	if (priv->hw_plcp_len)
-		txconf = txconf & ~TCR_PLCP_LEN;
-	else
-		txconf = txconf | TCR_PLCP_LEN;
-
-	txconf = txconf & ~TCR_MXDMA_MASK;
-	txconf = txconf | (TCR_MXDMA_2048<<TCR_MXDMA_SHIFT);
-	txconf = txconf | TCR_CWMIN;
-	txconf = txconf | TCR_DISCW;
-
-	txconf = txconf | (1 << TX_NOICV_SHIFT);
-
-	write_nic_dword(dev, TX_CONF, txconf);
-
-	fix_tx_fifo(dev);
-
-	cmd = read_nic_byte(dev, CMD);
-	write_nic_byte(dev, CMD, cmd | (1<<CMD_TX_ENABLE_SHIFT));
-
-	write_nic_dword(dev, TX_CONF, txconf);
-}
-
 void rtl8180_beacon_tx_enable(struct net_device *dev)
 {
 	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
@@ -3107,77 +2993,6 @@ void rtl8185_set_rate(struct net_device *dev)
 	write_nic_word(dev, BRSR, word);
 }
 
-void rtl8180_adapter_start(struct net_device *dev)
-{
-	struct r8180_priv *priv = ieee80211_priv(dev);
-
-	rtl8180_rtx_disable(dev);
-	rtl8180_reset(dev);
-
-	/* enable beacon timeout, beacon TX ok and err
-	 * LP tx ok and err, HP TX ok and err, NP TX ok and err,
-	 * RX ok and ERR, and GP timer
-	 */
-	priv->irq_mask = 0x6fcf;
-
-	priv->dma_poll_mask = 0;
-
-	rtl8180_beacon_tx_disable(dev);
-
-	rtl8180_set_mode(dev, EPROM_CMD_CONFIG);
-	write_nic_dword(dev, MAC0, ((u32 *)dev->dev_addr)[0]);
-	write_nic_word(dev, MAC4, ((u32 *)dev->dev_addr)[1] & 0xffff);
-	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
-
-	rtl8180_update_msr(dev);
-
-	/* These might be unnecessary since we do in rx_enable / tx_enable */
-	fix_rx_fifo(dev);
-	fix_tx_fifo(dev);
-
-	rtl8180_set_mode(dev, EPROM_CMD_CONFIG);
-
-	/*
-	 * The following is very strange. seems to be that 1 means test mode,
-	 * but we need to acknowledges the nic when a packet is ready
-	 * although we set it to 0
-	 */
-
-	write_nic_byte(dev,
-		       CONFIG2, read_nic_byte(dev, CONFIG2) & ~\
-		       (1<<CONFIG2_DMA_POLLING_MODE_SHIFT));
-	/* ^the nic isn't in test mode */
-	write_nic_byte(dev,
-		       CONFIG2, read_nic_byte(dev, CONFIG2)|(1<<4));
-
-	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
-
-	write_nic_dword(dev, INT_TIMEOUT, 0);
-
-	write_nic_byte(dev, WPA_CONFIG, 0);
-
-	rtl8180_no_hw_wep(dev);
-
-	rtl8185_set_rate(dev);
-	write_nic_byte(dev, RATE_FALLBACK, 0x81);
-
-	write_nic_byte(dev, GP_ENABLE, read_nic_byte(dev, GP_ENABLE) & ~(1<<6));
-
-	/* FIXME cfg 3 ClkRun enable - isn't it ReadOnly ? */
-	rtl8180_set_mode(dev, EPROM_CMD_CONFIG);
-	write_nic_byte(dev, CONFIG3, read_nic_byte(dev, CONFIG3)
-		       | (1 << CONFIG3_CLKRUN_SHIFT));
-	rtl8180_set_mode(dev, EPROM_CMD_NORMAL);
-
-	priv->rf_init(dev);
-
-	if (priv->rf_set_sens != NULL)
-		priv->rf_set_sens(dev, priv->sens);
-	rtl8180_irq_enable(dev);
-
-	netif_start_queue(dev);
-}
-
 /*
  * This configures registers for beacon tx and enables it via
  * rtl8180_beacon_tx_enable(). rtl8180_beacon_tx_disable() might
diff --git a/r8180_rtl8225z2.c b/r8180_rtl8225z2.c
index d28c1d9..a369a3d 100644
--- a/r8180_rtl8225z2.c
+++ b/r8180_rtl8225z2.c
@@ -412,22 +412,6 @@ static u32 read_rtl8225(struct net_device *dev, u8 adr)
 	return dataRead;
 }
 
-short rtl8225_is_V_z2(struct net_device *dev)
-{
-	short vz2 = 1;
-
-	if (read_rtl8225(dev, 8) != 0x588)
-		vz2 = 0;
-	else	/* reg 9 pg 1 = 24 */
-		if (read_rtl8225(dev, 9) != 0x700)
-			vz2 = 0;
-
-	/* sw back to pg 0 */
-	write_rtl8225(dev, 0, 0xb7);
-
-	return vz2;
-}
-
 void rtl8225z2_rf_close(struct net_device *dev)
 {
 	RF_WriteReg(dev, 0x4, 0x1f);
-- 
1.7.10.4

