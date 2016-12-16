Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59991 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbcLPLV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 06:21:59 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 11/11] ath10k: Added sdio support
Date: Fri, 16 Dec 2016 11:21:52 +0000
Message-ID: <871sx8unjn.fsf@kamboji.qca.qualcomm.com> (sfid-20161216_122204_202258_96C794B7)
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
        <1479496971-19174-12-git-send-email-erik.stromdahl@gmail.com>
In-Reply-To: <1479496971-19174-12-git-send-email-erik.stromdahl@gmail.com>
        (Erik Stromdahl's message of "Fri, 18 Nov 2016 20:22:51 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Initial HIF sdio/mailbox implementation.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

I know most of this coming from ath6kl but I think we should still
improve the code. Lots of comments will follow, don't get scared :)

> +#define CALC_TXRX_PADDED_LEN(ar_sdio, len) \
> +	(__ALIGN_MASK((len), (ar_sdio)->mbox_info.block_mask))

I think this could be a proper static inline function. Andrew Morton
once said: "Write in C, not CPP" (or something like that), I think
that's a really good point.

> +static int ath10k_sdio_read_write_sync(struct ath10k *ar, u32 addr, u8 *=
buf,
> +				       u32 len, u32 request);
> +static int ath10k_sdio_hif_diag_read(struct ath10k *ar, u32 address, voi=
d *buf,
> +				     size_t buf_len);
> +static int ath10k_sdio_hif_diag_read32(struct ath10k *ar, u32 address,
> +				       u32 *value);

We prefer to avoid forward declarations if at all possible. I didn't
check but if there's a clean way to avoid these please remove them.

> +/* HIF mbox interrupt handling */
> +
> +static int ath10k_sdio_mbox_rx_process_packet(struct ath10k_sdio *ar_sdi=
o,
> +					      struct ath10k_sdio_rx_data *pkt,
> +					      u32 *lookaheads,
> +					      int *n_lookaheads)
> +{

So the style in ath10k is that all functions (of course this doesn't
apply to callbacks etc) have "struct ath10k *ar" as the first parameter.
This way there's no need to check if a function takes ar or ar_sdio.

> +	int status =3D 0;

In ath10k we prefer to use ret. And avoid initialising it, please.

> +	struct ath10k_htc *htc =3D &ar_sdio->ar->htc;
> +	struct sk_buff *skb =3D pkt->skb;
> +	struct ath10k_htc_hdr *htc_hdr =3D (struct ath10k_htc_hdr *)skb->data;
> +	bool trailer_present =3D htc_hdr->flags & ATH10K_HTC_FLAG_TRAILER_PRESE=
NT;
> +	u16 payload_len;
> +
> +	payload_len =3D le16_to_cpu(htc_hdr->len);
> +
> +	if (trailer_present) {
> +		u8 *trailer;
> +		enum ath10k_htc_ep_id eid;
> +
> +		trailer =3D skb->data + sizeof(struct ath10k_htc_hdr) +
> +			  payload_len - htc_hdr->trailer_len;
> +
> +		eid =3D (enum ath10k_htc_ep_id)htc_hdr->eid;

A some kind of mapping function for ep id would be nice, it makes it
more visible how it works.

> +static int ath10k_sdio_mbox_rx_process_packets(struct ath10k_sdio *ar_sd=
io,
> +					       u32 lookaheads[],
> +					       int *n_lookahead)
> +{
> +	struct ath10k *ar =3D ar_sdio->ar;
> +	struct ath10k_htc *htc =3D &ar->htc;
> +	struct ath10k_sdio_rx_data *pkt;
> +	int status =3D 0, i;
> +
> +	for (i =3D 0; i < ar_sdio->n_rx_pkts; i++) {
> +		struct ath10k_htc_ep *ep;
> +		enum ath10k_htc_ep_id id;
> +		u32 *lookaheads_local =3D lookaheads;
> +		int *n_lookahead_local =3D n_lookahead;
> +
> +		id =3D ((struct ath10k_htc_hdr *)&lookaheads[i])->eid;
> +
> +		if (id >=3D ATH10K_HTC_EP_COUNT) {
> +			ath10k_err(ar, "Invalid endpoint in look-ahead: %d\n",
> +				   id);

In ath10k we use ath10k_err() for errors from which can't survive and
ath10k_warn() for errors where we try to continue. So ath10k_warn()
would be more approriate here and most of other cases in sdio.c

> +			status =3D -ENOMEM;
> +			goto out;
> +		}
> +
> +		ep =3D &htc->endpoint[id];
> +
> +		if (ep->service_id =3D=3D 0) {
> +			ath10k_err(ar, "ep %d is not connected !\n", id);
> +			status =3D -ENOMEM;
> +			goto out;
> +		}
> +
> +		pkt =3D &ar_sdio->rx_pkts[i];
> +
> +		if (pkt->part_of_bundle && !pkt->last_in_bundle) {
> +			/* Only read lookahead's from RX trailers
> +			 * for the last packet in a bundle.
> +			 */
> +			lookaheads_local =3D NULL;
> +			n_lookahead_local =3D NULL;
> +		}
> +
> +		status =3D ath10k_sdio_mbox_rx_process_packet(ar_sdio,
> +							    pkt,
> +							    lookaheads_local,
> +							    n_lookahead_local);
> +		if (status)
> +			goto out;
> +
> +		ep->ep_ops.ep_rx_complete(ar_sdio->ar, pkt->skb);
> +		/* The RX complete handler now owns the skb...*/
> +		pkt->skb =3D NULL;
> +		pkt->alloc_len =3D 0;
> +	}
> +
> +out:
> +	/* Free all packets that was not passed on to the RX completion
> +	 * handler...
> +	 */
> +	for (; i < ar_sdio->n_rx_pkts; i++)
> +		ath10k_sdio_mbox_free_rx_pkt(&ar_sdio->rx_pkts[i]);

I got a bit fooled by not initialising i here and only then realised
why. I guess it's ok but a bit of so and so

> +
> +	return status;
> +}
> +
> +static int alloc_pkt_bundle(struct ath10k *ar,
> +			    struct ath10k_sdio_rx_data *rx_pkts,
> +			    struct ath10k_htc_hdr *htc_hdr,
> +			    size_t full_len, size_t act_len, size_t *bndl_cnt)
> +{
> +	int i, status =3D 0;
> +
> +	*bndl_cnt =3D (htc_hdr->flags & ATH10K_HTC_FLAG_BUNDLE_MASK) >>
> +		    ATH10K_HTC_FLAG_BUNDLE_LSB;

We recently got FIELD_GET() and FIELD_PREP() to kernel for handling
bitmasks. ath10k is not yet converted (patches welcome!) but it would be
good to use those already in sdio.c. Also SM() could be replaced with
those.

> +int ath10k_sdio_mbox_rxmsg_pending_handler(struct ath10k_sdio *ar_sdio,
> +					   u32 msg_lookahead, bool *done)
> +{
> +	struct ath10k *ar =3D ar_sdio->ar;
> +	int status =3D 0;
> +	u32 lookaheads[ATH10K_SDIO_MAX_RX_MSGS];
> +	int n_lookaheads =3D 1;
> +
> +	*done =3D true;
> +
> +	/* Copy the lookahead obtained from the HTC register table into our
> +	 * temp array as a start value.
> +	 */
> +	lookaheads[0] =3D msg_lookahead;
> +
> +	for (;;) {

Iternal loops in kernel can be dangerous. Better to add some sort of
timeout check with a warning message, something like:

while ((time_before(jiffies, timeout)) {
}

if (timed out)
        ath10k_warn("timeout in foo");

> +		/* Try to allocate as many HTC RX packets indicated by
> +		 * n_lookaheads.
> +		 */
> +		status =3D ath10k_sdio_mbox_rx_alloc(ar_sdio, lookaheads,
> +						   n_lookaheads);
> +		if (status)
> +			break;
> +
> +		if (ar_sdio->n_rx_pkts >=3D 2)
> +			/* A recv bundle was detected, force IRQ status
> +			 * re-check again.
> +			 */
> +			*done =3D false;
> +
> +		status =3D ath10k_sdio_mbox_rx_fetch(ar_sdio);
> +
> +		/* Process fetched packets. This will potentially update
> +		 * n_lookaheads depending on if the packets contain lookahead
> +		 * reports.
> +		 */
> +		n_lookaheads =3D 0;
> +		status =3D ath10k_sdio_mbox_rx_process_packets(ar_sdio,
> +							     lookaheads,
> +							     &n_lookaheads);
> +
> +		if (!n_lookaheads || status)
> +			break;
> +
> +		/* For SYNCH processing, if we get here, we are running
> +		 * through the loop again due to updated lookaheads. Set
> +		 * flag that we should re-check IRQ status registers again
> +		 * before leaving IRQ processing, this can net better
> +		 * performance in high throughput situations.
> +		 */
> +		*done =3D false;
> +	}
> +
> +	if (status && (status !=3D -ECANCELED))
> +		ath10k_err(ar, "failed to get pending recv messages: %d\n",
> +			   status);
> +
> +	if (atomic_read(&ar_sdio->stopping)) {
> +		ath10k_warn(ar, "host is going to stop. Turning of RX\n");
> +		ath10k_sdio_hif_rx_control(ar_sdio, false);
> +	}

I'm always skeptic when I use atomic variables used like this, I doubt
it's really correct.

> +
> +	return status;
> +}
> +
> +static int ath10k_sdio_mbox_proc_dbg_intr(struct ath10k_sdio *ar_sdio)
> +{
> +	int ret;
> +	u32 dummy;
> +	struct ath10k *ar =3D ar_sdio->ar;
> +
> +	ath10k_warn(ar, "firmware crashed\n");

We have firmware crash dump support in ath10k. You could add a "TODO:"
comment about implementing that later.

> +static int ath10k_sdio_mbox_proc_err_intr(struct ath10k_sdio *ar_sdio)
> +{
> +	int status;
> +	u8 error_int_status;
> +	u8 reg_buf[4];
> +	struct ath10k_sdio_irq_data *irq_data =3D &ar_sdio->irq_data;
> +	struct ath10k *ar =3D ar_sdio->ar;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_SDIO, "error interrupt\n");
> +
> +	error_int_status =3D irq_data->irq_proc_reg.error_int_status & 0x0F;
> +	if (!error_int_status) {
> +		WARN_ON(1);
> +		return -EIO;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_SDIO,
> +		   "valid interrupt source(s) in ERROR_INT_STATUS: 0x%x\n",
> +		   error_int_status);
> +
> +	if (MS(error_int_status, MBOX_ERROR_INT_STATUS_WAKEUP))
> +		ath10k_dbg(ar, ATH10K_DBG_SDIO, "error : wakeup\n");
> +
> +	if (MS(error_int_status, MBOX_ERROR_INT_STATUS_RX_UNDERFLOW))
> +		ath10k_err(ar, "rx underflow\n");
> +
> +	if (MS(error_int_status, MBOX_ERROR_INT_STATUS_TX_OVERFLOW))
> +		ath10k_err(ar, "tx overflow\n");
> +
> +	/* Clear the interrupt */
> +	irq_data->irq_proc_reg.error_int_status &=3D ~error_int_status;
> +
> +	/* set W1C value to clear the interrupt, this hits the register first *=
/
> +	reg_buf[0] =3D error_int_status;
> +	reg_buf[1] =3D 0;
> +	reg_buf[2] =3D 0;
> +	reg_buf[3] =3D 0;
> +
> +	status =3D ath10k_sdio_read_write_sync(ar,
> +					     MBOX_ERROR_INT_STATUS_ADDRESS,
> +					     reg_buf, 4, HIF_WR_SYNC_BYTE_FIX);
> +
> +	WARN_ON(status);

This is a bit dangerous, in worst case it can spam the kernel log and
force a host reboot due watchdog timing out etc.

Better to replace with standard warning message:

ret =3D ath10k_sdio_read_write_sync(ar,
				     MBOX_ERROR_INT_STATUS_ADDRESS,
				     reg_buf, 4, HIF_WR_SYNC_BYTE_FIX);
if (ret) {
        ath10k_warn("failed to read interrupr status: %d", ret);
        return ret;
}

> +static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k_sdio *ar_sdio)
> +{
> +	int status;
> +	struct ath10k_sdio_irq_data *irq_data =3D &ar_sdio->irq_data;
> +	struct ath10k *ar =3D ar_sdio->ar;
> +	u8 cpu_int_status, reg_buf[4];
> +
> +	cpu_int_status =3D irq_data->irq_proc_reg.cpu_int_status &
> +			 irq_data->irq_en_reg.cpu_int_status_en;
> +	if (!cpu_int_status) {
> +		WARN_ON(1);
> +		return -EIO;
> +	}

Ditto about WARN_ON(), ath10k_warn() is much better.

> +/* process pending interrupts synchronously */
> +static int ath10k_sdio_mbox_proc_pending_irqs(struct ath10k_sdio *ar_sdi=
o,
> +					      bool *done)
> +{
> +	struct ath10k_sdio_irq_data *irq_data =3D &ar_sdio->irq_data;
> +	struct ath10k *ar =3D ar_sdio->ar;
> +	struct ath10k_sdio_irq_proc_registers *rg;
> +	int status =3D 0;
> +	u8 host_int_status =3D 0;
> +	u32 lookahead =3D 0;
> +	u8 htc_mbox =3D 1 << ATH10K_HTC_MAILBOX;
> +
> +	/* NOTE: HIF implementation guarantees that the context of this
> +	 * call allows us to perform SYNCHRONOUS I/O, that is we can block,
> +	 * sleep or call any API that can block or switch thread/task
> +	 * contexts. This is a fully schedulable context.
> +	 */
> +
> +	/* Process pending intr only when int_status_en is clear, it may
> +	 * result in unnecessary bus transaction otherwise. Target may be
> +	 * unresponsive at the time.
> +	 */
> +	if (irq_data->irq_en_reg.int_status_en) {
> +		/* Read the first sizeof(struct ath10k_irq_proc_registers)
> +		 * bytes of the HTC register table. This
> +		 * will yield us the value of different int status
> +		 * registers and the lookahead registers.
> +		 */
> +		status =3D ath10k_sdio_read_write_sync(
> +				ar,
> +				MBOX_HOST_INT_STATUS_ADDRESS,
> +				(u8 *)&irq_data->irq_proc_reg,
> +				sizeof(irq_data->irq_proc_reg),
> +				HIF_RD_SYNC_BYTE_INC);
> +		if (status)
> +			goto out;
> +
> +		/* Update only those registers that are enabled */
> +		host_int_status =3D irq_data->irq_proc_reg.host_int_status &
> +				  irq_data->irq_en_reg.int_status_en;
> +
> +		/* Look at mbox status */
> +		if (host_int_status & htc_mbox) {
> +			/* Mask out pending mbox value, we use look ahead as
> +			 * the real flag for mbox processing.
> +			 */
> +			host_int_status &=3D ~htc_mbox;
> +			if (irq_data->irq_proc_reg.rx_lookahead_valid &
> +			    htc_mbox) {
> +				rg =3D &irq_data->irq_proc_reg;
> +				lookahead =3D le32_to_cpu(
> +					rg->rx_lookahead[ATH10K_HTC_MAILBOX]);
> +				if (!lookahead)
> +					ath10k_err(ar, "lookahead is zero!\n");
> +			}
> +		}
> +	}
> +
> +	if (!host_int_status && !lookahead) {
> +		*done =3D true;
> +		goto out;
> +	}
> +
> +	if (lookahead) {
> +		ath10k_dbg(ar, ATH10K_DBG_SDIO,
> +			   "pending mailbox msg, lookahead: 0x%08X\n",
> +			   lookahead);
> +
> +		status =3D ath10k_sdio_mbox_rxmsg_pending_handler(ar_sdio,
> +								lookahead,
> +								done);
> +		if (status)
> +			goto out;
> +	}
> +
> +	/* now, handle the rest of the interrupts */
> +	ath10k_dbg(ar, ATH10K_DBG_SDIO,
> +		   "valid interrupt source(s) for other interrupts: 0x%x\n",
> +		   host_int_status);
> +
> +	if (MS(host_int_status, MBOX_HOST_INT_STATUS_CPU)) {
> +		/* CPU Interrupt */
> +		status =3D ath10k_sdio_mbox_proc_cpu_intr(ar_sdio);
> +		if (status)
> +			goto out;
> +	}
> +
> +	if (MS(host_int_status, MBOX_HOST_INT_STATUS_ERROR)) {
> +		/* Error Interrupt */
> +		status =3D ath10k_sdio_mbox_proc_err_intr(ar_sdio);
> +		if (status)
> +			goto out;
> +	}
> +
> +	if (MS(host_int_status, MBOX_HOST_INT_STATUS_COUNTER))
> +		/* Counter Interrupt */
> +		status =3D ath10k_sdio_mbox_proc_counter_intr(ar_sdio);
> +
> +out:
> +	/* An optimization to bypass reading the IRQ status registers
> +	 * unecessarily which can re-wake the target, if upper layers
> +	 * determine that we are in a low-throughput mode, we can rely on
> +	 * taking another interrupt rather than re-checking the status
> +	 * registers which can re-wake the target.
> +	 *
> +	 * NOTE : for host interfaces that makes use of detecting pending
> +	 * mbox messages at hif can not use this optimization due to
> +	 * possible side effects, SPI requires the host to drain all
> +	 * messages from the mailbox before exiting the ISR routine.
> +	 */
> +
> +	ath10k_dbg(ar, ATH10K_DBG_SDIO,
> +		   "%s: (done:%d, status=3D%d)\n", __func__, *done, status);

We try to follow this kind of format for debug messages:

"sdio pending irqs done %d status %d"

So start with the debug level name followed by the debug separated with spa=
ces.

And IIRC no need for "\n", the macro adds that automatically.

> +
> +	return status;
> +}
> +
> +/* Macro to check if DMA buffer is WORD-aligned and DMA-able.
> + * Most host controllers assume the buffer is DMA'able and will
> + * bug-check otherwise (i.e. buffers on the stack). virt_addr_valid
> + * check fails on stack memory.
> + */
> +static inline bool buf_needs_bounce(u8 *buf)
> +{
> +	return ((unsigned long)buf & 0x3) || !virt_addr_valid(buf);
> +}

IS_ALIGNED()? And this is super ugly, do we really need this? I would
much prefer that we would directly use struct sk_buff, more of that
later.

> +static inline enum ath10k_htc_ep_id pipe_id_to_eid(u8 pipe_id)
> +{
> +	return (enum ath10k_htc_ep_id)pipe_id;
> +}

Oh, we already have a this kind of mapping function? Can't this be used
earlier?

> +static void ath10k_sdio_set_mbox_info(struct ath10k_sdio *ar_sdio)
> +{
> +	struct ath10k_mbox_info *mbox_info =3D &ar_sdio->mbox_info;
> +	u16 device =3D ar_sdio->func->device;
> +
> +	mbox_info->htc_addr =3D ATH10K_HIF_MBOX_BASE_ADDR;
> +	mbox_info->block_size =3D ATH10K_HIF_MBOX_BLOCK_SIZE;
> +	mbox_info->block_mask =3D ATH10K_HIF_MBOX_BLOCK_SIZE - 1;
> +	mbox_info->gmbox_addr =3D ATH10K_HIF_GMBOX_BASE_ADDR;
> +	mbox_info->gmbox_sz =3D ATH10K_HIF_GMBOX_WIDTH;
> +
> +	mbox_info->ext_info[0].htc_ext_addr =3D ATH10K_HIF_MBOX0_EXT_BASE_ADDR;
> +
> +	if ((device & ATH10K_MANUFACTURER_ID_REV_MASK) < 4)
> +		mbox_info->ext_info[0].htc_ext_sz =3D ATH10K_HIF_MBOX0_EXT_WIDTH;
> +	else
> +		/* from rome 2.0(0x504), the width has been extended
> +		 * to 56K
> +		 */
> +		mbox_info->ext_info[0].htc_ext_sz =3D
> +			ATH10K_HIF_MBOX0_EXT_WIDTH_ROME_2_0;
> +
> +	mbox_info->ext_info[1].htc_ext_addr =3D
> +		mbox_info->ext_info[0].htc_ext_addr +
> +		mbox_info->ext_info[0].htc_ext_sz +
> +		ATH10K_HIF_MBOX_DUMMY_SPACE_SIZE;
> +	mbox_info->ext_info[1].htc_ext_sz =3D ATH10K_HIF_MBOX1_EXT_WIDTH;
> +}
> +
> +static inline void ath10k_sdio_set_cmd52_arg(u32 *arg, u8 write, u8 raw,
> +					     unsigned int address,
> +					     unsigned char val)
> +{
> +	const u8 func =3D 0;
> +
> +	*arg =3D ((write & 1) << 31) |
> +	       ((func & 0x7) << 28) |
> +	       ((raw & 1) << 27) |
> +	       (1 << 26) |
> +	       ((address & 0x1FFFF) << 9) |
> +	       (1 << 8) |
> +	       (val & 0xFF);
> +}

Quite ugly. FIELD_PREP() & co?

> +
> +static int ath10k_sdio_func0_cmd52_wr_byte(struct mmc_card *card,
> +					   unsigned int address,
> +					   unsigned char byte)
> +{
> +	struct mmc_command io_cmd;
> +
> +	memset(&io_cmd, 0, sizeof(io_cmd));
> +	ath10k_sdio_set_cmd52_arg(&io_cmd.arg, 1, 0, address, byte);
> +	io_cmd.opcode =3D SD_IO_RW_DIRECT;
> +	io_cmd.flags =3D MMC_RSP_R5 | MMC_CMD_AC;
> +
> +	return mmc_wait_for_cmd(card->host, &io_cmd, 0);
> +}
> +
> +static int ath10k_sdio_func0_cmd52_rd_byte(struct mmc_card *card,
> +					   unsigned int address,
> +					   unsigned char *byte)
> +{
> +	int ret;
> +	struct mmc_command io_cmd;
> +
> +	memset(&io_cmd, 0, sizeof(io_cmd));
> +	ath10k_sdio_set_cmd52_arg(&io_cmd.arg, 0, 0, address, 0);
> +	io_cmd.opcode =3D SD_IO_RW_DIRECT;
> +	io_cmd.flags =3D MMC_RSP_R5 | MMC_CMD_AC;
> +
> +	ret =3D mmc_wait_for_cmd(card->host, &io_cmd, 0);
> +	if (!ret)
> +		*byte =3D io_cmd.resp[0];
> +
> +	return ret;
> +}
> +
> +static int ath10k_sdio_io(struct ath10k_sdio *ar_sdio, u32 request, u32 =
addr,
> +			  u8 *buf, u32 len)
> +{
> +	int ret =3D 0;

Avoid these kind of unnecessary initialisations.

> +	struct sdio_func *func =3D ar_sdio->func;
> +	struct ath10k *ar =3D ar_sdio->ar;
> +
> +	sdio_claim_host(func);
> +
> +	if (request & HIF_WRITE) {
> +		if (request & HIF_FIXED_ADDRESS)
> +			ret =3D sdio_writesb(func, addr, buf, len);
> +		else
> +			ret =3D sdio_memcpy_toio(func, addr, buf, len);
> +	} else {
> +		if (request & HIF_FIXED_ADDRESS)
> +			ret =3D sdio_readsb(func, buf, addr, len);
> +		else
> +			ret =3D sdio_memcpy_fromio(func, buf, addr, len);
> +	}
> +
> +	sdio_release_host(func);
> +
> +	ath10k_dbg(ar, ATH10K_DBG_SDIO, "%s addr 0x%x%s buf 0x%p len %d\n",
> +		   request & HIF_WRITE ? "wr" : "rd", addr,
> +		   request & HIF_FIXED_ADDRESS ? " (fixed)" : "", buf, len);
> +	ath10k_dbg_dump(ar, ATH10K_DBG_SDIO_DUMP, NULL,
> +			request & HIF_WRITE ? "sdio wr " : "sdio rd ",
> +			buf, len);
> +
> +	return ret;
> +}
> +
> +static struct ath10k_sdio_bus_request
> +*ath10k_sdio_alloc_busreq(struct ath10k_sdio *ar_sdio)
> +{
> +	struct ath10k_sdio_bus_request *bus_req;
> +
> +	spin_lock_bh(&ar_sdio->lock);
> +
> +	if (list_empty(&ar_sdio->bus_req_freeq)) {
> +		spin_unlock_bh(&ar_sdio->lock);
> +		return NULL;
> +	}
> +
> +	bus_req =3D list_first_entry(&ar_sdio->bus_req_freeq,
> +				   struct ath10k_sdio_bus_request, list);
> +	list_del(&bus_req->list);
> +
> +	spin_unlock_bh(&ar_sdio->lock);
> +
> +	return bus_req;
> +}
> +
> +static void ath10k_sdio_free_bus_req(struct ath10k_sdio *ar_sdio,
> +				     struct ath10k_sdio_bus_request *bus_req)
> +{
> +	spin_lock_bh(&ar_sdio->lock);
> +	list_add_tail(&bus_req->list, &ar_sdio->bus_req_freeq);
> +	spin_unlock_bh(&ar_sdio->lock);
> +}
> +
> +static int ath10k_sdio_read_write_sync(struct ath10k *ar, u32 addr, u8 *=
buf,
> +				       u32 len, u32 request)
> +{
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	u8  *tbuf =3D NULL;

Extra space after u8?

> +	int ret;
> +	bool bounced =3D false;
> +
> +	if (request & HIF_BLOCK_BASIS)
> +		len =3D round_down(len, ar_sdio->mbox_info.block_size);
> +
> +	if (buf_needs_bounce(buf)) {
> +		if (!ar_sdio->dma_buffer)
> +			return -ENOMEM;
> +		/* FIXME: I am not sure if it is always correct to assume
> +		 * that the SDIO irq is a "fake" irq and sleep is possible.
> +		 * (this function will get called from
> +		 * ath10k_sdio_irq_handler
> +		 */
> +		mutex_lock(&ar_sdio->dma_buffer_mutex);
> +		tbuf =3D ar_sdio->dma_buffer;
> +
> +		if (request & HIF_WRITE)
> +			memcpy(tbuf, buf, len);
> +
> +		bounced =3D true;
> +	} else {
> +		tbuf =3D buf;
> +	}

So I really hate that ar_sdio->dma_buffer, do we really need it? What if
we just get rid of it and allocate struct sk_buff and pass that around?
No need to do extra copying then, I hope :)

> +
> +	ret =3D ath10k_sdio_io(ar_sdio, request, addr, tbuf, len);
> +	if ((request & HIF_READ) && bounced)
> +		memcpy(buf, tbuf, len);
> +
> +	if (bounced)
> +		mutex_unlock(&ar_sdio->dma_buffer_mutex);
> +
> +	return ret;
> +}
> +
> +static void __ath10k_sdio_write_async(struct ath10k_sdio *ar_sdio,
> +				      struct ath10k_sdio_bus_request *req)
> +{
> +	int status;
> +	struct ath10k_htc_ep *ep;
> +	struct sk_buff *skb;
> +
> +	skb =3D req->skb;
> +	status =3D ath10k_sdio_read_write_sync(ar_sdio->ar, req->address,
> +					     skb->data, req->len,
> +					     req->request);
> +	ep =3D &ar_sdio->ar->htc.endpoint[req->eid];
> +	ath10k_htc_notify_tx_completion(ep, skb);
> +	ath10k_sdio_free_bus_req(ar_sdio, req);
> +}
> +
> +static void ath10k_sdio_write_async_work(struct work_struct *work)
> +{
> +	struct ath10k_sdio *ar_sdio;
> +	struct ath10k_sdio_bus_request *req, *tmp_req;
> +
> +	ar_sdio =3D container_of(work, struct ath10k_sdio, wr_async_work);
> +
> +	spin_lock_bh(&ar_sdio->wr_async_lock);
> +	list_for_each_entry_safe(req, tmp_req, &ar_sdio->wr_asyncq, list) {
> +		list_del(&req->list);
> +		spin_unlock_bh(&ar_sdio->wr_async_lock);
> +		__ath10k_sdio_write_async(ar_sdio, req);
> +		spin_lock_bh(&ar_sdio->wr_async_lock);
> +	}
> +	spin_unlock_bh(&ar_sdio->wr_async_lock);
> +}
> +
> +static void ath10k_sdio_irq_handler(struct sdio_func *func)
> +{
> +	int status =3D 0;
> +	unsigned long timeout;
> +	struct ath10k_sdio *ar_sdio;
> +	bool done =3D false;
> +
> +	ar_sdio =3D sdio_get_drvdata(func);
> +	atomic_set(&ar_sdio->irq_handling, 1);
> +
> +	/* Release the host during interrupts so we can pick it back up when
> +	 * we process commands.
> +	 */
> +	sdio_release_host(ar_sdio->func);
> +
> +	timeout =3D jiffies + ATH10K_SDIO_HIF_COMMUNICATION_TIMEOUT_HZ;
> +	while (time_before(jiffies, timeout) && !done) {
> +		status =3D ath10k_sdio_mbox_proc_pending_irqs(ar_sdio, &done);
> +		if (status)
> +			break;
> +	}
> +
> +	sdio_claim_host(ar_sdio->func);
> +
> +	atomic_set(&ar_sdio->irq_handling, 0);
> +	wake_up(&ar_sdio->irq_wq);
> +
> +	WARN_ON(status && status !=3D -ECANCELED);
> +}

Questionable use of an atomic variable again, looks like badly implement
poor man's locking to me. And instead of wake_up() we should workqueues
or threaded irqs (if sdio supports that).

> +
> +static int ath10k_sdio_hif_disable_intrs(struct ath10k_sdio *ar_sdio)
> +{
> +	int ret;
> +	struct ath10k_sdio_irq_enable_reg regs;
> +	struct ath10k_sdio_irq_data *irq_data =3D &ar_sdio->irq_data;
> +
> +	memset(&regs, 0, sizeof(regs));
> +
> +	ret =3D ath10k_sdio_read_write_sync(ar_sdio->ar,
> +					  MBOX_INT_STATUS_ENABLE_ADDRESS,
> +					  &regs.int_status_en, sizeof(regs),
> +					  HIF_WR_SYNC_BYTE_INC);
> +	if (ret) {
> +		ath10k_err(ar_sdio->ar, "Unable to disable sdio interrupts\n");
> +		return ret;
> +	}
> +
> +	spin_lock_bh(&irq_data->lock);
> +	irq_data->irq_en_reg =3D regs;
> +	spin_unlock_bh(&irq_data->lock);
> +
> +	return 0;
> +}
> +
> +static int ath10k_sdio_hif_power_up(struct ath10k *ar)
> +{
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	struct sdio_func *func =3D ar_sdio->func;
> +	int ret =3D 0;
> +
> +	if (!ar_sdio->is_disabled)
> +		return 0;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT, "sdio power on\n");
> +
> +	sdio_claim_host(func);
> +
> +	ret =3D sdio_enable_func(func);
> +	if (ret) {
> +		ath10k_err(ar, "Unable to enable sdio func: %d)\n", ret);
> +		sdio_release_host(func);
> +		return ret;
> +	}
> +
> +	sdio_release_host(func);
> +
> +	/* Wait for hardware to initialise. It should take a lot less than
> +	 * 20 ms but let's be conservative here.
> +	 */
> +	msleep(20);
> +
> +	ar_sdio->is_disabled =3D false;
> +
> +	ret =3D ath10k_sdio_hif_disable_intrs(ar_sdio);
> +
> +	return ret;
> +}
> +
> +static void ath10k_sdio_hif_power_down(struct ath10k *ar)
> +{
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	int ret;
> +
> +	if (ar_sdio->is_disabled)
> +		return;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT, "sdio power off\n");
> +
> +	/* Disable the card */
> +	sdio_claim_host(ar_sdio->func);
> +	ret =3D sdio_disable_func(ar_sdio->func);
> +	sdio_release_host(ar_sdio->func);
> +
> +	if (ret)
> +		ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +			   "Unable to disable sdio: %d\n", ret);

Shouldn't this be ath10k_warn()?

> +
> +	ar_sdio->is_disabled =3D true;
> +}
> +
> +int ath10k_sdio_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
> +			  struct ath10k_hif_sg_item *items, int n_items)
> +{
> +	int i;
> +	u32 address;
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	struct ath10k_sdio_bus_request *bus_req;
> +
> +	bus_req =3D ath10k_sdio_alloc_busreq(ar_sdio);
> +
> +	if (WARN_ON_ONCE(!bus_req))
> +		return -ENOMEM;

Is ath10k_warn() more approriate?

> +	for (i =3D 0; i < n_items; i++) {
> +		bus_req->skb =3D items[i].transfer_context;
> +		bus_req->request =3D HIF_WRITE;
> +		bus_req->eid =3D pipe_id_to_eid(pipe_id);
> +		/* Write TX data to the end of the mbox address space */
> +		address =3D ar_sdio->mbox_addr[bus_req->eid] +
> +			  ar_sdio->mbox_size[bus_req->eid] - bus_req->skb->len;
> +		bus_req->address =3D address;
> +		bus_req->len =3D CALC_TXRX_PADDED_LEN(ar_sdio, bus_req->skb->len);
> +
> +		spin_lock_bh(&ar_sdio->wr_async_lock);
> +		list_add_tail(&bus_req->list, &ar_sdio->wr_asyncq);
> +		spin_unlock_bh(&ar_sdio->wr_async_lock);
> +	}
> +
> +	queue_work(ar_sdio->workqueue, &ar_sdio->wr_async_work);
> +
> +	return 0;
> +}
> +
> +static int ath10k_sdio_hif_enable_intrs(struct ath10k_sdio *ar_sdio)
> +{
> +	struct ath10k_sdio_irq_enable_reg regs;
> +	int status;
> +	struct ath10k_sdio_irq_data *irq_data =3D &ar_sdio->irq_data;
> +
> +	memset(&regs, 0, sizeof(regs));
> +
> +	/* Enable all but CPU interrupts */
> +	regs.int_status_en =3D SM(0x01, MBOX_INT_STATUS_ENABLE_ERROR) |
> +			     SM(0x01, MBOX_INT_STATUS_ENABLE_CPU) |
> +			     SM(0x01, MBOX_INT_STATUS_ENABLE_COUNTER);
> +
> +	/* NOTE: There are some cases where HIF can do detection of
> +	 * pending mbox messages which is disabled now.
> +	 */
> +	regs.int_status_en |=3D SM(0x01, MBOX_INT_STATUS_ENABLE_MBOX_DATA);
> +
> +	/* Set up the CPU Interrupt status Register */
> +	regs.cpu_int_status_en =3D 0;
> +
> +	/* Set up the Error Interrupt status Register */
> +	regs.err_int_status_en =3D
> +		SM(0x01, MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW) |
> +		SM(0x01, MBOX_ERROR_STATUS_ENABLE_TX_OVERFLOW);
> +
> +	/* Enable Counter interrupt status register to get fatal errors for
> +	 * debugging.
> +	 */
> +	regs.cntr_int_status_en =3D SM(ATH10K_SDIO_TARGET_DEBUG_INTR_MASK,
> +				     MBOX_COUNTER_INT_STATUS_ENABLE_BIT);
> +
> +	status =3D ath10k_sdio_read_write_sync(ar_sdio->ar,
> +					     MBOX_INT_STATUS_ENABLE_ADDRESS,
> +					     &regs.int_status_en, sizeof(regs),
> +					     HIF_WR_SYNC_BYTE_INC);
> +	if (status) {
> +		ath10k_err(ar_sdio->ar,
> +			   "failed to update interrupt ctl reg err: %d\n",
> +			   status);
> +		return status;
> +	}
> +
> +	spin_lock_bh(&irq_data->lock);
> +	irq_data->irq_en_reg =3D regs;
> +	spin_unlock_bh(&irq_data->lock);
> +
> +	return 0;
> +}
> +
> +static int ath10k_sdio_hif_start(struct ath10k *ar)
> +{
> +	int ret;
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	u32 addr, val;
> +
> +	addr =3D host_interest_item_address(HI_ITEM(hi_acs_flags));
> +
> +	ret =3D ath10k_sdio_hif_diag_read32(ar, addr, &val);
> +	if (ret) {
> +		ath10k_err(ar, "Unable to read diag mem: %d\n", ret);
> +		goto out;
> +	}
> +
> +	if (val & HI_ACS_FLAGS_SDIO_SWAP_MAILBOX_FW_ACK) {
> +		ath10k_dbg(ar, ATH10K_DBG_SDIO,
> +			   "Mailbox SWAP Service is enabled\n");
> +		ar_sdio->swap_mbox =3D true;
> +	}
> +
> +	/* eid 0 always uses the lower part of the extended mailbox address
> +	 * space (ext_info[0].htc_ext_addr).
> +	 */
> +	ar_sdio->mbox_addr[0] =3D ar_sdio->mbox_info.ext_info[0].htc_ext_addr;
> +	ar_sdio->mbox_size[0] =3D ar_sdio->mbox_info.ext_info[0].htc_ext_sz;
> +
> +	sdio_claim_host(ar_sdio->func);
> +
> +	/* Register the isr */
> +	ret =3D  sdio_claim_irq(ar_sdio->func, ath10k_sdio_irq_handler);
> +	if (ret) {
> +		ath10k_err(ar, "Failed to claim sdio irq: %d\n", ret);
> +		sdio_release_host(ar_sdio->func);
> +		goto out;
> +	}
> +
> +	sdio_release_host(ar_sdio->func);
> +
> +	ret =3D ath10k_sdio_hif_enable_intrs(ar_sdio);
> +	if (ret)
> +		ath10k_err(ar, "Failed to enable sdio interrupts: %d\n", ret);
> +
> +out:
> +	return ret;
> +}
> +
> +static bool ath10k_sdio_is_on_irq(struct ath10k *ar)
> +{
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +
> +	return !atomic_read(&ar_sdio->irq_handling);
> +}

Yikes.

> +
> +static void ath10k_sdio_irq_disable(struct ath10k *ar)
> +{
> +	struct ath10k_sdio *ar_sdio =3D ath10k_sdio_priv(ar);
> +	int ret;
> +
> +	sdio_claim_host(ar_sdio->func);
> +
> +	atomic_set(&ar_sdio->stopping, 1);
> +
> +	if (atomic_read(&ar_sdio->irq_handling)) {
> +		sdio_release_host(ar_sdio->func);
> +
> +		ret =3D wait_event_interruptible(ar_sdio->irq_wq,
> +					       ath10k_sdio_is_on_irq(ar));
> +		if (ret)
> +			return;
> +
> +		sdio_claim_host(ar_sdio->func);
> +	}

There has to be a better way to implement this, now it feels that it's
just reimplementing the wheel. We should have proper way to wait for
interrupt handlers and workqueues to end etc.

> +	ret =3D sdio_release_irq(ar_sdio->func);
> +	if (ret)
> +		ath10k_err(ar, "Failed to release sdio irq: %d\n", ret);
> +
> +	sdio_release_host(ar_sdio->func);
> +}
> +
> +static int ath10k_sdio_config(struct ath10k_sdio *ar_sdio)
> +{
> +	struct ath10k *ar =3D ar_sdio->ar;
> +	struct sdio_func *func =3D ar_sdio->func;
> +	unsigned char byte, asyncintdelay =3D 2;
> +	int ret;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT, "SDIO configuration\n");
> +
> +	sdio_claim_host(func);
> +
> +	byte =3D 0;
> +	ret =3D ath10k_sdio_func0_cmd52_rd_byte(func->card,
> +					      SDIO_CCCR_DRIVE_STRENGTH,
> +					      &byte);
> +
> +	byte =3D (byte & (~(SDIO_DRIVE_DTSx_MASK << SDIO_DRIVE_DTSx_SHIFT))) |
> +		SDIO_DTSx_SET_TYPE_D;

FIELD_PREP(). There are lots of places where that an be used.

> +static void ath10k_sdio_write32(struct ath10k *ar, u32 offset, u32 value=
)
> +{
> +}
> +
> +static u32 ath10k_sdio_read32(struct ath10k *ar, u32 offset)
> +{
> +	return 0;
> +}

Somekind of FIXME/TODO comments for write32() and read32()? What
functionality are we going to miss when we don't implement these?

> +static void ath10k_sdio_hif_send_complete_check(struct ath10k *ar,
> +						u8 pipe, int force)
> +{
> +}
> +
> +static u16 ath10k_sdio_hif_get_free_queue_number(struct ath10k *ar, u8 p=
ipe)
> +{
> +	return 0;
> +}

Similar comments here also.

> +
> +static const struct ath10k_hif_ops ath10k_sdio_hif_ops =3D {
> +	.tx_sg			=3D ath10k_sdio_hif_tx_sg,
> +	.diag_read		=3D ath10k_sdio_hif_diag_read,
> +	.diag_write		=3D ath10k_sdio_diag_write_mem,
> +	.exchange_bmi_msg	=3D ath10k_sdio_hif_exchange_bmi_msg,
> +	.start			=3D ath10k_sdio_hif_start,
> +	.stop			=3D ath10k_sdio_hif_stop,
> +	.map_service_to_pipe	=3D ath10k_sdio_hif_map_service_to_pipe,
> +	.get_default_pipe	=3D ath10k_sdio_hif_get_default_pipe,
> +	.send_complete_check	=3D ath10k_sdio_hif_send_complete_check,
> +	.get_free_queue_number	=3D ath10k_sdio_hif_get_free_queue_number,
> +	.power_up		=3D ath10k_sdio_hif_power_up,
> +	.power_down		=3D ath10k_sdio_hif_power_down,
> +	.read32			=3D ath10k_sdio_read32,
> +	.write32		=3D ath10k_sdio_write32,
> +#ifdef CONFIG_PM
> +	.suspend		=3D ath10k_sdio_hif_suspend,
> +	.resume			=3D ath10k_sdio_hif_resume,
> +#endif
> +	.fetch_cal_eeprom	=3D ath10k_sdio_hif_fetch_cal_eeprom,
> +};
> +
> +#ifdef CONFIG_PM_SLEEP
> +
> +/* Empty handlers so that mmc subsystem doesn't remove us entirely durin=
g
> + * suspend. We instead follow cfg80211 suspend/resume handlers.
> + */
> +static int ath10k_sdio_pm_suspend(struct device *device)
> +{
> +	return 0;
> +}
> +
> +static int ath10k_sdio_pm_resume(struct device *device)
> +{
> +	return 0;
> +}
> +
> +static SIMPLE_DEV_PM_OPS(ath10k_sdio_pm_ops, ath10k_sdio_pm_suspend,
> +			 ath10k_sdio_pm_resume);
> +
> +#define ATH10K_SDIO_PM_OPS (&ath10k_sdio_pm_ops)
> +
> +#else
> +
> +#define ATH10K_SDIO_PM_OPS NULL
> +
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static int ath10k_sdio_probe(struct sdio_func *func,
> +			     const struct sdio_device_id *id)
> +{
> +	int ret;
> +	struct ath10k_sdio *ar_sdio;
> +	struct ath10k *ar;
> +	int i;
> +	enum ath10k_hw_rev hw_rev;
> +
> +	hw_rev =3D ATH10K_HW_QCA6174;

This needs a comment, at least to remind if ever add something else than
QCA6174 based SDIO design.

> +
> +	ar =3D ath10k_core_create(sizeof(*ar_sdio), &func->dev, ATH10K_BUS_SDIO=
,
> +				hw_rev, &ath10k_sdio_hif_ops);
> +	if (!ar) {
> +		dev_err(&func->dev, "failed to allocate core\n");
> +		return -ENOMEM;
> +	}
> +
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +		   "sdio new func %d vendor 0x%x device 0x%x block 0x%x/0x%x\n",
> +		   func->num, func->vendor, func->device,
> +		   func->max_blksize, func->cur_blksize);
> +
> +	ar_sdio =3D ath10k_sdio_priv(ar);
> +
> +	ar_sdio->dma_buffer =3D kzalloc(ATH10K_HIF_DMA_BUFFER_SIZE, GFP_KERNEL)=
;
> +	if (!ar_sdio->dma_buffer) {
> +		ret =3D -ENOMEM;
> +		goto err_core_destroy;
> +	}
> +
> +	ar_sdio->func =3D func;
> +	sdio_set_drvdata(func, ar_sdio);
> +
> +	ar_sdio->is_disabled =3D true;
> +	ar_sdio->ar =3D ar;
> +
> +	spin_lock_init(&ar_sdio->lock);
> +	spin_lock_init(&ar_sdio->wr_async_lock);
> +	spin_lock_init(&ar_sdio->irq_data.lock);
> +	mutex_init(&ar_sdio->dma_buffer_mutex);
> +
> +	INIT_LIST_HEAD(&ar_sdio->bus_req_freeq);
> +	INIT_LIST_HEAD(&ar_sdio->wr_asyncq);
> +
> +	INIT_WORK(&ar_sdio->wr_async_work, ath10k_sdio_write_async_work);
> +	ar_sdio->workqueue =3D create_singlethread_workqueue("ath10k_sdio_wq");
> +	if (!ar_sdio->workqueue)
> +		goto err;
> +
> +	init_waitqueue_head(&ar_sdio->irq_wq);
> +
> +	for (i =3D 0; i < ATH10K_SDIO_BUS_REQUEST_MAX_NUM; i++)
> +		ath10k_sdio_free_bus_req(ar_sdio, &ar_sdio->bus_req[i]);
> +
> +	ar->dev_id =3D id->device;
> +	ar->id.vendor =3D id->vendor;
> +	ar->id.device =3D id->device;
> +
> +	ath10k_sdio_set_mbox_info(ar_sdio);
> +
> +	ret =3D ath10k_sdio_config(ar_sdio);
> +	if (ret) {
> +		ath10k_err(ar, "Failed to config sdio: %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret =3D ath10k_core_register(ar, 0/*chip_id is not applicaple for SDIO*=
/);
> +	if (ret) {
> +		ath10k_err(ar, "failed to register driver core: %d\n", ret);
> +		goto err;
> +	}

I would assume that chip_id is applicaple also with SDIO, there has to
be a register where to get it. Also this kind of comment style is
preferred:

/* TODO: don't know yet how to get chip_id with SDIO */
chip_id =3D 0;

ret =3D ath10k_core_register(ar, chip_id);

> +
> +	return ret;
> +
> +err:
> +	kfree(ar_sdio->dma_buffer);
> +err_core_destroy:
> +	ath10k_core_destroy(ar);
> +
> +	return ret;
> +}
> +
> +static void ath10k_sdio_remove(struct sdio_func *func)
> +{
> +	struct ath10k_sdio *ar_sdio;
> +	struct ath10k *ar;
> +
> +	ar_sdio =3D sdio_get_drvdata(func);
> +	ar =3D ar_sdio->ar;
> +
> +	ath10k_dbg(ar, ATH10K_DBG_BOOT,
> +		   "sdio removed func %d vendor 0x%x device 0x%x\n",
> +		   func->num, func->vendor, func->device);
> +
> +	(void)ath10k_sdio_hif_disable_intrs(ar_sdio);
> +	cancel_work_sync(&ar_sdio->wr_async_work);
> +	ath10k_core_unregister(ar);
> +	ath10k_core_destroy(ar);
> +
> +	kfree(ar_sdio->dma_buffer);
> +}
> +
> +static const struct sdio_device_id ath10k_sdio_devices[] =3D {
> +	{SDIO_DEVICE(ATH10K_MANUFACTURER_CODE,
> +		     (ATH10K_MANUFACTURER_ID_AR6005_BASE | 0xA))},
> +	{},
> +};

I suspect there's a more sensible way to create the device table than
this, just no time to check it now. Anyone know?

The naming "ath10k manufacturer" is also wrong, it should be QCA or
Qualcomm.

--=20
Kalle Valo=
