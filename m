Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34087 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932878AbcI3M6w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 08:58:52 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Benjamin Berg <benjamin@sipsolutions.net>
CC: Simon Wunderlich <sw@simonwunderlich.de>,
        "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        "ath10k @ lists . infradead . org" <ath10k@lists.infradead.org>,
        "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
        Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Subject: Re: [PATCH] ath10k: Fix spinlock use in coverage class hack
Date: Fri, 30 Sep 2016 12:58:42 +0000
Message-ID: <87ponltugu.fsf@kamboji.qca.qualcomm.com> (sfid-20160930_145855_714221_F56B589B)
References: <8760q0j8st.fsf@kamboji.qca.qualcomm.com>
        <20160914163231.20863-1-benjamin@sipsolutions.net>
In-Reply-To: <20160914163231.20863-1-benjamin@sipsolutions.net> (Benjamin
        Berg's message of "Wed, 14 Sep 2016 18:32:31 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin@sipsolutions.net> writes:

> ath10k_hw_qca988x_set_coverage_class needs to hold both conf_mutex and
> the data_lock spin lock for parts of the function. However, data_lock
> is only needed while storing the coverage_class to store the value that
> the card is configured to.
>
> Fix the locking issue by only holding data_lock for the required duration=
.
>
> Signed-off-by: Benjamin Berg <benjamin@sipsolutions.net>

Thanks, I also folded this with the patch in the pending branch.

> And yes, I fully agree with your points of it being rather fragile. But a=
s
> you said, it should be entirely safe if not used.

That's good.

> Obviously a firmware implementation would be preferential.

That's a shame as this feature is quite often requested. But if the
firmware ever starts supporting the featrue we can then remove this hack
from ath10k.

> This locking issue was pretty unnecessary. Lets see if any more issues sh=
ow
> up in a closer review.

I can't see the locking problem anymore so it seems to be fixed. I'll
fix some minor things and send v2. I'll also CC linux-wireless.

--=20
Kalle Valo=
