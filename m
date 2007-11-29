Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55353 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757379AbXK2DRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:17:18 -0500
Subject: Re: [PATCH 15/36] iwlwifi: add comments to iwl*-base.c
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-7-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-8-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-9-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-10-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-11-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-12-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-13-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-14-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-15-git-send-email-yi.zhu@intel.com>
	 <1196305816-23023-16-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 11:17:04 +0800
Message-Id: <1196306225.7614.101.camel@debian.sh.intel.com> (sfid-20071129_031726_614117_7D39BA80)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resend. Replace mail subject due to ML restriction for capital Triple-X
in subject.

On Thu, 2007-11-29 at 11:09 +0800, Zhu Yi wrote:
> From: Cahill, Ben M <ben.m.cahill@intel.com>
> 
> Add comments to iwlXXXX-base.c
> 
> Signed-off-by: Cahill, Ben M <ben.m.cahill@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |  215 ++++++++++++++++++++++-----
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |  212 ++++++++++++++++++++++----
>  2 files changed, 356 insertions(+), 71 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index c0b6ac3..a742309 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -63,13 +63,13 @@ static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
>   ******************************************************************************/
>  
>  /* module parameters */
> -static int iwl3945_param_disable_hw_scan;
> -static int iwl3945_param_debug;
> -static int iwl3945_param_disable;  /* def: enable radio */
> +static int iwl3945_param_disable_hw_scan; /* def: 0 = use 3945's h/w scan */
> +static int iwl3945_param_debug;    /* def: 0 = minimal debug log messages */
> +static int iwl3945_param_disable;  /* def: 0 = enable radio */
>  static int iwl3945_param_antenna;  /* def: 0 = both antennas (use diversity) */
> -int iwl3945_param_hwcrypto;        /* def: using software encryption */
> -static int iwl3945_param_qos_enable = 1;
> -int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES;
> +int iwl3945_param_hwcrypto;        /* def: 0 = use software encryption */
> +static int iwl3945_param_qos_enable = 1; /* def: 1 = use quality of service */
> +int iwl3945_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 8 Tx queues */
>  
>  /*
>   * module name, copyright, version, etc.
> @@ -184,17 +184,24 @@ static void iwl3945_print_hex_dump(int level, void *p, u32 len)
>   *
>   * Theory of operation
>   *
> - * A queue is a circular buffers with 'Read' and 'Write' pointers.
> - * 2 empty entries always kept in the buffer to protect from overflow.
> + * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
> + * of buffer descriptors, each of which points to one or more data buffers for
> + * the device to read from or fill.  Driver and device exchange status of each
> + * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
> + * entries in each circular buffer, to protect against confusing empty and full
> + * queue states.
> + *
> + * The device reads or writes the data in the queues via the device's several
> + * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
>   *
>   * For Tx queue, there are low mark and high mark limits. If, after queuing
>   * the packet for Tx, free space become < low mark, Tx queue stopped. When
>   * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
>   * Tx queue resumed.
>   *
> - * The IWL operates with six queues, one receive queue in the device's
> - * sram, one transmit queue for sending commands to the device firmware,
> - * and four transmit queues for data.
> + * The 3945 operates with six queues:  One receive queue, one transmit queue
> + * (#4) for sending commands to the device firmware, and four transmit queues
> + * (#0-3) for data tx via EDCA.  An additional 2 HCCA queues are unused.
>   ***************************************************/
>  
>  static int iwl3945_queue_space(const struct iwl3945_queue *q)
> @@ -213,13 +220,21 @@ static int iwl3945_queue_space(const struct iwl3945_queue *q)
>  	return s;
>  }
>  
> -/* XXX: n_bd must be power-of-two size */
> +/**
> + * iwl3945_queue_inc_wrap - increment queue index, wrap back to beginning
> + * @index -- current index
> + * @n_bd -- total number of entries in queue (must be power of 2)
> + */
>  static inline int iwl3945_queue_inc_wrap(int index, int n_bd)
>  {
>  	return ++index & (n_bd - 1);
>  }
>  
> -/* XXX: n_bd must be power-of-two size */
> +/**
> + * iwl3945_queue_dec_wrap - increment queue index, wrap back to end
> + * @index -- current index
> + * @n_bd -- total number of entries in queue (must be power of 2)
> + */
>  static inline int iwl3945_queue_dec_wrap(int index, int n_bd)
>  {
>  	return --index & (n_bd - 1);
> @@ -234,12 +249,17 @@ static inline int x2_queue_used(const struct iwl3945_queue *q, int i)
>  
>  static inline u8 get_cmd_index(struct iwl3945_queue *q, u32 index, int is_huge)
>  {
> +	/* This is for scan command, the big buffer at end of command array */
>  	if (is_huge)
> -		return q->n_window;
> +		return q->n_window;	/* must be power of 2 */
>  
> +	/* Otherwise, use normal size buffers */
>  	return index & (q->n_window - 1);
>  }
>  
> +/**
> + * iwl3945_queue_init - Initialize queue's high/low-water and read/write indexes
> + */
>  static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q,
>  			  int count, int slots_num, u32 id)
>  {
> @@ -268,11 +288,16 @@ static int iwl3945_queue_init(struct iwl3945_priv *priv, struct iwl3945_queue *q
>  	return 0;
>  }
>  
> +/**
> + * iwl3945_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
> + */
>  static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
>  			      struct iwl3945_tx_queue *txq, u32 id)
>  {
>  	struct pci_dev *dev = priv->pci_dev;
>  
> +	/* Driver private data, only for Tx (not command) queues,
> +	 * not shared with device. */
>  	if (id != IWL_CMD_QUEUE_NUM) {
>  		txq->txb = kmalloc(sizeof(txq->txb[0]) *
>  				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
> @@ -284,6 +309,8 @@ static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
>  	} else
>  		txq->txb = NULL;
>  
> +	/* Circular buffer of transmit frame descriptors (TFDs),
> +	 * shared with device */
>  	txq->bd = pci_alloc_consistent(dev,
>  			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
>  			&txq->q.dma_addr);
> @@ -306,6 +333,9 @@ static int iwl3945_tx_queue_alloc(struct iwl3945_priv *priv,
>  	return -ENOMEM;
>  }
>  
> +/**
> + * iwl3945_tx_queue_init - Allocate and initialize one tx/cmd queue
> + */
>  int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
>  		      struct iwl3945_tx_queue *txq, int slots_num, u32 txq_id)
>  {
> @@ -313,9 +343,14 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
>  	int len;
>  	int rc = 0;
>  
> -	/* allocate command space + one big command for scan since scan
> -	 * command is very huge the system will not have two scan at the
> -	 * same time */
> +	/*
> +	 * Alloc buffer array for commands (Tx or other types of commands).
> +	 * For the command queue (#4), allocate command space + one big
> +	 * command for scan, since scan command is very huge; the system will
> +	 * not have two scans at the same time, so only one is needed.
> +	 * For data Tx queues (all other queues), no super-size command
> +	 * space is needed.
> +	 */
>  	len = sizeof(struct iwl3945_cmd) * slots_num;
>  	if (txq_id == IWL_CMD_QUEUE_NUM)
>  		len +=  IWL_MAX_SCAN_SIZE;
> @@ -323,6 +358,7 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
>  	if (!txq->cmd)
>  		return -ENOMEM;
>  
> +	/* Alloc driver data array and TFD circular buffer */
>  	rc = iwl3945_tx_queue_alloc(priv, txq, txq_id);
>  	if (rc) {
>  		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
> @@ -334,8 +370,11 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
>  	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
>  	 * iwl3945_queue_inc_wrap and iwl3945_queue_dec_wrap are broken. */
>  	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
> +
> +	/* Initialize queue high/low-water, head/tail indexes */
>  	iwl3945_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
>  
> +	/* Tell device where to find queue, enable DMA channel. */
>  	iwl3945_hw_tx_queue_init(priv, txq);
>  
>  	return 0;
> @@ -346,8 +385,8 @@ int iwl3945_tx_queue_init(struct iwl3945_priv *priv,
>   * @txq: Transmit queue to deallocate.
>   *
>   * Empty queue by removing and destroying all BD's.
> - * Free all buffers.  txq itself is not freed.
> - *
> + * Free all buffers.
> + * 0-fill, but do not free "txq" descriptor structure.
>   */
>  void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *txq)
>  {
> @@ -367,19 +406,21 @@ void iwl3945_tx_queue_free(struct iwl3945_priv *priv, struct iwl3945_tx_queue *t
>  	if (q->id == IWL_CMD_QUEUE_NUM)
>  		len += IWL_MAX_SCAN_SIZE;
>  
> +	/* De-alloc array of command/tx buffers */
>  	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
>  
> -	/* free buffers belonging to queue itself */
> +	/* De-alloc circular buffer of TFDs */
>  	if (txq->q.n_bd)
>  		pci_free_consistent(dev, sizeof(struct iwl3945_tfd_frame) *
>  				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
>  
> +	/* De-alloc array of per-TFD driver data */
>  	if (txq->txb) {
>  		kfree(txq->txb);
>  		txq->txb = NULL;
>  	}
>  
> -	/* 0 fill whole structure */
> +	/* 0-fill queue descriptor structure */
>  	memset(txq, 0, sizeof(*txq));
>  }
>  
> @@ -392,6 +433,11 @@ const u8 iwl3945_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
>  
>  /**************************************************************/
>  #if 0 /* temporary disable till we add real remove station */
> +/**
> + * iwl3945_remove_station - Remove driver's knowledge of station.
> + *
> + * NOTE:  This does not remove station from device's station table.
> + */
>  static u8 iwl3945_remove_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap)
>  {
>  	int index = IWL_INVALID_STATION;
> @@ -428,6 +474,12 @@ out:
>  	return 0;
>  }
>  #endif
> +
> +/**
> + * iwl3945_clear_stations_table - Clear the driver's station table
> + *
> + * NOTE:  This does not clear or otherwise alter the device's station table.
> + */
>  static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
>  {
>  	unsigned long flags;
> @@ -440,7 +492,9 @@ static void iwl3945_clear_stations_table(struct iwl3945_priv *priv)
>  	spin_unlock_irqrestore(&priv->sta_lock, flags);
>  }
>  
> -
> +/**
> + * iwl3945_add_station - Add station to station tables in driver and device
> + */
>  u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8 flags)
>  {
>  	int i;
> @@ -486,6 +540,7 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
>  	station->used = 1;
>  	priv->num_stations++;
>  
> +	/* Set up the REPLY_ADD_STA command to send to device */
>  	memset(&station->sta, 0, sizeof(struct iwl3945_addsta_cmd));
>  	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
>  	station->sta.mode = 0;
> @@ -504,6 +559,8 @@ u8 iwl3945_add_station(struct iwl3945_priv *priv, const u8 *addr, int is_ap, u8
>  			le16_to_cpu(station->sta.rate_n_flags);
>  
>  	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
> +
> +	/* Add station to device's station table */
>  	iwl3945_send_add_station(priv, &station->sta, flags);
>  	return index;
>  
> @@ -673,6 +730,8 @@ static int iwl3945_enqueue_hcmd(struct iwl3945_priv *priv, struct iwl3945_host_c
>  		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
>  
>  	txq->need_update = 1;
> +
> +	/* Increment and update queue's write index */
>  	q->write_ptr = iwl3945_queue_inc_wrap(q->write_ptr, q->n_bd);
>  	ret = iwl3945_tx_queue_update_write_ptr(priv, txq);
>  
> @@ -1511,7 +1570,7 @@ static void get_eeprom_mac(struct iwl3945_priv *priv, u8 *mac)
>  /**
>   * iwl3945_eeprom_init - read EEPROM contents
>   *
> - * Load the EEPROM from adapter into priv->eeprom
> + * Load the EEPROM contents from adapter into priv->eeprom
>   *
>   * NOTE:  This routine uses the non-debug IO access functions.
>   */
> @@ -1536,6 +1595,7 @@ int iwl3945_eeprom_init(struct iwl3945_priv *priv)
>  		return -ENOENT;
>  	}
>  
> +	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
>  	rc = iwl3945_eeprom_acquire_semaphore(priv);
>  	if (rc < 0) {
>  		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
> @@ -2631,21 +2691,23 @@ static void iwl3945_build_tx_cmd_basic(struct iwl3945_priv *priv,
>  	cmd->cmd.tx.next_frame_len = 0;
>  }
>  
> +/**
> + * iwl3945_get_sta_id - Find station's index within station table
> + */
>  static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *hdr)
>  {
>  	int sta_id;
>  	u16 fc = le16_to_cpu(hdr->frame_control);
>  
> -	/* If this frame is broadcast or not data then use the broadcast
> -	 * station id */
> +	/* If this frame is broadcast or management, use broadcast station id */
>  	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
>  	    is_multicast_ether_addr(hdr->addr1))
>  		return priv->hw_setting.bcast_sta_id;
>  
>  	switch (priv->iw_mode) {
>  
> -	/* If this frame is part of a BSS network (we're a station), then
> -	 * we use the AP's station id */
> +	/* If we are a client station in a BSS network, use the special
> +	 * AP station entry (that's the only station we communicate with) */
>  	case IEEE80211_IF_TYPE_STA:
>  		return IWL_AP_ID;
>  
> @@ -2656,11 +2718,12 @@ static int iwl3945_get_sta_id(struct iwl3945_priv *priv, struct ieee80211_hdr *h
>  			return sta_id;
>  		return priv->hw_setting.bcast_sta_id;
>  
> -	/* If this frame is part of a IBSS network, then we use the
> -	 * target specific station id */
> +	/* If this frame is going out to an IBSS network, find the station,
> +	 * or create a new station table entry */
>  	case IEEE80211_IF_TYPE_IBSS: {
>  		DECLARE_MAC_BUF(mac);
>  
> +		/* Create new station table entry */
>  		sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
>  		if (sta_id != IWL_INVALID_STATION)
>  			return sta_id;
> @@ -2746,6 +2809,8 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  
>  	hdr_len = ieee80211_get_hdrlen(fc);
> +
> +	/* Find (or create) index into station table for destination station */
>  	sta_id = iwl3945_get_sta_id(priv, hdr);
>  	if (sta_id == IWL_INVALID_STATION) {
>  		DECLARE_MAC_BUF(mac);
> @@ -2767,30 +2832,52 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
>  				__constant_cpu_to_le16(IEEE80211_SCTL_FRAG));
>  		seq_number += 0x10;
>  	}
> +
> +	/* Descriptor for chosen Tx queue */
>  	txq = &priv->txq[txq_id];
>  	q = &txq->q;
>  
>  	spin_lock_irqsave(&priv->lock, flags);
>  
> +	/* Set up first empty TFD within this queue's circular TFD buffer */
>  	tfd = &txq->bd[q->write_ptr];
>  	memset(tfd, 0, sizeof(*tfd));
>  	control_flags = (u32 *) tfd;
>  	idx = get_cmd_index(q, q->write_ptr, 0);
>  
> +	/* Set up driver data for this TFD */
>  	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl3945_tx_info));
>  	txq->txb[q->write_ptr].skb[0] = skb;
>  	memcpy(&(txq->txb[q->write_ptr].status.control),
>  	       ctl, sizeof(struct ieee80211_tx_control));
> +
> +	/* Init first empty entry in queue's array of Tx/cmd buffers */
>  	out_cmd = &txq->cmd[idx];
>  	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
>  	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
> +
> +	/*
> +	 * Set up the Tx-command (not MAC!) header.
> +	 * Store the chosen Tx queue and TFD index within the sequence field;
> +	 * after Tx, uCode's Tx response will return this value so driver can
> +	 * locate the frame within the tx queue and do post-tx processing.
> +	 */
>  	out_cmd->hdr.cmd = REPLY_TX;
>  	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
>  				INDEX_TO_SEQ(q->write_ptr)));
> -	/* copy frags header */
> +
> +	/* Copy MAC header from skb into command buffer */
>  	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
>  
> -	/* hdr = (struct ieee80211_hdr *)out_cmd->cmd.tx.hdr; */
> +	/*
> +	 * Use the first empty entry in this queue's command buffer array
> +	 * to contain the Tx command and MAC header concatenated together
> +	 * (payload data will be in another buffer).
> +	 * Size of this varies, due to varying MAC header length.
> +	 * If end is not dword aligned, we'll have 2 extra bytes at the end
> +	 * of the MAC header (device reads on dword boundaries).
> +	 * We'll tell device about this padding later.
> +	 */
>  	len = priv->hw_setting.tx_cmd_len +
>  		sizeof(struct iwl3945_cmd_header) + hdr_len;
>  
> @@ -2802,15 +2889,20 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
>  	else
>  		len_org = 0;
>  
> +	/* Physical address of this Tx command's header (not MAC header!),
> +	 * within command buffer array. */
>  	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl3945_cmd) * idx +
>  		     offsetof(struct iwl3945_cmd, hdr);
>  
> +	/* Add buffer containing Tx command and MAC(!) header to TFD's
> +	 * first entry */
>  	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
>  
>  	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
>  		iwl3945_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
>  
> -	/* 802.11 null functions have no payload... */
> +	/* Set up TFD's 2nd entry to point directly to remainder of skb,
> +	 * if any (802.11 null frames have no payload). */
>  	len = skb->len - hdr_len;
>  	if (len) {
>  		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
> @@ -2818,13 +2910,16 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
>  		iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
>  	}
>  
> -	/* If there is no payload, then only one TFD is used */
>  	if (!len)
> +		/* If there is no payload, then we use only one Tx buffer */
>  		*control_flags = TFD_CTL_COUNT_SET(1);
>  	else
> +		/* Else use 2 buffers.
> +		 * Tell 3945 about any padding after MAC header */
>  		*control_flags = TFD_CTL_COUNT_SET(2) |
>  			TFD_CTL_PAD_SET(U32_PAD(len));
>  
> +	/* Total # bytes to be transmitted */
>  	len = (u16)skb->len;
>  	out_cmd->cmd.tx.len = cpu_to_le16(len);
>  
> @@ -2854,6 +2949,7 @@ static int iwl3945_tx_skb(struct iwl3945_priv *priv,
>  	iwl3945_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
>  			   ieee80211_get_hdrlen(fc));
>  
> +	/* Tell device the write index *just past* this latest filled TFD */
>  	q->write_ptr = iwl3945_queue_inc_wrap(q->write_ptr, q->n_bd);
>  	rc = iwl3945_tx_queue_update_write_ptr(priv, txq);
>  	spin_unlock_irqrestore(&priv->lock, flags);
> @@ -3325,11 +3421,11 @@ static void iwl3945_txstatus_to_ieee(struct iwl3945_priv *priv,
>  }
>  
>  /**
> - * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries no more used by NIC.
> + * iwl3945_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
>   *
> - * When FW advances 'R' index, all entries between old and
> - * new 'R' index need to be reclaimed. As result, some free space
> - * forms. If there is enough free space (> low mark), wake Tx queue.
> + * When FW advances 'R' index, all entries between old and new 'R' index
> + * need to be reclaimed. As result, some free space forms. If there is
> + * enough free space (> low mark), wake the stack that feeds us.
>   */
>  static int iwl3945_tx_queue_reclaim(struct iwl3945_priv *priv, int txq_id, int index)
>  {
> @@ -3378,6 +3474,9 @@ static int iwl3945_is_tx_success(u32 status)
>   * Generic RX handler implementations
>   *
>   ******************************************************************************/
> +/**
> + * iwl3945_rx_reply_tx - Handle Tx response
> + */
>  static void iwl3945_rx_reply_tx(struct iwl3945_priv *priv,
>  			    struct iwl3945_rx_mem_buffer *rxb)
>  {
> @@ -3913,6 +4012,7 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_
>  	if (q->need_update == 0)
>  		goto exit_unlock;
>  
> +	/* If power-saving is in use, make sure device is awake */
>  	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
>  		reg = iwl3945_read32(priv, CSR_UCODE_DRV_GP1);
>  
> @@ -3926,10 +4026,14 @@ int iwl3945_rx_queue_update_write_ptr(struct iwl3945_priv *priv, struct iwl3945_
>  		if (rc)
>  			goto exit_unlock;
>  
> +		/* Device expects a multiple of 8 */
>  		iwl3945_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
>  				     q->write & ~0x7);
>  		iwl3945_release_nic_access(priv);
> +
> +	/* Else device is assumed to be awake */
>  	} else
> +		/* Device expects a multiple of 8 */
>  		iwl3945_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
>  
> 
> @@ -3971,9 +4075,12 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
>  	spin_lock_irqsave(&rxq->lock, flags);
>  	write = rxq->write & ~0x7;
>  	while ((iwl3945_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
> +		/* Get next free Rx buffer, remove from free list */
>  		element = rxq->rx_free.next;
>  		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
>  		list_del(element);
> +
> +		/* Point to Rx buffer via next RBD in circular buffer */
>  		rxq->bd[rxq->write] = iwl3945_dma_addr2rbd_ptr(priv, rxb->dma_addr);
>  		rxq->queue[rxq->write] = rxb;
>  		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
> @@ -3986,7 +4093,8 @@ static int iwl3945_rx_queue_restock(struct iwl3945_priv *priv)
>  		queue_work(priv->workqueue, &priv->rx_replenish);
>  
> 
> -	/* If we've added more space for the firmware to place data, tell it */
> +	/* If we've added more space for the firmware to place data, tell it.
> +	 * Increment device's write pointer in multiples of 8. */
>  	if ((write != (rxq->write & ~0x7))
>  	    || (abs(rxq->write - rxq->read) > 7)) {
>  		spin_lock_irqsave(&rxq->lock, flags);
> @@ -4019,6 +4127,8 @@ void iwl3945_rx_replenish(void *data)
>  	while (!list_empty(&rxq->rx_used)) {
>  		element = rxq->rx_used.next;
>  		rxb = list_entry(element, struct iwl3945_rx_mem_buffer, list);
> +
> +		/* Alloc a new receive buffer */
>  		rxb->skb =
>  		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
>  		if (!rxb->skb) {
> @@ -4032,6 +4142,8 @@ void iwl3945_rx_replenish(void *data)
>  		}
>  		priv->alloc_rxb_skb++;
>  		list_del(element);
> +
> +		/* Get physical address of RB/SKB */
>  		rxb->dma_addr =
>  		    pci_map_single(priv->pci_dev, rxb->skb->data,
>  				   IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
> @@ -4076,12 +4188,16 @@ int iwl3945_rx_queue_alloc(struct iwl3945_priv *priv)
>  	spin_lock_init(&rxq->lock);
>  	INIT_LIST_HEAD(&rxq->rx_free);
>  	INIT_LIST_HEAD(&rxq->rx_used);
> +
> +	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
>  	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
>  	if (!rxq->bd)
>  		return -ENOMEM;
> +
>  	/* Fill the rx_used queue with _all_ of the Rx buffers */
>  	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
>  		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
> +
>  	/* Set us so that we have processed and used all buffers, but have
>  	 * not restocked the Rx queue with fresh buffers */
>  	rxq->read = rxq->write = 0;
> @@ -4213,6 +4329,8 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
>  	int reclaim;
>  	unsigned long flags;
>  
> +	/* uCode's read index (stored in shared DRAM) indicates the last Rx
> +	 * buffer that the driver may process (last buffer filled by ucode). */
>  	r = iwl3945_hw_get_rx_read(priv);
>  	i = rxq->read;
>  
> @@ -4293,6 +4411,9 @@ static void iwl3945_rx_handle(struct iwl3945_priv *priv)
>  	iwl3945_rx_queue_restock(priv);
>  }
>  
> +/**
> + * iwl3945_tx_queue_update_write_ptr - Send new write index to hardware
> + */
>  static int iwl3945_tx_queue_update_write_ptr(struct iwl3945_priv *priv,
>  				  struct iwl3945_tx_queue *txq)
>  {
> @@ -4920,6 +5041,11 @@ static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int ban
>  	}
>  }
>  
> +/**
> + * iwl3945_get_channel_info - Find driver's private channel info
> + *
> + * Based on band and channel number.
> + */
>  const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945_priv *priv,
>  						    int phymode, u16 channel)
>  {
> @@ -4947,6 +5073,9 @@ const struct iwl3945_channel_info *iwl3945_get_channel_info(const struct iwl3945
>  #define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
>  			    ? # x " " : "")
>  
> +/**
> + * iwl3945_init_channel_map - Set up driver's info for all possible channels
> + */
>  static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
>  {
>  	int eeprom_ch_count = 0;
> @@ -5056,6 +5185,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
>  		}
>  	}
>  
> +	/* Set up txpower settings in driver for all channels */
>  	if (iwl3945_txpower_set_from_eeprom(priv))
>  		return -EIO;
>  
> @@ -8273,6 +8403,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	struct ieee80211_hw *hw;
>  	int i;
>  
> +	/* Disabling hardware scan means that mac80211 will perform scans
> +	 * "the hard way", rather than using device's scan. */
>  	if (iwl3945_param_disable_hw_scan) {
>  		IWL_DEBUG_INFO("Disabling hw_scan\n");
>  		iwl3945_hw_ops.hw_scan = NULL;
> @@ -8303,6 +8435,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	priv->hw = hw;
>  
>  	priv->pci_dev = pdev;
> +
> +	/* Select antenna (may be helpful if only one antenna is connected) */
>  	priv->antenna = (enum iwl3945_antenna)iwl3945_param_antenna;
>  #ifdef CONFIG_IWL3945_DEBUG
>  	iwl3945_debug_level = iwl3945_param_debug;
> @@ -8324,6 +8458,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	/* Tell mac80211 our Tx characteristics */
>  	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
>  
> +	/* 4 EDCA QOS priorities */
>  	hw->queues = 4;
>  
>  	spin_lock_init(&priv->lock);
> @@ -8344,6 +8479,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  
>  	pci_set_master(pdev);
>  
> +	/* Clear the driver's (not device's) station table */
>  	iwl3945_clear_stations_table(priv);
>  
>  	priv->data_retry_limit = -1;
> @@ -8363,9 +8499,11 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	err = pci_request_regions(pdev, DRV_NAME);
>  	if (err)
>  		goto out_pci_disable_device;
> +
>  	/* We disable the RETRY_TIMEOUT register (0x41) to keep
>  	 * PCI Tx retries from interfering with C3 CPU state */
>  	pci_write_config_byte(pdev, 0x41, 0x00);
> +
>  	priv->hw_base = pci_iomap(pdev, 0, 0);
>  	if (!priv->hw_base) {
>  		err = -ENODEV;
> @@ -8378,6 +8516,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  
>  	/* Initialize module parameter values here */
>  
> +	/* Disable radio (SW RF KILL) via parameter when loading driver */
>  	if (iwl3945_param_disable) {
>  		set_bit(STATUS_RF_KILL_SW, &priv->status);
>  		IWL_DEBUG_INFO("Radio disabled.\n");
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> index a840d5d..01ba374 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -63,13 +63,13 @@ static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
>   ******************************************************************************/
>  
>  /* module parameters */
> -static int iwl4965_param_disable_hw_scan;
> -static int iwl4965_param_debug;
> +static int iwl4965_param_disable_hw_scan; /* def: 0 = use 4965's h/w scan */
> +static int iwl4965_param_debug;    /* def: 0 = minimal debug log messages */
>  static int iwl4965_param_disable;  /* def: enable radio */
>  static int iwl4965_param_antenna;  /* def: 0 = both antennas (use diversity) */
>  int iwl4965_param_hwcrypto;        /* def: using software encryption */
> -static int iwl4965_param_qos_enable = 1;
> -int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES;
> +static int iwl4965_param_qos_enable = 1; /* def: 1 = use quality of service */
> +int iwl4965_param_queues_num = IWL_MAX_NUM_QUEUES; /* def: 16 Tx queues */
>  
>  /*
>   * module name, copyright, version, etc.
> @@ -183,17 +183,24 @@ static void iwl4965_print_hex_dump(int level, void *p, u32 len)
>   *
>   * Theory of operation
>   *
> - * A queue is a circular buffers with 'Read' and 'Write' pointers.
> - * 2 empty entries always kept in the buffer to protect from overflow.
> + * A Tx or Rx queue resides in host DRAM, and is comprised of a circular buffer
> + * of buffer descriptors, each of which points to one or more data buffers for
> + * the device to read from or fill.  Driver and device exchange status of each
> + * queue via "read" and "write" pointers.  Driver keeps minimum of 2 empty
> + * entries in each circular buffer, to protect against confusing empty and full
> + * queue states.
> + *
> + * The device reads or writes the data in the queues via the device's several
> + * DMA/FIFO channels.  Each queue is mapped to a single DMA channel.
>   *
>   * For Tx queue, there are low mark and high mark limits. If, after queuing
>   * the packet for Tx, free space become < low mark, Tx queue stopped. When
>   * reclaiming packets (on 'tx done IRQ), if free space become > high mark,
>   * Tx queue resumed.
>   *
> - * The IWL operates with six queues, one receive queue in the device's
> - * sram, one transmit queue for sending commands to the device firmware,
> - * and four transmit queues for data.
> + * The 4965 operates with up to 17 queues:  One receive queue, one transmit
> + * queue (#4) for sending commands to the device firmware, and 15 other
> + * Tx queues that may be mapped to prioritized Tx DMA/FIFO channels.
>   ***************************************************/
>  
>  static int iwl4965_queue_space(const struct iwl4965_queue *q)
> @@ -212,13 +219,21 @@ static int iwl4965_queue_space(const struct iwl4965_queue *q)
>  	return s;
>  }
>  
> -/* XXX: n_bd must be power-of-two size */
> +/**
> + * iwl4965_queue_inc_wrap - increment queue index, wrap back to beginning
> + * @index -- current index
> + * @n_bd -- total number of entries in queue (must be power of 2)
> + */
>  static inline int iwl4965_queue_inc_wrap(int index, int n_bd)
>  {
>  	return ++index & (n_bd - 1);
>  }
>  
> -/* XXX: n_bd must be power-of-two size */
> +/**
> + * iwl4965_queue_dec_wrap - decrement queue index, wrap back to end
> + * @index -- current index
> + * @n_bd -- total number of entries in queue (must be power of 2)
> + */
>  static inline int iwl4965_queue_dec_wrap(int index, int n_bd)
>  {
>  	return --index & (n_bd - 1);
> @@ -233,12 +248,17 @@ static inline int x2_queue_used(const struct iwl4965_queue *q, int i)
>  
>  static inline u8 get_cmd_index(struct iwl4965_queue *q, u32 index, int is_huge)
>  {
> +	/* This is for scan command, the big buffer at end of command array */
>  	if (is_huge)
> -		return q->n_window;
> +		return q->n_window;	/* must be power of 2 */
>  
> +	/* Otherwise, use normal size buffers */
>  	return index & (q->n_window - 1);
>  }
>  
> +/**
> + * iwl4965_queue_init - Initialize queue's high/low-water and read/write indexes
> + */
>  static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q,
>  			  int count, int slots_num, u32 id)
>  {
> @@ -267,11 +287,16 @@ static int iwl4965_queue_init(struct iwl4965_priv *priv, struct iwl4965_queue *q
>  	return 0;
>  }
>  
> +/**
> + * iwl4965_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
> + */
>  static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
>  			      struct iwl4965_tx_queue *txq, u32 id)
>  {
>  	struct pci_dev *dev = priv->pci_dev;
>  
> +	/* Driver private data, only for Tx (not command) queues,
> +	 * not shared with device. */
>  	if (id != IWL_CMD_QUEUE_NUM) {
>  		txq->txb = kmalloc(sizeof(txq->txb[0]) *
>  				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
> @@ -283,6 +308,8 @@ static int iwl4965_tx_queue_alloc(struct iwl4965_priv *priv,
>  	} else
>  		txq->txb = NULL;
>  
> +	/* Circular buffer of transmit frame descriptors (TFDs),
> +	 * shared with device */
>  	txq->bd = pci_alloc_consistent(dev,
>  			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
>  			&txq->q.dma_addr);
> @@ -320,7 +347,7 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
>  	 * For the command queue (#4), allocate command space + one big
>  	 * command for scan, since scan command is very huge; the system will
>  	 * not have two scans at the same time, so only one is needed.
> -	 * For normal Tx queues (all other queues), no super-size command
> +	 * For data Tx queues (all other queues), no super-size command
>  	 * space is needed.
>  	 */
>  	len = sizeof(struct iwl4965_cmd) * slots_num;
> @@ -357,8 +384,8 @@ int iwl4965_tx_queue_init(struct iwl4965_priv *priv,
>   * @txq: Transmit queue to deallocate.
>   *
>   * Empty queue by removing and destroying all BD's.
> - * Free all buffers.  txq itself is not freed.
> - *
> + * Free all buffers.
> + * 0-fill, but do not free "txq" descriptor structure.
>   */
>  void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *txq)
>  {
> @@ -378,19 +405,21 @@ void iwl4965_tx_queue_free(struct iwl4965_priv *priv, struct iwl4965_tx_queue *t
>  	if (q->id == IWL_CMD_QUEUE_NUM)
>  		len += IWL_MAX_SCAN_SIZE;
>  
> +	/* De-alloc array of command/tx buffers */
>  	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
>  
> -	/* free buffers belonging to queue itself */
> +	/* De-alloc circular buffer of TFDs */
>  	if (txq->q.n_bd)
>  		pci_free_consistent(dev, sizeof(struct iwl4965_tfd_frame) *
>  				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
>  
> +	/* De-alloc array of per-TFD driver data */
>  	if (txq->txb) {
>  		kfree(txq->txb);
>  		txq->txb = NULL;
>  	}
>  
> -	/* 0 fill whole structure */
> +	/* 0-fill queue descriptor structure */
>  	memset(txq, 0, sizeof(*txq));
>  }
>  
> @@ -404,6 +433,11 @@ const u8 iwl4965_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF
>  /**************************************************************/
>  
>  #if 0 /* temporary disable till we add real remove station */
> +/**
> + * iwl4965_remove_station - Remove driver's knowledge of station.
> + *
> + * NOTE:  This does not remove station from device's station table.
> + */
>  static u8 iwl4965_remove_station(struct iwl4965_priv *priv, const u8 *addr, int is_ap)
>  {
>  	int index = IWL_INVALID_STATION;
> @@ -441,6 +475,11 @@ out:
>  }
>  #endif
>  
> +/**
> + * iwl4965_clear_stations_table - Clear the driver's station table
> + *
> + * NOTE:  This does not clear or otherwise alter the device's station table.
> + */
>  static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
>  {
>  	unsigned long flags;
> @@ -453,6 +492,9 @@ static void iwl4965_clear_stations_table(struct iwl4965_priv *priv)
>  	spin_unlock_irqrestore(&priv->sta_lock, flags);
>  }
>  
> +/**
> + * iwl4965_add_station_flags - Add station to tables in driver and device
> + */
>  u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr, int is_ap, u8 flags)
>  {
>  	int i;
> @@ -499,6 +541,7 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr, int is_a
>  	station->used = 1;
>  	priv->num_stations++;
>  
> +	/* Set up the REPLY_ADD_STA command to send to device */
>  	memset(&station->sta, 0, sizeof(struct iwl4965_addsta_cmd));
>  	memcpy(station->sta.sta.addr, addr, ETH_ALEN);
>  	station->sta.mode = 0;
> @@ -513,6 +556,8 @@ u8 iwl4965_add_station_flags(struct iwl4965_priv *priv, const u8 *addr, int is_a
>  #endif /*CONFIG_IWL4965_HT*/
>  
>  	spin_unlock_irqrestore(&priv->sta_lock, flags_spin);
> +
> +	/* Add station to device's station table */
>  	iwl4965_send_add_station(priv, &station->sta, flags);
>  	return index;
>  
> @@ -682,7 +727,11 @@ static int iwl4965_enqueue_hcmd(struct iwl4965_priv *priv, struct iwl4965_host_c
>  		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
>  
>  	txq->need_update = 1;
> +
> +	/* Set up entry in queue's byte count circular buffer */
>  	ret = iwl4965_tx_queue_update_wr_ptr(priv, txq, 0);
> +
> +	/* Increment and update queue's write index */
>  	q->write_ptr = iwl4965_queue_inc_wrap(q->write_ptr, q->n_bd);
>  	iwl4965_tx_queue_update_write_ptr(priv, txq);
>  
> @@ -848,7 +897,10 @@ static int iwl4965_rxon_add_station(struct iwl4965_priv *priv,
>  {
>  	u8 sta_id;
>  
> +	/* Add station to device's station table */
>  	sta_id = iwl4965_add_station_flags(priv, addr, is_ap, 0);
> +
> +	/* Set up default rate scaling table in device's station table */
>  	iwl4965_add_station(priv, addr, is_ap);
>  
>  	return sta_id;
> @@ -1574,7 +1626,7 @@ static void get_eeprom_mac(struct iwl4965_priv *priv, u8 *mac)
>  /**
>   * iwl4965_eeprom_init - read EEPROM contents
>   *
> - * Load the EEPROM from adapter into priv->eeprom
> + * Load the EEPROM contents from adapter into priv->eeprom
>   *
>   * NOTE:  This routine uses the non-debug IO access functions.
>   */
> @@ -1599,6 +1651,7 @@ int iwl4965_eeprom_init(struct iwl4965_priv *priv)
>  		return -ENOENT;
>  	}
>  
> +	/* Make sure driver (instead of uCode) is allowed to read EEPROM */
>  	rc = iwl4965_eeprom_acquire_semaphore(priv);
>  	if (rc < 0) {
>  		IWL_ERROR("Failed to acquire EEPROM semaphore.\n");
> @@ -2739,6 +2792,11 @@ static void iwl4965_build_tx_cmd_basic(struct iwl4965_priv *priv,
>  	cmd->cmd.tx.next_frame_len = 0;
>  }
>  
> +/**
> + * iwl4965_get_sta_id - Find station's index within station table
> + *
> + * If new IBSS station, create new entry in station table
> + */
>  static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
>  				struct ieee80211_hdr *hdr)
>  {
> @@ -2746,16 +2804,15 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
>  	u16 fc = le16_to_cpu(hdr->frame_control);
>  	DECLARE_MAC_BUF(mac);
>  
> -	/* If this frame is broadcast or not data then use the broadcast
> -	 * station id */
> +	/* If this frame is broadcast or management, use broadcast station id */
>  	if (((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA) ||
>  	    is_multicast_ether_addr(hdr->addr1))
>  		return priv->hw_setting.bcast_sta_id;
>  
>  	switch (priv->iw_mode) {
>  
> -	/* If this frame is part of a BSS network (we're a station), then
> -	 * we use the AP's station id */
> +	/* If we are a client station in a BSS network, use the special
> +	 * AP station entry (that's the only station we communicate with) */
>  	case IEEE80211_IF_TYPE_STA:
>  		return IWL_AP_ID;
>  
> @@ -2766,13 +2823,14 @@ static int iwl4965_get_sta_id(struct iwl4965_priv *priv,
>  			return sta_id;
>  		return priv->hw_setting.bcast_sta_id;
>  
> -	/* If this frame is part of a IBSS network, then we use the
> -	 * target specific station id */
> +	/* If this frame is going out to an IBSS network, find the station,
> +	 * or create a new station table entry */
>  	case IEEE80211_IF_TYPE_IBSS:
>  		sta_id = iwl4965_hw_find_station(priv, hdr->addr1);
>  		if (sta_id != IWL_INVALID_STATION)
>  			return sta_id;
>  
> +		/* Create new station table entry */
>  		sta_id = iwl4965_add_station_flags(priv, hdr->addr1, 0, CMD_ASYNC);
>  
>  		if (sta_id != IWL_INVALID_STATION)
> @@ -2854,6 +2912,8 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  
>  	hdr_len = ieee80211_get_hdrlen(fc);
> +
> +	/* Find (or create) index into station table for destination station */
>  	sta_id = iwl4965_get_sta_id(priv, hdr);
>  	if (sta_id == IWL_INVALID_STATION) {
>  		DECLARE_MAC_BUF(mac);
> @@ -2882,30 +2942,52 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
>  #endif /* CONFIG_IWL4965_HT_AGG */
>  #endif /* CONFIG_IWL4965_HT */
>  	}
> +
> +	/* Descriptor for chosen Tx queue */
>  	txq = &priv->txq[txq_id];
>  	q = &txq->q;
>  
>  	spin_lock_irqsave(&priv->lock, flags);
>  
> +	/* Set up first empty TFD within this queue's circular TFD buffer */
>  	tfd = &txq->bd[q->write_ptr];
>  	memset(tfd, 0, sizeof(*tfd));
>  	control_flags = (u32 *) tfd;
>  	idx = get_cmd_index(q, q->write_ptr, 0);
>  
> +	/* Set up driver data for this TFD */
>  	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl4965_tx_info));
>  	txq->txb[q->write_ptr].skb[0] = skb;
>  	memcpy(&(txq->txb[q->write_ptr].status.control),
>  	       ctl, sizeof(struct ieee80211_tx_control));
> +
> +	/* Set up first empty entry in queue's array of Tx/cmd buffers */
>  	out_cmd = &txq->cmd[idx];
>  	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
>  	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
> +
> +	/*
> +	 * Set up the Tx-command (not MAC!) header.
> +	 * Store the chosen Tx queue and TFD index within the sequence field;
> +	 * after Tx, uCode's Tx response will return this value so driver can
> +	 * locate the frame within the tx queue and do post-tx processing.
> +	 */
>  	out_cmd->hdr.cmd = REPLY_TX;
>  	out_cmd->hdr.sequence = cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
>  				INDEX_TO_SEQ(q->write_ptr)));
> -	/* copy frags header */
> +
> +	/* Copy MAC header from skb into command buffer */
>  	memcpy(out_cmd->cmd.tx.hdr, hdr, hdr_len);
>  
> -	/* hdr = (struct ieee80211_hdr *)out_cmd->cmd.tx.hdr; */
> +	/*
> +	 * Use the first empty entry in this queue's command buffer array
> +	 * to contain the Tx command and MAC header concatenated together
> +	 * (payload data will be in another buffer).
> +	 * Size of this varies, due to varying MAC header length.
> +	 * If end is not dword aligned, we'll have 2 extra bytes at the end
> +	 * of the MAC header (device reads on dword boundaries).
> +	 * We'll tell device about this padding later.
> +	 */
>  	len = priv->hw_setting.tx_cmd_len +
>  		sizeof(struct iwl4965_cmd_header) + hdr_len;
>  
> @@ -2917,15 +2999,20 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
>  	else
>  		len_org = 0;
>  
> +	/* Physical address of this Tx command's header (not MAC header!),
> +	 * within command buffer array. */
>  	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl4965_cmd) * idx +
>  		     offsetof(struct iwl4965_cmd, hdr);
>  
> +	/* Add buffer containing Tx command and MAC(!) header to TFD's
> +	 * first entry */
>  	iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
>  
>  	if (!(ctl->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT))
>  		iwl4965_build_tx_cmd_hwcrypto(priv, ctl, out_cmd, skb, 0);
>  
> -	/* 802.11 null functions have no payload... */
> +	/* Set up TFD's 2nd entry to point directly to remainder of skb,
> +	 * if any (802.11 null frames have no payload). */
>  	len = skb->len - hdr_len;
>  	if (len) {
>  		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
> @@ -2933,9 +3020,11 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
>  		iwl4965_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, len);
>  	}
>  
> +	/* Tell 4965 about any 2-byte padding after MAC header */
>  	if (len_org)
>  		out_cmd->cmd.tx.tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
>  
> +	/* Total # bytes to be transmitted */
>  	len = (u16)skb->len;
>  	out_cmd->cmd.tx.len = cpu_to_le16(len);
>  
> @@ -2965,8 +3054,10 @@ static int iwl4965_tx_skb(struct iwl4965_priv *priv,
>  	iwl4965_print_hex_dump(IWL_DL_TX, (u8 *)out_cmd->cmd.tx.hdr,
>  			   ieee80211_get_hdrlen(fc));
>  
> +	/* Set up entry for this TFD in Tx byte-count array */
>  	iwl4965_tx_queue_update_wr_ptr(priv, txq, len);
>  
> +	/* Tell device the write index *just past* this latest filled TFD */
>  	q->write_ptr = iwl4965_queue_inc_wrap(q->write_ptr, q->n_bd);
>  	rc = iwl4965_tx_queue_update_write_ptr(priv, txq);
>  	spin_unlock_irqrestore(&priv->lock, flags);
> @@ -3439,11 +3530,11 @@ static void iwl4965_txstatus_to_ieee(struct iwl4965_priv *priv,
>  }
>  
>  /**
> - * iwl4965_tx_queue_reclaim - Reclaim Tx queue entries no more used by NIC.
> + * iwl4965_tx_queue_reclaim - Reclaim Tx queue entries already Tx'd
>   *
> - * When FW advances 'R' index, all entries between old and
> - * new 'R' index need to be reclaimed. As result, some free space
> - * forms. If there is enough free space (> low mark), wake Tx queue.
> + * When FW advances 'R' index, all entries between old and new 'R' index
> + * need to be reclaimed. As result, some free space forms.  If there is
> + * enough free space (> low mark), wake the stack that feeds us.
>   */
>  int iwl4965_tx_queue_reclaim(struct iwl4965_priv *priv, int txq_id, int index)
>  {
> @@ -3524,6 +3615,10 @@ static inline u32 iwl4965_get_scd_ssn(struct iwl4965_tx_resp *tx_resp)
>  	return le32_to_cpu(*scd_ssn) & MAX_SN;
>  
>  }
> +
> +/**
> + * iwl4965_tx_status_reply_tx - Handle Tx rspnse for frames in aggregation queue
> + */
>  static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
>  				      struct iwl4965_ht_agg *agg,
>  				      struct iwl4965_tx_resp *tx_resp,
> @@ -3538,14 +3633,16 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
>  	u16 seq;
>  
>  	if (agg->wait_for_ba)
> -		IWL_DEBUG_TX_REPLY("got tx repsons w/o back\n");
> +		IWL_DEBUG_TX_REPLY("got tx response w/o block-ack\n");
>  
>  	agg->frame_count = tx_resp->frame_count;
>  	agg->start_idx = start_idx;
>  	agg->rate_n_flags = le32_to_cpu(tx_resp->rate_n_flags);
>  	agg->bitmap0 = agg->bitmap1 = 0;
>  
> +	/* # frames attempted by Tx command */
>  	if (agg->frame_count == 1) {
> +		/* Only one frame was attempted; no block-ack will arrive */
>  		struct iwl4965_tx_queue *txq ;
>  		status = le32_to_cpu(frame_status[0]);
>  
> @@ -3574,9 +3671,11 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
>  
>  		agg->wait_for_ba = 0;
>  	} else {
> +		/* Two or more frames were attempted; expect block-ack */
>  		u64 bitmap = 0;
>  		int start = agg->start_idx;
>  
> +		/* Construct bit-map of pending frames within Tx window */
>  		for (i = 0; i < agg->frame_count; i++) {
>  			u16 sc;
>  			status = le32_to_cpu(frame_status[i]);
> @@ -3640,6 +3739,9 @@ static int iwl4965_tx_status_reply_tx(struct iwl4965_priv *priv,
>  #endif
>  #endif
>  
> +/**
> + * iwl4965_rx_reply_tx - Handle standard (non-aggregation) Tx response
> + */
>  static void iwl4965_rx_reply_tx(struct iwl4965_priv *priv,
>  			    struct iwl4965_rx_mem_buffer *rxb)
>  {
> @@ -4261,6 +4363,7 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_
>  	if (q->need_update == 0)
>  		goto exit_unlock;
>  
> +	/* If power-saving is in use, make sure device is awake */
>  	if (test_bit(STATUS_POWER_PMI, &priv->status)) {
>  		reg = iwl4965_read32(priv, CSR_UCODE_DRV_GP1);
>  
> @@ -4274,10 +4377,14 @@ int iwl4965_rx_queue_update_write_ptr(struct iwl4965_priv *priv, struct iwl4965_
>  		if (rc)
>  			goto exit_unlock;
>  
> +		/* Device expects a multiple of 8 */
>  		iwl4965_write_direct32(priv, FH_RSCSR_CHNL0_WPTR,
>  				     q->write & ~0x7);
>  		iwl4965_release_nic_access(priv);
> +
> +	/* Else device is assumed to be awake */
>  	} else
> +		/* Device expects a multiple of 8 */
>  		iwl4965_write32(priv, FH_RSCSR_CHNL0_WPTR, q->write & ~0x7);
>  
> 
> @@ -4320,9 +4427,12 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
>  	spin_lock_irqsave(&rxq->lock, flags);
>  	write = rxq->write & ~0x7;
>  	while ((iwl4965_rx_queue_space(rxq) > 0) && (rxq->free_count)) {
> +		/* Get next free Rx buffer, remove from free list */
>  		element = rxq->rx_free.next;
>  		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
>  		list_del(element);
> +
> +		/* Point to Rx buffer via next RBD in circular buffer */
>  		rxq->bd[rxq->write] = iwl4965_dma_addr2rbd_ptr(priv, rxb->dma_addr);
>  		rxq->queue[rxq->write] = rxb;
>  		rxq->write = (rxq->write + 1) & RX_QUEUE_MASK;
> @@ -4335,7 +4445,8 @@ static int iwl4965_rx_queue_restock(struct iwl4965_priv *priv)
>  		queue_work(priv->workqueue, &priv->rx_replenish);
>  
> 
> -	/* If we've added more space for the firmware to place data, tell it */
> +	/* If we've added more space for the firmware to place data, tell it.
> +	 * Increment device's write pointer in multiples of 8. */
>  	if ((write != (rxq->write & ~0x7))
>  	    || (abs(rxq->write - rxq->read) > 7)) {
>  		spin_lock_irqsave(&rxq->lock, flags);
> @@ -4368,6 +4479,8 @@ void iwl4965_rx_replenish(void *data)
>  	while (!list_empty(&rxq->rx_used)) {
>  		element = rxq->rx_used.next;
>  		rxb = list_entry(element, struct iwl4965_rx_mem_buffer, list);
> +
> +		/* Alloc a new receive buffer */
>  		rxb->skb =
>  		    alloc_skb(IWL_RX_BUF_SIZE, __GFP_NOWARN | GFP_ATOMIC);
>  		if (!rxb->skb) {
> @@ -4381,6 +4494,8 @@ void iwl4965_rx_replenish(void *data)
>  		}
>  		priv->alloc_rxb_skb++;
>  		list_del(element);
> +
> +		/* Get physical address of RB/SKB */
>  		rxb->dma_addr =
>  		    pci_map_single(priv->pci_dev, rxb->skb->data,
>  				   IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
> @@ -4425,12 +4540,16 @@ int iwl4965_rx_queue_alloc(struct iwl4965_priv *priv)
>  	spin_lock_init(&rxq->lock);
>  	INIT_LIST_HEAD(&rxq->rx_free);
>  	INIT_LIST_HEAD(&rxq->rx_used);
> +
> +	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
>  	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
>  	if (!rxq->bd)
>  		return -ENOMEM;
> +
>  	/* Fill the rx_used queue with _all_ of the Rx buffers */
>  	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
>  		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
> +
>  	/* Set us so that we have processed and used all buffers, but have
>  	 * not restocked the Rx queue with fresh buffers */
>  	rxq->read = rxq->write = 0;
> @@ -4562,6 +4681,8 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
>  	int reclaim;
>  	unsigned long flags;
>  
> +	/* uCode's read index (stored in shared DRAM) indicates the last Rx
> +	 * buffer that the driver may process (last buffer filled by ucode). */
>  	r = iwl4965_hw_get_rx_read(priv);
>  	i = rxq->read;
>  
> @@ -4645,6 +4766,9 @@ static void iwl4965_rx_handle(struct iwl4965_priv *priv)
>  	iwl4965_rx_queue_restock(priv);
>  }
>  
> +/**
> + * iwl4965_tx_queue_update_write_ptr - Send new write index to hardware
> + */
>  static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
>  				  struct iwl4965_tx_queue *txq)
>  {
> @@ -5276,6 +5400,11 @@ static void iwl4965_init_band_reference(const struct iwl4965_priv *priv,
>  	}
>  }
>  
> +/**
> + * iwl4965_get_channel_info - Find driver's private channel info
> + *
> + * Based on band and channel number.
> + */
>  const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965_priv *priv,
>  						    int phymode, u16 channel)
>  {
> @@ -5303,6 +5432,9 @@ const struct iwl4965_channel_info *iwl4965_get_channel_info(const struct iwl4965
>  #define CHECK_AND_PRINT(x) ((eeprom_ch_info[ch].flags & EEPROM_CHANNEL_##x) \
>  			    ? # x " " : "")
>  
> +/**
> + * iwl4965_init_channel_map - Set up driver's info for all possible channels
> + */
>  static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
>  {
>  	int eeprom_ch_count = 0;
> @@ -5412,6 +5544,7 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
>  		}
>  	}
>  
> +	/* Two additional EEPROM bands for 2.4 and 5 GHz FAT channels */
>  	for (band = 6; band <= 7; band++) {
>  		int phymode;
>  		u8 fat_extension_chan;
> @@ -5419,7 +5552,9 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
>  		iwl4965_init_band_reference(priv, band, &eeprom_ch_count,
>  					&eeprom_ch_info, &eeprom_ch_index);
>  
> +		/* EEPROM band 6 is 2.4, band 7 is 5 GHz */
>  		phymode = (band == 6) ? MODE_IEEE80211B : MODE_IEEE80211A;
> +
>  		/* Loop through each band adding each of the channels */
>  		for (ch = 0; ch < eeprom_ch_count; ch++) {
>  
> @@ -5431,11 +5566,13 @@ static int iwl4965_init_channel_map(struct iwl4965_priv *priv)
>  			else
>  				fat_extension_chan = HT_IE_EXT_CHANNEL_ABOVE;
>  
> +			/* Set up driver's info for lower half */
>  			iwl4965_set_fat_chan_info(priv, phymode,
>  						  eeprom_ch_index[ch],
>  						  &(eeprom_ch_info[ch]),
>  						  fat_extension_chan);
>  
> +			/* Set up driver's info for upper half */
>  			iwl4965_set_fat_chan_info(priv, phymode,
>  						  (eeprom_ch_index[ch] + 4),
>  						  &(eeprom_ch_info[ch]),
> @@ -8936,6 +9073,8 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	struct ieee80211_hw *hw;
>  	int i;
>  
> +	/* Disabling hardware scan means that mac80211 will perform scans
> +	 * "the hard way", rather than using device's scan. */
>  	if (iwl4965_param_disable_hw_scan) {
>  		IWL_DEBUG_INFO("Disabling hw_scan\n");
>  		iwl4965_hw_ops.hw_scan = NULL;
> @@ -8987,9 +9126,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	/* Tell mac80211 our Tx characteristics */
>  	hw->flags = IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE;
>  
> +	/* Default value; 4 EDCA QOS priorities */
>  	hw->queues = 4;
>  #ifdef CONFIG_IWL4965_HT
>  #ifdef CONFIG_IWL4965_HT_AGG
> +	/* Enhanced value; more queues, to support 11n aggregation */
>  	hw->queues = 16;
>  #endif /* CONFIG_IWL4965_HT_AGG */
>  #endif /* CONFIG_IWL4965_HT */
> @@ -9013,6 +9154,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  
>  	pci_set_master(pdev);
>  
> +	/* Clear the driver's (not device's) station table */
>  	iwl4965_clear_stations_table(priv);
>  
>  	priv->data_retry_limit = -1;
> @@ -9032,9 +9174,11 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	err = pci_request_regions(pdev, DRV_NAME);
>  	if (err)
>  		goto out_pci_disable_device;
> +
>  	/* We disable the RETRY_TIMEOUT register (0x41) to keep
>  	 * PCI Tx retries from interfering with C3 CPU state */
>  	pci_write_config_byte(pdev, 0x41, 0x00);
> +
>  	priv->hw_base = pci_iomap(pdev, 0, 0);
>  	if (!priv->hw_base) {
>  		err = -ENODEV;
> @@ -9047,6 +9191,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  
>  	/* Initialize module parameter values here */
>  
> +	/* Disable radio (SW RF KILL) via parameter when loading driver */
>  	if (iwl4965_param_disable) {
>  		set_bit(STATUS_RF_KILL_SW, &priv->status);
>  		IWL_DEBUG_INFO("Radio disabled.\n");
> @@ -9061,6 +9206,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
>  	priv->valid_antenna = 0x7;	/* assume all 3 connected */
>  	priv->ps_mode = IWL_MIMO_PS_NONE;
>  
> +	/* Choose which receivers/antennas to use */
>  	iwl4965_set_rxon_chain(priv);
>  
>  	printk(KERN_INFO DRV_NAME
