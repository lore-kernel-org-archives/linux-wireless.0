Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:64563 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756729AbZFRWWo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 18:22:44 -0400
Received: by mail-ew0-f210.google.com with SMTP id 6so1987323ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2009 15:22:46 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 19/23] orinoco: provide generic commit function
Date: Thu, 18 Jun 2009 23:21:31 +0100
Message-Id: <1245363695-8289-20-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows changes to be commited from cfg80211 functions.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c   |  227 ++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/hw.h   |    1 +
 drivers/net/wireless/orinoco/main.c |  297 ++++++++---------------------------
 drivers/net/wireless/orinoco/main.h |    3 +-
 drivers/net/wireless/orinoco/wext.c |   35 +----
 5 files changed, 294 insertions(+), 269 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index eaa89d3..56627d9 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -406,6 +406,233 @@ void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic)
 	*automatic = bitrate_table[ratemode].automatic;
 }
 
+int orinoco_hw_program_rids(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	hermes_t *hw = &priv->hw;
+	int err;
+	struct hermes_idstring idbuf;
+
+	/* Set the MAC address */
+	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
+			       HERMES_BYTES_TO_RECLEN(ETH_ALEN), dev->dev_addr);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting MAC address\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set up the link mode */
+	err = hermes_write_wordrec(hw, USER_BAP, HERMES_RID_CNFPORTTYPE,
+				   priv->port_type);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting port type\n",
+		       dev->name, err);
+		return err;
+	}
+	/* Set the channel/frequency */
+	if (priv->channel != 0 && priv->iw_mode != IW_MODE_INFRA) {
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFOWNCHANNEL,
+					   priv->channel);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting channel %d\n",
+			       dev->name, err, priv->channel);
+			return err;
+		}
+	}
+
+	if (priv->has_ibss) {
+		u16 createibss;
+
+		if ((strlen(priv->desired_essid) == 0) && (priv->createibss)) {
+			printk(KERN_WARNING "%s: This firmware requires an "
+			       "ESSID in IBSS-Ad-Hoc mode.\n", dev->name);
+			/* With wvlan_cs, in this case, we would crash.
+			 * hopefully, this driver will behave better...
+			 * Jean II */
+			createibss = 0;
+		} else {
+			createibss = priv->createibss;
+		}
+
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFCREATEIBSS,
+					   createibss);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting CREATEIBSS\n",
+			       dev->name, err);
+			return err;
+		}
+	}
+
+	/* Set the desired BSSID */
+	err = __orinoco_hw_set_wap(priv);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting AP address\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set the desired ESSID */
+	idbuf.len = cpu_to_le16(strlen(priv->desired_essid));
+	memcpy(&idbuf.val, priv->desired_essid, sizeof(idbuf.val));
+	/* WinXP wants partner to configure OWNSSID even in IBSS mode. (jimc) */
+	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNSSID,
+			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
+			&idbuf);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting OWNSSID\n",
+		       dev->name, err);
+		return err;
+	}
+	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
+			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
+			&idbuf);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting DESIREDSSID\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set the station name */
+	idbuf.len = cpu_to_le16(strlen(priv->nick));
+	memcpy(&idbuf.val, priv->nick, sizeof(idbuf.val));
+	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
+			       HERMES_BYTES_TO_RECLEN(strlen(priv->nick)+2),
+			       &idbuf);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting nickname\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set AP density */
+	if (priv->has_sensitivity) {
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFSYSTEMSCALE,
+					   priv->ap_density);
+		if (err) {
+			printk(KERN_WARNING "%s: Error %d setting SYSTEMSCALE. "
+			       "Disabling sensitivity control\n",
+			       dev->name, err);
+
+			priv->has_sensitivity = 0;
+		}
+	}
+
+	/* Set RTS threshold */
+	err = hermes_write_wordrec(hw, USER_BAP, HERMES_RID_CNFRTSTHRESHOLD,
+				   priv->rts_thresh);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting RTS threshold\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set fragmentation threshold or MWO robustness */
+	if (priv->has_mwo)
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFMWOROBUST_AGERE,
+					   priv->mwo_robust);
+	else
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
+					   priv->frag_thresh);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting fragmentation\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set bitrate */
+	err = __orinoco_hw_set_bitrate(priv);
+	if (err) {
+		printk(KERN_ERR "%s: Error %d setting bitrate\n",
+		       dev->name, err);
+		return err;
+	}
+
+	/* Set power management */
+	if (priv->has_pm) {
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFPMENABLED,
+					   priv->pm_on);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting up PM\n",
+			       dev->name, err);
+			return err;
+		}
+
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFMULTICASTRECEIVE,
+					   priv->pm_mcast);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting up PM\n",
+			       dev->name, err);
+			return err;
+		}
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFMAXSLEEPDURATION,
+					   priv->pm_period);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting up PM\n",
+			       dev->name, err);
+			return err;
+		}
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFPMHOLDOVERDURATION,
+					   priv->pm_timeout);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting up PM\n",
+			       dev->name, err);
+			return err;
+		}
+	}
+
+	/* Set preamble - only for Symbol so far... */
+	if (priv->has_preamble) {
+		err = hermes_write_wordrec(hw, USER_BAP,
+					   HERMES_RID_CNFPREAMBLE_SYMBOL,
+					   priv->preamble);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d setting preamble\n",
+			       dev->name, err);
+			return err;
+		}
+	}
+
+	/* Set up encryption */
+	if (priv->has_wep || priv->has_wpa) {
+		err = __orinoco_hw_setup_enc(priv);
+		if (err) {
+			printk(KERN_ERR "%s: Error %d activating encryption\n",
+			       dev->name, err);
+			return err;
+		}
+	}
+
+	if (priv->iw_mode == IW_MODE_MONITOR) {
+		/* Enable monitor mode */
+		dev->type = ARPHRD_IEEE80211;
+		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
+					    HERMES_TEST_MONITOR, 0, NULL);
+	} else {
+		/* Disable monitor mode */
+		dev->type = ARPHRD_ETHER;
+		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
+					    HERMES_TEST_STOP, 0, NULL);
+	}
+	if (err)
+		return err;
+
+	/* Reset promiscuity / multicast*/
+	priv->promiscuous = 0;
+	priv->mc_count = 0;
+
+	return 0;
+}
+
 /* Get tsc from the firmware */
 int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc)
 {
diff --git a/drivers/net/wireless/orinoco/hw.h b/drivers/net/wireless/orinoco/hw.h
index 84c108c..210c2b1 100644
--- a/drivers/net/wireless/orinoco/hw.h
+++ b/drivers/net/wireless/orinoco/hw.h
@@ -29,6 +29,7 @@ int orinoco_hw_allocate_fid(struct orinoco_private *priv);
 int orinoco_get_bitratemode(int bitrate, int automatic);
 void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic);
 
+int orinoco_hw_program_rids(struct orinoco_private *priv);
 int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc);
 int __orinoco_hw_set_bitrate(struct orinoco_private *priv);
 int orinoco_hw_get_act_bitrate(struct orinoco_private *priv, int *bitrate);
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 0727b41..dab6649 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -210,9 +210,10 @@ struct orinoco_rx_data {
 /* Function prototypes                                              */
 /********************************************************************/
 
-static void __orinoco_set_multicast_list(struct net_device *dev);
+static int __orinoco_set_multicast_list(struct net_device *dev);
 static int __orinoco_up(struct orinoco_private *priv);
 static int __orinoco_down(struct orinoco_private *priv);
+static int __orinoco_commit(struct orinoco_private *priv);
 
 /********************************************************************/
 /* Internal helper functions                                        */
@@ -1524,7 +1525,7 @@ static int __orinoco_up(struct orinoco_private *priv)
 
 	netif_carrier_off(dev); /* just to make sure */
 
-	err = __orinoco_program_rids(dev);
+	err = __orinoco_commit(priv);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d configuring card\n",
 		       dev->name, err);
@@ -1593,237 +1594,7 @@ static int orinoco_reinit_firmware(struct orinoco_private *priv)
 	return err;
 }
 
-int __orinoco_program_rids(struct net_device *dev)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
-	int err;
-	struct hermes_idstring idbuf;
-
-	/* Set the MAC address */
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNMACADDR,
-			       HERMES_BYTES_TO_RECLEN(ETH_ALEN), dev->dev_addr);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting MAC address\n",
-		       dev->name, err);
-		return err;
-	}
-
-	/* Set up the link mode */
-	err = hermes_write_wordrec(hw, USER_BAP, HERMES_RID_CNFPORTTYPE,
-				   priv->port_type);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting port type\n",
-		       dev->name, err);
-		return err;
-	}
-	/* Set the channel/frequency */
-	if (priv->channel != 0 && priv->iw_mode != IW_MODE_INFRA) {
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFOWNCHANNEL,
-					   priv->channel);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting channel %d\n",
-			       dev->name, err, priv->channel);
-			return err;
-		}
-	}
-
-	if (priv->has_ibss) {
-		u16 createibss;
-
-		if ((strlen(priv->desired_essid) == 0) && (priv->createibss)) {
-			printk(KERN_WARNING "%s: This firmware requires an "
-			       "ESSID in IBSS-Ad-Hoc mode.\n", dev->name);
-			/* With wvlan_cs, in this case, we would crash.
-			 * hopefully, this driver will behave better...
-			 * Jean II */
-			createibss = 0;
-		} else {
-			createibss = priv->createibss;
-		}
-
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFCREATEIBSS,
-					   createibss);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting CREATEIBSS\n",
-			       dev->name, err);
-			return err;
-		}
-	}
-
-	/* Set the desired BSSID */
-	err = __orinoco_hw_set_wap(priv);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting AP address\n",
-		       dev->name, err);
-		return err;
-	}
-	/* Set the desired ESSID */
-	idbuf.len = cpu_to_le16(strlen(priv->desired_essid));
-	memcpy(&idbuf.val, priv->desired_essid, sizeof(idbuf.val));
-	/* WinXP wants partner to configure OWNSSID even in IBSS mode. (jimc) */
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNSSID,
-			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
-			&idbuf);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting OWNSSID\n",
-		       dev->name, err);
-		return err;
-	}
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
-			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
-			&idbuf);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting DESIREDSSID\n",
-		       dev->name, err);
-		return err;
-	}
-
-	/* Set the station name */
-	idbuf.len = cpu_to_le16(strlen(priv->nick));
-	memcpy(&idbuf.val, priv->nick, sizeof(idbuf.val));
-	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNNAME,
-			       HERMES_BYTES_TO_RECLEN(strlen(priv->nick)+2),
-			       &idbuf);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting nickname\n",
-		       dev->name, err);
-		return err;
-	}
-
-	/* Set AP density */
-	if (priv->has_sensitivity) {
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFSYSTEMSCALE,
-					   priv->ap_density);
-		if (err) {
-			printk(KERN_WARNING "%s: Error %d setting SYSTEMSCALE. "
-			       "Disabling sensitivity control\n",
-			       dev->name, err);
-
-			priv->has_sensitivity = 0;
-		}
-	}
-
-	/* Set RTS threshold */
-	err = hermes_write_wordrec(hw, USER_BAP, HERMES_RID_CNFRTSTHRESHOLD,
-				   priv->rts_thresh);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting RTS threshold\n",
-		       dev->name, err);
-		return err;
-	}
-
-	/* Set fragmentation threshold or MWO robustness */
-	if (priv->has_mwo)
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFMWOROBUST_AGERE,
-					   priv->mwo_robust);
-	else
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
-					   priv->frag_thresh);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting fragmentation\n",
-		       dev->name, err);
-		return err;
-	}
-
-	/* Set bitrate */
-	err = __orinoco_hw_set_bitrate(priv);
-	if (err) {
-		printk(KERN_ERR "%s: Error %d setting bitrate\n",
-		       dev->name, err);
-		return err;
-	}
-
-	/* Set power management */
-	if (priv->has_pm) {
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFPMENABLED,
-					   priv->pm_on);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting up PM\n",
-			       dev->name, err);
-			return err;
-		}
-
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFMULTICASTRECEIVE,
-					   priv->pm_mcast);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting up PM\n",
-			       dev->name, err);
-			return err;
-		}
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFMAXSLEEPDURATION,
-					   priv->pm_period);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting up PM\n",
-			       dev->name, err);
-			return err;
-		}
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFPMHOLDOVERDURATION,
-					   priv->pm_timeout);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting up PM\n",
-			       dev->name, err);
-			return err;
-		}
-	}
-
-	/* Set preamble - only for Symbol so far... */
-	if (priv->has_preamble) {
-		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFPREAMBLE_SYMBOL,
-					   priv->preamble);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d setting preamble\n",
-			       dev->name, err);
-			return err;
-		}
-	}
-
-	/* Set up encryption */
-	if (priv->has_wep || priv->has_wpa) {
-		err = __orinoco_hw_setup_enc(priv);
-		if (err) {
-			printk(KERN_ERR "%s: Error %d activating encryption\n",
-			       dev->name, err);
-			return err;
-		}
-	}
-
-	if (priv->iw_mode == IW_MODE_MONITOR) {
-		/* Enable monitor mode */
-		dev->type = ARPHRD_IEEE80211;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
-					    HERMES_TEST_MONITOR, 0, NULL);
-	} else {
-		/* Disable monitor mode */
-		dev->type = ARPHRD_ETHER;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
-					    HERMES_TEST_STOP, 0, NULL);
-	}
-	if (err)
-		return err;
-
-	/* Set promiscuity / multicast*/
-	priv->promiscuous = 0;
-	priv->mc_count = 0;
-
-	/* FIXME: what about netif_tx_lock */
-	__orinoco_set_multicast_list(dev);
-
-	return 0;
-}
-
-/* FIXME: return int? */
-static void
+static int
 __orinoco_set_multicast_list(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -1843,6 +1614,8 @@ __orinoco_set_multicast_list(struct net_device *dev)
 
 	err = __orinoco_hw_set_multicast_list(priv, dev->mc_list, mc_count,
 					      promisc);
+
+	return err;
 }
 
 /* This must be called from user context, without locks held - use
@@ -1920,6 +1693,64 @@ void orinoco_reset(struct work_struct *work)
 	printk(KERN_ERR "%s: Device has been disabled!\n", dev->name);
 }
 
+static int __orinoco_commit(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	int err = 0;
+
+	err = orinoco_hw_program_rids(priv);
+
+	/* FIXME: what about netif_tx_lock */
+	(void) __orinoco_set_multicast_list(dev);
+
+	return err;
+}
+
+/* Ensures configuration changes are applied. May result in a reset.
+ * The caller should hold priv->lock
+ */
+int orinoco_commit(struct orinoco_private *priv)
+{
+	struct net_device *dev = priv->ndev;
+	hermes_t *hw = &priv->hw;
+	int err;
+
+	if (priv->broken_disableport) {
+		schedule_work(&priv->reset_work);
+		return 0;
+	}
+
+	err = hermes_disable_port(hw, 0);
+	if (err) {
+		printk(KERN_WARNING "%s: Unable to disable port "
+		       "while reconfiguring card\n", dev->name);
+		priv->broken_disableport = 1;
+		goto out;
+	}
+
+	err = __orinoco_commit(priv);
+	if (err) {
+		printk(KERN_WARNING "%s: Unable to reconfigure card\n",
+		       dev->name);
+		goto out;
+	}
+
+	err = hermes_enable_port(hw, 0);
+	if (err) {
+		printk(KERN_WARNING "%s: Unable to enable port while reconfiguring card\n",
+		       dev->name);
+		goto out;
+	}
+
+ out:
+	if (err) {
+		printk(KERN_WARNING "%s: Resetting instead...\n", dev->name);
+		schedule_work(&priv->reset_work);
+		err = 0;
+	}
+	return err;
+}
+
 /********************************************************************/
 /* Interrupt handler                                                */
 /********************************************************************/
diff --git a/drivers/net/wireless/orinoco/main.h b/drivers/net/wireless/orinoco/main.h
index af2bae4..21ab36c 100644
--- a/drivers/net/wireless/orinoco/main.h
+++ b/drivers/net/wireless/orinoco/main.h
@@ -29,10 +29,9 @@ struct net_device;
 struct work_struct;
 
 void set_port_type(struct orinoco_private *priv);
-int __orinoco_program_rids(struct net_device *dev);
+int orinoco_commit(struct orinoco_private *priv);
 void orinoco_reset(struct work_struct *work);
 
-
 /* Information element helpers - find a home for these... */
 static inline u8 *orinoco_get_ie(u8 *data, size_t len,
 				 enum ieee80211_eid eid)
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 74892e1..4c20b1d 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -2163,49 +2163,16 @@ static int orinoco_ioctl_commit(struct net_device *dev,
 				char *extra)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
-	struct hermes *hw = &priv->hw;
 	unsigned long flags;
 	int err = 0;
 
 	if (!priv->open)
 		return 0;
 
-	if (priv->broken_disableport) {
-		orinoco_reset(&priv->reset_work);
-		return 0;
-	}
-
 	if (orinoco_lock(priv, &flags) != 0)
 		return err;
 
-	err = hermes_disable_port(hw, 0);
-	if (err) {
-		printk(KERN_WARNING "%s: Unable to disable port "
-		       "while reconfiguring card\n", dev->name);
-		priv->broken_disableport = 1;
-		goto out;
-	}
-
-	err = __orinoco_program_rids(dev);
-	if (err) {
-		printk(KERN_WARNING "%s: Unable to reconfigure card\n",
-		       dev->name);
-		goto out;
-	}
-
-	err = hermes_enable_port(hw, 0);
-	if (err) {
-		printk(KERN_WARNING "%s: Unable to enable port while reconfiguring card\n",
-		       dev->name);
-		goto out;
-	}
-
- out:
-	if (err) {
-		printk(KERN_WARNING "%s: Resetting instead...\n", dev->name);
-		schedule_work(&priv->reset_work);
-		err = 0;
-	}
+	err = orinoco_commit(priv);
 
 	orinoco_unlock(priv, &flags);
 	return err;
-- 
1.6.0.6

