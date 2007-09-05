Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124AbXIFNpp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:45:45 -0400
Message-Id: <20070905234625.092374000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 08/21] mac80211: document a lot more
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a lot more documentation (in kernel-doc format)
to include/net/mac80211.h

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/mac80211.h |  820 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 514 insertions(+), 306 deletions(-)

--- wireless-dev.orig/include/net/mac80211.h	2007-09-06 01:35:17.374453431 +0200
+++ wireless-dev/include/net/mac80211.h	2007-09-06 01:35:18.104453431 +0200
@@ -22,29 +22,51 @@
 #include <net/wireless.h>
 #include <net/cfg80211.h>
 
-/* Note! Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
+/**
+ * DOC: Introduction
+ *
+ * mac80211 is the Linux stack for 802.11 hardware that implements
+ * only partial functionality in hard- or firmware. This document
+ * defines the interface between mac80211 and low-level hardware
+ * drivers.
+ */
+
+/**
+ * DOC: Calling mac80211 from interrupts
+ *
+ * Only ieee80211_tx_status_irqsafe() and ieee80211_rx_irqsafe() can be
  * called in hardware interrupt context. The low-level driver must not call any
  * other functions in hardware interrupt context. If there is a need for such
  * call, the low-level driver should first ACK the interrupt and perform the
- * IEEE 802.11 code call after this, e.g., from a scheduled tasklet (in
- * software interrupt context).
+ * IEEE 802.11 code call after this, e.g. from a scheduled workqueue function.
  */
 
-/*
- * Frame format used when passing frame between low-level hardware drivers
- * and IEEE 802.11 driver the same as used in the wireless media, i.e.,
- * buffers start with IEEE 802.11 header and include the same octets that
- * are sent over air.
- *
- * If hardware uses IEEE 802.3 headers (and perform 802.3 <-> 802.11
- * conversion in firmware), upper layer 802.11 code needs to be changed to
- * support this.
- *
- * If the receive frame format is not the same as the real frame sent
- * on the wireless media (e.g., due to padding etc.), upper layer 802.11 code
- * could be updated to provide support for such format assuming this would
- * optimize the performance, e.g., by removing need to re-allocation and
- * copying of the data.
+/**
+ * DOC: Warning
+ *
+ * If you're reading this document and not the header file itself, it will
+ * be incomplete because not all documentation has been converted yet.
+ */
+
+/**
+ * DOC: Frame format
+ *
+ * As a general rule, when frames are passed between mac80211 and the driver,
+ * they start with the IEEE 802.11 header and include the same octets that are
+ * sent over the air except for the FCS which should be calculated by the
+ * hardware.
+ *
+ * There are, however, various exceptions to this rule for advanced features:
+ *
+ * The first exception is for hardware encryption and decryption offload
+ * where the IV/ICV may or may not be generated in hardware.
+ *
+ * Secondly, when the hardware handles fragmentation, the frame handed to
+ * the driver from mac80211 is the MSDU, not the MPDU.
+ *
+ * Finally, for received frames, the driver is able to indicate that it has
+ * filled a radiotap header and put that in front of the frame; if it does
+ * not do so then mac80211 may add this under certain circumstances.
  */
 
 #define IEEE80211_CHAN_W_SCAN 0x00000001
@@ -383,7 +405,7 @@ enum ieee80211_if_types {
  */
 struct ieee80211_if_init_conf {
 	int if_id;
-	int type;
+	enum ieee80211_if_types type;
 	void *mac_addr;
 };
 
@@ -558,371 +580,448 @@ enum ieee80211_hw_flags {
 
 /**
  * struct ieee80211_hw - hardware information and state
- * TODO: move documentation into kernel-doc format
+ *
+ * This structure contains the configuration and hardware
+ * information for an 802.11 PHY.
+ *
+ * @wiphy: This points to the &struct wiphy allocated for this
+ *	802.11 PHY. You must fill in the @perm_addr and @dev
+ *	members of this structure using SET_IEEE80211_DEV()
+ *	and SET_IEEE80211_PERM_ADDR().
+ *
+ * @conf: &struct ieee80211_conf, device configuration, don't use.
+ *
+ * @workqueue: single threaded workqueue available for driver use,
+ *	allocated by mac80211 on registration and flushed on
+ *	unregistration.
+ *
+ * @priv: pointer to private area that was allocated for driver use
+ *	along with this structure.
+ *
+ * @flags: hardware flags, see &enum ieee80211_hw_flags.
+ *
+ * @extra_tx_headroom: headroom to reserve in each transmit skb
+ *	for use by the driver (e.g. for transmit headers.)
+ *
+ * @channel_change_time: time (in microseconds) it takes to change channels.
+ *
+ * @max_rssi: Maximum value for ssi in RX information, use
+ *	negative numbers for dBm and 0 to indicate no support.
+ *
+ * @max_signal: like @max_rssi, but for the signal value.
+ *
+ * @max_noise: like @max_rssi, but for the noise value.
+ *
+ * @queues: number of available hardware transmit queues for
+ *	data packets. WMM/QoS requires at least four.
  */
 struct ieee80211_hw {
-	/* points to the cfg80211 wiphy for this piece. Note
-	 * that you must fill in the perm_addr and dev fields
-	 * of this structure, use the macros provided below. */
-	struct wiphy *wiphy;
-
-	/* assigned by mac80211, don't write */
 	struct ieee80211_conf conf;
-
-	/* Single thread workqueue available for driver use
-	 * Allocated by mac80211 on registration */
+	struct wiphy *wiphy;
 	struct workqueue_struct *workqueue;
-
-	/* Pointer to the private area that was
-	 * allocated with this struct for you. */
 	void *priv;
-
-	/* The rest is information about your hardware */
-
-	u32 flags;			/* hardware flags defined above */
-
-	/* Set to the size of a needed device specific skb headroom for TX skbs. */
+	u32 flags;
 	unsigned int extra_tx_headroom;
-
-	/* This is the time in us to change channels
-	 */
 	int channel_change_time;
-	/* Maximum values for various statistics.
-	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
+	u8 queues;
 	s8 max_rssi;
 	s8 max_signal;
 	s8 max_noise;
-
-	/* Number of available hardware TX queues for data packets.
-	 * WMM requires at least four queues. */
-	int queues;
 };
 
+/**
+ * SET_IEEE80211_DEV - set device for 802.11 hardware
+ *
+ * @hw: the &struct ieee80211_hw to set the device for
+ * @dev: the &struct device of this 802.11 device
+ */
 static inline void SET_IEEE80211_DEV(struct ieee80211_hw *hw, struct device *dev)
 {
 	set_wiphy_dev(hw->wiphy, dev);
 }
 
+/**
+ * SET_IEEE80211_PERM_ADDR - set the permanenet MAC address for 802.11 hardware
+ *
+ * @hw: the &struct ieee80211_hw to set the MAC address for
+ * @addr: the address to set
+ */
 static inline void SET_IEEE80211_PERM_ADDR(struct ieee80211_hw *hw, u8 *addr)
 {
 	memcpy(hw->wiphy->perm_addr, addr, ETH_ALEN);
 }
 
-/*
- * flags for change_filter_flags()
+/**
+ * DOC: Hardware crypto acceleration
+ *
+ * mac80211 is capable of taking advantage of many hardware
+ * acceleration designs for encryption and decryption operations.
+ *
+ * The set_key() callback in the &struct ieee80211_ops for a given
+ * device is called to enable hardware acceleration of encryption and
+ * decryption. The callback takes an @address parameter that will be
+ * the broadcast address for default keys, the other station's hardware
+ * address for individual keys or the zero address for keys that will
+ * be used only for transmission.
+ * Multiple transmission keys with the same key index may be used when
+ * VLANs are configured for an access point.
+ *
+ * The @local_address parameter will always be set to our own address,
+ * this is only relevant if you support multiple local addresses.
+ *
+ * When transmitting, the TX control data will use the @hw_key_idx
+ * selected by the driver by modifying the &struct ieee80211_key_conf
+ * pointed to by the @key parameter to the set_key() function.
+ *
+ * The set_key() call for the %SET_KEY command should return 0 if
+ * the key is now in use, -%EOPNOTSUPP or -%ENOSPC if it couldn't be
+ * added; if you return 0 then hw_key_idx must be assigned to the
+ * hardware key index, you are free to use the full u8 range.
+ *
+ * When the cmd is %DISABLE_KEY then it must succeed.
+ *
+ * Note that it is permissible to not decrypt a frame even if a key
+ * for it has been uploaded to hardware, the stack will not make any
+ * decision based on whether a key has been uploaded or not but rather
+ * based on the receive flags.
+ *
+ * The &struct ieee80211_key_conf structure pointed to by the @key
+ * parameter is guaranteed to be valid until another call to set_key()
+ * removes it, but it can only be used as a cookie to differentiate
+ * keys.
+ */
+
+/**
+ * DOC: Frame filtering
+ *
+ * mac80211 requires to see many management frames for proper
+ * operation, and users may want to see many more frames when
+ * in monitor mode. However, for best CPU usage and power consumption,
+ * having as few frames as possible percolate through the stack is
+ * desirable. Hence, the hardware should filter as much as possible.
+ *
+ * To achieve this, mac80211 uses filter flags (see below) to tell
+ * the driver's configure_filter() function which frames should be
+ * passed to mac80211 and which should be filtered out.
+ *
+ * If the device is capable of filtering for multicast addresses,
+ * you should set the %IEEE80211_HW_MULTICAST_FILTER flag in the
+ * hardware description.
+ *
+ * The configure_filter() callback is invoked with the parameters
+ * @get_mc_item and @get_mc_data allowing the driver to iterate the
+ * multicast addresses that should be added, @changed_flags telling
+ * which flags were changed, and @total_flags with the new flag states.
+ *
+ * If configure_filter() is called with a %NULL argument for @get_mc_item,
+ * this indicates that the multicast address list has not changed and
+ * previously cached values should be used, keep in mind that many filter
+ * flags including %FIF_ALLMULTI may change even when the multicast address
+ * list itself didn't change, hence, the driver may need to cache the list.
+ *
+ * All unsupported flags in @total_flags must be cleared, i.e. you
+ * should clear all bits except those you honoured.
+ */
+
+/**
+ * enum ieee80211_filter_flags - hardware filter flags
+ *
+ * These flags determine what the filter in hardware should be
+ * programmed to let through and what should not be passed to the
+ * stack. It is always safe to pass more frames than requested,
+ * but this has negative impact on power consumption.
+ *
+ * @FIF_PROMISC_IN_BSS: promiscuous mode within your BSS,
+ *	think of the BSS as your network segment and then this corresponds
+ *	to the regular ethernet device promiscuous mode.
+ *
+ * @FIF_ALLMULTI: pass all multicast frames, this is used if requested
+ *	by the user or if the hardware is not capable of filtering by
+ *	multicast address.
+ *
+ * @FIF_FCSFAIL: pass frames with failed FCS (but you need to set the
+ *	%RX_FLAG_FAILED_FCS_CRC for them)
+ *
+ * @FIF_PLCPFAIL: pass frames with failed PLCP CRC (but you need to set
+ *	the %RX_FLAG_FAILED_PLCP_CRC for them
+ *
+ * @FIF_BCN_PRBRESP_PROMISC: This flag is set during scanning to indicate
+ *	to the hardware that it should not filter beacons or probe responses
+ *	by BSSID. Filtering them can greatly reduce the amount of processing
+ *	mac80211 needs to do and the amount of CPU wakeups, so you should
+ *	honour this flag if possible.
+ *
+ * @FIF_CONTROL: pass control frames, if PROMISC_IN_BSS is not set then
+ *	only those addressed to this station
+ *
+ * @FIF_OTHER_BSS: pass frames destined to other BSSes
+ */
+enum ieee80211_filter_flags {
+	FIF_PROMISC_IN_BSS	= 1<<0,
+	FIF_ALLMULTI		= 1<<1,
+	FIF_FCSFAIL		= 1<<2,
+	FIF_PLCPFAIL		= 1<<3,
+	FIF_BCN_PRBRESP_PROMISC	= 1<<4,
+	FIF_CONTROL		= 1<<5,
+	FIF_OTHER_BSS		= 1<<6,
+};
+
+/**
+ * enum ieee80211_erp_change_flags - erp change flags
+ *
+ * These flags are used with the erp_ie_changed() callback in
+ * &struct ieee80211_ops to indicate which parameter(s) changed.
+ * @IEEE80211_ERP_CHANGE_PROTECTION: protection changed
+ * @IEEE80211_ERP_CHANGE_PREAMBLE: barker preamble mode changed
+ */
+enum ieee80211_erp_change_flags {
+	IEEE80211_ERP_CHANGE_PROTECTION	= 1<<0,
+	IEEE80211_ERP_CHANGE_PREAMBLE	= 1<<1,
+};
+
+
+/**
+ * struct ieee80211_ops - callbacks from mac80211 to the driver
+ *
+ * This structure contains various callbacks that the driver may
+ * handle or, in some cases, must handle, for example to configure
+ * the hardware to a new channel or to transmit a frame.
+ *
+ * @tx: Handler that 802.11 module calls for each transmitted frame.
+ *	skb contains the buffer starting from the IEEE 802.11 header.
+ *	The low-level driver should send the frame out based on
+ *	configuration in the TX control data. Must be implemented and
+ *	atomic.
+ *
+ * @start: Called before the first netdevice attached to the hardware
+ *	is enabled. This should turn on the hardware and must turn on
+ *	frame reception (for possibly enabled monitor interfaces.)
+ *	Returns negative error codes, these may be seen in userspace,
+ *	or zero.
+ *	When the device is started it should not have a MAC address
+ *	to avoid acknowledging frames before a non-monitor device
+ *	is added.
+ *	Must be implemented.
+ *
+ * @stop: Called after last netdevice attached to the hardware
+ *	is disabled. This should turn off the hardware (at least
+ *	it must turn off frame reception.)
+ *	May be called right after add_interface if that rejects
+ *	an interface.
+ *	Must be implemented.
+ *
+ * @add_interface: Called when a netdevice attached to the hardware is
+ *	enabled. Because it is not called for monitor mode devices, @open
+ *	and @stop must be implemented.
+ *	The driver should perform any initialization it needs before
+ *	the device can be enabled. The initial configuration for the
+ *	interface is given in the conf parameter.
+ *	The callback may refuse to add an interface by returning a
+ *	negative error code (which will be seen in userspace.)
+ *	Must be implemented.
+ *
+ * @remove_interface: Notifies a driver that an interface is going down.
+ *	The @stop callback is called after this if it is the last interface
+ *	and no monitor interfaces are present.
+ *	When all interfaces are removed, the MAC address in the hardware
+ *	must be cleared so the device no longer acknowledges packets,
+ *	the mac_addr member of the conf structure is, however, set to the
+ *	MAC address of the device going away.
+ *	Hence, this callback must be implemented.
+ *
+ * @config: Handler for configuration requests. IEEE 802.11 code calls this
+ *	function to change hardware configuration, e.g., channel.
+ *
+ * @config_interface: Handler for configuration requests related to interfaces
+ *	(e.g. BSSID changes.)
+ *
+ * @configure_filter: Configure the device's RX filter.
+ *	See the section "Frame filtering" for more information.
+ *	This callback must be implemented and atomic.
+ *
+ * @set_tim: Set TIM bit. If the hardware/firmware takes care of beacon
+ *	generation (that is, %IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE is set)
+ *	mac80211 calls this function when a TIM bit must be set or cleared
+ *	for a given AID. Must be atomic.
+ *
+ * @set_key: See the section "Hardware crypto acceleration"
+ *	This callback can sleep, and is only called between add_interface
+ *	and remove_interface calls, i.e. while the interface with the
+ *	given local_address is enabled.
+ *
+ * @set_ieee8021x: Enable/disable IEEE 802.1X. This item requests wlan card
+ *	to pass unencrypted EAPOL-Key frames even when encryption is
+ *	configured. If the wlan card does not require such a configuration,
+ *	this function pointer can be set to NULL.
+ * @set_port_auth: Set port authorization state (IEEE 802.1X PAE) to be
+ *	authorized (@authorized=1) or unauthorized (=0). This function can be
+ *	used if the wlan hardware or low-level driver implements PAE.
+ *	mac80211 will filter frames based on authorization state in any case,
+ *	so this function pointer can be NULL if low-level driver does not
+ *	require event notification about port state changes.
+ *
+ * @hw_scan: Ask the hardware to service the scan request, no need to start
+ *	the scan state machine in stack.
+ *
+ * @get_stats: return low-level statistics
+ *
+ * @set_privacy_invoked: For devices that generate their own beacons and probe
+ *	response or association responses this updates the state of privacy_invoked
+ *	returns 0 for success or an error number.
+ *
+ * @get_sequence_counter: For devices that have internal sequence counters this
+ *	callback allows mac80211 to access the current value of a counter.
+ *	This callback seems not well-defined, tell us if you need it.
+ *
+ * @set_rts_threshold: Configuration of RTS threshold (if device needs it)
+ *
+ * @set_frag_threshold: Configuration of fragmentation threshold. Assign this if
+ *	the device does fragmentation by itself; if this method is assigned then
+ *	the stack will not do fragmentation.
+ *
+ * @set_retry_limit: Configuration of retry limits (if device needs it)
  *
- * Note that e.g. if PROMISC_IN_BSS is unset then
- * you should still do MAC address filtering if
- * possible even if OTHER_BSS is set to indicate
- * no BSSID filtering should be done.
- */
-/*
- * promiscuous mode within your BSS,
- * think of the BSS as your network segment and then this corresponds
- * to the regular ethernet device promiscuous mode
- */
-#define FIF_PROMISC_IN_BSS	0x01
-/* show all multicast frames */
-#define FIF_ALLMULTI		0x02
-/* show frames with failed FCS, but set RX_FLAG_FAILED_FCS_CRC for them */
-#define FIF_FCSFAIL		0x04
-/* show frames with failed PLCP CRC, but set RX_FLAG_FAILED_PLCP_CRC for them */
-#define FIF_PLCPFAIL		0x08
-/*
- * This flag is set during scanning to indicate to the hardware
- * that it should not filter beacons or probe responses by BSSID.
- */
-#define FIF_BCN_PRBRESP_PROMISC	0x10
-/*
- * show control frames, if PROMISC_IN_BSS is not set then
- * only those addressed to this station
- */
-#define FIF_CONTROL		0x20
-/* show frames from other BSSes */
-#define FIF_OTHER_BSS		0x40
-
-/* Configuration block used by the low-level driver to tell the 802.11 code
- * about supported hardware features and to pass function pointers to callback
- * functions. */
+ * @sta_table_notification: Number of STAs in STA table notification. Must
+ *	be atomic.
+ *
+ * @erp_ie_changed: Handle ERP IE change notifications. Must be atomic.
+ *
+ * @conf_tx: Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
+ *	bursting) for a hardware TX queue. The @queue parameter uses the
+ *	%IEEE80211_TX_QUEUE_* constants. Must be atomic.
+ *
+ * @get_tx_stats: Get statistics of the current TX queue status. This is used
+ *	to get number of currently queued packets (queue length), maximum queue
+ *	size (limit), and total number of packets sent using each TX queue
+ *	(count). This information is used for WMM to find out which TX
+ *	queues have room for more packets and by hostapd to provide
+ *	statistics about the current queueing state to external programs.
+ *
+ * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
+ *	this is only used for IBSS mode debugging and, as such, is not a
+ *	required function. Must be atomic.
+ *
+ * @reset_tsf: Reset the TSF timer and allow firmware/hardware to synchronize
+ *	with other STAs in the IBSS. This is only used in IBSS mode. This
+ *	function is optional if the firmware/hardware takes full care of
+ *	TSF synchronization.
+ *
+ * @handle_ba_action: Call low level driver with 11n Block Ack action
+ *
+ * @conf_ht: Configure HT parameters.
+ *
+ * @get_ht_capab: Get HT capabilities from the device
+ *
+ * @beacon_update: Setup beacon data for IBSS beacons. Unlike access point,
+ *	IBSS uses a fixed beacon frame which is configured using this
+ *	function. This handler is required only for IBSS mode.
+ *
+ * @tx_last_beacon: Determine whether the last IBSS beacon was sent by us.
+ *	This is needed only for IBSS mode and the result of this function is
+ *	used to determine whether to reply to Probe Requests.
+ */
 struct ieee80211_ops {
-	/* Handler that 802.11 module calls for each transmitted frame.
-	 * skb contains the buffer starting from the IEEE 802.11 header.
-	 * The low-level driver should send the frame out based on
-	 * configuration in the TX control data.
-	 * Must be atomic. */
 	int (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb,
 		  struct ieee80211_tx_control *control);
-
-	/*
-	 * Called before the first netdevice attached to the hardware
-	 * is enabled. This should turn on the hardware and must turn on
-	 * frame reception (for possibly enabled monitor interfaces.)
-	 * Returns negative error codes, these may be seen in userspace,
-	 * or zero.
-	 * When the device is started it should not have a MAC address
-	 * to avoid acknowledging frames before a non-monitor device
-	 * is added.
-	 *
-	 * Must be implemented.
-	 */
 	int (*start)(struct ieee80211_hw *hw);
-
-	/*
-	 * Called after last netdevice attached to the hardware
-	 * is disabled. This should turn off the hardware (at least
-	 * it must turn off frame reception.)
-	 * May be called right after add_interface if that rejects
-	 * an interface.
-	 *
-	 * Must be implemented.
-	 */
 	void (*stop)(struct ieee80211_hw *hw);
-
-	/*
-	 * Called when a netdevice attached to the hardware is enabled.
-	 * Because it is not called for monitor mode devices, open()
-	 * and stop() must be implemented.
-	 * The driver should perform any initialization it needs before
-	 * the device can be enabled. The initial configuration for the
-	 * interface is given in the conf parameter.
-	 *
-	 * Must be implemented.
-	 */
 	int (*add_interface)(struct ieee80211_hw *hw,
 			     struct ieee80211_if_init_conf *conf);
-
-	/*
-	 * Notifies a driver that an interface is going down. The stop() handler
-	 * is called after this if it is the last interface and no monitor
-	 * interfaces are present.
-	 * When all interfaces are removed, the MAC address in the hardware
-	 * must be cleared so the device no longer acknowledges packets,
-	 * the mac_addr member of the conf structure is, however, set to the
-	 * MAC address of the device going away.
-	 *
-	 * Hence, this callback must be implemented.
-	 */
 	void (*remove_interface)(struct ieee80211_hw *hw,
 				 struct ieee80211_if_init_conf *conf);
-
-	/* Handler for configuration requests. IEEE 802.11 code calls this
-	 * function to change hardware configuration, e.g., channel. */
 	int (*config)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
-
-	/* Handler for configuration requests related to interfaces (e.g.
-	 * BSSID). */
 	int (*config_interface)(struct ieee80211_hw *hw,
 				int if_id, struct ieee80211_if_conf *conf);
-
-	/*
-	 * Configure the device's RX filter.
-	 *
-	 * If get_mc_item is assigned, then the multicast address filter
-	 * must be changed if the hardware flags indicate that one is
-	 * present. The get_mc_item function should be called until it
-	 * returns %NULL, it must be passed the @get_mc_data pointer
-	 * each time.
-	 *
-	 * All unsupported flags in 'total_flags' must be cleared,
-	 * clear all bits except those you honoured.
-	 *
-	 * The callback must be implemented and must be atomic.
-	 */
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 struct dev_mc_list *(get_mc_item)(void *data),
 				 void *get_mc_data,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags);
-
-	/* Set TIM bit handler. If the hardware/firmware takes care of beacon
-	 * generation, IEEE 802.11 code uses this function to tell the
-	 * low-level to set (or clear if set==0) TIM bit for the given aid. If
-	 * host system is used to generate beacons, this handler is not used
-	 * and low-level driver should set it to NULL.
-	 * Must be atomic. */
 	int (*set_tim)(struct ieee80211_hw *hw, int aid, int set);
-
-	/*
-	 * Set encryption key.
-	 *
-	 * This is called to enable hardware acceleration of encryption and
-	 * decryption. The address will be the broadcast address for default
-	 * keys, the other station's hardware address for individual keys or
-	 * the zero address for keys that will be used only for transmission.
-	 *
-	 * The local_address parameter will always be set to our own address,
-	 * this is only relevant if you support multiple local addresses.
-	 *
-	 * When transmitting, the TX control data will use the hw_key_idx
-	 * selected by the low-level driver.
-	 *
-	 * Return 0 if the key is now in use, -EOPNOTSUPP or -ENOSPC if it
-	 * couldn't be added; if you return 0 then hw_key_idx must be assigned
-	 * to the hardware key index, you are free to use the full u8 range.
-	 *
-	 * When the cmd is DISABLE_KEY then it must succeed.
-	 *
-	 * Note that it is permissible to not decrypt a frame even if a key
-	 * for it has been uploaded to hardware, the stack will not make any
-	 * decision based on whether a key has been uploaded or not but rather
-	 * based on the receive flags.
-	 *
-	 * This callback can sleep, and is only called between add_interface
-	 * and remove_interface calls, i.e. while the interface with the
-	 * given local_address is enabled.
-	 *
-	 * The ieee80211_key_conf structure pointed to by the key parameter
-	 * is guaranteed to be valid until another call to set_key removes
-	 * it, but it can only be used as a cookie to differentiate keys.
-	 */
 	int (*set_key)(struct ieee80211_hw *hw, set_key_cmd cmd,
 		       const u8 *local_address, const u8 *address,
 		       struct ieee80211_key_conf *key);
-
-	/* Enable/disable IEEE 802.1X. This item requests wlan card to pass
-	 * unencrypted EAPOL-Key frames even when encryption is configured.
-	 * If the wlan card does not require such a configuration, this
-	 * function pointer can be set to NULL. */
 	int (*set_ieee8021x)(struct ieee80211_hw *hw, int use_ieee8021x);
-
-	/* Set port authorization state (IEEE 802.1X PAE) to be authorized
-	 * (authorized=1) or unauthorized (authorized=0). This function can be
-	 * used if the wlan hardware or low-level driver implements PAE.
-	 * 80211.o module will anyway filter frames based on authorization
-	 * state, so this function pointer can be NULL if low-level driver does
-	 * not require event notification about port state changes. */
 	int (*set_port_auth)(struct ieee80211_hw *hw, u8 *addr,
 			     int authorized);
-
-	/* Ask the hardware to service the scan request, no need to start
-	 * the scan state machine in stack. */
 	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
-
-	/* return low-level statistics */
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
-
-	/* For devices that generate their own beacons and probe response
-	 * or association responses this updates the state of privacy_invoked
-	 * returns 0 for success or an error number */
 	int (*set_privacy_invoked)(struct ieee80211_hw *hw,
 				   int privacy_invoked);
-
-	/* For devices that have internal sequence counters, allow 802.11
-	 * code to access the current value of a counter */
 	int (*get_sequence_counter)(struct ieee80211_hw *hw,
 				    u8* addr, u8 keyidx, u8 txrx,
 				    u32* iv32, u16* iv16);
-
-	/* Configuration of RTS threshold (if device needs it) */
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
-
-	/* Configuration of fragmentation threshold.
-	 * Assign this if the device does fragmentation by itself,
-	 * if this method is assigned then the stack will not do
-	 * fragmentation. */
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
-
-	/* Configuration of retry limits (if device needs it) */
 	int (*set_retry_limit)(struct ieee80211_hw *hw,
 			       u32 short_retry, u32 long_retr);
-
-	/* Number of STAs in STA table notification (NULL = disabled).
-	 * Must be atomic. */
 	void (*sta_table_notification)(struct ieee80211_hw *hw,
 				       int num_sta);
-
-	/* Handle ERP IE change notifications. Must be atomic. */
 	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
 			       int cts_protection, int preamble);
-
-	/* Flags for the erp_ie_changed changes parameter */
-#define IEEE80211_ERP_CHANGE_PROTECTION (1<<0) /* protection flag changed */
-#define IEEE80211_ERP_CHANGE_PREAMBLE (1<<1) /* barker preamble mode changed */
-
-	/* Configure TX queue parameters (EDCF (aifs, cw_min, cw_max),
-	 * bursting) for a hardware TX queue.
-	 * queue = IEEE80211_TX_QUEUE_*.
-	 * Must be atomic. */
 	int (*conf_tx)(struct ieee80211_hw *hw, int queue,
 		       const struct ieee80211_tx_queue_params *params);
-
-	/* Get statistics of the current TX queue status. This is used to get
-	 * number of currently queued packets (queue length), maximum queue
-	 * size (limit), and total number of packets sent using each TX queue
-	 * (count). This information is used for WMM to find out which TX
-	 * queues have room for more packets and by hostapd to provide
-	 * statistics about the current queueing state to external programs. */
 	int (*get_tx_stats)(struct ieee80211_hw *hw,
 			    struct ieee80211_tx_queue_stats *stats);
-
-	/* Get the current TSF timer value from firmware/hardware. Currently,
-	 * this is only used for IBSS mode debugging and, as such, is not a
-	 * required function.
-	 * Must be atomic. */
 	u64 (*get_tsf)(struct ieee80211_hw *hw);
-
-	/* Reset the TSF timer and allow firmware/hardware to synchronize with
-	 * other STAs in the IBSS. This is only used in IBSS mode. This
-	 * function is optional if the firmware/hardware takes full care of
-	 * TSF synchronization. */
 	void (*reset_tsf)(struct ieee80211_hw *hw);
 
 #ifdef CONFIG_MAC80211_HT
-	/* Call low level driver with 11n Block Ack action */
 	int (*handle_ba_action)(struct ieee80211_hw *hw,
 				struct ieee80211_mgmt *mgmt);
-
-	/* Configure ht parameters. */
 	int (*conf_ht)(struct ieee80211_hw *hw,
 		       struct ieee80211_ht_capability *ht_cap_param,
 		       struct ieee80211_ht_additional_info *ht_extra_param);
-
-	/* Get ht capabilities from the device */
 	void (*get_ht_capab)(struct ieee80211_hw *hw,
 			     struct ieee80211_ht_capability *ht_cap_param);
-
 #endif /* CONFIG_MAC80211_HT */
 
-	/* Setup beacon data for IBSS beacons. Unlike access point (Master),
-	 * IBSS uses a fixed beacon frame which is configured using this
-	 * function. This handler is required only for IBSS mode. */
 	int (*beacon_update)(struct ieee80211_hw *hw,
 			     struct sk_buff *skb,
 			     struct ieee80211_tx_control *control);
-
-	/* Determine whether the last IBSS beacon was sent by us. This is
-	 * needed only for IBSS mode and the result of this function is used to
-	 * determine whether to reply to Probe Requests. */
 	int (*tx_last_beacon)(struct ieee80211_hw *hw);
 };
 
-/* Allocate a new hardware device. This must be called once for each
- * hardware device. The returned pointer must be used to refer to this
- * device when calling other functions. 802.11 code allocates a private data
- * area for the low-level driver. The size of this area is given as
- * priv_data_len.
+/**
+ * ieee80211_alloc_hw -  Allocate a new hardware device
+ *
+ * This must be called once for each hardware device. The returned pointer
+ * must be used to refer to this device when calling other functions.
+ * mac80211 allocates a private data area for the driver pointed to by
+ * @priv in &struct ieee80211_hw, the size of this area is given as
+ * @priv_data_len.
+ *
+ * @priv_data_len: length of private data
+ * @ops: callbacks for this device
  */
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops);
 
-/* Register hardware device to the IEEE 802.11 code and kernel. Low-level
- * drivers must call this function before using any other IEEE 802.11
- * function except ieee80211_register_hwmode. */
+/**
+ * ieee80211_register_hw - Register hardware device
+ *
+ * You must call this function before any other functions
+ * except ieee80211_register_hwmode.
+ *
+ * @hw: the device to register as returned by ieee80211_alloc_hw()
+ */
 int ieee80211_register_hw(struct ieee80211_hw *hw);
 
-/* driver can use this and ieee80211_get_rx_led_name to get the
- * name of the registered LEDs after ieee80211_register_hw
- * was called.
- * This is useful to set the default trigger on the LED class
- * device that your driver should export for each LED the device
- * has, that way the default behaviour will be as expected but
- * the user can still change it/turn off the LED etc.
- */
 #ifdef CONFIG_MAC80211_LEDS
 extern char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw);
 extern char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw);
 #endif
+/**
+ * ieee80211_get_tx_led_name - get name of TX LED
+ *
+ * mac80211 creates a transmit LED trigger for each wireless hardware
+ * that can be used to drive LEDs if your driver registers a LED device.
+ * This function returns the name (or %NULL if not configured for LEDs)
+ * of the trigger so you can automatically link the LED device.
+ *
+ * @hw: the hardware to get the LED trigger name for
+ */
 static inline char *ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
@@ -932,6 +1031,16 @@ static inline char *ieee80211_get_tx_led
 #endif
 }
 
+/**
+ * ieee80211_get_rx_led_name - get name of RX LED
+ *
+ * mac80211 creates a receive LED trigger for each wireless hardware
+ * that can be used to drive LEDs if your driver registers a LED device.
+ * This function returns the name (or %NULL if not configured for LEDs)
+ * of the trigger so you can automatically link the LED device.
+ *
+ * @hw: the hardware to get the LED trigger name for
+ */
 static inline char *ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
 {
 #ifdef CONFIG_MAC80211_LEDS
@@ -945,29 +1054,80 @@ static inline char *ieee80211_get_rx_led
 int ieee80211_register_hwmode(struct ieee80211_hw *hw,
 			      struct ieee80211_hw_mode *mode);
 
-/* Unregister a hardware device. This function instructs 802.11 code to free
- * allocated resources and unregister netdevices from the kernel. */
+/**
+ * ieee80211_unregister_hw - Unregister a hardware device
+ *
+ * This function instructs mac80211 to free allocated resources
+ * and unregister netdevices from the networking subsystem.
+ *
+ * @hw: the hardware to unregister
+ */
 void ieee80211_unregister_hw(struct ieee80211_hw *hw);
 
-/* Free everything that was allocated including private data of a driver. */
+/**
+ * ieee80211_free_hw - free hardware descriptor
+ *
+ * This function frees everything that was allocated, including the
+ * private data for the driver. You must call ieee80211_unregister_hw()
+ * before calling this function
+ *
+ * @hw: the hardware to free
+ */
 void ieee80211_free_hw(struct ieee80211_hw *hw);
 
-/* Receive frame callback function. The low-level driver uses this function to
- * send received frames to the IEEE 802.11 code. Receive buffer (skb) must
- * start with IEEE 802.11 header. */
+/* trick to avoid symbol clashes with the ieee80211 subsystem */
 void __ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
 		    struct ieee80211_rx_status *status);
+
+/**
+ * ieee80211_rx - receive frame
+ *
+ * Use this function to hand received frames to mac80211. The receive
+ * buffer in @skb must start with an IEEE 802.11 header or a radiotap
+ * header if %RX_FLAG_RADIOTAP is set in the @status flags.
+ *
+ * This function may not be called in IRQ context.
+ *
+ * @hw: the hardware this frame came in on
+ * @skb: the buffer to receive, owned by mac80211 after this call
+ * @status: status of this frame; the status pointer need not be valid
+ *	after this function returns
+ */
+static inline void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb,
+				struct ieee80211_rx_status *status)
+{
+	__ieee80211_rx(hw, skb, status);
+}
+
+/**
+ * ieee80211_rx_irqsafe - receive frame
+ *
+ * Like ieee80211_rx() but can be called in IRQ context
+ * (internally defers to a workqueue.)
+ *
+ * @hw: the hardware this frame came in on
+ * @skb: the buffer to receive, owned by mac80211 after this call
+ * @status: status of this frame; the status pointer need not be valid
+ *	after this function returns and is not freed by mac80211,
+ *	it is recommended that it points to a stack area
+ */
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw,
 			  struct sk_buff *skb,
 			  struct ieee80211_rx_status *status);
 
-/* Transmit status callback function. The low-level driver must call this
- * function to report transmit status for all the TX frames that had
- * req_tx_status set in the transmit control fields. In addition, this should
- * be called at least for all unicast frames to provide information for TX rate
- * control algorithm. In order to maintain all statistics, this function is
- * recommended to be called after each frame, including multicast/broadcast, is
- * sent. */
+/**
+ * ieee80211_tx_status - transmit status callback
+ *
+ * Call this function for all transmitted frames after they have been
+ * transmitted. It is permissible to not call this function for
+ * multicast frames but this can affect statistics.
+ *
+ * @hw: the hardware the frame was transmitted by
+ * @skb: the frame that was transmitted, owned by mac80211 after this call
+ * @status: status information for this frame; the status pointer need not
+ *	be valid after this function returns and is not freed by mac80211,
+ *	it is recommended that it points to a stack area
+ */
 void ieee80211_tx_status(struct ieee80211_hw *hw,
 			 struct sk_buff *skb,
 			 struct ieee80211_tx_status *status);
@@ -1099,14 +1259,26 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
 			  struct ieee80211_tx_control *control);
 
-/* Given an sk_buff with a raw 802.11 header at the data pointer this function
+/**
+ * ieee80211_get_hdrlen_from_skb - get header length from data
+ *
+ * Given an skb with a raw 802.11 header at the data pointer this function
  * returns the 802.11 header length in bytes (not including encryption
  * headers). If the data in the sk_buff is too short to contain a valid 802.11
  * header the function returns 0.
+ *
+ * @skb: the frame
  */
 int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb);
 
-/* Like ieee80211_get_hdrlen_from_skb() but takes a FC in CPU order. */
+/**
+ * ieee80211_get_hdrlen - get header length from frame control
+ *
+ * This function returns the 802.11 header length in bytes (not including
+ * encryption headers.)
+ *
+ * @fc: the frame control field (in CPU endianness)
+ */
 int ieee80211_get_hdrlen(u16 fc);
 
 /**
@@ -1151,10 +1323,28 @@ void ieee80211_stop_queues(struct ieee80
  */
 void ieee80211_wake_queues(struct ieee80211_hw *hw);
 
-/* called by driver to notify scan status completed */
+/**
+ * ieee80211_scan_completed - completed hardware scan
+ *
+ * When hardware scan offload is used (i.e. the hw_scan() callback is
+ * assigned) this function needs to be called by the driver to notify
+ * mac80211 that the scan finished.
+ *
+ * @hw: the hardware that finished the scan
+ */
 void ieee80211_scan_completed(struct ieee80211_hw *hw);
 
-/* return a pointer to the source address (SA) */
+/**
+ * ieee80211_get_SA - get pointer to SA
+ *
+ * Given an 802.11 frame, this function returns the offset
+ * to the source address (SA). It does not verify that the
+ * header is long enough to contain the address, and the
+ * header must be long enough to contain the frame control
+ * field.
+ *
+ * @hdr: the frame
+ */
 static inline u8 *ieee80211_get_SA(struct ieee80211_hdr *hdr)
 {
 	u8 *raw = (u8 *) hdr;
@@ -1169,7 +1359,17 @@ static inline u8 *ieee80211_get_SA(struc
 	return hdr->addr2;
 }
 
-/* return a pointer to the destination address (DA) */
+/**
+ * ieee80211_get_DA - get pointer to DA
+ *
+ * Given an 802.11 frame, this function returns the offset
+ * to the destination address (DA). It does not verify that
+ * the header is long enough to contain the address, and the
+ * header must be long enough to contain the frame control
+ * field.
+ *
+ * @hdr: the frame
+ */
 static inline u8 *ieee80211_get_DA(struct ieee80211_hdr *hdr)
 {
 	u8 *raw = (u8 *) hdr;
@@ -1180,6 +1380,14 @@ static inline u8 *ieee80211_get_DA(struc
 	return hdr->addr1;
 }
 
+/**
+ * ieee80211_get_morefrag - determine whether the MOREFRAGS bit is set
+ *
+ * This function determines whether the "more fragments" bit is set
+ * in the frame.
+ *
+ * @hdr: the frame
+ */
 static inline int ieee80211_get_morefrag(struct ieee80211_hdr *hdr)
 {
 	return (le16_to_cpu(hdr->frame_control) &

-- 

