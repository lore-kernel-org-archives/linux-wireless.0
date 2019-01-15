Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7601C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 18:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFED520656
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 18:55:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731976AbfAOSzO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 13:55:14 -0500
Received: from muru.com ([72.249.23.125]:33742 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbfAOSzO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 13:55:14 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 248878022;
        Tue, 15 Jan 2019 18:55:19 +0000 (UTC)
Date:   Tue, 15 Jan 2019 10:55:09 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        linux-wireless@vger.kernel.org,
        Ricardo Salveti <rsalveti@rsalveti.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] wlcore: sdio: Fixup power on/off sequence
Message-ID: <20190115185509.GJ5544@atomide.com>
References: <20190115150433.12558-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190115150433.12558-1-ulf.hansson@linaro.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

* Ulf Hansson <ulf.hansson@linaro.org> [190115 15:04]:
> During "wlan-up", we are programming the FW into the WiFi-chip. However,
> re-programming the FW doesn't work, unless a power cycle of the WiFi-chip
> is made in-between the programmings.
> 
> To conform to this requirement and to fix the regression in a simple way,
> let's start by allowing that the SDIO card (WiFi-chip) may stay powered on
> (runtime resumed) when wl12xx_sdio_power_off() returns. The intent with the
> current code is to treat this scenario as an error, but unfortunate this
> doesn't work as expected, so let's fix this.
> 
> The other part is to guarantee that a power cycle of the SDIO card has been
> completed when wl12xx_sdio_power_on() returns, as to allow the FW
> programming to succeed. However, relying solely on runtime PM to deal with
> this isn't sufficient. For example, userspace may prevent runtime suspend
> via sysfs for the device that represents the SDIO card, leading to that the
> mmc core also keeps it powered on. For this reason, let's instead do a
> brute force power cycle in wl12xx_sdio_power_on().

Thanks this looks good.. But looks like udelay 20000
is needed with:

# while [ 1 ]; do ifconfig wlan0 down; usleep 20000; \
  ifconfig wlan0 up; done

Otherwise I get the following on warning pandaboard-es:

WARNING: CPU: 0 PID: 1770 at drivers/bus/omap_l3_noc.c:147
l3_interrupt_handler+0x2f8/0x388
44000000.ocp:L3 Custom Error: MASTER MPU TARGET L4PER2 (Read):
Data Access in User mode during Functional access

Meaning that we access registers while not clocked
somewhere. I think that warning is different from the
earlier errors though :) And we could add a msleep(50)
to the end to mostly avoid it until we have a better
fix available?

Regards,

Tony
