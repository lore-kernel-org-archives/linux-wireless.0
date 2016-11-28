Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbcK1TCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 14:02:24 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 1/2] rsi: New firware loading method for RSI 91X devices
References: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
Date: Mon, 28 Nov 2016 21:02:19 +0200
In-Reply-To: <1477044595-10348-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Fri, 21 Oct 2016 15:39:55
        +0530")
Message-ID: <87r35vmnr8.fsf@purkki.adurom.net> (sfid-20161128_200227_581873_0F7D9186)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> RSI deprecated the old firmware loading method and introduced
> new method using soft boot loader for 9113 chipsets.
> Current driver only supports 9113 device model hence firmware
> loading method has been changed.
>
> In the new method, complete RAM image and flash image are present
> in the flash. Two firmwares present in the device, Boot loader firmware
> and functional firmware. Boot loader firmware is fixed but functional
> firmware can be changed. Before loading the functional firmware, host
> issues commands to check whether existing firmware in the chip and the
> firmware file content to load are same or not. If not, host issues
> commands to load the RAM image and then boot loaded switches to the
> functioanl firmware.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Forgot this:


[...]

> +#define FIRMWARE_RSI9113		"rsi_91x.fw"

I see that you add the define here but I don't see you anywhere removing
the old one. I assume you were planning just to move it.

-- 
Kalle Valo
