Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60788 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab0GVLls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 07:41:48 -0400
Message-ID: <4C482D01.1040109@nokia.com>
Date: Thu, 22 Jul 2010 14:35:29 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v2 18/20] mmc: sdio: enable a default power off mode of
 the card
References: <1279733634-21974-1-git-send-email-ohad@wizery.com> <1279733634-21974-19-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-19-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2010 08:33 PM, ext Ohad Ben-Cohen wrote:
> Add support for an SDIO device to stay powered off even without
> the presence of an SDIO function driver. A host should explicitly
> ask for it by means of MMC_CAP_DONT_POWER_CARD, and the SDIO
> function driver should know it needs to call sdio_claim_power
> before accessing the device.
>
> Signed-off-by: Ohad Ben-Cohen<ohad@wizery.com>

Shouldn't this be the default behaviour? If there is no function driver for any 
of the functions of the card, then sdio core shold power off the card.

I don't see a need for a special capability flag for this.

in fact MMC_CAP_DONT_POWER_CARD does not seem like an mmc host's capability 
flag, it seems more like a request from the board to keep the card powered off.

regards,
-roger
