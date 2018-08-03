Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729350AbeHCLHG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 07:07:06 -0400
Date: Fri, 3 Aug 2018 11:11:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the
 wireless-drivers-next tree
Message-ID: <20180803091140.GA10284@redhat.com> (sfid-20180803_111156_477506_B19BC85E)
References: <20180803182942.4de98df2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180803182942.4de98df2@canb.auug.org.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Fri, Aug 03, 2018 at 06:29:42PM +1000, Stephen Rothwell wrote:
> After merging the wireless-drivers-next tree, today's linux-next build
> (powerpc allyesconfig) failed like this:
[snip]
> diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
> index 850611ad347a..ad56b3ed2be2 100644
> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -13,6 +13,7 @@ config MT76x0U
>  	tristate "MediaTek MT76x0U (USB) support"
>  	depends on MAC80211
>  	depends on USB
> +	depends on BROKEN
Would be better to limit driver to be build as module.
Hopefully that will fix the issue. I'll post patch in a moment.

Thanks
Stanislaw
