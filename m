Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog128.obsmtp.com ([74.125.149.141]:51701 "EHLO
	na3sys009aog128.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758830Ab3DZAlH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 20:41:07 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Date: Thu, 25 Apr 2013 17:40:27 -0700
Subject: RE: mwifiex frequent "not allowed while suspended" crash on resume
Message-ID: <477F20668A386D41ADCC57781B1F70430D9E14FFB9@SC-VEXCH1.marvell.com> (sfid-20130426_024122_456086_5E0F542A)
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
	<CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com>
	<CAMLZHHTe+9D_XwYHFMbu8bRAD7OHNgf8_0+44ZhM+AwSnwLZBw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E057145@SC-VEXCH1.marvell.com>
 <CAMLZHHS_fBABvx1rGSs2zwv3RredXHh5ChrN7Nwz8ofuL8Vmyg@mail.gmail.com>
In-Reply-To: <CAMLZHHS_fBABvx1rGSs2zwv3RredXHh5ChrN7Nwz8ofuL8Vmyg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> The order of events in this code makes me uneasy. You suggested
> earlier that is_suspended is the flag that indicates from the
> mwifiex_sdio layer "I'm ready to transmit again". But is it really OK
> to transmit before the host sleep is cancelled, as the above ordering
> suggests?

No, it's not OK to transmit before the host sleep is cancelled.
I was under the assumption that no TX packet is from kernel during the time we cancel host sleep. This assumption can be wrong without netif_device_detach, etc.

> 
> In this particular case, as you can see in the dynamic debug logs, it
> looks like the whole situation is confused here due to the arrival of
> an interrupt which causes mwifiex to take an early exit from the host
> sleep.

The driver has the code to work around this case. It is buggy however because it never gets verified with my own platforms.

> 
> http://dev.laptop.org/~dsd/20130425/mwifiex-earlytx.log

Could you try resetting is_suspend flag when an early RX is received?

+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -1191,6 +1191,7 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
        adapter->if_ops.wakeup(adapter);
        adapter->hs_activated = false;
        adapter->is_hs_configured = false;
+       adapter->is_suspended = false;
        mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
                                                    MWIFIEX_BSS_ROLE_ANY),
                                   false);

> No, that message doesn't appear.
> I can't quite grasp what you're trying to do in that patch. Where does
> mwifiex even set MMC_PM_WAKE_SDIO_IRQ?

I was expecting sdhci driver to set MMC_PM_WAKE_SDIO_IRQ bit.

> But the logic in the patch suggests that you would expect the
> WAKE_SDIO_IRQ flag to be set before sdio_release_irq() is called,
> triggering the "KEEP IRQ ON" message that you're looking for.

That's correct. I'm hoping that this MMC change generates "resume handler first, RX interrupt next" sequence.

Thanks,
Bing

> 
> Thanks
> Daniel
