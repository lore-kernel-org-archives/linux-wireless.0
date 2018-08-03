Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729357AbeHCLOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 07:14:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wireless <linux-wireless@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mt76x0: build driver only as module
References: <20180803091401.GB10284@redhat.com>
Date: Fri, 03 Aug 2018 12:19:20 +0300
In-Reply-To: <20180803091401.GB10284@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 3 Aug 2018 11:14:01 +0200")
Message-ID: <87zhy36c4n.fsf@kamboji.qca.qualcomm.com> (sfid-20180803_111940_856729_C50BB531)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> There are various symbols that conflicts with mt7601u.
> Due to that kernel will not build with allyesconfig.
> For now limit the driver to be build only as module.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks for the quick patch!

> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> @@ -11,7 +11,7 @@ config MT76x2_COMMON
>  
>  config MT76x0U
>  	tristate "MediaTek MT76x0U (USB) support"
> -	depends on MAC80211
> +	depends on MAC80211 && m

But this feels like an ugly hack to me. Isn't there a better way to fix
this? (I don't have time to investigate the error in detail right now.)

-- 
Kalle Valo
