Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45620 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755819AbeEaR42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 13:56:28 -0400
Date: Thu, 31 May 2018 10:56:20 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [RFTv3 8/6] wlcore: Enable runtime PM autosuspend support
Message-ID: <20180531175620.GS5705@atomide.com> (sfid-20180531_195634_867704_B7CBAAFA)
References: <20180529180605.73622-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180529180605.73622-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With runtime PM tested working for wlcore with no autosuspend, we can
now enable autosuspend to cut down on enable/disable for interrupts.
Basically we just replace pm_runtime_put() with the autosuspend variants.

Let's use autosuspend delay of 50ms that MMC drivers typically use.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---

And here's the patch to test to enable autosuspend assuming people
don't find issues with the earlier patches in this series.

---
 drivers/net/wireless/ti/wl18xx/debugfs.c    |   9 +-
 drivers/net/wireless/ti/wlcore/cmd.c        |   3 +-
 drivers/net/wireless/ti/wlcore/debugfs.c    |  33 ++++--
 drivers/net/wireless/ti/wlcore/main.c       | 111 +++++++++++++-------
 drivers/net/wireless/ti/wlcore/scan.c       |   3 +-
 drivers/net/wireless/ti/wlcore/sysfs.c      |   3 +-
 drivers/net/wireless/ti/wlcore/testmode.c   |   6 +-
 drivers/net/wireless/ti/wlcore/tx.c         |   3 +-
 drivers/net/wireless/ti/wlcore/vendor_cmd.c |   9 +-
 9 files changed, 121 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -288,7 +288,8 @@ static ssize_t radar_detection_write(struct file *file,
 	if (ret < 0)
 		count = ret;
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
@@ -329,7 +330,8 @@ static ssize_t dynamic_fw_traces_write(struct file *file,
 	if (ret < 0)
 		count = ret;
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
@@ -392,7 +394,8 @@ static ssize_t radar_debug_mode_write(struct file *file,
 				       wl->radar_debug_mode, 0);
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
diff --git a/drivers/net/wireless/ti/wlcore/cmd.c b/drivers/net/wireless/ti/wlcore/cmd.c
--- a/drivers/net/wireless/ti/wlcore/cmd.c
+++ b/drivers/net/wireless/ti/wlcore/cmd.c
@@ -230,7 +230,8 @@ int wlcore_cmd_wait_for_event_or_timeout(struct wl1271 *wl,
 	} while (!event);
 
 out:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 	kfree(events_vector);
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -79,7 +79,8 @@ void wl1271_debugfs_update_stats(struct wl1271 *wl)
 		wl->stats.fw_stats_update = jiffies;
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -131,7 +132,8 @@ static void chip_op_handler(struct wl1271 *wl, unsigned long value,
 	chip_op = arg;
 	chip_op(wl);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 }
 
 
@@ -313,7 +315,8 @@ static ssize_t dynamic_ps_timeout_write(struct file *file,
 			wl1271_ps_set_mode(wl, wlvif, STATION_AUTO_PS_MODE);
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -384,7 +387,8 @@ static ssize_t forced_ps_write(struct file *file,
 			wl1271_ps_set_mode(wl, wlvif, ps_mode);
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -858,7 +862,8 @@ static ssize_t rx_streaming_interval_write(struct file *file,
 		wl1271_recalc_rx_streaming(wl, wlvif);
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
@@ -915,7 +920,8 @@ static ssize_t rx_streaming_always_write(struct file *file,
 		wl1271_recalc_rx_streaming(wl, wlvif);
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
@@ -964,7 +970,8 @@ static ssize_t beacon_filtering_write(struct file *file,
 		ret = wl1271_acx_beacon_filter_opt(wl, wlvif, !!value);
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
@@ -1046,7 +1053,8 @@ static ssize_t sleep_auth_write(struct file *file,
 		goto out_sleep;
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return count;
@@ -1120,7 +1128,8 @@ static ssize_t dev_mem_read(struct file *file,
 		goto part_err;
 
 part_err:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 skip_read:
 	mutex_unlock(&wl->mutex);
@@ -1201,7 +1210,8 @@ static ssize_t dev_mem_write(struct file *file, const char __user *user_buf,
 		goto part_err;
 
 part_err:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 skip_write:
 	mutex_unlock(&wl->mutex);
@@ -1276,7 +1286,8 @@ static ssize_t fw_logger_write(struct file *file,
 
 	ret = wl12xx_cmd_config_fwlog(wl);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -170,7 +170,8 @@ static void wl1271_rx_streaming_enable_work(struct work_struct *work)
 		  jiffies + msecs_to_jiffies(wl->conf.rx_streaming.duration));
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -198,7 +199,8 @@ static void wl1271_rx_streaming_disable_work(struct work_struct *work)
 		goto out_sleep;
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -251,7 +253,8 @@ static void wlcore_rc_update_work(struct work_struct *work)
 	}
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -650,7 +653,8 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	return ret;
@@ -977,7 +981,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	}
 
 	wlcore_op_stop_locked(wl);
-	pm_runtime_put_sync(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 	ieee80211_restart_hw(wl->hw);
 
@@ -1875,7 +1880,8 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		goto out_sleep;
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	wl->wow_enabled = false;
@@ -2064,7 +2070,8 @@ static void wlcore_channel_switch_work(struct work_struct *work)
 
 	wl12xx_cmd_stop_channel_switch(wl, wlvif);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -2135,7 +2142,8 @@ static void wlcore_pending_auth_complete_work(struct work_struct *work)
 	/* cancel the ROC if active */
 	wlcore_update_inconn_sta(wl, wlvif, NULL, false);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -2629,7 +2637,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	else
 		wl->sta_count++;
 out:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out_unlock:
 	mutex_unlock(&wl->mutex);
 
@@ -2706,7 +2715,8 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 				goto deinit;
 		}
 
-		pm_runtime_put(wl->dev);
+		pm_runtime_mark_last_busy(wl->dev);
+		pm_runtime_put_autosuspend(wl->dev);
 	}
 deinit:
 	wl12xx_tx_reset_wlvif(wl, wlvif);
@@ -3144,7 +3154,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -3260,7 +3271,8 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	 */
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -3475,7 +3487,8 @@ static int wlcore_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	ret = wlcore_hw_set_key(wl, cmd, vif, sta, key_conf);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out_wake_queues:
 	if (might_change_spare)
@@ -3633,7 +3646,8 @@ static void wl1271_op_set_default_key_idx(struct ieee80211_hw *hw,
 	}
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out_unlock:
 	mutex_unlock(&wl->mutex);
@@ -3661,7 +3675,8 @@ void wlcore_regdomain_config(struct wl1271 *wl)
 		goto out;
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -3710,7 +3725,8 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 
 	ret = wlcore_scan(hw->priv, vif, ssid, len, req);
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -3762,7 +3778,8 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 	ieee80211_scan_completed(wl->hw, &info);
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -3800,7 +3817,8 @@ static int wl1271_op_sched_scan_start(struct ieee80211_hw *hw,
 	wl->sched_vif = wlvif;
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return ret;
@@ -3828,7 +3846,8 @@ static int wl1271_op_sched_scan_stop(struct ieee80211_hw *hw,
 
 	wl->ops->sched_scan_stop(wl, wlvif);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -3857,7 +3876,8 @@ static int wl1271_op_set_frag_threshold(struct ieee80211_hw *hw, u32 value)
 	if (ret < 0)
 		wl1271_warning("wl1271_op_set_frag_threshold failed: %d", ret);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -3889,7 +3909,8 @@ static int wl1271_op_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 		if (ret < 0)
 			wl1271_warning("set rts threshold failed: %d", ret);
 	}
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -4657,7 +4678,8 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	else
 		wl1271_bss_info_changed_sta(wl, vif, bss_conf, changed);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -4723,7 +4745,8 @@ static void wlcore_op_change_chanctx(struct ieee80211_hw *hw,
 		}
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -4772,7 +4795,8 @@ static int wlcore_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 		wlvif->radar_enabled = true;
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -4815,7 +4839,8 @@ static void wlcore_op_unassign_vif_chanctx(struct ieee80211_hw *hw,
 		wlvif->radar_enabled = false;
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -4886,7 +4911,8 @@ wlcore_op_switch_vif_chanctx(struct ieee80211_hw *hw,
 			goto out_sleep;
 	}
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -4940,7 +4966,8 @@ static int wl1271_op_conf_tx(struct ieee80211_hw *hw,
 				 0, 0);
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -4975,7 +5002,8 @@ static u64 wl1271_op_get_tsf(struct ieee80211_hw *hw,
 		goto out_sleep;
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -5289,7 +5317,8 @@ static int wl12xx_op_sta_state(struct ieee80211_hw *hw,
 
 	ret = wl12xx_update_sta_state(wl, wlvif, sta, old_state, new_state);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	if (new_state < old_state)
@@ -5415,7 +5444,8 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -5460,7 +5490,8 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 			wl1271_tx_min_rate_get(wl, wlvif->basic_rate_set);
 		ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 
-		pm_runtime_put(wl->dev);
+		pm_runtime_mark_last_busy(wl->dev);
+		pm_runtime_put_autosuspend(wl->dev);
 	}
 out:
 	mutex_unlock(&wl->mutex);
@@ -5516,7 +5547,8 @@ static void wl12xx_op_channel_switch(struct ieee80211_hw *hw,
 	}
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -5596,7 +5628,8 @@ static void wlcore_op_channel_switch_beacon(struct ieee80211_hw *hw,
 	set_bit(WLVIF_FLAG_CS_PROGRESS, &wlvif->flags);
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -5651,7 +5684,8 @@ static int wlcore_op_remain_on_channel(struct ieee80211_hw *hw,
 	ieee80211_queue_delayed_work(hw, &wl->roc_complete_work,
 				     msecs_to_jiffies(duration));
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 	return ret;
@@ -5701,7 +5735,8 @@ static int wlcore_roc_completed(struct wl1271 *wl)
 
 	ret = __wlcore_roc_completed(wl);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -5790,7 +5825,8 @@ static void wlcore_op_sta_statistics(struct ieee80211_hw *hw,
 	sinfo->signal = rssi_dbm;
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 out:
 	mutex_unlock(&wl->mutex);
@@ -6754,6 +6790,8 @@ int wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	}
 
 	wl->dev->driver->pm = &wlcore_pm_ops;
+	pm_runtime_set_autosuspend_delay(wl->dev, 50);
+	pm_runtime_use_autosuspend(wl->dev);
 	pm_runtime_enable(wl->dev);
 
 	return ret;
@@ -6784,6 +6822,7 @@ int wlcore_remove(struct platform_device *pdev)
 	wl1271_unregister_hw(wl);
 
 	pm_runtime_put_sync(wl->dev);
+	pm_runtime_dont_use_autosuspend(wl->dev);
 	pm_runtime_disable(wl->dev);
 
 	free_irq(wl->irq, wl);
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -85,7 +85,8 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	wlcore_cmd_regdomain_config_locked(wl);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
 	ieee80211_scan_completed(wl->hw, &info);
 
diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -77,7 +77,8 @@ static ssize_t wl1271_sysfs_store_bt_coex_state(struct device *dev,
 	}
 
 	wl1271_acx_sg_enable(wl, wl->sg_enabled);
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 
  out:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/ti/wlcore/testmode.c b/drivers/net/wireless/ti/wlcore/testmode.c
--- a/drivers/net/wireless/ti/wlcore/testmode.c
+++ b/drivers/net/wireless/ti/wlcore/testmode.c
@@ -143,7 +143,8 @@ static int wl1271_tm_cmd_test(struct wl1271 *wl, struct nlattr *tb[])
 	}
 
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -209,7 +210,8 @@ static int wl1271_tm_cmd_interrogate(struct wl1271 *wl, struct nlattr *tb[])
 out_free:
 	kfree(cmd);
 out_sleep:
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -881,7 +881,8 @@ void wl1271_tx_work(struct work_struct *work)
 		goto out;
 	}
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 }
diff --git a/drivers/net/wireless/ti/wlcore/vendor_cmd.c b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
--- a/drivers/net/wireless/ti/wlcore/vendor_cmd.c
+++ b/drivers/net/wireless/ti/wlcore/vendor_cmd.c
@@ -65,7 +65,8 @@ wlcore_vendor_cmd_smart_config_start(struct wiphy *wiphy,
 	ret = wlcore_smart_config_start(wl,
 			nla_get_u32(tb[WLCORE_VENDOR_ATTR_GROUP_ID]));
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -98,7 +99,8 @@ wlcore_vendor_cmd_smart_config_stop(struct wiphy *wiphy,
 
 	ret = wlcore_smart_config_stop(wl);
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -147,7 +149,8 @@ wlcore_vendor_cmd_smart_config_set_group_key(struct wiphy *wiphy,
 			nla_len(tb[WLCORE_VENDOR_ATTR_GROUP_KEY]),
 			nla_data(tb[WLCORE_VENDOR_ATTR_GROUP_KEY]));
 
-	pm_runtime_put(wl->dev);
+	pm_runtime_mark_last_busy(wl->dev);
+	pm_runtime_put_autosuspend(wl->dev);
 out:
 	mutex_unlock(&wl->mutex);
 
-- 
2.17.0
