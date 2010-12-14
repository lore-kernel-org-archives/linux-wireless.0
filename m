Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f45.google.com ([209.85.214.45]:41962 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab0LNRyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 12:54:00 -0500
Received: by bwz16 with SMTP id 16so1089960bwz.4
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 09:51:01 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 14/17] rt2x00: Fix WMM Queue naming
Date: Tue, 14 Dec 2010 18:49:48 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Johannes Stezenbach <js@sig21.net>, jay.weihung@gmail.com
References: <201012131231.28313.IvDoorn@gmail.com> <201012131236.19791.IvDoorn@gmail.com> <201012131236.39071.IvDoorn@gmail.com>
In-Reply-To: <201012131236.39071.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012141849.48488.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 13. Dezember 2010 schrieb Ivo van Doorn:
> The Queue names were incorrectly copied from the legacy drivers,
> as a result the queue names were inversed to what was expected.
> 
> This renames the queues using this mapping:
> 	QID_AC_BK -> QID_AC_VO (priority 0)
> 	QID_AC_BE -> QID_AC_VI (priority 1)
> 	QID_AC_VI -> QID_AC_BE (priority 2)
> 	QID_AC_VO -> QID_AC_BK (priority 3)
> 
> Note that this was a naming problem only, which didn't affect
> the assignment of frames to their respective queues.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

Ivo, due to the latest info from Ralink I'd say we should drop this patch
and instead introduce a mac80211_to_rt2x00_qid mapper that maps from
ieee80211_ac_numbers to data_queue_qid.

This patch doesn't cause any harm, but we would have to revert it partly
if we introduce the queue mapping as needed by the rt2x00 devices.

Thanks,
Helmut

> ---
>  drivers/net/wireless/rt2x00/rt2400pci.c   |   12 +++---
>  drivers/net/wireless/rt2x00/rt2500pci.c   |   12 +++---
>  drivers/net/wireless/rt2x00/rt2800.h      |   44 ++++++++++----------
>  drivers/net/wireless/rt2x00/rt2800pci.c   |    4 +-
>  drivers/net/wireless/rt2x00/rt2x00queue.c |   18 ++++----
>  drivers/net/wireless/rt2x00/rt2x00queue.h |   12 +++---
>  drivers/net/wireless/rt2x00/rt2x00usb.c   |    8 ++--
>  drivers/net/wireless/rt2x00/rt61pci.c     |   16 ++++----
>  drivers/net/wireless/rt2x00/rt61pci.h     |   62 ++++++++++++++--------------
>  drivers/net/wireless/rt2x00/rt73usb.h     |   36 ++++++++--------
>  10 files changed, 112 insertions(+), 112 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 2fc6ca5..54ca49a 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -664,12 +664,12 @@ static void rt2400pci_kick_queue(struct data_queue *queue)
>  	u32 reg;
>  
>  	switch (queue->qid) {
> -	case QID_AC_BE:
> +	case QID_AC_VO:
>  		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>  		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
>  		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
>  		break;
> -	case QID_AC_BK:
> +	case QID_AC_VI:
>  		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>  		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
>  		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
> @@ -690,8 +690,8 @@ static void rt2400pci_stop_queue(struct data_queue *queue)
>  	u32 reg;
>  
>  	switch (queue->qid) {
> -	case QID_AC_BE:
> -	case QID_AC_BK:
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_ATIM:
>  		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>  		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
> @@ -1322,13 +1322,13 @@ static irqreturn_t rt2400pci_interrupt_thread(int irq, void *dev_instance)
>  	 * 4 - Priority ring transmit done interrupt.
>  	 */
>  	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
> -		rt2400pci_txdone(rt2x00dev, QID_AC_BE);
> +		rt2400pci_txdone(rt2x00dev, QID_AC_VO);
>  
>  	/*
>  	 * 5 - Tx ring transmit done interrupt.
>  	 */
>  	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
> -		rt2400pci_txdone(rt2x00dev, QID_AC_BK);
> +		rt2400pci_txdone(rt2x00dev, QID_AC_VI);
>  
>  	/* Enable interrupts again. */
>  	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index d67f911..a9ff26a 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -754,12 +754,12 @@ static void rt2500pci_kick_queue(struct data_queue *queue)
>  	u32 reg;
>  
>  	switch (queue->qid) {
> -	case QID_AC_BE:
> +	case QID_AC_VO:
>  		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>  		rt2x00_set_field32(&reg, TXCSR0_KICK_PRIO, 1);
>  		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
>  		break;
> -	case QID_AC_BK:
> +	case QID_AC_VI:
>  		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>  		rt2x00_set_field32(&reg, TXCSR0_KICK_TX, 1);
>  		rt2x00pci_register_write(rt2x00dev, TXCSR0, reg);
> @@ -780,8 +780,8 @@ static void rt2500pci_stop_queue(struct data_queue *queue)
>  	u32 reg;
>  
>  	switch (queue->qid) {
> -	case QID_AC_BE:
> -	case QID_AC_BK:
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_ATIM:
>  		rt2x00pci_register_read(rt2x00dev, TXCSR0, &reg);
>  		rt2x00_set_field32(&reg, TXCSR0_ABORT, 1);
> @@ -1455,13 +1455,13 @@ static irqreturn_t rt2500pci_interrupt_thread(int irq, void *dev_instance)
>  	 * 4 - Priority ring transmit done interrupt.
>  	 */
>  	if (rt2x00_get_field32(reg, CSR7_TXDONE_PRIORING))
> -		rt2500pci_txdone(rt2x00dev, QID_AC_BE);
> +		rt2500pci_txdone(rt2x00dev, QID_AC_VO);
>  
>  	/*
>  	 * 5 - Tx ring transmit done interrupt.
>  	 */
>  	if (rt2x00_get_field32(reg, CSR7_TXDONE_TXRING))
> -		rt2500pci_txdone(rt2x00dev, QID_AC_BK);
> +		rt2500pci_txdone(rt2x00dev, QID_AC_VI);
>  
>  	/* Enable interrupts again. */
>  	rt2x00dev->ops->lib->set_device_state(rt2x00dev,
> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index 9ea0961..4c55e85 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -213,10 +213,10 @@
>  
>  /*
>   * WMM_AIFSN_CFG: Aifsn for each EDCA AC
> - * AIFSN0: AC_BE
> - * AIFSN1: AC_BK
> - * AIFSN2: AC_VI
> - * AIFSN3: AC_VO
> + * AIFSN0: AC_VO
> + * AIFSN1: AC_VI
> + * AIFSN2: AC_BE
> + * AIFSN3: AC_BK
>   */
>  #define WMM_AIFSN_CFG			0x0214
>  #define WMM_AIFSN_CFG_AIFSN0		FIELD32(0x0000000f)
> @@ -226,10 +226,10 @@
>  
>  /*
>   * WMM_CWMIN_CSR: CWmin for each EDCA AC
> - * CWMIN0: AC_BE
> - * CWMIN1: AC_BK
> - * CWMIN2: AC_VI
> - * CWMIN3: AC_VO
> + * CWMIN0: AC_VO
> + * CWMIN1: AC_VI
> + * CWMIN2: AC_BE
> + * CWMIN3: AC_BK
>   */
>  #define WMM_CWMIN_CFG			0x0218
>  #define WMM_CWMIN_CFG_CWMIN0		FIELD32(0x0000000f)
> @@ -239,10 +239,10 @@
>  
>  /*
>   * WMM_CWMAX_CSR: CWmax for each EDCA AC
> - * CWMAX0: AC_BE
> - * CWMAX1: AC_BK
> - * CWMAX2: AC_VI
> - * CWMAX3: AC_VO
> + * CWMAX0: AC_VO
> + * CWMAX1: AC_VI
> + * CWMAX2: AC_BE
> + * CWMAX3: AC_BK
>   */
>  #define WMM_CWMAX_CFG			0x021c
>  #define WMM_CWMAX_CFG_CWMAX0		FIELD32(0x0000000f)
> @@ -251,18 +251,18 @@
>  #define WMM_CWMAX_CFG_CWMAX3		FIELD32(0x0000f000)
>  
>  /*
> - * AC_TXOP0: AC_BK/AC_BE TXOP register
> - * AC0TXOP: AC_BK in unit of 32us
> - * AC1TXOP: AC_BE in unit of 32us
> + * AC_TXOP0: AC_VO/AC_VI TXOP register
> + * AC0TXOP: AC_VO in unit of 32us
> + * AC1TXOP: AC_VI in unit of 32us
>   */
>  #define WMM_TXOP0_CFG			0x0220
>  #define WMM_TXOP0_CFG_AC0TXOP		FIELD32(0x0000ffff)
>  #define WMM_TXOP0_CFG_AC1TXOP		FIELD32(0xffff0000)
>  
>  /*
> - * AC_TXOP1: AC_VO/AC_VI TXOP register
> - * AC2TXOP: AC_VI in unit of 32us
> - * AC3TXOP: AC_VO in unit of 32us
> + * AC_TXOP1: AC_BE/AC_BK TXOP register
> + * AC2TXOP: AC_BE in unit of 32us
> + * AC3TXOP: AC_BK in unit of 32us
>   */
>  #define WMM_TXOP1_CFG			0x0224
>  #define WMM_TXOP1_CFG_AC2TXOP		FIELD32(0x0000ffff)
> @@ -288,7 +288,7 @@
>  #define MCU_CMD_CFG			0x022c
>  
>  /*
> - * AC_BK register offsets
> + * AC_VO register offsets
>   */
>  #define TX_BASE_PTR0			0x0230
>  #define TX_MAX_CNT0			0x0234
> @@ -296,7 +296,7 @@
>  #define TX_DTX_IDX0			0x023c
>  
>  /*
> - * AC_BE register offsets
> + * AC_VI register offsets
>   */
>  #define TX_BASE_PTR1			0x0240
>  #define TX_MAX_CNT1			0x0244
> @@ -304,7 +304,7 @@
>  #define TX_DTX_IDX1			0x024c
>  
>  /*
> - * AC_VI register offsets
> + * AC_BE register offsets
>   */
>  #define TX_BASE_PTR2			0x0250
>  #define TX_MAX_CNT2			0x0254
> @@ -312,7 +312,7 @@
>  #define TX_DTX_IDX2			0x025c
>  
>  /*
> - * AC_VO register offsets
> + * AC_BK register offsets
>   */
>  #define TX_BASE_PTR3			0x0260
>  #define TX_MAX_CNT3			0x0264
> diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
> index 195f0be3..403013f 100644
> --- a/drivers/net/wireless/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2800pci.c
> @@ -217,10 +217,10 @@ static void rt2800pci_kick_queue(struct data_queue *queue)
>  	struct queue_entry *entry;
>  
>  	switch (queue->qid) {
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_AC_BE:
>  	case QID_AC_BK:
> -	case QID_AC_VI:
> -	case QID_AC_VO:
>  		entry = rt2x00queue_get_entry(queue, Q_INDEX);
>  		rt2800_register_write(rt2x00dev, TX_CTX_IDX(queue->qid), entry->entry_idx);
>  		break;
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
> index 52cc92d..ca82b3a 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
> @@ -746,10 +746,10 @@ void rt2x00queue_pause_queue(struct data_queue *queue)
>  		return;
>  
>  	switch (queue->qid) {
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_AC_BE:
>  	case QID_AC_BK:
> -	case QID_AC_VI:
> -	case QID_AC_VO:
>  		/*
>  		 * For TX queues, we have to disable the queue
>  		 * inside mac80211.
> @@ -770,10 +770,10 @@ void rt2x00queue_unpause_queue(struct data_queue *queue)
>  		return;
>  
>  	switch (queue->qid) {
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_AC_BE:
>  	case QID_AC_BK:
> -	case QID_AC_VI:
> -	case QID_AC_VO:
>  		/*
>  		 * For TX queues, we have to enable the queue
>  		 * inside mac80211.
> @@ -834,10 +834,10 @@ void rt2x00queue_flush_queue(struct data_queue *queue, bool drop)
>  	unsigned int i;
>  	bool started;
>  	bool tx_queue =
> -		(queue->qid == QID_AC_BE) ||
> -		(queue->qid == QID_AC_BK) ||
> +		(queue->qid == QID_AC_VO) ||
>  		(queue->qid == QID_AC_VI) ||
> -		(queue->qid == QID_AC_VO);
> +		(queue->qid == QID_AC_BE) ||
> +		(queue->qid == QID_AC_BK);
>  
>  	mutex_lock(&queue->status_lock);
>  
> @@ -1141,7 +1141,7 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
>  	/*
>  	 * Initialize queue parameters.
>  	 * RX: qid = QID_RX
> -	 * TX: qid = QID_AC_BE + index
> +	 * TX: qid = QID_AC_VO + index
>  	 * TX: cw_min: 2^5 = 32.
>  	 * TX: cw_max: 2^10 = 1024.
>  	 * BCN: qid = QID_BEACON
> @@ -1149,7 +1149,7 @@ int rt2x00queue_allocate(struct rt2x00_dev *rt2x00dev)
>  	 */
>  	rt2x00queue_init(rt2x00dev, rt2x00dev->rx, QID_RX);
>  
> -	qid = QID_AC_BE;
> +	qid = QID_AC_VO;
>  	tx_queue_for_each(rt2x00dev, queue)
>  		rt2x00queue_init(rt2x00dev, queue, qid++);
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
> index 4765934..fab8e26 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00queue.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
> @@ -45,10 +45,10 @@
>  /**
>   * enum data_queue_qid: Queue identification
>   *
> + * @QID_AC_VO: AC VO queue
> + * @QID_AC_VI: AC VI queue
>   * @QID_AC_BE: AC BE queue
>   * @QID_AC_BK: AC BK queue
> - * @QID_AC_VI: AC VI queue
> - * @QID_AC_VO: AC VO queue
>   * @QID_HCCA: HCCA queue
>   * @QID_MGMT: MGMT queue (prio queue)
>   * @QID_RX: RX queue
> @@ -57,10 +57,10 @@
>   * @QID_ATIM: Atim queue (value unspeficied, don't send it to device)
>   */
>  enum data_queue_qid {
> -	QID_AC_BE = 0,
> -	QID_AC_BK = 1,
> -	QID_AC_VI = 2,
> -	QID_AC_VO = 3,
> +	QID_AC_VO = 0,
> +	QID_AC_VI = 1,
> +	QID_AC_BE = 2,
> +	QID_AC_BK = 3,
>  	QID_HCCA = 4,
>  	QID_MGMT = 13,
>  	QID_RX = 14,
> diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
> index 8a16b51..1a9937d 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
> @@ -353,10 +353,10 @@ static void rt2x00usb_kick_rx_entry(struct queue_entry *entry)
>  void rt2x00usb_kick_queue(struct data_queue *queue)
>  {
>  	switch (queue->qid) {
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_AC_BE:
>  	case QID_AC_BK:
> -	case QID_AC_VI:
> -	case QID_AC_VO:
>  		if (!rt2x00queue_empty(queue))
>  			rt2x00queue_for_each_entry(queue, Q_INDEX_DONE, Q_INDEX,
>  						   rt2x00usb_kick_tx_entry);
> @@ -403,10 +403,10 @@ void rt2x00usb_flush_queue(struct data_queue *queue)
>  	 * Obtain the queue completion handler
>  	 */
>  	switch (queue->qid) {
> +	case QID_AC_VO:
> +	case QID_AC_VI:
>  	case QID_AC_BE:
>  	case QID_AC_BK:
> -	case QID_AC_VI:
> -	case QID_AC_VO:
>  		completion = &queue->rt2x00dev->txdone_work;
>  		break;
>  	case QID_RX:
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index 7156b78..9405b10 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -1171,22 +1171,22 @@ static void rt61pci_kick_queue(struct data_queue *queue)
>  	u32 reg;
>  
>  	switch (queue->qid) {
> -	case QID_AC_BE:
> +	case QID_AC_VO:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC0, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  		break;
> -	case QID_AC_BK:
> +	case QID_AC_VI:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC1, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  		break;
> -	case QID_AC_VI:
> +	case QID_AC_BE:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC2, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  		break;
> -	case QID_AC_VO:
> +	case QID_AC_BK:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_KICK_TX_AC3, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
> @@ -1202,22 +1202,22 @@ static void rt61pci_stop_queue(struct data_queue *queue)
>  	u32 reg;
>  
>  	switch (queue->qid) {
> -	case QID_AC_BE:
> +	case QID_AC_VO:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC0, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  		break;
> -	case QID_AC_BK:
> +	case QID_AC_VI:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC1, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  		break;
> -	case QID_AC_VI:
> +	case QID_AC_BE:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC2, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
>  		break;
> -	case QID_AC_VO:
> +	case QID_AC_BK:
>  		rt2x00pci_register_read(rt2x00dev, TX_CNTL_CSR, &reg);
>  		rt2x00_set_field32(&reg, TX_CNTL_CSR_ABORT_TX_AC3, 1);
>  		rt2x00pci_register_write(rt2x00dev, TX_CNTL_CSR, reg);
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.h b/drivers/net/wireless/rt2x00/rt61pci.h
> index afc803b..e3cd6db 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.h
> +++ b/drivers/net/wireless/rt2x00/rt61pci.h
> @@ -784,25 +784,25 @@ struct hw_pairwise_ta_entry {
>   */
>  
>  /*
> - * AC0_BASE_CSR: AC_BK base address.
> + * AC0_BASE_CSR: AC_VO base address.
>   */
>  #define AC0_BASE_CSR			0x3400
>  #define AC0_BASE_CSR_RING_REGISTER	FIELD32(0xffffffff)
>  
>  /*
> - * AC1_BASE_CSR: AC_BE base address.
> + * AC1_BASE_CSR: AC_VI base address.
>   */
>  #define AC1_BASE_CSR			0x3404
>  #define AC1_BASE_CSR_RING_REGISTER	FIELD32(0xffffffff)
>  
>  /*
> - * AC2_BASE_CSR: AC_VI base address.
> + * AC2_BASE_CSR: AC_BE base address.
>   */
>  #define AC2_BASE_CSR			0x3408
>  #define AC2_BASE_CSR_RING_REGISTER	FIELD32(0xffffffff)
>  
>  /*
> - * AC3_BASE_CSR: AC_VO base address.
> + * AC3_BASE_CSR: AC_BK base address.
>   */
>  #define AC3_BASE_CSR			0x340c
>  #define AC3_BASE_CSR_RING_REGISTER	FIELD32(0xffffffff)
> @@ -814,7 +814,7 @@ struct hw_pairwise_ta_entry {
>  #define MGMT_BASE_CSR_RING_REGISTER	FIELD32(0xffffffff)
>  
>  /*
> - * TX_RING_CSR0: TX Ring size for AC_BK, AC_BE, AC_VI, AC_VO.
> + * TX_RING_CSR0: TX Ring size for AC_VO, AC_VI, AC_BE, AC_BK.
>   */
>  #define TX_RING_CSR0			0x3418
>  #define TX_RING_CSR0_AC0_RING_SIZE	FIELD32(0x000000ff)
> @@ -833,10 +833,10 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * AIFSN_CSR: AIFSN for each EDCA AC.
> - * AIFSN0: For AC_BK.
> - * AIFSN1: For AC_BE.
> - * AIFSN2: For AC_VI.
> - * AIFSN3: For AC_VO.
> + * AIFSN0: For AC_VO.
> + * AIFSN1: For AC_VI.
> + * AIFSN2: For AC_BE.
> + * AIFSN3: For AC_BK.
>   */
>  #define AIFSN_CSR			0x3420
>  #define AIFSN_CSR_AIFSN0		FIELD32(0x0000000f)
> @@ -846,10 +846,10 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * CWMIN_CSR: CWmin for each EDCA AC.
> - * CWMIN0: For AC_BK.
> - * CWMIN1: For AC_BE.
> - * CWMIN2: For AC_VI.
> - * CWMIN3: For AC_VO.
> + * CWMIN0: For AC_VO.
> + * CWMIN1: For AC_VI.
> + * CWMIN2: For AC_BE.
> + * CWMIN3: For AC_BK.
>   */
>  #define CWMIN_CSR			0x3424
>  #define CWMIN_CSR_CWMIN0		FIELD32(0x0000000f)
> @@ -859,10 +859,10 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * CWMAX_CSR: CWmax for each EDCA AC.
> - * CWMAX0: For AC_BK.
> - * CWMAX1: For AC_BE.
> - * CWMAX2: For AC_VI.
> - * CWMAX3: For AC_VO.
> + * CWMAX0: For AC_VO.
> + * CWMAX1: For AC_VI.
> + * CWMAX2: For AC_BE.
> + * CWMAX3: For AC_BK.
>   */
>  #define CWMAX_CSR			0x3428
>  #define CWMAX_CSR_CWMAX0		FIELD32(0x0000000f)
> @@ -883,14 +883,14 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * TX_CNTL_CSR: KICK/Abort TX.
> - * KICK_TX_AC0: For AC_BK.
> - * KICK_TX_AC1: For AC_BE.
> - * KICK_TX_AC2: For AC_VI.
> - * KICK_TX_AC3: For AC_VO.
> - * ABORT_TX_AC0: For AC_BK.
> - * ABORT_TX_AC1: For AC_BE.
> - * ABORT_TX_AC2: For AC_VI.
> - * ABORT_TX_AC3: For AC_VO.
> + * KICK_TX_AC0: For AC_VO.
> + * KICK_TX_AC1: For AC_VI.
> + * KICK_TX_AC2: For AC_BE.
> + * KICK_TX_AC3: For AC_BK.
> + * ABORT_TX_AC0: For AC_VO.
> + * ABORT_TX_AC1: For AC_VI.
> + * ABORT_TX_AC2: For AC_BE.
> + * ABORT_TX_AC3: For AC_BK.
>   */
>  #define TX_CNTL_CSR			0x3430
>  #define TX_CNTL_CSR_KICK_TX_AC0		FIELD32(0x00000001)
> @@ -1010,18 +1010,18 @@ struct hw_pairwise_ta_entry {
>  #define E2PROM_CSR_LOAD_STATUS		FIELD32(0x00000040)
>  
>  /*
> - * AC_TXOP_CSR0: AC_BK/AC_BE TXOP register.
> - * AC0_TX_OP: For AC_BK, in unit of 32us.
> - * AC1_TX_OP: For AC_BE, in unit of 32us.
> + * AC_TXOP_CSR0: AC_VO/AC_VI TXOP register.
> + * AC0_TX_OP: For AC_VO, in unit of 32us.
> + * AC1_TX_OP: For AC_VI, in unit of 32us.
>   */
>  #define AC_TXOP_CSR0			0x3474
>  #define AC_TXOP_CSR0_AC0_TX_OP		FIELD32(0x0000ffff)
>  #define AC_TXOP_CSR0_AC1_TX_OP		FIELD32(0xffff0000)
>  
>  /*
> - * AC_TXOP_CSR1: AC_VO/AC_VI TXOP register.
> - * AC2_TX_OP: For AC_VI, in unit of 32us.
> - * AC3_TX_OP: For AC_VO, in unit of 32us.
> + * AC_TXOP_CSR1: AC_BE/AC_BK TXOP register.
> + * AC2_TX_OP: For AC_BE, in unit of 32us.
> + * AC3_TX_OP: For AC_BK, in unit of 32us.
>   */
>  #define AC_TXOP_CSR1			0x3478
>  #define AC_TXOP_CSR1_AC2_TX_OP		FIELD32(0x0000ffff)
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.h b/drivers/net/wireless/rt2x00/rt73usb.h
> index 1315ce5..9f6b470 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.h
> +++ b/drivers/net/wireless/rt2x00/rt73usb.h
> @@ -689,10 +689,10 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * AIFSN_CSR: AIFSN for each EDCA AC.
> - * AIFSN0: For AC_BK.
> - * AIFSN1: For AC_BE.
> - * AIFSN2: For AC_VI.
> - * AIFSN3: For AC_VO.
> + * AIFSN0: For AC_VO.
> + * AIFSN1: For AC_VI.
> + * AIFSN2: For AC_BE.
> + * AIFSN3: For AC_BK.
>   */
>  #define AIFSN_CSR			0x0400
>  #define AIFSN_CSR_AIFSN0		FIELD32(0x0000000f)
> @@ -702,10 +702,10 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * CWMIN_CSR: CWmin for each EDCA AC.
> - * CWMIN0: For AC_BK.
> - * CWMIN1: For AC_BE.
> - * CWMIN2: For AC_VI.
> - * CWMIN3: For AC_VO.
> + * CWMIN0: For AC_VO.
> + * CWMIN1: For AC_VI.
> + * CWMIN2: For AC_BE.
> + * CWMIN3: For AC_BK.
>   */
>  #define CWMIN_CSR			0x0404
>  #define CWMIN_CSR_CWMIN0		FIELD32(0x0000000f)
> @@ -715,10 +715,10 @@ struct hw_pairwise_ta_entry {
>  
>  /*
>   * CWMAX_CSR: CWmax for each EDCA AC.
> - * CWMAX0: For AC_BK.
> - * CWMAX1: For AC_BE.
> - * CWMAX2: For AC_VI.
> - * CWMAX3: For AC_VO.
> + * CWMAX0: For AC_VO.
> + * CWMAX1: For AC_VI.
> + * CWMAX2: For AC_BE.
> + * CWMAX3: For AC_BK.
>   */
>  #define CWMAX_CSR			0x0408
>  #define CWMAX_CSR_CWMAX0		FIELD32(0x0000000f)
> @@ -727,18 +727,18 @@ struct hw_pairwise_ta_entry {
>  #define CWMAX_CSR_CWMAX3		FIELD32(0x0000f000)
>  
>  /*
> - * AC_TXOP_CSR0: AC_BK/AC_BE TXOP register.
> - * AC0_TX_OP: For AC_BK, in unit of 32us.
> - * AC1_TX_OP: For AC_BE, in unit of 32us.
> + * AC_TXOP_CSR0: AC_VO/AC_VI TXOP register.
> + * AC0_TX_OP: For AC_VO, in unit of 32us.
> + * AC1_TX_OP: For AC_VI, in unit of 32us.
>   */
>  #define AC_TXOP_CSR0			0x040c
>  #define AC_TXOP_CSR0_AC0_TX_OP		FIELD32(0x0000ffff)
>  #define AC_TXOP_CSR0_AC1_TX_OP		FIELD32(0xffff0000)
>  
>  /*
> - * AC_TXOP_CSR1: AC_VO/AC_VI TXOP register.
> - * AC2_TX_OP: For AC_VI, in unit of 32us.
> - * AC3_TX_OP: For AC_VO, in unit of 32us.
> + * AC_TXOP_CSR1: AC_BE/AC_BK TXOP register.
> + * AC2_TX_OP: For AC_BE, in unit of 32us.
> + * AC3_TX_OP: For AC_BK, in unit of 32us.
>   */
>  #define AC_TXOP_CSR1			0x0410
>  #define AC_TXOP_CSR1_AC2_TX_OP		FIELD32(0x0000ffff)
> 

