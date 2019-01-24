Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575D0C282C5
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:29:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E47B218A2
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbfAXP3b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:29:31 -0500
Received: from muru.com ([72.249.23.125]:35080 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfAXP3a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 10:29:30 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 71D4D80C3;
        Thu, 24 Jan 2019 15:29:37 +0000 (UTC)
Date:   Thu, 24 Jan 2019 07:29:26 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Jan Kiszka <jan.kiszka@web.de>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Wei Xu <xuwei5@hisilicon.com>, Ryan Grachek <ryan@edited.us>,
        John Stultz <john.stultz@linaro.org>,
        linux-wireless@vger.kernel.org, "Reizer, Eyal" <eyalr@ti.com>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2] arm64: dts: zcu100-revC: Give wifi some time after
 power-on
Message-ID: <20190124152926.GM5720@atomide.com>
References: <efc793c8-da17-e267-851e-f08f097843ee@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efc793c8-da17-e267-851e-f08f097843ee@web.de>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Jan Kiszka <jan.kiszka@web.de> [190124 08:29]:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 
> Somewhere along recent changes to power control of the wl1831, power-on
> became very unreliable on the Ultra96, failing like this:
> 
> wl1271_sdio: probe of mmc2:0001:1 failed with error -16
> wl1271_sdio: probe of mmc2:0001:2 failed with error -16
> 
> After playing with some dt parameters and comparing to other users of
> this chip, it turned out we need some power-on delay to make things
> stable again. In contrast to those other users which define 200 ms,
> Ultra96 is already happy with 10 ms.

Good to hear this got sorted out, thanks everybody.

Acked-by: Tony Lindgren <tony@atomide.com>
