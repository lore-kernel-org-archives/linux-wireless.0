Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42208 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753502AbbL2SeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 13:34:14 -0500
Date: Tue, 29 Dec 2015 12:34:09 -0600
From: Rob Herring <robh@kernel.org>
To: Uri Mashiach <uri.mashiach@compulab.co.il>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 2/3] wlcore/wl12xx: spi: add device tree support
Message-ID: <20151229183409.GA12260@rob-hp-laptop> (sfid-20151229_193420_004251_0B7F0412)
References: <1451304139-10899-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451304139-10899-3-git-send-email-uri.mashiach@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1451304139-10899-3-git-send-email-uri.mashiach@compulab.co.il>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 28, 2015 at 02:02:18PM +0200, Uri Mashiach wrote:
> Add DT support for the wl1271 SPI WiFi.
> 
> Add documentation file for the wl1271 SPI WiFi.
> 
> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
> Acked-by: Igor Grinberg <grinberg@compulab.co.il>
> ---
> v1 -> v2: update interrupt documentation.
>           replace interrupts and interrupt-parent with interrupts-extended.

Why? interrupts-extended is really just for cases with 2 interrupt 
parents.

> 	  IRQ parameters retrieved from spi_device instead of DT.
> 	  remove redundant #ifdef CONFIG_OF
> v2 -> v3: Add MODULE_DEVICE_TABLE.
>           Remove #ifdef CONFIG_OF.
> 	  Make the Kconfig symbol to depend on OF.
> 	  Replace irqd_get_trigger_type() with irq_get_trigger_type().
> 
>  .../bindings/net/wireless/ti,wlcore,spi.txt        | 34 ++++++++++++++++

In any case:

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/net/wireless/ti/wlcore/Kconfig             |  2 +-
>  drivers/net/wireless/ti/wlcore/spi.c               | 47 ++++++++++++++++++++--
>  3 files changed, 78 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ti,wlcore,spi.txt
