Return-Path: <SRS0=f6eh=ZE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4852C43331
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Nov 2019 18:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F17921925
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Nov 2019 18:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfKLSAf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:00:35 -0500
Received: from muru.com ([72.249.23.125]:41930 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbfKLSAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Nov 2019 13:00:34 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 543F480F3;
        Tue, 12 Nov 2019 18:01:10 +0000 (UTC)
Date:   Tue, 12 Nov 2019 10:00:30 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Eyal Reizer <eyalreizer@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] mmc: Fixup HW reset for SDIO cards
Message-ID: <20191112180030.GA43123@atomide.com>
References: <20191109103046.26445-1-ulf.hansson@linaro.org>
 <20191111220812.GX43123@atomide.com>
 <CAPDyKFq03X0hd5B6h6fuNht5OjSEWe6Ap4hH4a+0nVZsS4r3hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDyKFq03X0hd5B6h6fuNht5OjSEWe6Ap4hH4a+0nVZsS4r3hw@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Ulf Hansson <ulf.hansson@linaro.org> [191112 12:24]:
> On Mon, 11 Nov 2019 at 23:08, Tony Lindgren <tony@atomide.com> wrote:
> > Looks good to me. I tried testing this, but looks like at least on duovero
> > mwifiex_sdio is broken in v5.4-rc7:
> >
> > # dmesg | grep mwifi
> > mwifiex_sdio mmc1:0001:1: poll card status failed, tries = 100
> > mwifiex_sdio mmc1:0001:1: FW download with helper:       poll status timeout @ 0
> > mwifiex_sdio mmc1:0001:1: prog_fw failed ret=0xffffffff
> > mwifiex_sdio mmc1:0001:1: info: _mwifiex_fw_dpc: unregister device
> >
> > No idea when it broke and what might be the issue this time around.
> > Any ideas?
> 
> Sorry, no good idea.
> 
> Perhaps something on the mmc host level that has changed?

No idea, not even v4.19 is not behaving properly. I guess another
victim of eternal ongoing regressions.

Regards,

Tony
