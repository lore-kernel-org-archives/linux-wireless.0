Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58589 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0KHWOj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 17:14:39 -0500
Received: by ywc21 with SMTP id 21so3788690ywc.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 14:14:38 -0800 (PST)
MIME-Version: 1.0
From: Joerie de Gram <j.de.gram@gmail.com>
Date: Mon, 8 Nov 2010 23:14:18 +0100
Message-ID: <AANLkTikVZT-hQvr83bTkuVENe8jPSG=LNMw5NTwUXCp1@mail.gmail.com>
Subject: wl1271 sdio timeouts on omap3
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to get the wl1271 (sdio) driver running on an
OMAP3430-based board. I've based my board support on the patches by
Ohad Ben-Cohen for zoom2 and Luciano Coelho's beagleboard patches.
However, I'm experiencing trouble bringing the interface up, getting a
lockup in mmc_wait_for_req (called from wl1271_sdio_power_on). In 10%
of my attempts the driver gets as far as uploading the firmware after
which I'm getting similar SDIO timeouts.

I'm mostly unsure about my regulator config (relevant snippets below),
having no wl1271 documentation to work with. The wl1271 is on mmc3,
powered by twl4030 vsim. I assume the fixed regulator in [1] is just
to be able to control the PMENA GPIO?

Pin muxing aside, all changes are equal to those displayed in [1]. Is
there anything I might be doing wrong wrt. the power-up sequence?

[1]: https://patchwork.kernel.org/patch/201572/

Joerie

----------

static struct regulator_consumer_supply nowplus_vsim_supply = {
	.supply			= "vmmc",
};


static struct regulator_consumer_supply nowplus_wl1271_supply = {
	.supply			= "vmmc_aux",
	.dev_name		= "mmci-omap-hs.2",
};


/* VSIM for WiFi SDIO */
static struct regulator_init_data nowplus_vsim = {
	.constraints = {
		.name			= "VSIM",
		.min_uV			= 1800000,
		.max_uV			= 1800000,
		.apply_uV		= true,
		.valid_modes_mask	= REGULATOR_MODE_NORMAL
					| REGULATOR_MODE_STANDBY,
		.valid_ops_mask		= REGULATOR_CHANGE_MODE
					| REGULATOR_CHANGE_STATUS,
	},
	.num_consumer_supplies	= 1,
	.consumer_supplies	= &nowplus_vsim_supply,
};

static struct regulator_init_data nowplus_wlgpio = {
	.constraints = {
		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
	},
	.num_consumer_supplies	= 1,
	.consumer_supplies	= &nowplus_wl1271_supply,
};
