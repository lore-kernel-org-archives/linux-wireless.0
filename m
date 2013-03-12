Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:62272 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab3CLN7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:59:50 -0400
Message-ID: <ccfc79b224366f1bf963e81b78413b2d.squirrel@www.infidigm.net> (sfid-20130312_145953_461316_CDDEEDA1)
Date: Tue, 12 Mar 2013 11:02:24 -0400
Subject: Re: Silex SX-SDCAN (AR6003) sdio module, mmc0 timout on imx35
 platform
From: drwho@infidigm.net
To: jjo.braun@gmail.com, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm using an AR6103 (AR6003) on the imx51 platform connected via sdio on
mmc1.  Seems to work good.  I'm using Freescale's patched 2.6.35 kernel
which comes from their ltib L2.6.35_11.05.01 and compat v3.8.  Here are
the QUIRKs from drivers/mmc/host/sdhci-of-esdhc.c

struct sdhci_of_data sdhci_esdhc = {
	.quirks = SDHCI_QUIRK_FORCE_BLK_SZ_2048 |
		  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
		  SDHCI_QUIRK_NO_BUSY_IRQ |
		  SDHCI_QUIRK_NONSTANDARD_CLOCK |
		  SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK |
		  SDHCI_QUIRK_PIO_NEEDS_DELAY |
		  SDHCI_QUIRK_RESTORE_IRQS_AFTER_RESET |
		  SDHCI_QUIRK_NO_CARD_NO_RESET,
	.ops = {

Jon

