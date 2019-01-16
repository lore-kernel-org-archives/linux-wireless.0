Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4771C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:43:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A545C20657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 15:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394195AbfAPPnQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:43:16 -0500
Received: from muru.com ([72.249.23.125]:33900 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbfAPPnP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 10:43:15 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C424F8030;
        Wed, 16 Jan 2019 15:43:21 +0000 (UTC)
Date:   Wed, 16 Jan 2019 07:43:11 -0800
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
Subject: Re: [PATCH V2] wlcore: sdio: Fixup power on/off sequence
Message-ID: <20190116154311.GP5544@atomide.com>
References: <20190116113723.15668-1-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190116113723.15668-1-ulf.hansson@linaro.org>
User-Agent: Mutt/1.11.1 (2018-12-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ulf Hansson <ulf.hansson@linaro.org> [190116 11:37]:
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
> 
> Fixes: 728a9dc61f13 ("wlcore: sdio: Fix flakey SDIO runtime PM handling")
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> ---
> 
> Changes in v2:
> 	- Keep the SDIO host claimed when calling mmc_hw_reset().
> 	- Add a fixes tag.

This v2 version works for me as tested with:

# while [ 1 ]; do ifconfig wlan0 down; ifconfig wlan0 up; done
[  181.364990] wlcore: down
[  182.116424] wlcore: firmware booted (Rev 6.3.10.0.141)
[  182.151641] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  182.166778] wlcore: down
[  182.773132] wlcore: firmware booted (Rev 6.3.10.0.141)
[  182.811096] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
...

Thanks for fixing this issue properly, and feel free to add:

Tested-by: Tony Lindgren <tony@atomide.com>
