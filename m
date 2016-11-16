Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:33196 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752210AbcKPTBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 14:01:07 -0500
Received: by mail-pf0-f177.google.com with SMTP id d2so44196600pfd.0
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 11:01:07 -0800 (PST)
Date: Wed, 16 Nov 2016 11:01:04 -0800
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 4/5] mwifiex: wait firmware dump complete during card
 remove process
Message-ID: <20161116190104.GB115729@google.com> (sfid-20161116_200111_192670_CD664E61)
References: <1479301749-14803-1-git-send-email-akarwar@marvell.com>
 <1479301749-14803-4-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479301749-14803-4-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2016 at 06:39:08PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> Wait for firmware dump complete in card remove function.
> For sdio interface, there are two diffenrent cases,
> card reset trigger sdio_work and firmware dump trigger sdio_work.
> Do code rearrangement for distinguish between these two cases.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: 1. Get rid of reset_triggered flag. Instead split the code and use
>     __mwifiex_sdio_remove() (Brian Norris/Dmitry Torokhov)
>     2. "v1 4/5 mwifiex: firmware dump code rearrangement.." is dropped. So
>     rebased accordingly.
> v3: same as [v2,5/5]. The improvement of 'moving pcie_work to card struct'
> suggested by Brian is taken care in next patch.
> ---
>  drivers/net/wireless/marvell/mwifiex/pcie.c |  6 +++++-
>  drivers/net/wireless/marvell/mwifiex/sdio.c | 15 ++++++++++++---
>  2 files changed, 17 insertions(+), 4 deletions(-)

I've expressed my unhappiness with the SDIO card-reset code that already
exists (and prevents doing sane code improvements on the rest of the
driver), but the current change looks OK anyway.

I haven't reviewed patch 1 as closely, but for 2 to 5:

Reviewed-by: Brian Norris <briannorris@chromium.org>
