Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49658 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2KLV7P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 16:59:15 -0500
Received: by mail-ee0-f46.google.com with SMTP id b15so3644080eek.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 13:59:14 -0800 (PST)
From: Maxim Mikityanskiy <maxtram95@gmail.com>
To: greg@kroah.com, linux-wireless@vger.kernel.org
Cc: Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH 15/17] Removed unused fields in r8180_priv
Date: Mon, 12 Nov 2012 23:58:29 +0200
Message-Id: <1352757511-26957-16-git-send-email-maxtram95@gmail.com> (sfid-20121112_231525_917647_EA02ED9B)
In-Reply-To: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
References: <1352757511-26957-1-git-send-email-maxtram95@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 r8180.h       |   10 ----------
 r8180_core.c  |   49 +++----------------------------------------------
 r8185b_init.c |    6 ++----
 3 files changed, 5 insertions(+), 60 deletions(-)

diff --git a/r8180.h b/r8180.h
index a819b01..1db8257 100644
--- a/r8180.h
+++ b/r8180.h
@@ -327,12 +327,8 @@ typedef struct r8180_priv
 	int irq;
 	struct ieee80211_device *ieee80211;
 
-	short phy_ver; /* meaningful for rtl8225 1:A 2:B 3:C */
-	short enable_gpio0;
-	short hw_plcp_len;
 	short plcp_preamble_mode; // 0:auto 1:short 2:long
 
-	spinlock_t irq_lock;
 	spinlock_t irq_th_lock;
 	spinlock_t tx_lock;
 	spinlock_t ps_lock;
@@ -350,7 +346,6 @@ typedef struct r8180_priv
 	u8 channel_plan;  // it's the channel plan index
 	short up;
 	short crcmon; //if 1 allow bad crc frame reception in monitor mode
-	short prism_hdr;
 
 	struct timer_list scan_timer;
 	/*short scanpending;
@@ -359,7 +354,6 @@ typedef struct r8180_priv
 	u8 active_probe;
 	//u8 active_scan_num;
 	struct semaphore wx_sem;
-	struct semaphore rf_state;
 	short hw_wep;
 
 	short digphy;
@@ -489,7 +483,6 @@ typedef struct r8180_priv
 	RT_RF_POWER_STATE eRFPowerState;
 	u32 RfOffReason;
 	bool RFChangeInProgress;
-	bool bInHctTest;
 	bool SetRFPowerStateInProgress;
 	u8   RFProgType;
 	bool bLeisurePs;
@@ -616,15 +609,12 @@ typedef struct r8180_priv
 //	struct workqueue_struct *workqueue;
 	struct work_struct reset_wq;
 	struct work_struct watch_dog_wq;
-	struct work_struct tx_irq_wq;
 	short ack_tx_to_ieee;
 
 	u8 PowerProfile;
-	u32 CSMethod;
 	u8 dma_poll_stop_mask;
 
 	//u8 RegThreeWireMode;
-	u8 MWIEnable;
 	u16 ShortRetryLimit;
 	u16 LongRetryLimit;
 	u16 EarlyRxThreshold;
diff --git a/r8180_core.c b/r8180_core.c
index 70373e9..1202332 100644
--- a/r8180_core.c
+++ b/r8180_core.c
@@ -1437,14 +1437,9 @@ void rtl8180_rx(struct net_device *dev)
 				dev_kfree_skb_any(priv->rx_skb);
 				priv->stats.rxnolast++;
 			}
-			/* support for prism header has been originally added by Christian */
-			if (priv->prism_hdr && priv->ieee80211->iw_mode == IW_MODE_MONITOR) {
-
-			} else {
-				priv->rx_skb = dev_alloc_skb(len+2);
-				if (!priv->rx_skb)
-					goto drop;
-			}
+			priv->rx_skb = dev_alloc_skb(len+2);
+			if (!priv->rx_skb)
+				goto drop;
 
 			priv->rx_skb_complete = 0;
 			priv->rx_skb->dev = dev;
@@ -1717,8 +1712,6 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 	int remain;
 	int buflen;
 	int count;
-	u16 duration;
-	short ext;
 	struct buffer *buflist;
 	struct ieee80211_hdr_3addr *frag_hdr = (struct ieee80211_hdr_3addr *)txbuf;
 	u8 dest[ETH_ALEN];
@@ -1914,15 +1907,6 @@ short rtl8180_tx(struct net_device *dev, u8* txbuf, int len, int priority,
 
 		*tail = *tail | ((rate&0xf) << 24);
 
-		/* hw_plcp_len is not used for rtl8180 chip */
-		/* FIXME */
-		if (!priv->hw_plcp_len) {
-			duration = rtl8180_len2duration(len, rate, &ext);
-			*(tail+1) = *(tail+1) | ((duration & 0x7fff)<<16);
-			if (ext)
-				*(tail+1) = *(tail+1) | (1<<31); /* plcp length extension */
-		}
-
 		if (morefrag)
 			*tail = (*tail) | (1<<17); /* more fragment */
 		if (!remain)
@@ -2219,7 +2203,6 @@ void rtl8180_wmm_param_update(struct work_struct *work)
 	}
 }
 
-void rtl8180_tx_irq_wq(struct work_struct *work);
 void rtl8180_restart_wq(struct work_struct *work);
 /* void rtl8180_rq_tx_ack(struct work_struct *work); */
 void rtl8180_watch_dog_wq(struct work_struct *work);
@@ -2408,7 +2391,6 @@ short rtl8180_init(struct net_device *dev)
 	priv->RFChangeInProgress = false;
 	priv->SetRFPowerStateInProgress = false;
 	priv->RFProgType = 0;
-	priv->bInHctTest = false;
 
 	priv->irq_enabled = 0;
 
@@ -2432,14 +2414,12 @@ short rtl8180_init(struct net_device *dev)
 	priv->ieee80211->ps_is_queue_empty = rtl8180_is_tx_queue_empty;
 
 	priv->hw_wep = hwwep;
-	priv->prism_hdr = 0;
 	priv->dev = dev;
 	priv->retry_rts = DEFAULT_RETRY_RTS;
 	priv->retry_data = DEFAULT_RETRY_DATA;
 	priv->RFChangeInProgress = false;
 	priv->SetRFPowerStateInProgress = false;
 	priv->RFProgType = 0;
-	priv->bInHctTest = false;
 	priv->bInactivePs = true; /* false; */
 	priv->ieee80211->bInactivePs = priv->bInactivePs;
 	priv->bSwRfProcessing = false;
@@ -2522,15 +2502,12 @@ short rtl8180_init(struct net_device *dev)
 	priv->RegBModeGainStage = 1;
 
 	priv->promisc = (dev->flags & IFF_PROMISC) ? 1 : 0;
-	spin_lock_init(&priv->irq_lock);
 	spin_lock_init(&priv->irq_th_lock);
 	spin_lock_init(&priv->tx_lock);
 	spin_lock_init(&priv->ps_lock);
 	spin_lock_init(&priv->rf_ps_lock);
 	sema_init(&priv->wx_sem, 1);
-	sema_init(&priv->rf_state, 1);
 	INIT_WORK(&priv->reset_wq, (void *)rtl8180_restart_wq);
-	INIT_WORK(&priv->tx_irq_wq, (void *)rtl8180_tx_irq_wq);
 	INIT_DELAYED_WORK(&priv->ieee80211->hw_wakeup_wq,
 			  (void *)rtl8180_hw_wakeup_wq);
 	INIT_DELAYED_WORK(&priv->ieee80211->hw_sleep_wq,
@@ -2572,14 +2549,10 @@ short rtl8180_init(struct net_device *dev)
 	priv->ieee80211->stop_send_beacons = rtl8180_beacon_tx_disable;
 	priv->ieee80211->fts = DEFAULT_FRAG_THRESHOLD;
 
-	priv->MWIEnable = 0;
-
 	priv->ShortRetryLimit = 7;
 	priv->LongRetryLimit = 7;
 	priv->EarlyRxThreshold = 7;
 
-	priv->CSMethod = (0x01 << 29);
-
 	priv->TransmitConfig =	(1<<TCR_DurProcMode_OFFSET) |
 				(7<<TCR_MXDMA_OFFSET) |
 				(priv->ShortRetryLimit<<TCR_SRL_OFFSET) |
@@ -2605,14 +2578,10 @@ short rtl8180_init(struct net_device *dev)
 	priv->InitialGain = 6;
 
 	DMESG("MAC controller is a RTL8187SE b/g");
-	priv->phy_ver = 2;
 
 	priv->ieee80211->modulation |= IEEE80211_OFDM_MODULATION;
 	priv->ieee80211->short_slot = 1;
 
-	/* just for sync 85 */
-	priv->enable_gpio0 = 0;
-
 	eeprom_93cx6_read(&eeprom, EEPROM_SW_REVD_OFFSET, &usValue);
 	DMESG("usValue is %#hx\n", usValue);
 	/* 3Read AntennaDiversity */
@@ -2639,9 +2608,6 @@ short rtl8180_init(struct net_device *dev)
 		/* 1: main, 2: aux. */
 		priv->bDefaultAntenna1 = priv->RegDefaultAntenna == 2;
 
-	/* rtl8185 can calc plcp len in HW. */
-	priv->hw_plcp_len = 1;
-
 	priv->plcp_preamble_mode = 2;
 	/* the eeprom type is stored in RCR register bit #6 */
 	if (RCR_9356SEL & read_nic_dword(dev, RCR))
@@ -3594,15 +3560,6 @@ void rtl8180_tx_isr(struct net_device *dev, int pri, short error)
 	spin_unlock_irqrestore(&priv->tx_lock, flag);
 }
 
-void rtl8180_tx_irq_wq(struct work_struct *work)
-{
-	struct delayed_work *dwork = to_delayed_work(work);
-	struct ieee80211_device * ieee = (struct ieee80211_device *)
-		container_of(dwork, struct ieee80211_device, watch_dog_wq);
-	struct net_device *dev = ieee->dev;
-
-	rtl8180_tx_isr(dev, MANAGE_PRIORITY, 0);
-}
 irqreturn_t rtl8180_interrupt(int irq, void *netdev, struct pt_regs *regs)
 {
 	struct net_device *dev = (struct net_device *) netdev;
diff --git a/r8185b_init.c b/r8185b_init.c
index 52e6802..0b3ffd7 100644
--- a/r8185b_init.c
+++ b/r8185b_init.c
@@ -1230,11 +1230,9 @@ bool MgntActSet_RF_State(struct net_device *dev, RT_RF_POWER_STATE StateToSet, u
 			priv->RfOffReason = 0;
 			bActionAllowed = true;
 
-			if (rtState == eRfOff && ChangeSource >= RF_CHANGE_BY_HW && !priv->bInHctTest)
+			if (rtState == eRfOff && ChangeSource >= RF_CHANGE_BY_HW)
 				bConnectBySSID = true;
-
-		} else
-			;
+		}
 		break;
 
 	case eRfOff:
-- 
1.7.10.4

