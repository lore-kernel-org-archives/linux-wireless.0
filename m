Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:50699 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028Ab2LEUtC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 15:49:02 -0500
Message-ID: <1354740499.6234.83.camel@cumari.coelho.fi> (sfid-20121205_214908_131047_5B6B6A5C)
Subject: Re: [PATCH 08/20] wlcore: add new plt power-mode: CHIP_AWAKE
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>,
	Yair Shapira <yair.shapira@ti.com>
Date: Wed, 5 Dec 2012 22:48:19 +0200
In-Reply-To: <1354095769-8724-9-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-9-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> From: Yair Shapira <yair.shapira@ti.com>
> 
> Under this mode the chip is powered on including sdio
> but no FW is downloaded and run, interrupts are not enabled, etc...
> 
> This mode is intended to allow RTTT to bridge sdio as a transport
> to the chip.
> 
> Driver only provides sdio access using the dev_mem debugfs file.
> 
> Some fixes done to the code that ensures that PLT mode and normal
> driver power mode (ifconfig/add_interface) are mutually excluded.
> 
> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Hmmm... I must admit that I didn't look very carefully in the previous
changes to this same code.

Anyway, we already have a similar functionality where we can power the
chip on without uploading the firmware.  We have the gpio_power file in
debugfs to handle that.  By using it, you can easily power the chip on
without uploading and running the firmware, so other tools (such as RTTT
and the calibrator) can take over.

Do we really need this?

--
Luca.

