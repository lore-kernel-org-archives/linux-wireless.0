Return-Path: <SRS0=pdv6=UY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861A6C48BD4
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 06:26:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 675A920659
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Jun 2019 06:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfFYG0x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Jun 2019 02:26:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:40655 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726301AbfFYG0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jun 2019 02:26:53 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hfeuf-0005gw-62; Tue, 25 Jun 2019 08:26:41 +0200
Date:   Tue, 25 Jun 2019 08:26:40 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Kalle Valo <kvalo@codeaurora.org>
cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: linux-next: build failure after merge of the tip tree
In-Reply-To: <8736jyfaje.fsf@codeaurora.org>
Message-ID: <alpine.DEB.2.21.1906250825050.32342@nanos.tec.linutronix.de>
References: <20190625160432.533aa140@canb.auug.org.au> <8736jyfaje.fsf@codeaurora.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 25 Jun 2019, Kalle Valo wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
> > ---
> >  drivers/net/wireless/intersil/p54/txrx.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/intersil/p54/txrx.c b/drivers/net/wireless/intersil/p54/txrx.c
> > index be6968454282..873fea59894f 100644
> > --- a/drivers/net/wireless/intersil/p54/txrx.c
> > +++ b/drivers/net/wireless/intersil/p54/txrx.c
> > @@ -383,7 +383,7 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
> >  
> >  	fc = ((struct ieee80211_hdr *)skb->data)->frame_control;
> >  	if (ieee80211_is_probe_resp(fc) || ieee80211_is_beacon(fc))
> > -		rx_status->boottime_ns = ktime_get_boot_ns();
> > +		rx_status->boottime_ns = ktime_get_boottime_ns();
> 
> Thanks for the report. Any suggestions how to handle this? Or do we let
> Linus take care of this?

As the core changes which cause this are in tip timers/core, I can just
pick that up and be done with it. Ok?

Thanks,

	tglx
