Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:52086 "EHLO
        mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdKMJhC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:37:02 -0500
Date: Mon, 13 Nov 2017 10:37:05 +0100
From: Johan Hovold <johan@kernel.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Johan Hovold <johan@kernel.org>,
        "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>
Subject: Re: [PATCH] wcn36xx: fix iris child-node lookup
Message-ID: <20171113093705.GS11226@localhost> (sfid-20171113_103735_874338_1951F527)
References: <20171111170532.6110-1-johan@kernel.org>
 <87po8m7e8s.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87po8m7e8s.fsf@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 13, 2017 at 08:51:49AM +0000, Kalle Valo wrote:
> Johan Hovold <johan@kernel.org> writes:
> 
> > Fix child-node lookup during probe, which ended up searching the whole
> > device tree depth-first starting at the parent rather than just matching
> > on its children.
> >
> > To make things worse, the parent mmio node was also prematurely freed.
> >
> > Fixes: fd52bdae9ab0 ("wcn36xx: Disable 5GHz for wcn3620")
> 
> fd52bdae9ab0 is in net-next right now so the first release for that
> commit should be v4.15-rc1.
> 
> > Cc: stable <stable@vger.kernel.org>     # 4.14
> 
> As fd52bdae9ab0 is not in v4.14 no need to Cc stable. I'll remove it.

Ah, sorry. Thanks for fixing that up.

> > Cc: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> Thanks, I'll queue this to v4.15.

Johan
