Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:42403 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965098AbbKDBiD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 20:38:03 -0500
Date: Wed, 4 Nov 2015 02:37:14 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Vincent Cuissard <cuissard@marvell.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] NFC: nfcmrvl: fix SPI driver dependencies
Message-ID: <20151104013714.GA4090@zurbaran.home> (sfid-20151104_023826_188988_BF4D6368)
References: <243350307.K4hHIg3V2N@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <243350307.K4hHIg3V2N@wuerfel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arnd,

On Tue, Nov 03, 2015 at 03:03:33PM +0100, Arnd Bergmann wrote:
> The newly added nfcmrvl_spi driver uses the spi_nci
> infrastructure, but does not have a Kconfig dependency on
> that, so we can get a link-time error:
> 
> drivers/built-in.o: In function `nfcmrvl_spi_nci_send':
> (.text+0x1428dc): undefined reference to `nci_spi_send'
> drivers/built-in.o: In function `nfcmrvl_spi_probe':
> (.text+0x142a24): undefined reference to `nci_spi_allocate_spi'
> drivers/built-in.o: In function `nfcmrvl_spi_int_irq_thread_fn':
> (.text+0x142abc): undefined reference to `nci_spi_read'
> 
> This clarifies the dependency.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
Applied, thanks.

Cheers,
Samuel.
