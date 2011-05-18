Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:55975 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753283Ab1ERUi4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 16:38:56 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 5/7] rt2x00: Move rt2800_txdone andrt2800_txdone_entry_check to rt2800usb.
Date: Wed, 18 May 2011 22:38:48 +0200
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <201105182022.20341.IvDoorn@gmail.com> <201105182023.25912.IvDoorn@gmail.com> <201105182025.50070.IvDoorn@gmail.com>
In-Reply-To: <201105182025.50070.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201105182238.49341.marvin24@gmx.de> (sfid-20110518_223859_611632_29F1169E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi, 

I tested the patches and got this during boot on a rt3070 chip:

[   14.173458] ------------[ cut here ]------------
[   14.173482] WARNING: at /home/marc/ac100/marvin24s-kernel/kernel/softirq.c:159 local_bh_enable_ip+0x4c/0xcc()
[   14.173490] Modules linked in: binfmt_misc snd_soc_tegra_paz00 snd_soc_alc5632 snd_soc_tegra_i2s snd_soc_tegra_pcm 
snd_soc_tegra_das rt2800usb snd_soc_core snd_pcm_oss rt2800lib rt2x00usb snd_mixer_oss rt2x00lib snd_pcm mac80211 
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq cfg80211 snd_timer snd_seq_device uvcvideo rfkill cdc_acm snd 
cdc_wdm videodev snd_soc_tegra_utils soundcore snd_page_alloc g_cdc btrfs
[   14.173567] Backtrace:
[   14.173607] [<c0043708>] (unwind_backtrace+0x0/0xe0) from [<c00753f8>] (warn_slowpath_common+0x4c/0x64)
[   14.173628] [<c00753f8>] (warn_slowpath_common+0x4c/0x64) from [<c0075428>] (warn_slowpath_null+0x18/0x1c)
[   14.173646] [<c0075428>] (warn_slowpath_null+0x18/0x1c) from [<c007bc80>] (local_bh_enable_ip+0x4c/0xcc)
[   14.173676] [<c007bc80>] (local_bh_enable_ip+0x4c/0xcc) from [<bf40b9b4>] (rt2x00usb_interrupt_rxdone+0x30/0x70 
[rt2x00usb])
[   14.173723] [<bf40b9b4>] (rt2x00usb_interrupt_rxdone+0x30/0x70 [rt2x00usb]) from [<c02d9150>] 
(usb_hcd_giveback_urb+0x74/0xbc)
[   14.173752] [<c02d9150>] (usb_hcd_giveback_urb+0x74/0xbc) from [<c02e75f8>] (ehci_urb_done+0x90/0x9c)
[   14.173775] [<c02e75f8>] (ehci_urb_done+0x90/0x9c) from [<c02eb284>] (qh_completions+0xb4/0x3ec)
[   14.173795] [<c02eb284>] (qh_completions+0xb4/0x3ec) from [<c02ec4b8>] (ehci_work+0xb4/0x97c)
[   14.173814] [<c02ec4b8>] (ehci_work+0xb4/0x97c) from [<c02ed3d0>] (ehci_irq+0x21c/0x24c)
[   14.173830] [<c02ed3d0>] (ehci_irq+0x21c/0x24c) from [<c02d8b34>] (usb_hcd_irq+0x34/0x6c)
[   14.173865] [<c02d8b34>] (usb_hcd_irq+0x34/0x6c) from [<c00bb840>] (handle_IRQ_event+0x9c/0x1b4)
[   14.173884] [<c00bb840>] (handle_IRQ_event+0x9c/0x1b4) from [<c00bd4fc>] (handle_level_irq+0xd0/0x154)
[   14.173910] [<c00bd4fc>] (handle_level_irq+0xd0/0x154) from [<c0037080>] (asm_do_IRQ+0x80/0xb4)
[   14.173943] [<c0037080>] (asm_do_IRQ+0x80/0xb4) from [<c040d84c>] (__irq_svc+0x4c/0xe0)
[   14.173954] Exception stack(0xdb84be10 to 0xdb84be58)
[   14.173964] be00:                                     db929800 db28dc60 00000000 dcc00000
[   14.173979] be20: db28dc60 dcd20000 00000000 00000010 db929800 00000008 00000010 db28dc98
[   14.173991] be40: 00000000 db84be58 c026c86c c026ef58 60000013 ffffffff
[   14.174027] [<c040d84c>] (__irq_svc+0x4c/0xe0) from [<c026ef58>] (cfb_imageblit+0x54/0x43c)
[   14.174047] [<c026ef58>] (cfb_imageblit+0x54/0x43c) from [<c026c86c>] (soft_cursor+0x1a0/0x1a8)
[   14.174065] [<c026c86c>] (soft_cursor+0x1a0/0x1a8) from [<c026c254>] (bit_cursor+0x41c/0x42c)
[   14.174083] [<c026c254>] (bit_cursor+0x41c/0x42c) from [<c0266d08>] (fb_flashcursor+0xfc/0x118)
[   14.174114] [<c0266d08>] (fb_flashcursor+0xfc/0x118) from [<c008c9a0>] (process_one_work+0x274/0x43c)
[   14.174136] [<c008c9a0>] (process_one_work+0x274/0x43c) from [<c008e698>] (worker_thread+0x1b8/0x2b4)
[   14.174159] [<c008e698>] (worker_thread+0x1b8/0x2b4) from [<c0091d5c>] (kthread+0x7c/0x84)
[   14.174190] [<c0091d5c>] (kthread+0x7c/0x84) from [<c003d470>] (kernel_thread_exit+0x0/0x8)
[   14.174202] ---[ end trace 7b2804cb6c2b13fe ]---

Of course, this didn't happen before.

Thanks

Marc

Am Mittwoch 18 Mai 2011, 20:25:49 schrieb Ivo van Doorn:
> From: Gertjan van Wingerde <gwingerde@gmail.com>
> 
> These two functions are only used by rt2800usb so they don't have to be
> in rt2800lib.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |   82
> ------------------------------ drivers/net/wireless/rt2x00/rt2800lib.h |  
>  1 -
>  drivers/net/wireless/rt2x00/rt2800usb.c |   83
> ++++++++++++++++++++++++++++++- 3 files changed, 82 insertions(+), 84
> deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
> b/drivers/net/wireless/rt2x00/rt2800lib.c index 445d681..562dc1d 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -601,49 +601,6 @@ void rt2800_process_rxwi(struct queue_entry *entry,
>  }
>  EXPORT_SYMBOL_GPL(rt2800_process_rxwi);
> 
> -static bool rt2800_txdone_entry_check(struct queue_entry *entry, u32 reg)
> -{
> -	__le32 *txwi;
> -	u32 word;
> -	int wcid, ack, pid;
> -	int tx_wcid, tx_ack, tx_pid;
> -
> -	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
> -	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
> -	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
> -
> -	/*
> -	 * This frames has returned with an IO error,
> -	 * so the status report is not intended for this
> -	 * frame.
> -	 */
> -	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags)) {
> -		rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
> -		return false;
> -	}
> -
> -	/*
> -	 * Validate if this TX status report is intended for
> -	 * this entry by comparing the WCID/ACK/PID fields.
> -	 */
> -	txwi = rt2800_drv_get_txwi(entry);
> -
> -	rt2x00_desc_read(txwi, 1, &word);
> -	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> -	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> -	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> -
> -	if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid)) {
> -		WARNING(entry->queue->rt2x00dev,
> -			"TX status report missed for queue %d entry %d\n",
> -		entry->queue->qid, entry->entry_idx);
> -		rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
> -		return false;
> -	}
> -
> -	return true;
> -}
> -
>  void rt2800_txdone_entry(struct queue_entry *entry, u32 status)
>  {
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> @@ -726,45 +683,6 @@ void rt2800_txdone_entry(struct queue_entry *entry,
> u32 status) }
>  EXPORT_SYMBOL_GPL(rt2800_txdone_entry);
> 
> -void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
> -{
> -	struct data_queue *queue;
> -	struct queue_entry *entry;
> -	u32 reg;
> -	u8 qid;
> -
> -	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
> -
> -		/* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
> -		 * qid is guaranteed to be one of the TX QIDs
> -		 */
> -		qid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_QUEUE);
> -		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
> -		if (unlikely(!queue)) {
> -			WARNING(rt2x00dev, "Got TX status for an unavailable "
> -					   "queue %u, dropping\n", qid);
> -			continue;
> -		}
> -
> -		/*
> -		 * Inside each queue, we process each entry in a chronological
> -		 * order. We first check that the queue is not empty.
> -		 */
> -		entry = NULL;
> -		while (!rt2x00queue_empty(queue)) {
> -			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> -			if (rt2800_txdone_entry_check(entry, reg))
> -				break;
> -		}
> -
> -		if (!entry || rt2x00queue_empty(queue))
> -			break;
> -
> -		rt2800_txdone_entry(entry, reg);
> -	}
> -}
> -EXPORT_SYMBOL_GPL(rt2800_txdone);
> -
>  void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc
> *txdesc) {
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h
> b/drivers/net/wireless/rt2x00/rt2800lib.h index f2d1594..69deb31 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.h
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.h
> @@ -152,7 +152,6 @@ void rt2800_write_tx_data(struct queue_entry *entry,
>  			  struct txentry_desc *txdesc);
>  void rt2800_process_rxwi(struct queue_entry *entry, struct
> rxdone_entry_desc *txdesc);
> 
> -void rt2800_txdone(struct rt2x00_dev *rt2x00dev);
>  void rt2800_txdone_entry(struct queue_entry *entry, u32 status);
> 
>  void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc
> *txdesc); diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
> b/drivers/net/wireless/rt2x00/rt2800usb.c index ba82c97..6e92298 100644
> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> @@ -457,6 +457,87 @@ static int rt2800usb_get_tx_data_len(struct
> queue_entry *entry) /*
>   * TX control handlers
>   */
> +static bool rt2800usb_txdone_entry_check(struct queue_entry *entry, u32
> reg) +{
> +	__le32 *txwi;
> +	u32 word;
> +	int wcid, ack, pid;
> +	int tx_wcid, tx_ack, tx_pid;
> +
> +	wcid	= rt2x00_get_field32(reg, TX_STA_FIFO_WCID);
> +	ack	= rt2x00_get_field32(reg, TX_STA_FIFO_TX_ACK_REQUIRED);
> +	pid	= rt2x00_get_field32(reg, TX_STA_FIFO_PID_TYPE);
> +
> +	/*
> +	 * This frames has returned with an IO error,
> +	 * so the status report is not intended for this
> +	 * frame.
> +	 */
> +	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags)) {
> +		rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
> +		return false;
> +	}
> +
> +	/*
> +	 * Validate if this TX status report is intended for
> +	 * this entry by comparing the WCID/ACK/PID fields.
> +	 */
> +	txwi = rt2800usb_get_txwi(entry);
> +
> +	rt2x00_desc_read(txwi, 1, &word);
> +	tx_wcid = rt2x00_get_field32(word, TXWI_W1_WIRELESS_CLI_ID);
> +	tx_ack  = rt2x00_get_field32(word, TXWI_W1_ACK);
> +	tx_pid  = rt2x00_get_field32(word, TXWI_W1_PACKETID);
> +
> +	if ((wcid != tx_wcid) || (ack != tx_ack) || (pid != tx_pid)) {
> +		WARNING(entry->queue->rt2x00dev,
> +			"TX status report missed for queue %d entry %d\n",
> +		entry->queue->qid, entry->entry_idx);
> +		rt2x00lib_txdone_noinfo(entry, TXDONE_UNKNOWN);
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void rt2800usb_txdone(struct rt2x00_dev *rt2x00dev)
> +{
> +	struct data_queue *queue;
> +	struct queue_entry *entry;
> +	u32 reg;
> +	u8 qid;
> +
> +	while (kfifo_get(&rt2x00dev->txstatus_fifo, &reg)) {
> +
> +		/* TX_STA_FIFO_PID_QUEUE is a 2-bit field, thus
> +		 * qid is guaranteed to be one of the TX QIDs
> +		 */
> +		qid = rt2x00_get_field32(reg, TX_STA_FIFO_PID_QUEUE);
> +		queue = rt2x00queue_get_tx_queue(rt2x00dev, qid);
> +		if (unlikely(!queue)) {
> +			WARNING(rt2x00dev, "Got TX status for an unavailable "
> +					   "queue %u, dropping\n", qid);
> +			continue;
> +		}
> +
> +		/*
> +		 * Inside each queue, we process each entry in a chronological
> +		 * order. We first check that the queue is not empty.
> +		 */
> +		entry = NULL;
> +		while (!rt2x00queue_empty(queue)) {
> +			entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
> +			if (rt2800usb_txdone_entry_check(entry, reg))
> +				break;
> +		}
> +
> +		if (!entry || rt2x00queue_empty(queue))
> +			break;
> +
> +		rt2800_txdone_entry(entry, reg);
> +	}
> +}
> +
>  static void rt2800usb_work_txdone(struct work_struct *work)
>  {
>  	struct rt2x00_dev *rt2x00dev =
> @@ -464,7 +545,7 @@ static void rt2800usb_work_txdone(struct work_struct
> *work) struct data_queue *queue;
>  	struct queue_entry *entry;
> 
> -	rt2800_txdone(rt2x00dev);
> +	rt2800usb_txdone(rt2x00dev);
> 
>  	/*
>  	 * Process any trailing TX status reports for IO failures,

