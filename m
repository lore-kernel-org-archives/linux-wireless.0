Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:21008 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYGNPxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 11:53:19 -0400
Date: Mon, 14 Jul 2008 08:51:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH -next] mac80211: fix lots of kernel-doc
Message-Id: <20080714085154.4fae0a29.randy.dunlap@oracle.com> (sfid-20080714_175323_826159_E91748DC)
In-Reply-To: <20080703135218.fddcac59.randy.dunlap@oracle.com>
References: <20080703135218.fddcac59.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 3 Jul 2008 13:52:18 -0700 Randy Dunlap wrote:

ping ??

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix more than 50 kernel-doc warnings in ieee80211/mac80211 kernel-doc notation.
> Fix a few typos also.
> 
> Note: Some fields are marked as TBD and need to have their description
> corrected.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/net/mac80211.h  |   40 ++++++++++++++---------
>  net/mac80211/sta_info.c |    1 
>  net/mac80211/sta_info.h |   81 +++++++++++++++++++++++++++++++++++-------------
>  3 files changed, 86 insertions(+), 36 deletions(-)
> 
> --- linnext-20080703-80211.orig/net/mac80211/sta_info.c
> +++ linnext-20080703-80211/net/mac80211/sta_info.c
> @@ -135,6 +135,7 @@ struct sta_info *sta_info_get_by_idx(str
>  /**
>   * __sta_info_free - internal STA free helper
>   *
> + * @local: pointer to the global information
>   * @sta: STA info to free
>   *
>   * This function must undo everything done by sta_info_alloc()
> --- linnext-20080703-80211.orig/include/net/mac80211.h
> +++ linnext-20080703-80211/include/net/mac80211.h
> @@ -42,7 +42,7 @@
>   * tasklet function.
>   *
>   * NOTE: If the driver opts to use the _irqsafe() functions, it may not also
> - *	 use the non-irqsafe functions!
> + *	 use the non-IRQ-safe functions!
>   */
>  
>  /**
> @@ -85,7 +85,7 @@ enum ieee80211_notification_types {
>   * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
>   *
>   * This structure describes most essential parameters needed
> - * to describe 802.11n HT characteristics in a BSS
> + * to describe 802.11n HT characteristics in a BSS.
>   *
>   * @primary_channel: channel number of primery channel
>   * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
> @@ -201,9 +201,9 @@ struct ieee80211_bss_conf {
>  };
>  
>  /**
> - * enum mac80211_tx_flags - flags to transmission information/status
> + * enum mac80211_tx_control_flags - flags to describe transmission information/status
>   *
> - * These flags are used with the @flags member of &ieee80211_tx_info
> + * These flags are used with the @flags member of &ieee80211_tx_info.
>   *
>   * @IEEE80211_TX_CTL_REQ_TX_STATUS: request TX status callback for this frame.
>   * @IEEE80211_TX_CTL_DO_NOT_ENCRYPT: send this frame without encryption;
> @@ -212,11 +212,12 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_CTL_USE_CTS_PROTECT: use CTS protection for the frame (e.g.,
>   *	for combined 802.11g / 802.11b networks)
>   * @IEEE80211_TX_CTL_NO_ACK: tell the low level not to wait for an ack
> - * @IEEE80211_TX_CTL_RATE_CTRL_PROBE
> + * @IEEE80211_TX_CTL_RATE_CTRL_PROBE: TBD
>   * @IEEE80211_TX_CTL_CLEAR_PS_FILT: clear powersave filter for destination
>   *	station
> - * @IEEE80211_TX_CTL_REQUEUE:
> + * @IEEE80211_TX_CTL_REQUEUE: TBD
>   * @IEEE80211_TX_CTL_FIRST_FRAGMENT: this is a first fragment of the frame
> + * @IEEE80211_TX_CTL_SHORT_PREAMBLE: TBD
>   * @IEEE80211_TX_CTL_LONG_RETRY_LIMIT: this frame should be send using the
>   *	through set_retry_limit configured long retry value
>   * @IEEE80211_TX_CTL_EAPOL_FRAME: internal to mac80211
> @@ -230,6 +231,7 @@ struct ieee80211_bss_conf {
>   * @IEEE80211_TX_CTL_40_MHZ_WIDTH: send this frame using 40 Mhz channel width
>   * @IEEE80211_TX_CTL_DUP_DATA: duplicate data frame on both 20 Mhz channels
>   * @IEEE80211_TX_CTL_SHORT_GI: send this frame using short guard interval
> + * @IEEE80211_TX_CTL_INJECTED: TBD
>   * @IEEE80211_TX_STAT_TX_FILTERED: The frame was not transmitted
>   *	because the destination STA was in powersave mode.
>   * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
> @@ -277,6 +279,12 @@ enum mac80211_tx_control_flags {
>   *  (3) TX status information - driver tells mac80211 what happened
>   *
>   * @flags: transmit info flags, defined above
> + * @band: TBD
> + * @tx_rate_idx: TBD
> + * @antenna_sel_tx: TBD
> + * @control: union for control data
> + * @status: union for status data
> + * @driver_data: array of driver_data pointers
>   * @retry_count: number of retries
>   * @excessive_retries: set to 1 if the frame was retried many times
>   *	but not acknowledged
> @@ -559,8 +567,8 @@ enum ieee80211_key_alg {
>  
>  /**
>   * enum ieee80211_key_len - key length
> - * @WEP40: WEP 5 byte long key
> - * @WEP104: WEP 13 byte long key
> + * @LEN_WEP40: WEP 5-byte long key
> + * @LEN_WEP104: WEP 13-byte long key
>   */
>  enum ieee80211_key_len {
>  	LEN_WEP40 = 5,
> @@ -637,7 +645,7 @@ enum set_key_cmd {
>   * enum sta_notify_cmd - sta notify command
>   *
>   * Used with the sta_notify() callback in &struct ieee80211_ops, this
> - * indicates addition and removal of a station to station table
> + * indicates addition and removal of a station to station table.
>   *
>   * @STA_NOTIFY_ADD: a station was added to the station table
>   * @STA_NOTIFY_REMOVE: a station being removed from the station table
> @@ -1337,7 +1345,7 @@ void ieee80211_unregister_hw(struct ieee
>   *
>   * This function frees everything that was allocated, including the
>   * private data for the driver. You must call ieee80211_unregister_hw()
> - * before calling this function
> + * before calling this function.
>   *
>   * @hw: the hardware to free
>   */
> @@ -1408,7 +1416,7 @@ void ieee80211_tx_status(struct ieee8021
>  			 struct sk_buff *skb);
>  
>  /**
> - * ieee80211_tx_status_irqsafe - irq-safe transmit status callback
> + * ieee80211_tx_status_irqsafe - IRQ-safe transmit status callback
>   *
>   * Like ieee80211_tx_status() but can be called in IRQ context
>   * (internally defers to a tasklet.)
> @@ -1586,6 +1594,8 @@ unsigned int ieee80211_hdrlen(__le16 fc)
>   * @keyconf: the parameter passed with the set key
>   * @skb: the skb for which the key is needed
>   * @rc4key: a buffer to which the key will be written
> + * @type: TBD
> + * @key: TBD
>   */
>  void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
>  				struct sk_buff *skb,
> @@ -1636,7 +1646,7 @@ void ieee80211_wake_queues(struct ieee80
>  void ieee80211_scan_completed(struct ieee80211_hw *hw);
>  
>  /**
> - * ieee80211_iterate_active_interfaces- iterate active interfaces
> + * ieee80211_iterate_active_interfaces - iterate active interfaces
>   *
>   * This function iterates over the interfaces associated with a given
>   * hardware that are currently active and calls the callback for them.
> @@ -1703,7 +1713,7 @@ void ieee80211_start_tx_ba_cb(struct iee
>   *
>   * This function must be called by low level driver once it has
>   * finished with preparations for the BA session.
> - * This version of the function is irq safe.
> + * This version of the function is IRQ-safe.
>   */
>  void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
>  				      u16 tid);
> @@ -1743,7 +1753,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee
>   *
>   * This function must be called by low level driver once it has
>   * finished with preparations for the BA session tear down.
> - * This version of the function is irq safe.
> + * This version of the function is IRQ-safe.
>   */
>  void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
>  				     u16 tid);
> @@ -1751,7 +1761,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(str
>  /**
>   * ieee80211_notify_mac - low level driver notification
>   * @hw: pointer as obtained from ieee80211_alloc_hw().
> - * @notification_types: enum ieee80211_notification_types
> + * @notif_type: enum ieee80211_notification_types
>   *
>   * This function must be called by low level driver to inform mac80211 of
>   * low level driver status change or force mac80211 to re-assoc for low
> --- linnext-20080703-80211.orig/net/mac80211/sta_info.h
> +++ linnext-20080703-80211/net/mac80211/sta_info.h
> @@ -160,11 +160,21 @@ struct sta_ampdu_mlme {
>   * @list: global linked list entry
>   * @hnext: hash table linked list pointer
>   * @local: pointer to the global information
> + * @sdata: TBD
> + * @key: TBD
> + * @rate_ctrl: TBD
> + * @rate_ctrl_priv: TBD
> + * @lock: used for locking all fields that require locking, see comments
> + *	in the header file.
> + * @flaglock: spinlock for flags accesses
> + * @ht_info: HT capabilities of this STA
> + * @supp_rates: Bitmap of supported rates (per band)
>   * @addr: MAC address of this STA
>   * @aid: STA's unique AID (1..2007, 0 = not assigned yet),
>   *	only used in AP (and IBSS?) mode
> + * @listen_interval: TBD
> + * @pin_status: TBD
>   * @flags: STA flags, see &enum ieee80211_sta_info_flags
> - * @flaglock: spinlock for flags accesses
>   * @ps_tx_buf: buffer of frames to transmit to this station
>   *	when it leaves power saving state
>   * @tx_filtered: buffer of frames we already tried to transmit
> @@ -172,10 +182,41 @@ struct sta_ampdu_mlme {
>   *	power saving state
>   * @rx_packets: Number of MSDUs received from this STA
>   * @rx_bytes: Number of bytes received from this STA
> - * @supp_rates: Bitmap of supported rates (per band)
> - * @ht_info: HT capabilities of this STA
> - * @lock: used for locking all fields that require locking, see comments
> - *	in the header file.
> + * @wep_weak_iv_count: TBD
> + * @last_rx: TBD
> + * @num_duplicates: number of duplicate frames received from this STA
> + * @rx_fragments: number of received MPDUs
> + * @rx_dropped: number of dropped MPDUs from this STA
> + * @last_signal: signal of last received frame from this STA
> + * @last_qual: qual of last received frame from this STA
> + * @last_noise: noise of last received frame from this STA
> + * @last_seq_ctrl: last received seq/frag number from this STA (per RX queue)
> + * @wme_rx_queue: TBD
> + * @tx_filtered_count: TBD
> + * @tx_retry_failed: TBD
> + * @tx_retry_count: TBD
> + * @tx_num_consecutive_failures: TBD
> + * @tx_num_mpdu_ok: TBD
> + * @tx_num_mpdu_fail: TBD
> + * @fail_avg: moving percentage of failed MSDUs
> + * @tx_packets: number of RX/TX MSDUs
> + * @tx_bytes: TBD
> + * @tx_fragments: number of transmitted MPDUs
> + * @txrate_idx: TBD
> + * @last_txrate_idx: TBD
> + * @wme_tx_queue: TBD
> + * @ampdu_mlme: TBD
> + * @timer_to_tid: identity mapping to ID timers
> + * @tid_to_tx_q: map tid to tx queue
> + * @llid: Local link ID
> + * @plid: Peer link ID
> + * @reason: Cancel reason on PLINK_HOLDING state
> + * @plink_retries: Retries in establishment
> + * @ignore_plink_timer: TBD
> + * @plink_state plink_state: TBD
> + * @plink_timeout: TBD
> + * @plink_timer: TBD
> + * @debugfs: debug filesystem info
>   */
>  struct sta_info {
>  	/* General information, mostly static */
> @@ -217,14 +258,12 @@ struct sta_info {
>  	unsigned long rx_packets, rx_bytes;
>  	unsigned long wep_weak_iv_count;
>  	unsigned long last_rx;
> -	unsigned long num_duplicates; /* number of duplicate frames received
> -				       * from this STA */
> -	unsigned long rx_fragments; /* number of received MPDUs */
> -	unsigned long rx_dropped; /* number of dropped MPDUs from this STA */
> -	int last_signal; /* signal of last received frame from this STA */
> -	int last_qual;  /* qual of last received frame from this STA */
> -	int last_noise; /* noise of last received frame from this STA */
> -	/* last received seq/frag number from this STA (per RX queue) */
> +	unsigned long num_duplicates;
> +	unsigned long rx_fragments;
> +	unsigned long rx_dropped;
> +	int last_signal;
> +	int last_qual;
> +	int last_noise;
>  	__le16 last_seq_ctrl[NUM_RX_DATA_QUEUES];
>  #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
>  	unsigned int wme_rx_queue[NUM_RX_DATA_QUEUES];
> @@ -241,9 +280,9 @@ struct sta_info {
>  	unsigned int fail_avg;
>  
>  	/* Updated from TX path only, no locking requirements */
> -	unsigned long tx_packets; /* number of RX/TX MSDUs */
> +	unsigned long tx_packets;
>  	unsigned long tx_bytes;
> -	unsigned long tx_fragments; /* number of transmitted MPDUs */
> +	unsigned long tx_fragments;
>  	int txrate_idx;
>  	int last_txrate_idx;
>  #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
> @@ -254,18 +293,18 @@ struct sta_info {
>  	 * Aggregation information, locked with lock.
>  	 */
>  	struct sta_ampdu_mlme ampdu_mlme;
> -	u8 timer_to_tid[STA_TID_NUM];	/* identity mapping to ID timers */
> -	u8 tid_to_tx_q[STA_TID_NUM];	/* map tid to tx queue */
> +	u8 timer_to_tid[STA_TID_NUM];
> +	u8 tid_to_tx_q[STA_TID_NUM];
>  
>  #ifdef CONFIG_MAC80211_MESH
>  	/*
>  	 * Mesh peer link attributes
>  	 * TODO: move to a sub-structure that is referenced with pointer?
>  	 */
> -	__le16 llid;		/* Local link ID */
> -	__le16 plid;		/* Peer link ID */
> -	__le16 reason;		/* Cancel reason on PLINK_HOLDING state */
> -	u8 plink_retries;	/* Retries in establishment */
> +	__le16 llid;
> +	__le16 plid;
> +	__le16 reason;
> +	u8 plink_retries;
>  	bool ignore_plink_timer;
>  	enum plink_state plink_state;
>  	u32 plink_timeout;
> 
> 
> ---

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
