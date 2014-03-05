Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:8567 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754984AbaCEMgV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:36:21 -0500
Date: Wed, 5 Mar 2014 13:36:16 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] NFC: trf7970a: Add driver with ISO/IEC 14443 Type 2
 Tag Support
Message-ID: <20140305123616.GC14401@zurbaran> (sfid-20140305_133627_813674_542D8961)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-2-git-send-email-mgreer@animalcreek.com>
 <20140221005059.GS18868@zurbaran>
 <20140226215309.GA21867@animalcreek.com>
 <20140305001943.GA29983@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140305001943.GA29983@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 04, 2014 at 05:19:43PM -0700, Mark A. Greer wrote:
> On Wed, Feb 26, 2014 at 02:53:09PM -0700, Mark A. Greer wrote:
> > On Fri, Feb 21, 2014 at 01:50:59AM +0100, Samuel Ortiz wrote:
> > 
> > > > +static int trf7970a_in_send_cmd(struct nfc_digital_dev *ddev,
> > > > +		struct sk_buff *skb, u16 timeout,
> > > > +		nfc_digital_cmd_complete_t cb, void *arg)
> > > > +{
> > > > +	struct trf7970a *trf = nfc_digital_get_drvdata(ddev);
> > > > +	char *prefix;
> > > > +	unsigned int len;
> > > > +	int ret;
> > > > +
> > > > +	dev_dbg(trf->dev, "New request - state: %d, timeout: %d ms, len: %d\n",
> > > > +			trf->state, timeout, skb->len);
> > > > +
> > > > +	if (skb->len > TRF7970A_TX_MAX)
> > > > +		return -EINVAL;
> > > > +
> > > > +	mutex_lock(&trf->lock);
> > > > +
> > > > +	if ((trf->state != TRF7970A_ST_IDLE) &&
> > > > +			(trf->state != TRF7970A_ST_IDLE_RX_BLOCKED)) {
> > > > +		dev_err(trf->dev, "%s - Bogus state: %d\n", __func__,
> > > > +				trf->state);
> > > > +		ret = -EIO;
> > > > +		goto out_err;
> > > > +	}
> > > > +
> > > > +	trf->rx_skb = nfc_alloc_recv_skb(TRF7970A_RX_SKB_ALLOC_SIZE,
> > > > +			GFP_KERNEL);
> > > > +	if (!trf->rx_skb) {
> > > > +		dev_dbg(trf->dev, "Can't alloc rx_skb\n");
> > > > +		ret = -ENOMEM;
> > > > +		goto out_err;
> > > > +	}
> > > > +
> > > > +	if (trf->state == TRF7970A_ST_IDLE_RX_BLOCKED) {
> > > > +		ret = trf7970a_cmd(trf, TRF7970A_CMD_ENABLE_RX);
> > > > +		if (ret)
> > > > +			goto out_err;
> > > > +
> > > > +		trf->state = TRF7970A_ST_IDLE;
> > > > +	}
> > > > +
> > > > +	ret = trf7970a_per_cmd_config(trf, skb);
> > > > +	if (ret)
> > > > +		goto out_err;
> > > > +
> > > > +	trf->ddev = ddev;
> > > > +	trf->tx_skb = skb;
> > > As you're going to carry this guy around and may need it from e.g. your
> > > threaded interrupt handler, shouldn't you take a reference (skb_get) on it ?
> > > I'm concerned by the fact that you could see your tx_skb disappear from
> > > abort_cmd and get an IRQ before your state is set to IDLE.
> > > Hmm, I guess that's protected by the mutex and so when you get an abort
> > > from the digital stack you reset the state to IDLE and no one should try
> > > to touch tx_skb after you release the mutex. Is that what you had in
> > > mind ?
> > 
> > It is but taking a reference is a good idea.  I'll add that.
> 
> I've changed my mind on this (hope that's okay).
> 
> The driver is in control of freeing that skb and won't free it until
> there's an abort or the processing is complete.  I believe that handle
> the race with an abort correctly.
That was my understanding as well, and I wanted to make sure that you
had that in mind too. It seems to be the case.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
