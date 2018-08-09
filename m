Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44832 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727786AbeHINQM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 09:16:12 -0400
Date: Thu, 9 Aug 2018 12:51:52 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: valdis.kletnieks@vt.edu
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] fix build for MediaTek MT7610U USB wireless dongle
Message-ID: <20180809105151.GB1955@redhat.com> (sfid-20180809_125336_322327_2D1FDB3E)
References: <145751.1533759414@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <145751.1533759414@turing-police.cc.vt.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2018 at 04:16:54PM -0400, valdis.kletnieks@vt.edu wrote:
> The mt76x0 driver requires the mt76 core driver to actually function.
> So add a 'select' to avoid embarrassing 'symbol unknown' errors
> when attempting to modprobe it in a module tree that doesn't
> include mt76.ko
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> ---
> Still need to figure out why it totally fails to see the 5gz band,
> it works find on 2.4 but ends up locked at 72mbits/sec. Works
> OK otherwise...

This may depend on HW configuration written in the EEPROM. My dongle
Linksys AE6000 do not require various features that Mediatek driver has,
those are not implemented in mt76x0 driver and should be added. Your
hardware may require those features.

You can try version of the driver from:
https://github.com/sgruszka/wireless-drivers-next/commits/mt76x0-draft-v2
which include various fixes and possibly can make things better
(or worse, there can be regressions too)

Cheers
Stanislaw
