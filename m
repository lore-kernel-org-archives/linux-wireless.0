Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:47187 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933900AbbLWKJw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2015 05:09:52 -0500
Subject: Re: [PATCH 1/3] wlcore/wl12xx: spi: fix NULL pointer dereference
 (Oops)
To: Uri Mashiach <uri.mashiach@compulab.co.il>,
	Kalle Valo <kvalo@codeaurora.org>,
	Rob Herring <robh+dt@kernel.org>,
	Tony Lindgren <tony@atomide.com>
References: <1450859744-9948-1-git-send-email-uri.mashiach@compulab.co.il>
 <1450859744-9948-2-git-send-email-uri.mashiach@compulab.co.il>
CC: Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, <bcousson@baylibre.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Eliad Peller <eliad@wizery.com>, <devicetree@vger.kernel.org>,
	<linux-omap@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
From: Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <567A7287.3010205@ti.com> (sfid-20151223_110959_798127_0111E0DB)
Date: Wed, 23 Dec 2015 12:08:07 +0200
MIME-Version: 1.0
In-Reply-To: <1450859744-9948-2-git-send-email-uri.mashiach@compulab.co.il>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/2015 10:35 AM, Uri Mashiach wrote:
> The power function uses a consumer regulator access to update the WiFi
> enable GPIO value.
> 
> Fix the below Oops when trying to modprobe wlcore_spi.
> The oops occurs because the wl1271_power_{off,on}()
> function doesn't check the power() function pointer.
> 
> [   23.401447] Unable to handle kernel NULL pointer dereference at
> virtual address 00000000
> [   23.409954] pgd = c0004000
> [   23.412922] [00000000] *pgd=00000000
> [   23.416693] Internal error: Oops: 80000007 [#1] SMP ARM
> [   23.422168] Modules linked in: wl12xx wlcore mac80211 cfg80211
> musb_dsps musb_hdrc usbcore usb_common snd_soc_simple_card evdev joydev
> omap_rng wlcore_spi snd_soc_tlv320aic23_i2c rng_core snd_soc_tlv320aic23
> c_can_platform c_can can_dev snd_soc_davinci_mcasp snd_soc_edma
> snd_soc_omap omap_wdt musb_am335x cpufreq_dt thermal_sys hwmon
> [   23.453253] CPU: 0 PID: 36 Comm: kworker/0:2 Not tainted
> 4.2.0-00002-g951efee-dirty #233
> [   23.461720] Hardware name: Generic AM33XX (Flattened Device Tree)
> [   23.468123] Workqueue: events request_firmware_work_func
> [   23.473690] task: de32efc0 ti: de4ee000 task.ti: de4ee000
> [   23.479341] PC is at 0x0
> [   23.482112] LR is at wl12xx_set_power_on+0x28/0x124 [wlcore]

Why can't you just add proper check in wl1271_power_on/wl1271_power_off() instead?

-- 
regards,
-grygorii
