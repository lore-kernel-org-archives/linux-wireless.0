Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56935 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab0KLK6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 05:58:52 -0500
Received: by qwi4 with SMTP id 4so897700qwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 02:58:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <000101cb8248$579d3d90$06d7b8b0$@com>
References: <004701cb8191$e82c75e0$b88561a0$@com> <AANLkTikZD_1DUqkxQyGSLdaQS01Qg15+_TDkW3QuRuOt@mail.gmail.com>
 <1289476604.1606.36.camel@powerslave> <005101cb81af$f1e75280$d5b5f780$@com>
 <1289488173.1606.58.camel@powerslave> <000001cb822d$067f8230$137e8690$@com>
 <AC090B9732AB2B4DB7FF476E907FE6600113BB263C@dnce02.ent.ti.com> <000101cb8248$579d3d90$06d7b8b0$@com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 12 Nov 2010 12:58:36 +0200
Message-ID: <AANLkTi=YH7df-oqbGkW1gZxCD6jBhCvfDMf_882Cj5si@mail.gmail.com>
Subject: Re: Ti's WL1271 on OMAP3EVM board with kernel version 2.6.36
To: raghunath <raghunath@airvod.com>
Cc: "Levi, Shahar" <shahar_levi@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 12, 2010 at 11:02, raghunath <raghunath@airvod.com> wrote:
> Hi Shahar/Luca,
>
> Its constantly coming, I am building wl1271 sdio driver statically and I am running on OMAP3EVM board from Mistral
> And running 2.6.36 kernel and wl1271 sits on MMC2 I have modified code to set PIN MUX and clock for MMC2 and WLAN_EN(GPIO 150)
> And WLAN_IRQ(GPIO-149). I am able to download firmare successfully and get Static data from firmware and Chip ID after firmware
> Download. With this I am assuming that code I modified for MMC2 on EVM is proper(correct me if I am worng) after that ware is
> Failing ,in ELP wake up.
>

Is it only ELP mode that's failing? You can test this by commenting
out these line in wl1271_elp_work():

	wl1271_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG_ADDR, ELPCTRL_SLEEP);
	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);

Regards,
Arik
