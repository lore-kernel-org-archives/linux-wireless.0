Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:10243 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYCLVPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 17:15:44 -0400
Received: by wx-out-0506.google.com with SMTP id h31so3333201wxd.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2008 14:15:44 -0700 (PDT)
Message-ID: <40f31dec0803121415uede5e60k4ac6829349436680@mail.gmail.com> (sfid-20080312_211548_825387_80BAAE1F)
Date: Wed, 12 Mar 2008 23:15:30 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable irq handling in ath5k_hw_detach()
Cc: ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1205352811.5557.2.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1205352811.5557.2.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/3/12, Pavel Roskin <proski@gnu.org>:
> Once ah has been freed, it may not be accessed.  Set ATH_STAT_INVALID
>  bit to make the interrupt handler return IRQ_NONE without accessing ah.
>
>  This fixes oops on unload with CONFIG_DEBUG_SHIRQ enabled.
>
>  Signed-off-by: Pavel Roskin <proski@gnu.org>
>  ---
>
>   drivers/net/wireless/ath5k/hw.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
>
>  diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
>  index 677600b..ff579a2 100644
>  --- a/drivers/net/wireless/ath5k/hw.c
>  +++ b/drivers/net/wireless/ath5k/hw.c
>  @@ -458,6 +458,8 @@ void ath5k_hw_detach(struct ath5k_hw *ah)
>   {
>         ATH5K_TRACE(ah->ah_sc);
>
>  +       __set_bit(ATH_STAT_INVALID, ah->ah_sc->status);
>  +
>         if (ah->ah_rf_banks != NULL)
>                 kfree(ah->ah_rf_banks);
>
>
>
>  --
>  Regards,
>  Pavel Roskin

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
