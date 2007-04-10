Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40118 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030192AbXDJA6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2007 20:58:07 -0400
Message-ID: <461AE160.6060404@lwfinger.net>
Date: Mon, 09 Apr 2007 19:59:12 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] mac80211: Report correct wireless statistics
References: <461877ea.cyxM3SSnr6WhYkjX%Larry.Finger@lwfinger.net> <200704091316.23661.flamingice@sourmilk.net> <461AAC33.4030409@lwfinger.net> <200704091902.14301.flamingice@sourmilk.net>
In-Reply-To: <200704091902.14301.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
>>
> Absolutely - it is confusing since dBm can also be specified in addition to 
> RSSI. Renaming signal to qual or something along those lines would also be 
> useful IMHO, but if you're okay with it as it stands, I don't mind it.

I changed signal to qual and (r)ssi to level. Once these changes were made, iwconfig gives me the 
following:

Link Quality=57/100  Signal level=-37 dBm  Noise level=-70 dBm

The patch is pretty large and touches a lot of files, but if one is to be able to bisect around it, 
it has to be a single commit. As the patch entitled "[PATCH] bcm43xx-mac80211: Fix error in 
initiallizing max RSSI and max signal" has been accepted into Michael Buesch's tree, I have assumed 
that it is already included.

Larry
---

Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
@@ -3760,7 +3760,7 @@ static int bcm43xx_wireless_init(struct
  		    IEEE80211_HW_MONITOR_DURING_OPER |
  		    IEEE80211_HW_DEVICE_HIDES_WEP |
  		    IEEE80211_HW_WEP_INCLUDE_IV;
-	hw->max_signal = -110;
+	hw->max_qual = 100;
  	hw->max_rssi = BCM43xx_RX_MAX_SSI;
  	hw->max_noise = -110;
  	hw->queues = 1;
Index: wireless-dev/include/net/mac80211.h
===================================================================
--- wireless-dev.orig/include/net/mac80211.h
+++ wireless-dev/include/net/mac80211.h
@@ -227,8 +227,8 @@ struct ieee80211_rx_status {
  	int freq; /* receive frequency in Mhz */
  	int channel;
  	int phymode;
-	int ssi;
-	int signal; /* used as qual in statistics reporting */
+	int level;  /* used in statistics reporting */
+	int qual; /* used in statistics reporting */
  	int noise;
  	int antenna;
  	int rate;
@@ -540,7 +540,7 @@ struct ieee80211_hw {
  	/* Maximum values for various statistics.
  	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
  	s8 max_rssi;
-	s8 max_signal;
+	s8 max_qual;
  	s8 max_noise;

  	/* Number of available hardware TX queues for data packets.
Index: wireless-dev/net/mac80211/ieee80211.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211.c
+++ wireless-dev/net/mac80211/ieee80211.c
@@ -2705,7 +2705,7 @@ ieee80211_fill_frame_info(struct ieee802
  		fi->antenna = htonl(status->antenna);
  		fi->priority = 0xffffffff; /* no clue */
  		fi->ssi_type = htonl(ieee80211_ssi_raw);
-		fi->ssi_signal = htonl(status->ssi);
+		fi->ssi_signal = htonl(status->level);
  		fi->ssi_noise = 0x00000000;
  		fi->encoding = 0;
  	} else {
@@ -3352,10 +3352,10 @@ ieee80211_rx_h_sta_process(struct ieee80

  	sta->rx_fragments++;
  	sta->rx_bytes += rx->skb->len;
-	sta->last_rssi = (sta->last_rssi * 15 +
-			  rx->u.rx.status->ssi) / 16;
-	sta->last_signal = (sta->last_signal * 15 +
-			    rx->u.rx.status->signal) / 16;
+	sta->last_level = (sta->last_level * 15 +
+			  rx->u.rx.status->level) / 16;
+	sta->last_qual = (sta->last_qual * 15 +
+			    rx->u.rx.status->qual) / 16;
  	sta->last_noise = (sta->last_noise * 15 +
  			   rx->u.rx.status->noise) / 16;

@@ -4643,7 +4643,7 @@ int ieee80211_register_hw(struct ieee802

  	local->wstats_flags |= local->hw.max_rssi ?
  			       IW_QUAL_LEVEL_UPDATED : IW_QUAL_LEVEL_INVALID;
-	local->wstats_flags |= local->hw.max_signal ?
+	local->wstats_flags |= local->hw.max_qual ?
  			       IW_QUAL_QUAL_UPDATED : IW_QUAL_QUAL_INVALID;
  	local->wstats_flags |= local->hw.max_noise ?
  			       IW_QUAL_NOISE_UPDATED : IW_QUAL_NOISE_INVALID;
Index: wireless-dev/net/mac80211/ieee80211_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c
+++ wireless-dev/net/mac80211/ieee80211_sta.c
@@ -1192,8 +1192,8 @@ static void ieee80211_rx_mgmt_assoc_resp
  		}
  		bss = ieee80211_rx_bss_get(dev, ifsta->bssid);
  		if (bss) {
-			sta->last_rssi = bss->rssi;
-			sta->last_signal = bss->signal;
+			sta->last_level = bss->level;
+			sta->last_qual = bss->qual;
  			sta->last_noise = bss->noise;
  			ieee80211_rx_bss_put(dev, bss);
  		}
@@ -1582,8 +1582,8 @@ static void ieee80211_rx_bss_info(struct
  	}
  	bss->timestamp = timestamp;
  	bss->last_update = jiffies;
-	bss->rssi = rx_status->ssi;
-	bss->signal = rx_status->signal;
+	bss->level = rx_status->level;
+	bss->qual = rx_status->qual;
  	bss->noise = rx_status->noise;
  	if (!beacon)
  		bss->probe_resp++;
@@ -2060,7 +2060,7 @@ static int ieee80211_sta_config_auth(str
  	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
  	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
  	struct ieee80211_sta_bss *bss, *selected = NULL;
-	int top_rssi = 0, freq;
+	int top_level = 0, freq;

  	if (!ifsta->auto_channel_sel && !ifsta->auto_bssid_sel &&
  	    !ifsta->auto_ssid_sel) {
@@ -2090,9 +2090,9 @@ static int ieee80211_sta_config_auth(str
  		    !ieee80211_sta_match_ssid(ifsta, bss->ssid, bss->ssid_len))
  			continue;

-		if (top_rssi < bss->rssi) {
+		if (top_level < bss->level) {
  			selected = bss;
-			top_rssi = bss->rssi;
+			top_level = bss->level;
  		}
  	}
  	if (selected)
@@ -2822,8 +2822,8 @@ ieee80211_sta_scan_result(struct net_dev

  	memset(&iwe, 0, sizeof(iwe));
  	iwe.cmd = IWEVQUAL;
-	iwe.u.qual.qual = bss->signal;
-	iwe.u.qual.level = bss->rssi;
+	iwe.u.qual.qual = bss->qual;
+	iwe.u.qual.level = bss->level;
  	iwe.u.qual.noise = bss->noise;
  	iwe.u.qual.updated = local->wstats_flags;
  	current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
@@ -2908,7 +2908,7 @@ ieee80211_sta_scan_result(struct net_dev

  		memset(&iwe, 0, sizeof(iwe));
  		iwe.cmd = IWEVCUSTOM;
-		sprintf(buf, "rssi=%d", bss->rssi);
+		sprintf(buf, "level=%d", bss->level);
  		iwe.u.data.length = strlen(buf);
  		current_ev = iwe_stream_add_point(current_ev, end_buf, &iwe,
  						  buf);
Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_xmit.c
@@ -460,7 +460,7 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
  	u16 phystat0, phystat3, chanstat, mactime;
  	u32 macstat;
  	u16 chanid;
-	u8 jssi;
+	u8 qual;
  	int padding;

  	memset(&status, 0, sizeof(status));
@@ -468,7 +468,7 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
  	/* Get metadata about the frame from the header. */
  	phystat0 = le16_to_cpu(rxhdr->phy_status0);
  	phystat3 = le16_to_cpu(rxhdr->phy_status3);
-	jssi = rxhdr->jssi;
+	qual = rxhdr->jssi;
  	macstat = le32_to_cpu(rxhdr->mac_status);
  	mactime = le16_to_cpu(rxhdr->mac_time);
  	chanstat = le16_to_cpu(rxhdr->channel);
@@ -529,12 +529,12 @@ void bcm43xx_rx(struct bcm43xx_wldev *de
  		}
  	}

-	status.signal = bcm43xx_rssi_postprocess(dev, jssi,
+	status.level = bcm43xx_rssi_postprocess(dev, qual,
  					      (phystat0 & BCM43xx_RX_PHYST0_OFDM),
  					      (phystat0 & BCM43xx_RX_PHYST0_GAINCTL),
  					      (phystat3 & BCM43xx_RX_PHYST3_TRSTATE));
  	status.noise = dev->stats.link_noise;
-	status.ssi = jssi;
+	status.qual = qual;
  	if (phystat0 & BCM43xx_RX_PHYST0_OFDM)
  		status.rate = bcm43xx_plcp_get_bitrate_ofdm(plcp);
  	else
Index: wireless-dev/net/mac80211/debugfs_sta.c
===================================================================
--- wireless-dev.orig/net/mac80211/debugfs_sta.c
+++ wireless-dev/net/mac80211/debugfs_sta.c
@@ -76,8 +76,8 @@ STA_FILE(txrate, txrate, RATE);
  STA_FILE(last_txrate, last_txrate, RATE);
  STA_FILE(tx_retry_failed, tx_retry_failed, LU);
  STA_FILE(tx_retry_count, tx_retry_count, LU);
-STA_FILE(last_rssi, last_rssi, D);
-STA_FILE(last_signal, last_signal, D);
+STA_FILE(last_level, last_level, D);
+STA_FILE(last_qual, last_qual, D);
  STA_FILE(last_noise, last_noise, D);
  STA_FILE(channel_use, channel_use, D);
  STA_FILE(wep_weak_iv_count, wep_weak_iv_count, D);
Index: wireless-dev/net/mac80211/ieee80211_i.h
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_i.h
+++ wireless-dev/net/mac80211/ieee80211_i.h
@@ -82,7 +82,7 @@ struct ieee80211_sta_bss {
  	int hw_mode;
  	int channel;
  	int freq;
-	int rssi, signal, noise;
+	int level, qual, noise;
  	u8 *wpa_ie;
  	size_t wpa_ie_len;
  	u8 *rsn_ie;
Index: wireless-dev/net/mac80211/ieee80211_ioctl.c
===================================================================
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c
@@ -445,7 +445,7 @@ static int ieee80211_ioctl_get_info_sta(
  		skb_queue_len(&sta->ps_tx_buf);
  	param->u.get_info_sta.tx_retry_failed = sta->tx_retry_failed;
  	param->u.get_info_sta.tx_retry_count = sta->tx_retry_count;
-	param->u.get_info_sta.last_rssi = sta->last_rssi;
+	param->u.get_info_sta.last_rssi = sta->last_level;
  	param->u.get_info_sta.last_ack_rssi = sta->last_ack_rssi[2];

  	sta_info_put(sta);
@@ -1593,12 +1593,12 @@ static int ieee80211_ioctl_giwrange(stru
  	range->min_frag = 256;
  	range->max_frag = 2346;

-	range->max_qual.qual = local->hw.max_signal;
+	range->max_qual.qual = local->hw.max_qual;
  	range->max_qual.level = local->hw.max_rssi;
  	range->max_qual.noise = local->hw.max_noise;
  	range->max_qual.updated = local->wstats_flags;

-	range->avg_qual.qual = local->hw.max_signal/2;
+	range->avg_qual.qual = local->hw.max_qual/2;
  	range->avg_qual.level = 0;
  	range->avg_qual.noise = 0;
  	range->avg_qual.updated = local->wstats_flags;
@@ -3084,8 +3084,8 @@ static struct iw_statistics *ieee80211_g
  		wstats->qual.noise = 0;
  		wstats->qual.updated = IW_QUAL_ALL_INVALID;
  	} else {
-		wstats->qual.level = sta->last_rssi;
-		wstats->qual.qual = sta->last_signal;
+		wstats->qual.level = sta->last_level;
+		wstats->qual.qual = sta->last_qual;
  		wstats->qual.noise = sta->last_noise;
  		wstats->qual.updated = local->wstats_flags;
  		sta_info_put(sta);
Index: wireless-dev/net/mac80211/sta_info.h
===================================================================
--- wireless-dev.orig/net/mac80211/sta_info.h
+++ wireless-dev/net/mac80211/sta_info.h
@@ -82,8 +82,8 @@ struct sta_info {
  	unsigned long rx_fragments; /* number of received MPDUs */
  	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */

-	int last_rssi; /* RSSI of last received frame from this STA */
-	int last_signal; /* signal of last received frame from this STA */
+	int last_level; /* level of last received frame from this STA */
+	int last_qual; /* qual of last received frame from this STA */
  	int last_noise; /* noise of last received frame from this STA */
  	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
  	unsigned long last_ack;
Index: wireless-dev/drivers/net/wireless/mac80211/adm8211/adm8211.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/adm8211/adm8211.c
+++ wireless-dev/drivers/net/wireless/mac80211/adm8211/adm8211.c
@@ -540,9 +540,9 @@ static void adm8211_interrupt_rci(struct
  			struct ieee80211_rx_status rx_status = {0};

  			if (priv->revid < ADM8211_REV_CA)
-				rx_status.ssi = rssi;
+				rx_status.level = rssi;
  			else
-				rx_status.ssi = 100 - rssi;
+				rx_status.level = 100 - rssi;

  			if (rate <= 4)
  				rx_status.rate = rate_tbl[rate];
Index: wireless-dev/drivers/net/wireless/mac80211/p54/prism54common.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/p54/prism54common.c
+++ wireless-dev/drivers/net/wireless/mac80211/p54/prism54common.c
@@ -282,7 +282,7 @@ static void p54_rx_data(struct ieee80211
  	struct ieee80211_rx_status rx_status = {0};
  	u16 freq = le16_to_cpu(hdr->freq);

-	rx_status.ssi = hdr->rssi;	/* TODO: check this */
+	rx_status.level = hdr->rssi;	/* TODO: check this */
  	rx_status.rate = min(hdr->rate + 1, 12);	/* TODO: check this */
  	rx_status.channel = freq == 2484 ? 14 : (freq - 2407)/5;
  	rx_status.freq = freq;
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500pci.c
@@ -1742,7 +1742,7 @@ static void rt2500pci_rxdone(struct work
  		 * Update link statistics
  		 */
  		rt2x00_update_link_rssi(&rt2x00dev->link,
-			rt2x00dev->rx_status.ssi);
+			rt2x00dev->rx_status.level);

  skip_entry:
  		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2500usb.c
@@ -1702,7 +1702,7 @@ static void rt2500usb_interrupt_rxdone(s
  	/*
  	 * Update link statistics
  	 */
-	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.ssi);
+	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.level);

  skip_entry:
  	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt2x00dev.c
@@ -157,7 +157,7 @@ void rt2x00lib_update_rx_stats(struct rt
  	}

  	rt2x00dev->rx_status.rate = val;
-	rt2x00dev->rx_status.ssi = rssi;
+	rt2x00dev->rx_status.level = rssi;
  	rt2x00dev->rx_status.noise = rt2x00_get_link_noise(&rt2x00dev->link);
  }
  EXPORT_SYMBOL_GPL(rt2x00lib_update_rx_stats);
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -2047,7 +2047,7 @@ static void rt61pci_rxdone(struct work_s
  		 * Update link statistics
  		 */
  		rt2x00_update_link_rssi(&rt2x00dev->link,
-			rt2x00dev->rx_status.ssi);
+			rt2x00dev->rx_status.level);

  skip_entry:
  		rt2x00_set_field32(&word0, RXD_W0_OWNER_NIC, 1);
Index: wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ wireless-dev/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1858,7 +1858,7 @@ static void rt73usb_interrupt_rxdone(str
  	/*
  	 * Update link statistics
  	 */
-	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.ssi);
+	rt2x00_update_link_rssi(&rt2x00dev->link, rt2x00dev->rx_status.level);

  skip_entry:
  	if (!GET_FLAG(ring->rt2x00dev, DEVICE_ENABLED_RADIO))
Index: wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
+++ wireless-dev/drivers/net/wireless/mac80211/rtl818x/rtl8187_dev.c
@@ -161,8 +161,8 @@ static void rtl8187_rx_cb(struct urb *ur
  	}

  	rx_status.antenna = (hdr->signal >> 7) & 1;
-	rx_status.signal = 64 - min(hdr->noise, (u8)64);
-	rx_status.ssi = signal;
+	rx_status.qual = 64 - min(hdr->noise, (u8)64);
+	rx_status.level = signal;
  	rx_status.rate = priv->rates[rate].rate;
  	rx_status.freq = dev->conf.freq;
  	rx_status.channel = dev->conf.channel;
@@ -609,7 +609,7 @@ static int __devinit rtl8187_probe(struc
  	dev->extra_tx_headroom = sizeof(struct rtl8187_tx_hdr);
  	dev->queues = 1;
  	dev->max_rssi = 65;
-	dev->max_signal = 64;
+	dev->max_qual = 64;

  	for (i = 0; i < 2; i++)
  		if ((err = ieee80211_register_hwmode(dev, &priv->modes[i])))
Index: wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ wireless-dev/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -407,8 +407,8 @@ static int fill_rx_stats(struct ieee8021
  	stats->channel = _zd_chip_get_channel(&mac->chip);
  	stats->freq = zd_channels[stats->channel - 1].freq;
  	stats->phymode = MODE_IEEE80211G;
-	stats->ssi = zd_rx_strength_percent(status->signal_strength);
-	stats->signal = zd_rx_qual_percent(buffer,
+	stats->level = zd_rx_strength_percent(status->signal_strength);
+	stats->qual = zd_rx_qual_percent(buffer,
  		                          length - sizeof(struct rx_status),
  		                          status);
  	stats->rate = zd_rx_rate(buffer, status);
@@ -453,7 +453,7 @@ static int filter_ack(struct ieee80211_h
  	if (control) {
  		memcpy(&status.control, control, sizeof(status.control));
  		status.flags = IEEE80211_TX_STATUS_ACK;
-		status.ack_signal = stats->ssi;
+		status.ack_signal = stats->level;
  		ieee80211_tx_status_irqsafe(dev, skb, &status);
  		kfree(control);
  	} else
@@ -631,7 +631,7 @@ struct ieee80211_hw *zd_mac_alloc(struct
  	dev->flags = IEEE80211_HW_RX_INCLUDES_FCS |
  		     IEEE80211_HW_WEP_INCLUDE_IV;
  	dev->max_rssi = 100;
-	dev->max_signal = 100;
+	dev->max_qual = 100;

  	dev->queues = 1;
  	dev->extra_tx_headroom = sizeof(struct zd_ctrlset);

----



