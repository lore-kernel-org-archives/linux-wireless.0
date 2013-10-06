Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f49.google.com ([209.85.212.49]:36624 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3JFTal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Oct 2013 15:30:41 -0400
Received: by mail-vb0-f49.google.com with SMTP id w16so3082730vbb.36
        for <linux-wireless@vger.kernel.org>; Sun, 06 Oct 2013 12:30:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131004234514.GA11128@garbanzo.do-not-panic.com>
References: <1380234508-3121-1-git-send-email-k.eugene.e@gmail.com>
	<20131004234514.GA11128@garbanzo.do-not-panic.com>
Date: Sun, 6 Oct 2013 21:30:40 +0200
Message-ID: <CAFSJ42YRmwZ-mK5yADsf=sfi7b5rEK9hFdH-waoswrubvyZddA@mail.gmail.com> (sfid-20131006_213056_133845_BE53FF77)
Subject: Re: [PATCH] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org, wcn36xx@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

Thanx for the patch. Although there is a one small comment:

> +static void wcn_reg_notifier(struct wiphy *wiphy,
> +                            struct regulatory_request *request)
> +{

Function should be called wcn36xx_reg_notifier not wcn_reg_notifier.
Could you please change that?

Also are you concerned about this warnings?

> Nice! I test compiled with sparse enabled and got this:
>
> mcgrof@chalten ~/wireless-testing (git::master)$ make C=1
> M=drivers/net/wireless/ath/wcn36xx/
> CHECK   drivers/net/wireless/ath/wcn36xx/main.c
> CC [M]  drivers/net/wireless/ath/wcn36xx/main.o
> CHECK   drivers/net/wireless/ath/wcn36xx/dxe.c
> CC [M]  drivers/net/wireless/ath/wcn36xx/dxe.o
> CHECK   drivers/net/wireless/ath/wcn36xx/txrx.c
> CC [M]  drivers/net/wireless/ath/wcn36xx/txrx.o
> CHECK   drivers/net/wireless/ath/wcn36xx/smd.c
> /home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (4096 8)
> /home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (512 8)
> /home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (128 8)
> /home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (8 8)
> /home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (256 8)
> /home/mcgrof/wireless-testing/arch/x86/include/asm/bitops.h:329:18: warning: invalid access past the end of 'caps' (4096 8)

What kind of config are you using to generate this warnings?
