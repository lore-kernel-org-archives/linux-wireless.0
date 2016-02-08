Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:58672 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbcBHMLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 07:11:12 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	wnhuang@chromium.com, devicetree@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 2/3] mwifiex: parse chip specific gpio from device tree
Date: Mon, 08 Feb 2016 13:11:03 +0100
Message-ID: <4072066.xhEHjcRQWo@wuerfel> (sfid-20160208_131117_926536_8DE6F562)
In-Reply-To: <1454926528-17480-2-git-send-email-akarwar@marvell.com>
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com> <1454926528-17480-2-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 08 February 2016 02:15:27 Amitkumar Karwar wrote:
>                 if (adapter->dt_node) {
> +                       if (of_property_read_u32(adapter->dt_node,
> +                                                "mwifiex,chip-gpio",
> +                                                &data) == 0) {
> +                               mwifiex_dbg(adapter, INFO,
> +                                           "chip_gpio = 0x%x\n", data);
> +                               adapter->hs_cfg.gpio = data;
> +                       }
> +
> 

Please use the GPIO DT binding. Reading a number from DT is not a proper
way to get a GPIO number, as you may have more than one GPIO controller
in a system and it is not obvious to which controller this number belongs,
or if you need to specify things like polarity.

	Arnd
