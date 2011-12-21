Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:33710 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703Ab1LULKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 06:10:44 -0500
Received: by mail-lpp01m010-f54.google.com with SMTP id l5so3755126lah.41
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 03:10:43 -0800 (PST)
Subject: Re: [PATCH] atheros: force endian checks on atheros wireless
 drivers
From: Luciano Coelho <coelho@ti.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1324408728-20300-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324408728-20300-1-git-send-email-rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Dec 2011 13:10:40 +0200
Message-ID: <1324465840.2182.198.camel@cumari> (sfid-20111221_121047_806730_87573FD9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-20 at 11:18 -0800, Luis R. Rodriguez wrote: 
> From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> 
> Please NACK nasty patches.
> 
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/Makefile b/drivers/net/wireless/ath/Makefile
> index d121469..d716b74 100644
> --- a/drivers/net/wireless/ath/Makefile
> +++ b/drivers/net/wireless/ath/Makefile
> @@ -11,3 +11,4 @@ ath-objs :=	main.o \
>  		key.o
>  
>  ath-$(CONFIG_ATH_DEBUG) += debug.o
> +ccflags-y += -D__CHECK_ENDIAN__

Doesn't this force everyone who compiles the modules (even
non-developers) to have sparse installed? Is it really what we want?

If that's the case, shouldn't we do this in a higher level, maybe
enforce sparse check for everything? Of course the number of warnings
would explode, but we could at least do it for all the wireless code in
a first phase?

-- 
Cheers,
Luca.

