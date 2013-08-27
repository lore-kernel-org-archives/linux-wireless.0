Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:55254 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038Ab3H0Xmo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Aug 2013 19:42:44 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Tobias Waldekranz <tobias@waldekranz.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 Aug 2013 16:42:37 -0700
Subject: RE: sd8787 (mwifiex) on big endian system
Message-ID: <477F20668A386D41ADCC57781B1F70430EAF1FF23F@SC-VEXCH1.marvell.com> (sfid-20130828_014247_858596_57248772)
References: <20130826102759.GA14350@gmail.com>
 <477F20668A386D41ADCC57781B1F70430EAF1FEDA0@SC-VEXCH1.marvell.com>
 <20130827061745.GA19431@gmail.com>
In-Reply-To: <20130827061745.GA19431@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tobias,

> Hi Bing,
> 
> Here is the log output without the added udelay. It is always the 0xd9
> command that fails, but not always with these sdio_ireg/wr_bitmask
> values. I have seen these combinations:
> 
>  - sdio_ireg incorrect(2), wr_bitmask incorrect(fffe)
>  - sdio_ireg   correct(3), wr_bitmask incorrect(fffe)
>  - sdio_ireg incorrect(2), wr_bitmask   correct(ffff)
> 
> Waiting 50 us before reading the mp_regs always returns the correct
> response.

Thanks for the logs.

Could you try the following change to bypass 0xd9 command?

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifi
index c0268b5..3cecc86 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1541,6 +1541,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8
                if (ret)
                        return -1;

+#if 0
                /* Reconfigure tx buf size */
                ret = mwifiex_send_cmd_sync(priv,
                                            HostCmd_CMD_RECONFIGURE_TX_BUFF,
@@ -1548,6 +1549,7 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8
                                            &priv->adapter->tx_buf_size);
                if (ret)
                        return -1;
+#endif

                if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP) {
                        /* Enable IEEE PS by default */

Thanks,
Bing

