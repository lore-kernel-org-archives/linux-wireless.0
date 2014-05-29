Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:57197 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbaE2BWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 21:22:49 -0400
Date: Thu, 29 May 2014 11:22:33 +1000
From: James Cameron <quozl@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mwifiex: block work queue while suspended
Message-ID: <20140529012233.GC10000@us.netrek.org> (sfid-20140529_032253_136018_A62394B9)
References: <20140516012439.GI15430@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5D8ED@SC-VEXCH1.marvell.com>
 <20140526080110.GJ6118@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F70F5E39F@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 27, 2014 at 04:39:07PM -0700, Bing Zhao wrote:
> [...]
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.340430] after resume
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.372814] PM: noirq resume of devices complete after 0.098 msecs
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.391862] PM: early resume of devices complete after 18.934 msecs
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.391873] [galcore] enter gpu_resume
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396056] [galcore] exit gpu_resume, return 0
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396056] sdhci_wakeup_irq
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396070] sdhci_wakeup_irq
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396072] sdhci_wakeup_irq
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  188.396074] sdhci_wakeup_irq
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341764] mmc0: Timeout waiting for hardware interrupt.
> > May 26 07:44:33 xo-96-6d-f4 kernel: [  198.341784] mwifiex_sdio mmc0:0001:1: read mp_regs failed
> 
> I was expecting that mwifiex_sdio_resume handler is called before
> the SDIO interrupt function is called.

This does not happen.  The SDIO interrupt function is always called
before the mwifiex_sdio_resume handler.

Method to test:

--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -712,6 +712,9 @@ static void mwifiex_interrupt_status(struct mwifiex_adapter *adapter)
 	u32 sdio_ireg;
 	unsigned long flags;
 
+	if (adapter->is_suspended)
+		dev_warn(adapter->dev, "interrupt while adapter is suspended\n");
+
 	if (mwifiex_read_data_sync(adapter, card->mp_regs, MAX_MP_REGS,
 				   REG_PORT | MWIFIEX_SDIO_BYTE_MODE_MASK,
 				   0)) {

# grep -c "after resume" /var/log/messages
630
# grep -c "interrupt while adapter" /var/log/messages
630

Also, sometimes mwifiex_sdio_suspend runs while an SDIO register
operation is in progress, because of an interrupt.  I can reduce the
frequency of the "mmc0: Timeout..." if I delay suspend until the
register option is completed.

This occurs roughly 3 out of 630 suspends.

The platform is not SMP, even though it is mmp3.  So I made an
unpleasant hack:

--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -54,6 +54,8 @@ static DEFINE_RATELIMIT_STATE(noskb_rs,
 		120 * HZ,
 		1);
 
+volatile static bool in_progress;
+
 /*
  * SDIO probe.
  *
@@ -206,6 +208,22 @@ static int mwifiex_sdio_suspend(struct device *dev)
 	struct mwifiex_adapter *adapter;
 	mmc_pm_flag_t pm_flag = 0;
 	int ret = 0;
+	int i;
+
+	/* an attempt to avoid suspend for a short time while sdio i/o is in progress */
+	if (in_progress) {
+		pr_err("suspend: sdio i/o is in_progress, delaying\n");
+		WARN_ON_ONCE(1);
+
+		i = 50;
+		while (in_progress && i-- > 0) msleep(10);
+
+		if (in_progress) {
+			pr_err("suspend: sdio i/o was in_progress\n");
+			WARN_ON_ONCE(1);
+			return -EFAULT;
+		}
+	}
 
 	if (mwifiex_always_poweroff_on_sleep)
 		return -ENOSYS;
@@ -291,7 +309,9 @@ static int
 mwifiex_write_reg_locked(struct sdio_func *func, u32 reg, u8 data)
 {
 	int ret = -1;
+	in_progress = true;
 	sdio_writeb(func, data, reg, &ret);
+	in_progress = false;
 	return ret;
 }
 
@@ -321,9 +341,11 @@ mwifiex_read_reg(struct mwifiex_adapter *adapter, u32 reg, u32 *data)
 	int ret = -1;
 	u8 val;
 
+	in_progress = true;
 	sdio_claim_host(card->func);
 	val = sdio_readb(card->func, reg, &ret);
 	sdio_release_host(card->func);
+	in_progress = false;
 
 	*data = val;
 
@@ -356,6 +378,8 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
+	in_progress = true;
+
 	sdio_claim_host(card->func);
 
 	if (!sdio_writesb(card->func, ioport, buffer, blk_cnt * blk_size))
@@ -363,6 +387,8 @@ mwifiex_write_data_sync(struct mwifiex_adapter *adapter,
 
 	sdio_release_host(card->func);
 
+	in_progress = false;
+
 	return ret;
 }
 
@@ -381,6 +407,8 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
 			: len;
 	u32 ioport = (port & MWIFIEX_SDIO_IO_PORT_MASK);
 
+	in_progress = true;
+
 	if (claim)
 		sdio_claim_host(card->func);
 
@@ -390,6 +418,8 @@ static int mwifiex_read_data_sync(struct mwifiex_adapter *adapter, u8 *buffer,
 	if (claim)
 		sdio_release_host(card->func);
 
+	in_progress = false;
+
 	return ret;
 }
 
@@ -1889,6 +1919,7 @@ mwifiex_sdio_init_module(void)
 
 	/* Clear the flag in case user removes the card. */
 	user_rmmod = 0;
+	in_progress = false;
 
 	return sdio_register_driver(&mwifiex_sdio);
 }



-- 
James Cameron
http://quozl.linux.org.au/
