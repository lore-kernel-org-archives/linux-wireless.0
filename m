Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52576 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754129AbZG2VVM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 17:21:12 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 14:21:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] mac80211: redefine usage of the mac80211 workqueue
Date: Wed, 29 Jul 2009 14:20:42 -0700
Message-ID: <1248902442-14621-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248902442-14621-1-git-send-email-lrodriguez@atheros.com>
References: <1248902442-14621-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mac80211 workqueue exists to enable mac80211 and drivers
to queue their own work on a single threaded workqueue. mac80211
takes care to flush the workqueue during suspend but we never
really had requirements on drivers for how they should use
the workqueue in consideration for suspend.

We extend mac80211 to document how the mac80211 workqueue should
be used, how it should not be used and finally move raw access to
the workqueue to mac80211 only. Drivers and mac80211 use helpers
to queue work onto the mac80211 workqueue:

  * ieee80211_queue_work()
  * ieee80211_queue_delayed_work()

These helpers will now warn if mac80211 already completed its
suspend cycle and someone is trying to queue work. mac80211
flushes the mac80211 workqueue prior to suspend a few times,
but we haven't taken the care to ensure drivers won't add more
work after suspend. To help with this we add a warning when
someone tries to add work and mac80211 already completed the
suspend cycle.

Drivers should ensure they cancel any work or delayed work
in the mac80211 stop() callback.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/at76c50x-usb.c         |   10 +++---
 drivers/net/wireless/ath/ar9170/led.c       |   11 ++++--
 drivers/net/wireless/ath/ar9170/main.c      |   26 ++++++++------
 drivers/net/wireless/ath/ath9k/main.c       |   15 ++++----
 drivers/net/wireless/ath/ath9k/virtual.c    |   17 +++++----
 drivers/net/wireless/ath/ath9k/xmit.c       |    2 +-
 drivers/net/wireless/b43/main.c             |    8 ++--
 drivers/net/wireless/b43/phy_common.c       |    2 +-
 drivers/net/wireless/b43/pio.c              |    2 +-
 drivers/net/wireless/b43legacy/main.c       |    8 ++--
 drivers/net/wireless/p54/led.c              |    5 +--
 drivers/net/wireless/p54/main.c             |    2 +-
 drivers/net/wireless/p54/p54spi.c           |    4 +-
 drivers/net/wireless/p54/txrx.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    2 +-
 drivers/net/wireless/rt2x00/rt2x00link.c    |    8 ++--
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_dev.c  |    2 +-
 drivers/net/wireless/rtl818x/rtl8187_leds.c |   10 +++---
 include/net/mac80211.h                      |   50 ++++++++++++++++++++++----
 net/mac80211/ibss.c                         |    6 ++--
 net/mac80211/ieee80211_i.h                  |    6 +++
 net/mac80211/iface.c                        |    4 +-
 net/mac80211/main.c                         |    8 ++--
 net/mac80211/mesh.c                         |   10 +++---
 net/mac80211/mesh_hwmp.c                    |    4 +-
 net/mac80211/mlme.c                         |   48 ++++++++++++--------------
 net/mac80211/pm.c                           |    2 +-
 net/mac80211/scan.c                         |    8 ++--
 net/mac80211/tx.c                           |    2 +-
 net/mac80211/util.c                         |   41 ++++++++++++++++++++++
 31 files changed, 206 insertions(+), 121 deletions(-)

diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index aff09a1..7218dba 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1875,8 +1875,8 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	/* FIXME: add maximum time for scan to complete */
 
 	if (ret != CMD_STATUS_COMPLETE) {
-		queue_delayed_work(priv->hw->workqueue, &priv->dwork_hw_scan,
-				   SCAN_POLL_INTERVAL);
+		ieee80211_queue_delayed_work(priv->hw, &priv->dwork_hw_scan,
+					     SCAN_POLL_INTERVAL);
 		mutex_unlock(&priv->mtx);
 		return;
 	}
@@ -1937,8 +1937,8 @@ static int at76_hw_scan(struct ieee80211_hw *hw,
 		goto exit;
 	}
 
-	queue_delayed_work(priv->hw->workqueue, &priv->dwork_hw_scan,
-			   SCAN_POLL_INTERVAL);
+	ieee80211_queue_delayed_work(priv->hw, &priv->dwork_hw_scan,
+				     SCAN_POLL_INTERVAL);
 
 exit:
 	mutex_unlock(&priv->mtx);
@@ -2027,7 +2027,7 @@ static void at76_configure_filter(struct ieee80211_hw *hw,
 	} else
 		return;
 
-	queue_work(hw->workqueue, &priv->work_set_promisc);
+	ieee80211_queue_work(hw, &priv->work_set_promisc);
 }
 
 static int at76_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
diff --git a/drivers/net/wireless/ath/ar9170/led.c b/drivers/net/wireless/ath/ar9170/led.c
index 63fda6c..86c4e79 100644
--- a/drivers/net/wireless/ath/ar9170/led.c
+++ b/drivers/net/wireless/ath/ar9170/led.c
@@ -90,9 +90,12 @@ static void ar9170_update_leds(struct work_struct *work)
 	ar9170_set_leds_state(ar, led_val);
 	mutex_unlock(&ar->mutex);
 
-	if (rerun)
-		queue_delayed_work(ar->hw->workqueue, &ar->led_work,
-				   msecs_to_jiffies(blink_delay));
+	if (!rerun)
+		return;
+
+	ieee80211_queue_delayed_work(ar->hw,
+				     &ar->led_work,
+				     msecs_to_jiffies(blink_delay));
 }
 
 static void ar9170_led_brightness_set(struct led_classdev *led,
@@ -110,7 +113,7 @@ static void ar9170_led_brightness_set(struct led_classdev *led,
 	}
 
 	if (likely(IS_ACCEPTING_CMD(ar) && arl->toggled))
-		queue_delayed_work(ar->hw->workqueue, &ar->led_work, HZ/10);
+		ieee80211_queue_delayed_work(ar->hw, &ar->led_work, HZ/10);
 }
 
 static int ar9170_register_led(struct ar9170 *ar, int i, char *name,
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 099ed3c..4fc389a 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -595,10 +595,12 @@ static void ar9170_tx_janitor(struct work_struct *work)
 
 	ar9170_tx_fake_ampdu_status(ar);
 
-	if (resched)
-		queue_delayed_work(ar->hw->workqueue,
-				   &ar->tx_janitor,
-				   msecs_to_jiffies(AR9170_JANITOR_DELAY));
+	if (!resched)
+		return;
+
+	ieee80211_queue_delayed_work(ar->hw,
+				     &ar->tx_janitor,
+				     msecs_to_jiffies(AR9170_JANITOR_DELAY));
 }
 
 void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
@@ -648,7 +650,7 @@ void ar9170_handle_command_response(struct ar9170 *ar, void *buf, u32 len)
 		 * pre-TBTT event
 		 */
 		if (ar->vif && ar->vif->type == NL80211_IFTYPE_AP)
-			queue_work(ar->hw->workqueue, &ar->beacon_work);
+			ieee80211_queue_work(ar->hw, &ar->beacon_work);
 		break;
 
 	case 0xc2:
@@ -1825,10 +1827,12 @@ static void ar9170_tx(struct ar9170 *ar)
 		}
 	}
 
-	if (schedule_garbagecollector)
-		queue_delayed_work(ar->hw->workqueue,
-				   &ar->tx_janitor,
-				   msecs_to_jiffies(AR9170_JANITOR_DELAY));
+	if (!schedule_garbagecollector)
+		return;
+
+	ieee80211_queue_delayed_work(ar->hw,
+				     &ar->tx_janitor,
+				     msecs_to_jiffies(AR9170_JANITOR_DELAY));
 }
 
 static bool ar9170_tx_ampdu_queue(struct ar9170 *ar, struct sk_buff *skb)
@@ -2157,7 +2161,7 @@ static void ar9170_op_configure_filter(struct ieee80211_hw *hw,
 	}
 
 	if (likely(IS_STARTED(ar)))
-		queue_work(ar->hw->workqueue, &ar->filter_config_work);
+		ieee80211_queue_work(ar->hw, &ar->filter_config_work);
 }
 
 static void ar9170_op_bss_info_changed(struct ieee80211_hw *hw,
@@ -2415,7 +2419,7 @@ static void ar9170_sta_notify(struct ieee80211_hw *hw,
 	}
 
 	if (IS_STARTED(ar) && ar->filter_changed)
-		queue_work(ar->hw->workqueue, &ar->filter_config_work);
+		ieee80211_queue_work(ar->hw, &ar->filter_config_work);
 }
 
 static int ar9170_get_stats(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index cf44623..292ac2b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -973,10 +973,11 @@ static void ath_led_blink_work(struct work_struct *work)
 		ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN,
 				  (sc->sc_flags & SC_OP_LED_ON) ? 1 : 0);
 
-	queue_delayed_work(sc->hw->workqueue, &sc->ath_led_blink_work,
-			   (sc->sc_flags & SC_OP_LED_ON) ?
-			   msecs_to_jiffies(sc->led_off_duration) :
-			   msecs_to_jiffies(sc->led_on_duration));
+	ieee80211_queue_delayed_work(sc->hw,
+				     &sc->ath_led_blink_work,
+				     (sc->sc_flags & SC_OP_LED_ON) ?
+					msecs_to_jiffies(sc->led_off_duration) :
+					msecs_to_jiffies(sc->led_on_duration));
 
 	sc->led_on_duration = sc->led_on_cnt ?
 			max((ATH_LED_ON_DURATION_IDLE - sc->led_on_cnt), 25) :
@@ -1013,8 +1014,8 @@ static void ath_led_brightness(struct led_classdev *led_cdev,
 	case LED_FULL:
 		if (led->led_type == ATH_LED_ASSOC) {
 			sc->sc_flags |= SC_OP_LED_ASSOCIATED;
-			queue_delayed_work(sc->hw->workqueue,
-					   &sc->ath_led_blink_work, 0);
+			ieee80211_queue_delayed_work(sc->hw,
+						     &sc->ath_led_blink_work, 0);
 		} else if (led->led_type == ATH_LED_RADIO) {
 			ath9k_hw_set_gpio(sc->sc_ah, ATH_LED_PIN, 0);
 			sc->sc_flags |= SC_OP_LED_ON;
@@ -1972,7 +1973,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
-	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work, 0);
+	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
 
 mutex_unlock:
 	mutex_unlock(&sc->mutex);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index e1d419e..19b88f8 100644
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
@@ -648,8 +648,9 @@ try_again:
 		       "change\n");
 	}
 
-	queue_delayed_work(sc->hw->workqueue, &sc->wiphy_work,
-			   sc->wiphy_scheduler_int);
+	ieee80211_queue_delayed_work(sc->hw,
+				     &sc->wiphy_work,
+				     sc->wiphy_scheduler_int);
 }
 
 void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int)
@@ -657,8 +658,8 @@ void ath9k_wiphy_set_scheduler(struct ath_softc *sc, unsigned int msec_int)
 	cancel_delayed_work_sync(&sc->wiphy_work);
 	sc->wiphy_scheduler_int = msecs_to_jiffies(msec_int);
 	if (sc->wiphy_scheduler_int)
-		queue_delayed_work(sc->hw->workqueue, &sc->wiphy_work,
-				   sc->wiphy_scheduler_int);
+		ieee80211_queue_delayed_work(sc->hw, &sc->wiphy_work,
+					     sc->wiphy_scheduler_int);
 }
 
 /* caller must hold wiphy_lock */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b7806e2..87762da 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2063,7 +2063,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 		ath_reset(sc, false);
 	}
 
-	queue_delayed_work(sc->hw->workqueue, &sc->tx_complete_work,
+	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
 			msecs_to_jiffies(ATH_TX_COMPLETE_POLL_INT));
 }
 
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 3f4360a..f985938 100644
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
@@ -2914,7 +2914,7 @@ out_requeue:
 		delay = msecs_to_jiffies(50);
 	else
 		delay = round_jiffies_relative(HZ * 15);
-	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
+	ieee80211_queue_delayed_work(wl->hw, &dev->periodic_work, delay);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -2925,7 +2925,7 @@ static void b43_periodic_tasks_setup(struct b43_wldev *dev)
 
 	dev->periodic_state = 0;
 	INIT_DELAYED_WORK(work, b43_periodic_work_handler);
-	queue_delayed_work(dev->wl->hw->workqueue, work, 0);
+	ieee80211_queue_delayed_work(dev->wl->hw, work, 0);
 }
 
 /* Check if communication with the device works correctly. */
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
index c4973c1..b143559 100644
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
@@ -2300,7 +2300,7 @@ out_requeue:
 		delay = msecs_to_jiffies(50);
 	else
 		delay = round_jiffies_relative(HZ * 15);
-	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
+	ieee80211_queue_delayed_work(wl->hw, &dev->periodic_work, delay);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -2311,7 +2311,7 @@ static void b43legacy_periodic_tasks_setup(struct b43legacy_wldev *dev)
 
 	dev->periodic_state = 0;
 	INIT_DELAYED_WORK(work, b43legacy_periodic_work_handler);
-	queue_delayed_work(dev->wl->hw->workqueue, work, 0);
+	ieee80211_queue_delayed_work(dev->wl->hw, work, 0);
 }
 
 /* Validate access to the chip (SHM) */
@@ -3885,7 +3885,7 @@ void b43legacy_controller_restart(struct b43legacy_wldev *dev,
 	if (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED)
 		return;
 	b43legacyinfo(dev->wl, "Controller RESET (%s) ...\n", reason);
-	queue_work(dev->wl->hw->workqueue, &dev->restart_work);
+	ieee80211_queue_work(dev->wl->hw, &dev->restart_work);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/net/wireless/p54/led.c b/drivers/net/wireless/p54/led.c
index c00115b..9575ac0 100644
--- a/drivers/net/wireless/p54/led.c
+++ b/drivers/net/wireless/p54/led.c
@@ -61,7 +61,7 @@ static void p54_update_leds(struct work_struct *work)
 			wiphy_name(priv->hw->wiphy), err);
 
 	if (rerun)
-		queue_delayed_work(priv->hw->workqueue, &priv->led_work,
+		ieee80211_queue_delayed_work(priv->hw, &priv->led_work,
 			msecs_to_jiffies(blink_delay));
 }
 
@@ -78,8 +78,7 @@ static void p54_led_brightness_set(struct led_classdev *led_dev,
 
 	if ((brightness) && (led->registered)) {
 		led->toggled++;
-		queue_delayed_work(priv->hw->workqueue, &priv->led_work,
-				   HZ/10);
+		ieee80211_queue_delayed_work(priv->hw, &priv->led_work, HZ/10);
 	}
 }
 
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index 955f6d7..a0d0e72 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -180,7 +180,7 @@ static int p54_start(struct ieee80211_hw *dev)
 		goto out;
 	}
 
-	queue_delayed_work(dev->workqueue, &priv->work, 0);
+	ieee80211_queue_delayed_work(dev, &priv->work, 0);
 
 	priv->softled_state = 0;
 	err = p54_set_leds(priv);
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
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index c32a0d2..704685f 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -380,7 +380,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 
 	ieee80211_rx_irqsafe(priv->hw, skb);
 
-	queue_delayed_work(priv->hw->workqueue, &priv->work,
+	ieee80211_queue_delayed_work(priv->hw, &priv->work,
 			   msecs_to_jiffies(P54_STATISTICS_UPDATE));
 
 	return -1;
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
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00link.c b/drivers/net/wireless/rt2x00/rt2x00link.c
index 7991568..9178316 100644
--- a/drivers/net/wireless/rt2x00/rt2x00link.c
+++ b/drivers/net/wireless/rt2x00/rt2x00link.c
@@ -351,8 +351,8 @@ void rt2x00link_start_tuner(struct rt2x00_dev *rt2x00dev)
 
 	rt2x00link_reset_tuner(rt2x00dev, false);
 
-	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &link->work, LINK_TUNE_INTERVAL);
+	ieee80211_queue_delayed_work(rt2x00dev->hw,
+				     &link->work, LINK_TUNE_INTERVAL);
 }
 
 void rt2x00link_stop_tuner(struct rt2x00_dev *rt2x00dev)
@@ -461,8 +461,8 @@ static void rt2x00link_tuner(struct work_struct *work)
 	 * Increase tuner counter, and reschedule the next link tuner run.
 	 */
 	link->count++;
-	queue_delayed_work(rt2x00dev->hw->workqueue,
-			   &link->work, LINK_TUNE_INTERVAL);
+	ieee80211_queue_delayed_work(rt2x00dev->hw,
+				     &link->work, LINK_TUNE_INTERVAL);
 }
 
 void rt2x00link_register(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index e92c8f9..81febdf 100644
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
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index c9b9dbe..53f57dc 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -220,7 +220,7 @@ static void rtl8187_tx_cb(struct urb *urb)
 		 * reading a register in the device. We are in interrupt mode
 		 * here, thus queue the skb and finish on a work queue. */
 		skb_queue_tail(&priv->b_tx_status.queue, skb);
-		queue_delayed_work(hw->workqueue, &priv->work, 0);
+		ieee80211_queue_delayed_work(hw, &priv->work, 0);
 	}
 }
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187_leds.c b/drivers/net/wireless/rtl818x/rtl8187_leds.c
index cf9f899..a6cfb7e 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_leds.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_leds.c
@@ -108,11 +108,11 @@ static void rtl8187_led_brightness_set(struct led_classdev *led_dev,
 	struct rtl8187_priv *priv = hw->priv;
 
 	if (brightness == LED_OFF) {
-		queue_delayed_work(hw->workqueue, &priv->led_off, 0);
+		ieee80211_queue_delayed_work(hw, &priv->led_off, 0);
 		/* The LED is off for 1/20 sec so that it just blinks. */
-		queue_delayed_work(hw->workqueue, &priv->led_on, HZ / 20);
+		ieee80211_queue_delayed_work(hw, &priv->led_on, HZ / 20);
 	} else
-		queue_delayed_work(hw->workqueue, &priv->led_on, 0);
+		ieee80211_queue_delayed_work(hw, &priv->led_on, 0);
 }
 
 static int rtl8187_register_led(struct ieee80211_hw *dev,
@@ -193,7 +193,7 @@ void rtl8187_leds_init(struct ieee80211_hw *dev, u16 custid)
 	err = rtl8187_register_led(dev, &priv->led_rx, name,
 			 ieee80211_get_rx_led_name(dev), ledpin);
 	if (!err) {
-		queue_delayed_work(dev->workqueue, &priv->led_on, 0);
+		ieee80211_queue_delayed_work(dev, &priv->led_on, 0);
 		return;
 	}
 	/* registration of RX LED failed - unregister TX */
@@ -209,7 +209,7 @@ void rtl8187_leds_exit(struct ieee80211_hw *dev)
 	struct rtl8187_priv *priv = dev->priv;
 
 	/* turn the LED off before exiting */
-	queue_delayed_work(dev->workqueue, &priv->led_off, 0);
+	ieee80211_queue_delayed_work(dev, &priv->led_off, 0);
 	cancel_delayed_work_sync(&priv->led_off);
 	cancel_delayed_work_sync(&priv->led_on);
 	rtl8187_unregister_led(&priv->led_rx);
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d4e09a0..5ed93f4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -73,6 +73,21 @@
  */
 
 /**
+ * DOC: mac80211 workqueue
+ *
+ * mac80211 provides its own workqueue for drivers and internal mac80211 use.
+ * The workqueue is a single threaded workqueue and can only be accessed by
+ * helpers for sanity checking. Drivers must ensure all work added onto the
+ * mac80211 workqueue should be cancelled on the driver stop() callback.
+ *
+ * mac80211 will flushed the workqueue upon interface removal and during
+ * suspend.
+ *
+ * All work performed on the mac80211 workqueue must not acquire the RTNL lock.
+ *
+ */
+
+/**
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
@@ -913,12 +928,6 @@ enum ieee80211_hw_flags {
  *
  * @conf: &struct ieee80211_conf, device configuration, don't use.
  *
- * @workqueue: single threaded workqueue available for driver use,
- *	allocated by mac80211 on registration and flushed when an
- *	interface is removed.
- *	NOTICE: All work performed on this workqueue must not
- *	acquire the RTNL lock.
- *
  * @priv: pointer to private area that was allocated for driver use
  *	along with this structure.
  *
@@ -954,7 +963,6 @@ enum ieee80211_hw_flags {
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
 	struct wiphy *wiphy;
-	struct workqueue_struct *workqueue;
 	const char *rate_control_algorithm;
 	void *priv;
 	u32 flags;
@@ -1301,7 +1309,8 @@ enum ieee80211_ampdu_mlme_action {
  *	is disabled. This should turn off the hardware (at least
  *	it must turn off frame reception.)
  *	May be called right after add_interface if that rejects
- *	an interface.
+ *	an interface. If you added any work onto the mac80211 workqueue
+ *	you should ensure to cancel it on this callback.
  *	Must be implemented.
  *
  * @add_interface: Called when a netdevice attached to the hardware is
@@ -1928,6 +1937,31 @@ void ieee80211_iterate_active_interfaces_atomic(struct ieee80211_hw *hw,
 						void *data);
 
 /**
+ * ieee80211_queue_work - add work onto the mac80211 workqueue
+ *
+ * Drivers and mac80211 use this to add work onto the mac80211 workqueue.
+ * This helper ensures drivers are not queueing work when they should not be.
+ *
+ * @hw: the hardware struct for the interface we are adding work for
+ * @work: the work we want to add onto the mac80211 workqueue
+ */
+void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work);
+
+/**
+ * ieee80211_queue_delayed_work - add work onto the mac80211 workqueue
+ *
+ * Drivers and mac80211 use this to queue delayed work onto the mac80211
+ * workqueue.
+ *
+ * @hw: the hardware struct for the interface we are adding work for
+ * @dwork: delayable work to queue onto the mac80211 workqueue
+ * @delay: number of jiffies to wait before queueing
+ */
+void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
+				  struct delayed_work *dwork,
+				  unsigned long delay);
+
+/**
  * ieee80211_start_tx_ba_session - Start a tx Block Ack session.
  * @hw: pointer as obtained from ieee80211_alloc_hw().
  * @ra: receiver address of the BA session recipient
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6e3cca6..920ec87 100644
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
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index aec6853..316825b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -614,6 +614,12 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
+	/*
+	 * private workqueue to mac80211. mac80211 makes this accessible
+	 * via ieee80211_queue_work()
+	 */
+	struct workqueue_struct *workqueue;
+
 	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a83087f..8c1284d 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -312,7 +312,7 @@ static int ieee80211_open(struct net_device *dev)
 	 * to fix this.
 	 */
 	if (sdata->vif.type == NL80211_IFTYPE_STATION)
-		queue_work(local->hw.workqueue, &sdata->u.mgd.work);
+		ieee80211_queue_work(&local->hw, &sdata->u.mgd.work);
 
 	netif_tx_start_all_queues(dev);
 
@@ -551,7 +551,7 @@ static int ieee80211_stop(struct net_device *dev)
 
 		ieee80211_led_radio(local, false);
 
-		flush_workqueue(local->hw.workqueue);
+		flush_workqueue(local->workqueue);
 
 		tasklet_disable(&local->tx_pending_tasklet);
 		tasklet_disable(&local->tasklet);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 5e76dd1..22e0738 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -821,9 +821,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (hw->queues > IEEE80211_MAX_QUEUES)
 		hw->queues = IEEE80211_MAX_QUEUES;
 
-	local->hw.workqueue =
+	local->workqueue =
 		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
-	if (!local->hw.workqueue) {
+	if (!local->workqueue) {
 		result = -ENOMEM;
 		goto fail_workqueue;
 	}
@@ -913,7 +913,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	sta_info_stop(local);
  fail_sta_info:
 	debugfs_hw_del(local);
-	destroy_workqueue(local->hw.workqueue);
+	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
  fail_wiphy_register:
@@ -955,7 +955,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
 
-	destroy_workqueue(local->hw.workqueue);
+	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
 	ieee80211_wep_free(local);
 	ieee80211_led_exit(local);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9a38269..2f4f518 100644
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
index ee83125..0779ba1 100644
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
 	if (local->quiescing || local->suspended)
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
 
@@ -2026,7 +2025,7 @@ static void ieee80211_sta_timer(unsigned long data)
 		return;
 	}
 
-	queue_work(local->hw.workqueue, &ifmgd->work);
+	ieee80211_queue_work(&local->hw, &ifmgd->work);
 }
 
 static void ieee80211_sta_work(struct work_struct *work)
@@ -2051,13 +2050,11 @@ static void ieee80211_sta_work(struct work_struct *work)
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
@@ -2113,9 +2110,9 @@ static void ieee80211_sta_work(struct work_struct *work)
 		mutex_unlock(&ifmgd->mtx);
 
 		if (test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request))
-			queue_delayed_work(local->hw.workqueue,
-					   &local->scan_work,
-					   round_jiffies_relative(0));
+			ieee80211_queue_delayed_work(&local->hw,
+						     &local->scan_work,
+						     round_jiffies_relative(0));
 		return;
 	}
 
@@ -2196,8 +2193,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(sdata->local->hw.workqueue,
-		   &sdata->u.mgd.beacon_loss_work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
 }
 
 static void ieee80211_sta_conn_mon_timer(unsigned long data)
@@ -2210,7 +2206,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	if (local->quiescing)
 		return;
 
-	queue_work(local->hw.workqueue, &ifmgd->monitor_work);
+	ieee80211_queue_work(&local->hw, &ifmgd->monitor_work);
 }
 
 static void ieee80211_sta_monitor_work(struct work_struct *work)
@@ -2229,10 +2225,10 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
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
@@ -2393,7 +2389,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 	list_add(&wk->list, &sdata->u.mgd.work_list);
 	mutex_unlock(&ifmgd->mtx);
 
-	queue_work(sdata->local->hw.workqueue, &sdata->u.mgd.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 	return 0;
 }
 
@@ -2467,7 +2463,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	else
 		ifmgd->flags &= ~IEEE80211_STA_CONTROL_PORT;
 
-	queue_work(sdata->local->hw.workqueue, &sdata->u.mgd.work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.work);
 
 	err = 0;
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index e79aa7e..1da62e2 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -25,7 +25,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
 	/* make quiescing visible to timers everywhere */
 	mb();
 
-	flush_workqueue(local->hw.workqueue);
+	flush_workqueue(local->workqueue);
 
 	/* Don't try to run timers while suspended. */
 	del_timer_sync(&local->sta_cleanup);
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4573100..244f53f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -385,8 +385,9 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	spin_unlock_bh(&local->filter_lock);
 
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
-	queue_delayed_work(local->hw.workqueue, &local->scan_work,
-			   IEEE80211_CHANNEL_TIME);
+	ieee80211_queue_delayed_work(&local->hw,
+				     &local->scan_work,
+				     IEEE80211_CHANNEL_TIME);
 
 	return 0;
 }
@@ -715,8 +716,7 @@ void ieee80211_scan_work(struct work_struct *work)
 		}
 	} while (next_delay == 0);
 
-	queue_delayed_work(local->hw.workqueue, &local->scan_work,
-			   next_delay);
+	ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);
 }
 
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9b64f1b..d265d6f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1399,7 +1399,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 		if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 			ieee80211_stop_queues_by_reason(&local->hw,
 					IEEE80211_QUEUE_STOP_REASON_PS);
-			queue_work(local->hw.workqueue,
+			ieee80211_queue_work(&local->hw,
 					&local->dynamic_ps_disable_work);
 		}
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 988a2b8..e006fa6 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -511,6 +511,46 @@ void ieee80211_iterate_active_interfaces_atomic(
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
 
+/*
+ * Nothing should have been stuffed into the workqueue during
+ * the suspend->resume cycle. If this WARN is seen then there
+ * is a bug with either the driver suspend or something in
+ * mac80211 stuffing into the workqueue which we haven't yet
+ * cleared during mac80211's suspend cycle.
+ */
+static bool ieee80211_can_queue_work(struct ieee80211_local *local)
+{
+        if (WARN(local->suspended, "queueing ieee80211 work while "
+		 "going to suspend\n"))
+                return false;
+
+	return true;
+}
+
+void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (!ieee80211_can_queue_work(local))
+		return;
+
+	queue_work(local->workqueue, work);
+}
+EXPORT_SYMBOL(ieee80211_queue_work);
+
+void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
+				  struct delayed_work *dwork,
+				  unsigned long delay)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (!ieee80211_can_queue_work(local))
+		return;
+
+	queue_delayed_work(local->workqueue, dwork, delay);
+}
+EXPORT_SYMBOL(ieee80211_queue_delayed_work);
+
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems)
 {
@@ -1113,3 +1153,4 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 #endif
 	return 0;
 }
+
-- 
1.6.0.4

