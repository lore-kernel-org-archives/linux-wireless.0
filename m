Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:3599 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758580AbZACDEk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 22:04:40 -0500
Received: by rv-out-0506.google.com with SMTP id k40so6119672rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 19:04:39 -0800 (PST)
From: Colin McCabe <colin@cozybit.com>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: [PATCH v2 0/3] libertas: driver for GSPI devices
Date: Fri,  2 Jan 2009 19:00:20 -0800
Message-Id: <1230951623-26998-1-git-send-email-colin@cozybit.com> (sfid-20090103_040443_590810_731190FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series adds suport for GSPI devices to libertas.
These devices are found in some embedded systems. We used a blackfin-based
board for development.

Thanks to everyone who took a look at version 1 of the patch.

Changes in v2: 
* Store the host IRQ setting in spi->irq rather than creating a new variable
for this purpose.
* Add TODO comment to declaration of card->gpio_cs.
(We do intend to get rid of gpio_cs eventually, but it will require some
changes to the generic SPI layer, which could take a while.)
* When loading the module, check to see if the firmware is already loaded. If
so, skip firmware load.
* Speed up module load time slightly.
* Add if_spi_e2h to handle libertas card events.
* Include relevant Kconfig change.

thanks... and
Happy New Year.

Colin
