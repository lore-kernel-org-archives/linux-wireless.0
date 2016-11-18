Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36406 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754159AbcKRRGO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 12:06:14 -0500
Date: Fri, 18 Nov 2016 11:06:10 -0600
From: Rob Herring <robh@kernel.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        briannorris@google.com, dmitry.torokhov@gmail.com,
        devicetree@vger.kernel.org, Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v8] mwifiex: parse device tree node for PCIe
Message-ID: <20161118170610.42gumxv37a3dsgxu@rob-hp-laptop> (sfid-20161118_180638_347515_B35AC1EC)
References: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479472624-22340-1-git-send-email-akarwar@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2016 at 06:07:04PM +0530, Amitkumar Karwar wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> This patch derives device tree node from pcie bus layer framework.
> Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
> marvell-8xxx.txt) to accommodate PCIe changes.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Rajat Jain <rajatja@google.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> ---
> v2: Included vendor and product IDs in compatible strings for PCIe
> chipsets(Rob Herring)
> v3: Patch is created using -M option so that it will only include diff of
> original and renamed files(Rob Herring)
> Resend v3: Resending the patch because I missed to include device tree mailing
> while sending v3.
> v4: Fix error handling, also move-on even if no device tree node is present.
> v5: Update commit log to include memory leak, return -EINVAL instead of -1.
> v6: Remove an unnecessary error print, fix typo in commit log
> v7: a) Earlier versions of this patch claims to have a change which fixes "memory
>        leak". But it actually introduces double-free problem. That change is removed
>        here(Brian Norris)
>     b) Cosmetic change in bindings documentation(Rob Herring)
> 	s/marvell/Marvell/
> 	s/sdio\/pcie/SDIO\/PCIE/
> v8: Same as v7. I had missed to CC device tree mailing list in v7. Correcting this
>     in v8.
> ---
>  .../{marvell-sd8xxx.txt => marvell-8xxx.txt}       |  8 +++++---

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/net/wireless/marvell/mwifiex/pcie.c        | 24 ++++++++++++++++++++++
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 ++-
>  3 files changed, 31 insertions(+), 4 deletions(-)
>  rename Documentation/devicetree/bindings/net/wireless/{marvell-sd8xxx.txt => marvell-8xxx.txt} (91%)
