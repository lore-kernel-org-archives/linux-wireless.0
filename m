Return-Path: <SRS0=BfPD=YA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FB9ECE58C
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Oct 2019 15:47:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0EF720684
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Oct 2019 15:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfJGPrH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Oct 2019 11:47:07 -0400
Received: from muru.com ([72.249.23.125]:35600 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727711AbfJGPrG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Oct 2019 11:47:06 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 9C68380A5;
        Mon,  7 Oct 2019 15:47:39 +0000 (UTC)
Date:   Mon, 7 Oct 2019 08:47:03 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] wlcore: fix race for WL1271_FLAG_IRQ_RUNNING
Message-ID: <20191007154703.GP5610@atomide.com>
References: <20191007153731.58045-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191007153731.58045-1-tony@atomide.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [191007 08:38]:
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -692,6 +687,9 @@ static irqreturn_t wlcore_irq(int irq, void *cookie)
>  
>  	mutex_unlock(&wl->mutex);
>  
> +out_handled:
> +	clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
> +
>  	return IRQ_HANDLED;
>  }

Sorry looks like I again sent out the patch too fast. The clear_bit()
here should have spin_lock_irqsave() and spin_unlock_irqrestore()
around it like we do elsewhere in the code currently.

Regards,

Tony
