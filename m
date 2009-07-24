Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbZGXSIi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:08:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dan Williams <dcbw@redhat.com>,
	Lennert Buytenhek <buytenh@marvell.com>,
	Daniel Drake <ddrake@brontes3d.com>
Subject: [PATCH] mac80211: add helper to add to the mac80211 workqueue
Date: Fri, 24 Jul 2009 14:08:29 -0400
Message-Id: <1248458909-15338-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We add a mac80211 helper for adding work onto the mac80211
workqueue. We then add a warning if we are suspended. At that
point drivers nor mac80211 should have queued work, drivers
and mac80211 should ensure the workqueue will remain clair
until resume.

We make use of the helper now in mac80211 and on all mac80211
drivers. If you see a warning because of this patch during
the suspend <--> resume cycle it means suspend is busted for
your driver or mac80211 and it needs to be fixed.

mac80211 drivers that *do not* use the mac80211 workqueue and
invented their own (and that this patch does not touch) and
could be changed to do so:

  * iwlwifi/*
  * libertas_tf
  * mwl8k
  * zd1211rw

Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Dan Williams <dcbw@redhat.com>
Cc: Lennert Buytenhek <buytenh@marvell.com>
Cc: Daniel Drake <ddrake@brontes3d.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Tested with ath9k with a ping -f during suspend <--> resume.
Seems we're not abusing the workqueue during the period, maybe
with my WoW patch we did though as I left the interface present
on mac80211.

Only compile tested against the others but I think they should be
fine, its a simple wrapper.

 drivers/net/wireless/at76c50x-usb.c      |    2 +-
 drivers/net/wireless/ath/ar9170/main.c   |    6 ++--
 drivers/net/wireless/ath/ath9k/virtual.c |    8 +++---
 drivers/net/wireless/b43/main.c          |    4 +-
 drivers/net/wireless/b43/phy_common.c    |    2 +-
 drivers/net/wireless/b43/pio.c           |    2 +-
 drivers/net/wireless/b43legacy/main.c    |    4 +-
 drivers/net/wireless/p54/p54spi.c        |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c  |    2 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c  |    2 +-
 include/net/mac80211.h                   |   12 ++++++++
 net/mac80211/ibss.c                      |    6 ++--
 net/mac80211/iface.c                     |    2 +-
 net/mac80211/mesh.c                      |   10 +++---
 net/mac80211/mesh_hwmp.c                 |    4 +-
 net/mac80211/mlme.c                      |   42 +++++++++++++----------------
 net/mac80211/tx.c                        |    2 +-
 net/mac80211/util.c                      |   20 ++++++++++++++
 18 files changed, 81 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 13303fa..c5e483b 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -2024,7 +2024,7 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	} else
 		return;
 
-	queue_work(hw->workqueue, &priv->work_set_promisc);
+	ieee80211_queue_work(hw, &priv->work_set_promisc);
 }
 
 static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index c7287a8..c5905eb 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -648,7 +648,7 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 		 * pre-TBTT event
 		 */
 		if (ar->vif && ar->vif->type == NL80211_IFTYPE_AP)
-			queue_work(ar->hw->workqueue, &ar->beacon_work);
+			ieee80211_queue_work(ar->hw, &ar->beacon_work);
 		break;
 
 	case 0xc2:
@@ -2156,7 +2156,7 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 	}
 
 	if (likely(IS_STARTED(ar)))
-		queue_work(ar->hw->workqueue, &ar->filter_config_work);
+		ieee80211_queue_work(ar->hw, &ar->filter_config_work);
 }
 
 static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
@@ -2414,7 +2414,7 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 	}
 
 	if (IS_STARTED(ar) && ar->filter_changed)
-		queue_work(ar->hw->workqueue, &ar->filter_config_work);
+		ieee80211_queue_work(ar->hw, &ar->filter_config_work);
 }
 
 static int ar9170_get_stats(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index e1d419e..9185082 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -351,7 +351,7 @@ void ath9k_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			 * Drop from tasklet to work to allow mutex for channel
 			 * change.
 			 */
-			queue_work(aphy->sc->hw->workqueue,
+			ieee80211_queue_work(aphy->sc->hw,
 				   &aphy->sc->chan_work);
 		}
 	}
@@ -367,7 +367,7 @@ static void ath9k_mark_paused(struct ath_wiphy *aphy)
 	struct ath_softc *sc = aphy->sc;
 	aphy->state = ATH_WIPHY_PAUSED;
 	if (!__ath9k_wiphy_pausing(sc))
-		queue_work(sc->hw->workqueue, &sc->chan_work);
+		ieee80211_queue_work(sc->hw, &sc->chan_work);
 }
 
 static void ath9k_pause_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
@@ -521,7 +521,7 @@ int ath9k_wiphy_select(struct ath_wiphy *aphy)
 			spin_unlock_bh(&sc->wiphy_lock);
 			ath_radio_disable(sc);
 			ath_radio_enable(sc);
-			queue_work(aphy->sc->hw->workqueue,
+			ieee80211_queue_work(aphy->sc->hw,
 				   &aphy->sc->chan_work);
 			return -EBUSY; /* previous select still in progress */
 		}
@@ -541,7 +541,7 @@ int ath9k_wiphy_select(struct ath_wiphy *aphy)
 
 	if (now) {
 		/* Ready to request channel change immediately */
-		queue_work(aphy->sc->hw->workqueue, &aphy->sc->chan_work);
+		ieee80211_queue_work(aphy->sc->hw, &aphy->sc->chan_work);
 	}
 
 	/*
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3f4360a..b1387fe 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1654,7 +1654,7 @@ static void b43_update_templates(struct b43_wl *wl)
 	wl->current_beacon = beacon;
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
-	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
+	ieee80211_queue_work(wl->hw, &wl->beacon_update_trigger);
 }
 
 static void b43_set_beacon_int(struct b43_wldev *dev, u16 beacon_int)
@@ -4871,7 +4871,7 @@ void b43_controller_restart(struct b43_wldev *dev, const char *reason)
 	if (b43_status(dev) < B43_STAT_INITIALIZED)
 		return;
 	b43info(dev->wl, "Controller RESET (%s) ...\n", reason);
-	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
+	ieee80211_queue_work(dev->wl->hw, &dev->restart_work);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/b43/phy_common.c b/drivers/net/wireless/b43/phy_common.c
index 6d24162..f537bfe 100644
--- a/drivers/net/wireless/b43/phy_common.c
+++ b/drivers/net/wireless/b43/phy_common.c
@@ -352,7 +352,7 @@ void b43_phy_txpower_check(struct b43_wldev *dev, unsigned int flags)
 
 	/* We must adjust the transmission power in hardware.
 	 * Schedule b43_phy_txpower_adjust_work(). */
-	queue_work(dev->wl->hw->workqueue, &dev->wl->txpower_adjust_work);
+	ieee80211_queue_work(dev->wl->hw, &dev->wl->txpower_adjust_work);
 }
 
 int b43_phy_shm_tssi_read(struct b43_wldev *dev, u16 shm_offset)
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 69138e8..73c047d 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -783,7 +783,7 @@ void b43_pio_rx(struct b43_pio_rxqueue *q)
 {
 	/* Due to latency issues we must run the RX path in
 	 * a workqueue to be able to schedule between packets. */
-	queue_work(q->dev->wl->hw->workqueue, &q->rx_work);
+	ieee80211_queue_work(q->dev->wl->hw, &q->rx_work);
 }
 
 static void b43_pio_tx_suspend_queue(struct b43_pio_txqueue *q)
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index c4973c1..c9ce4a4 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -1252,7 +1252,7 @@ static void b43legacy_update_templates(struct b43legacy_wl *wl)
 	wl->current_beacon = beacon;
 	wl->beacon0_uploaded = 0;
 	wl->beacon1_uploaded = 0;
-	queue_work(wl->hw->workqueue, &wl->beacon_update_trigger);
+	ieee80211_queue_work(wl->hw, &wl->beacon_update_trigger);
 }
 
 static void b43legacy_set_beacon_int(struct b43legacy_wldev *dev,
@@ -3885,7 +3885,7 @@ void b43legacy_controller_restart(struct b43legacy_wldev *dev,
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
 		return;
 	b43legacyinfo(dev->wl, "Controller RESET (%s) ...\n", reason);
-	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
+	ieee80211_queue_work(dev->wl->hw, &dev->restart_work);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index eef5329..05458d9 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -391,7 +391,7 @@ static irqreturn_t p54spi_interrupt(int irq, void *config)
 	struct spi_device *spi = config;
 	struct p54s_priv *priv = dev_get_drvdata(&spi->dev);
 
-	queue_work(priv->hw->workqueue, &priv->work);
+	ieee80211_queue_work(priv->hw, &priv->work);
 
 	return IRQ_HANDLED;
 }
@@ -479,7 +479,7 @@ static void p54spi_op_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	list_add_tail(&di->tx_list, &priv->tx_pending);
 	spin_unlock_irqrestore(&priv->tx_lock, flags);
 
-	queue_work(priv->hw->workqueue, &priv->work);
+	ieee80211_queue_work(priv->hw, &priv->work);
 }
 
 static void p54spi_work(struct work_struct *work)
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 658a63b..b717afb 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -215,7 +215,7 @@ void rt2x00lib_beacondone(struct rt2x00_dev *rt2x00dev)
 						   rt2x00lib_beacondone_iter,
 						   rt2x00dev);
 
-	queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->intf_work);
+	ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->intf_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_beacondone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 9d31c23..8d6e792 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -431,7 +431,7 @@ void rt2x00mac_configure_filter(struct ieee80211_hw *hw,
 	if (!test_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags))
 		rt2x00dev->ops->lib->config_filter(rt2x00dev, *total_flags);
 	else
-		queue_work(rt2x00dev->hw->workqueue, &rt2x00dev->filter_work);
+		ieee80211_queue_work(rt2x00dev->hw, &rt2x00dev->filter_work);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_configure_filter);
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7dd67a1..2f2445e 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1924,6 +1924,18 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						void *data);
 
 /**
+ * ieee80211_queue_work - add work onto the mac80211 workqueue
+ *
+ * Drivers and mac80211 should use this to add work onto the mac80211
+ * workqueue instead of adding work directly through queue_work(). This
+ * helper ensures drivers are not queueing work when they should not be.
+ *
+ * @hw: the hardware struct for the interface we are adding work for
+ * @work: the work we want to add onto the mac80211 workqueue
+ */
+void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8e22200..f0573c5 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -781,7 +781,7 @@ static void ieee80211_ibss_timer(unsigned long data)
 	}
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
-	queue_work(local->hw.workqueue, &ifibss->work);
+	ieee80211_queue_work(&local->hw, &ifibss->work);
 }
 
 #ifdef CONFIG_PM
@@ -853,7 +853,7 @@ ieee80211_ibss_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_AUTH:
 		skb_queue_tail(&sdata->u.ibss.skb_queue, skb);
-		queue_work(local->hw.workqueue, &sdata->u.ibss.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.ibss.work);
 		return RX_QUEUED;
 	}
 
@@ -912,7 +912,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_idle(sdata->local);
 
 	set_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	queue_work(sdata->local->hw.workqueue, &sdata->u.ibss.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.ibss.work);
 
 	return 0;
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2f797a8..9b9b3d4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -312,7 +312,7 @@ static int ieee80211_open(struct net_device *dev)
 	 * to fix this.
 	 */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 
 	netif_tx_start_all_queues(dev);
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 8a97b14..84546b2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -54,7 +54,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
 /**
@@ -357,7 +357,7 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
 struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
@@ -471,7 +471,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	ifmsh->housekeeping = true;
-	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED);
 }
@@ -619,7 +619,7 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			queue_work(local->hw.workqueue, &sdata->u.mesh.work);
+			ieee80211_queue_work(local->hw.workqueue, &sdata->u.mesh.work);
 	rcu_read_unlock();
 }
 
@@ -692,7 +692,7 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 		skb_queue_tail(&ifmsh->skb_queue, skb);
-		queue_work(local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
 		return RX_QUEUED;
 	}
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index e93c37e..11ab71a 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -660,14 +660,14 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 	spin_unlock(&ifmsh->mesh_preq_queue_lock);
 
 	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
-		queue_work(sdata->local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(sdata->local->hw.workqueue, &ifmsh->work);
 
 	else if (time_before(jiffies, ifmsh->last_preq)) {
 		/* avoid long wait if did not send preqs for a long time
 		 * and jiffies wrapped around
 		 */
 		ifmsh->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
-		queue_work(sdata->local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(sdata->local->hw.workqueue, &ifmsh->work);
 	} else
 		mod_timer(&ifmsh->mesh_path_timer, ifmsh->last_preq +
 						min_preq_int_jiff(sdata));
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index db0b4b2..3da36d2 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -565,7 +565,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
+	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 }
 
 void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
@@ -597,7 +597,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->local->csa_channel = new_ch;
 
 	if (sw_elem->count <= 1) {
-		queue_work(sdata->local->hw.workqueue, &ifmgd->chswitch_work);
+		ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 	} else {
 		ieee80211_stop_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -763,7 +763,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(local->hw.workqueue, &local->dynamic_ps_enable_work);
+	ieee80211_queue_work(&local->hw, &local->dynamic_ps_enable_work);
 }
 
 /* MLME */
@@ -950,7 +950,7 @@ ieee80211_direct_probe(struct ieee80211_sub_if_data *sdata,
 		 * due to work needing to be done. Hence, queue the STAs work
 		 * again for that.
 		 */
-		queue_work(local->hw.workqueue, &ifmgd->work);
+		ieee80211_queue_work(&local->hw, &ifmgd->work);
 		return RX_MGMT_CFG80211_AUTH_TO;
 	}
 
@@ -995,7 +995,7 @@ ieee80211_authenticate(struct ieee80211_sub_if_data *sdata,
 		 * due to work needing to be done. Hence, queue the STAs work
 		 * again for that.
 		 */
-		queue_work(local->hw.workqueue, &ifmgd->work);
+		ieee80211_queue_work(&local->hw, &ifmgd->work);
 		return RX_MGMT_CFG80211_AUTH_TO;
 	}
 
@@ -1124,7 +1124,7 @@ ieee80211_associate(struct ieee80211_sub_if_data *sdata,
 		 * due to work needing to be done. Hence, queue the STAs work
 		 * again for that.
 		 */
-		queue_work(local->hw.workqueue, &ifmgd->work);
+		ieee80211_queue_work(&local->hw, &ifmgd->work);
 		return RX_MGMT_CFG80211_ASSOC_TO;
 	}
 
@@ -1232,8 +1232,7 @@ void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 
-	queue_work(sdata->local->hw.workqueue,
-		   &sdata->u.mgd.beacon_loss_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
 }
 EXPORT_SYMBOL(ieee80211_beacon_loss);
 
@@ -1888,7 +1887,7 @@ ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 	case IEEE80211_STYPE_DISASSOC:
 	case IEEE80211_STYPE_ACTION:
 		skb_queue_tail(&sdata->u.mgd.skb_queue, skb);
-		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 		return RX_QUEUED;
 	}
 
@@ -2023,7 +2022,7 @@ static void ieee80211_sta_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmgd->work);
+	ieee80211_queue_work(&local->hw, &ifmgd->work);
 }
 
 static void ieee80211_sta_work(struct work_struct *work)
@@ -2048,13 +2047,11 @@ static void ieee80211_sta_work(struct work_struct *work)
 		return;
 
 	/*
-	 * Nothing should have been stuffed into the workqueue during
-	 * the suspend->resume cycle. If this WARN is seen then there
-	 * is a bug with either the driver suspend or something in
-	 * mac80211 stuffing into the workqueue which we haven't yet
-	 * cleared during mac80211's suspend cycle.
+	 * ieee80211_queue_work() should have picked up most cases,
+	 * here we'll pick the the rest.
 	 */
-	if (WARN_ON(local->suspended))
+	if (WARN(local->suspended, "STA MLME work scheduled while "
+		 "going to suspend\n"))
 		return;
 
 	ifmgd = &sdata->u.mgd;
@@ -2193,8 +2190,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(sdata->local->hw.workqueue,
-		   &sdata->u.mgd.beacon_loss_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
 }
 
 static void ieee80211_sta_conn_mon_timer(unsigned long data)
@@ -2207,7 +2203,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(local->hw.workqueue, &ifmgd->monitor_work);
+	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
 }
 
 static void ieee80211_sta_monitor_work(struct work_struct *work)
@@ -2226,10 +2222,10 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 					IEEE80211_STA_CONNECTION_POLL);
 
 		/* let's probe the connection once */
-		queue_work(sdata->local->hw.workqueue,
+		ieee80211_queue_work(&sdata->local->hw,
 			   &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
-		queue_work(sdata->local->hw.workqueue,
+		ieee80211_queue_work(&sdata->local->hw,
 			   &sdata->u.mgd.work);
 	}
 }
@@ -2389,7 +2385,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	list_add(&wk->list, &sdata->u.mgd.work_list);
 	mutex_unlock(&ifmgd->mtx);
 
-	queue_work(sdata->local->hw.workqueue, &sdata->u.mgd.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 	return 0;
 }
 
@@ -2462,7 +2458,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
-	queue_work(sdata->local->hw.workqueue, &sdata->u.mgd.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 
 	err = 0;
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c11cbbd..8369fe2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1400,7 +1400,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
-			queue_work(local->hw.workqueue,
+			ieee80211_queue_work(&local->hw,
 					&local->dynamic_ps_disable_work);
 		}
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7fc5584..cdb0108 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -498,6 +498,25 @@ void ieee80211_iterate_active_interfaces_atomic(
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
+void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	/*
+	 * Nothing should have been stuffed into the workqueue during
+	 * the suspend->resume cycle. If this WARN is seen then there
+	 * is a bug with either the driver suspend or something in
+	 * mac80211 stuffing into the workqueue which we haven't yet
+	 * cleared during mac80211's suspend cycle.
+	 */
+        if (WARN(local->suspended, "queueing ieee80211 work while "
+		 "going to suspend\n"))
+                return;
+
+	queue_work(hw->workqueue, work);
+}
+EXPORT_SYMBOL_GPL(ieee80211_queue_work);
+
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems)
 {
@@ -1101,3 +1120,4 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 #endif
 	return 0;
 }
+
-- 
1.6.3.3

