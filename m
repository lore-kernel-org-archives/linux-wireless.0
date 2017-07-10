Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbdGJGxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 02:53:15 -0400
Date: Mon, 10 Jul 2017 08:52:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: Jonas Gorski <jonas.gorski@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: call clk_get_rate only if we have a clock
Message-ID: <20170710065211.GA2808@redhat.com> (sfid-20170710_085330_522743_04CC5DF6)
References: <1499498863-6865-1-git-send-email-dev@kresin.me>
 <CAOiHx=m5CdOM82R3T7DBwQPNgHTrAA95mt4ZeYWqa-cr5KPGrQ@mail.gmail.com>
 <f3744f76-9909-90a9-012d-ddafbda9ad4a@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f3744f76-9909-90a9-012d-ddafbda9ad4a@kresin.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 08, 2017 at 03:37:11PM +0200, Mathias Kresin wrote:
> 08.07.2017 13:15, Jonas Gorski:
> >to consumers, to have a consistent API across implementations (with
> >drivers/clk/clk.c as the reference).
> >
> >And there don't seem that many, at least searching for clk_get_rate
> >gave me only two handful of implementations of which many already
> >check for NULL.
> 
> I do not necessarily see an error in the archs legacy clock
> implementation. It rather looks like it works with the common clock
> framework due the lucky coincident that someone has added (an extra)
> null check.
> 
> I only had a brief look at the common clock framework, but it seams
> to me one should not pass the error returned by clk_get() and/or
> call clk_get_rate() at all if there was an error. That is what I've
> already seen and mentioned in the commit message.

> The only difference here is that we do not have the error check and
> the clk_get_rate() call in the same function. rt2800_clk_is_20mhz()
> isn't aware that clk_get() failed. rt2x00dev->clk is set back to
> NULL in rt2x00soc_probe() in case of an clk_get error.

If we need to check clk before clk_get_rate() call, we can remove NULL
assignment from rt2x00soc_probe() and use IS_ERR_OR_NULL() on
rt2800_clk_is_20mhz() .

Thanks
Stanislaw
