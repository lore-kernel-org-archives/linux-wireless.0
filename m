Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933517Ab3CHQVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 11:21:03 -0500
Date: Fri, 8 Mar 2013 17:21:27 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Alex A. Mihaylov" <minimumlaw@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: RFC: RT3070 TX Power troubles
Message-ID: <20130308162126.GC1409@redhat.com> (sfid-20130308_172108_236940_AEF7AF2C)
References: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CALK7Yahs2=2UkN9uXGbuoWXhvcC1u4-R4xak5cx0ZqKm7OfK+A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 05, 2013 at 08:00:10PM +0400, Alex A. Mihaylov wrote:
> Good day!
> 
> I use Jorjin WN8020 USB WiFi module with RT3070 chip.
> On Windows and Os X module have 15dBm output power, but on Linux about
> 3dBm with 'ifconfig wlan0 txpower 20' and less if txpower set less,
> than 20dBm.
> 
> I analyse Ralink driver and found RF_R49/RF_R50 registers present in
> ralnik code, but abcent in Linux drivers. I try patch code:

Patch gnerally looks fine.

> 
> +	/*
> +	 * FixMe: Why POWER_BOUND and FREQ_OFFSET_BOUND not init here?
> +	 */
???

> +	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
> +	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
> +		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
> +	else
> +		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
> +	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);

Do we also need to init RF_R17 ? Does vendor driver do this ?

> and tx power stay 15dBm (ass writen in WN8020 specification) if
> txpower set to 20dBm in driver, and about 0dBm if tx power set to 0dBm
> in driver.
> I also found function rt2800_config_channel_rf2xxx without
> initialisation POWER_BOUND and FREQ_OFFSET_BOUND. May be this also
> incorrect?

Not sure, need to check on old vendor driver.

Stanislaw
