Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa11-05.prod.phx3.secureserver.net ([68.178.252.106]:44135
	"EHLO p3plsmtpa11-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbaBZWBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 17:01:01 -0500
Date: Wed, 26 Feb 2014 14:53:09 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] NFC: trf7970a: Add driver with ISO/IEC 14443 Type
 2 Tag Support
Message-ID: <20140226215309.GA21867@animalcreek.com> (sfid-20140226_230106_393842_E0763521)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-2-git-send-email-mgreer@animalcreek.com>
 <20140221005059.GS18868@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140221005059.GS18868@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 21, 2014 at 01:50:59AM +0100, Samuel Ortiz wrote:
> Hi Mark,

Hi Samuel - thanks for the feedback.

> Code looks quite nice, especially since this looks like a fairly complex
> driver. And the initial coments are quite useful, I appreciate that.
> I have a few comments/questions though:
> 
> 
> > + * been received and there isn't an error).  The delay is 3 ms since delays
> > + * over 2 ms have been observed during testing.
> Would you say this timeout depend on the SPI bus bandwidth ?

It'll be one of the factors but the tag's response characteristics are
a big factor too.  I can bump it up a bit more if you prefer or do you
want me to somehow calculate it from the SPI bitrate?

> > +#define TRF7970A_QUIRK_IRQ_STATUS_READ_ERRATA	BIT(0)
> Are there actually any TRF970 devices that do not need this quirk ?

Felipe thinks so :)

> > +static void trf7970a_drain_fifo(struct trf7970a *trf, u8 status)
> > +{
> > +	struct sk_buff *skb = trf->rx_skb;
> > +	int ret;
> > +	u8 fifo_bytes;
> > +
> > +	if (status & TRF7970A_IRQ_STATUS_ERROR) {
> > +		trf7970a_abort_and_send_err(trf, -EIO);
> > +		return;
> > +	}
> > +
> > +	ret = trf7970a_read(trf, TRF7970A_FIFO_STATUS, &fifo_bytes);
> > +	if (ret) {
> > +		trf7970a_abort_and_send_err(trf, ret);
> > +		return;
> > +	}
> > +
> > +	dev_dbg(trf->dev, "fifo_bytes: 0x%x\n", fifo_bytes);
> > +
> > +	if (!fifo_bytes)
> > +		goto no_rx_data;
> > +
> > +	if (fifo_bytes & TRF7970A_FIFO_STATUS_OVERFLOW) {
> > +		dev_err(trf->dev, "%s - fifo overflow: 0x%x\n", __func__,
> > +				fifo_bytes);
> > +		trf7970a_abort_and_send_err(trf, -EIO);
> > +		return;
> > +	}
> > +
> > +	if (fifo_bytes > skb_tailroom(skb)) {
> > +		skb = skb_copy_expand(skb, skb_headroom(skb),
> > +				max_t(int, fifo_bytes,
> > +					TRF7970A_RX_SKB_ALLOC_SIZE),
> > +				GFP_KERNEL);
> So there could be more pending bytes in the FIFO than you can accomodate
> in your rx_skb ?

Yes.

> Could we avoid that by allocating rx_skb to match the
> FIFO size ?

The alloc size (256) is already 2x the FIFO size (128) to try to minimize
this case from executing.  We never know how many total bytes may come in
so we can't eliminate the code altogether.

> > +static void trf7970a_timeout_work_handler(struct work_struct *work)
> > +{
> > +	struct trf7970a *trf = container_of(work, struct trf7970a,
> > +			timeout_work.work);
> > +
> > +	dev_dbg(trf->dev, "TIMEOUT - state: %d, ignore_timeout: %d\n",
> > +			trf->state, trf->ignore_timeout);
> > +
> > +	mutex_lock(&trf->lock);
> > +
> > +	if (trf->ignore_timeout)
> > +		trf->ignore_timeout = false;
> > +	else if (trf->state == TRF7970A_ST_WAIT_FOR_RX_DATA_CONT)
> > +		trf7970a_send_upstream(trf); /* No more rx data so send up */
> > +	else
> > +		trf7970a_abort_and_send_err(trf, -ETIMEDOUT);
> > +
> > +	mutex_unlock(&trf->lock);
> > +}
> > +
> > +/* ----------------------------------------------------------------- */
> Nitpick: I suppose you're separating the internal logic from the digital
> ops here ? Please add one comment line for that.

OK

> > +static int trf7970a_in_send_cmd(struct nfc_digital_dev *ddev,
> > +		struct sk_buff *skb, u16 timeout,
> > +		nfc_digital_cmd_complete_t cb, void *arg)
> > +{
> > +	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
> > +	char *prefix;
> > +	unsigned int len;
> > +	int ret;
> > +
> > +	dev_dbg(trf->dev, "New request - state: %d, timeout: %d ms, len: %d\n",
> > +			trf->state, timeout, skb->len);
> > +
> > +	if (skb->len > TRF7970A_TX_MAX)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&trf->lock);
> > +
> > +	if ((trf->state != TRF7970A_ST_IDLE) &&
> > +			(trf->state != TRF7970A_ST_IDLE_RX_BLOCKED)) {
> > +		dev_err(trf->dev, "%s - Bogus state: %d\n", __func__,
> > +				trf->state);
> > +		ret = -EIO;
> > +		goto out_err;
> > +	}
> > +
> > +	trf->rx_skb = nfc_alloc_recv_skb(TRF7970A_RX_SKB_ALLOC_SIZE,
> > +			GFP_KERNEL);
> > +	if (!trf->rx_skb) {
> > +		dev_dbg(trf->dev, "Can't alloc rx_skb\n");
> > +		ret = -ENOMEM;
> > +		goto out_err;
> > +	}
> > +
> > +	if (trf->state == TRF7970A_ST_IDLE_RX_BLOCKED) {
> > +		ret = trf7970a_cmd(trf, TRF7970A_CMD_ENABLE_RX);
> > +		if (ret)
> > +			goto out_err;
> > +
> > +		trf->state = TRF7970A_ST_IDLE;
> > +	}
> > +
> > +	ret = trf7970a_per_cmd_config(trf, skb);
> > +	if (ret)
> > +		goto out_err;
> > +
> > +	trf->ddev = ddev;
> > +	trf->tx_skb = skb;
> As you're going to carry this guy around and may need it from e.g. your
> threaded interrupt handler, shouldn't you take a reference (skb_get) on it ?
> I'm concerned by the fact that you could see your tx_skb disappear from
> abort_cmd and get an IRQ before your state is set to IDLE.
> Hmm, I guess that's protected by the mutex and so when you get an abort
> from the digital stack you reset the state to IDLE and no one should try
> to touch tx_skb after you release the mutex. Is that what you had in
> mind ?

It is but taking a reference is a good idea.  I'll add that.

> > +static int trf7970a_probe(struct spi_device *spi)
> > +{
> > +	struct device_node *np = spi->dev.of_node;
> > +	const struct spi_device_id *id = spi_get_device_id(spi);
> > +	struct trf7970a *trf;
> > +	int ret;
> > +
> > +	if (!np) {
> > +		dev_err(&spi->dev, "No Device Tree entry\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	trf = devm_kzalloc(&spi->dev, sizeof(*trf), GFP_KERNEL);
> > +	if (!trf)
> > +		return -ENOMEM;
> > +
> > +	trf->state = TRF7970A_ST_OFF;
> > +	trf->dev = &spi->dev;
> > +	trf->spi = spi;
> > +	trf->quirks = id->driver_data;
> > +	trf->initialized = false;
> > +
> > +	spi->mode = SPI_MODE_1;
> > +	spi->bits_per_word = 8;
> > +
> > +	/* Get the optional Slave Select GPIO used for SPI with SS mode */
> > +	trf->ss_gpio = of_get_named_gpio(np, "ti,ss-gpio", 0);
> > +	if (trf->ss_gpio >= 0) {
> > +		ret = devm_gpio_request_one(trf->dev, trf->ss_gpio,
> > +				GPIOF_DIR_OUT | GPIOF_INIT_LOW, "SS");
> > +		if (ret) {
> > +			dev_err(trf->dev, "Can't request SS GPIO: %d\n", ret);
> > +			return ret;
> > +		}
> > +	} else {
> > +		dev_info(trf->dev, "Using SPI without SS mode\n");
> > +	}
> > +
> > +	/* There are two enable pins - both must be present */
> > +	trf->en_gpio = of_get_named_gpio(np, "ti,enable-gpios", 0);
> > +	if (trf->en_gpio < 0) {
> > +		dev_err(trf->dev, "No EN GPIO property\n");
> > +		return ret;
> You probably want to return trf->en_gpio or otherwise the devm code
> won't release your managed resources.

Oops.  Good catch, thx.

> > +	}
> > +
> > +	ret = devm_gpio_request_one(trf->dev, trf->en_gpio,
> > +			GPIOF_DIR_OUT | GPIOF_INIT_LOW, "EN");
> > +	if (ret) {
> > +		dev_err(trf->dev, "Can't request EN GPIO: %d\n", ret);
> > +		return ret;
> > +	}
> > +
> > +	trf->en2_gpio = of_get_named_gpio(np, "ti,enable-gpios", 1);
> > +	if (trf->en2_gpio < 0) {
> > +		dev_err(trf->dev, "No EN2 GPIO property\n");
> > +		return ret;
> Ditto.

OK

Mark
--
