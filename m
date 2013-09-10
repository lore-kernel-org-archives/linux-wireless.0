Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:45023 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3IJGdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 02:33:08 -0400
Message-ID: <1378794813.4799.35.camel@porter.coelho.fi> (sfid-20130910_083311_910878_DA8BA6E1)
Subject: Re: [PATCH 02/12] wlcore: add new plt power-mode: CHIP_AWAKE
From: Luca Coelho <luca@coelho.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 10 Sep 2013 09:33:33 +0300
In-Reply-To: <1378218848-7853-2-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	 <1378218848-7853-2-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
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
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

I had some comments to this patch internally while I was still at TI.
Namely, I asked why do we need a new way of doing this if this is
already possible via debugsfs (using the gpio_power file)?

--
Cheers,
Luca.

