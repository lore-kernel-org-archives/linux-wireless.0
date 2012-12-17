Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:61800 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2LQVMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 16:12:54 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so5195654lag.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 13:12:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355756343-3406-1-git-send-email-juhosg@openwrt.org>
References: <1355756343-3406-1-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Mon, 17 Dec 2012 13:12:32 -0800
Message-ID: <CAB=NE6VjRQvg3ijdCX2G=4Q2d+OoyfQSfxPawHDviAapfS6X0w@mail.gmail.com> (sfid-20121217_221258_601152_15904CD9)
Subject: Re: [PATCH] qca-swiss-army-knife: fix build errors if ATH9K_DIR is used
To: Gabor Juhos <juhosg@openwrt.org>
Cc: qca-linux-team@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2012 at 6:59 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Some initval arrays were removed from ath9k with the
> upstream commit 14fec8d9baffc026beaffa2ee9e911df9d1d4ad2
> (ath9k_hw: remove duplicate initvals).
>
> Due to the missing symbols, this causes build errors
> when the ATHEROS Makefile variable is not set, and
> an external ATH9K_DIR is specified:
>
>   $ make clean all ATH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k
>   rm -f initvals
>   gcc  -I"/devel/wireless-testing/drivers/net/wireless/ath/ath9k" -o initvals initvals.c sha1.c
>   initvals.c: In function ‘ar9001_hw_print_initvals’:
>   initvals.c:588:2: error: ‘ar5416Bank0_9100’ undeclared (first use in this function)
>   initvals.c:588:2: note: each undeclared identifier is reported only once for each function it appears in
>   initvals.c:589:2: error: ‘ar5416BB_RfGain_9100’ undeclared (first use in this function)
>   initvals.c:590:2: error: ‘ar5416Bank1_9100’ undeclared (first use in this function)
>   initvals.c:591:2: error: ‘ar5416Bank2_9100’ undeclared (first use in this function)
>   initvals.c:592:2: error: ‘ar5416Bank3_9100’ undeclared (first use in this function)
>   initvals.c:595:2: error: ‘ar5416Bank7_9100’ undeclared (first use in this function)
>   initvals.c:599:2: error: ‘ar5416Bank0_9160’ undeclared (first use in this function)
>   initvals.c:600:2: error: ‘ar5416BB_RfGain_9160’ undeclared (first use in this function)
>   initvals.c:601:2: error: ‘ar5416Bank1_9160’ undeclared (first use in this function)
>   initvals.c:602:2: error: ‘ar5416Bank2_9160’ undeclared (first use in this function)
>   initvals.c:603:2: error: ‘ar5416Bank3_9160’ undeclared (first use in this function)
>   initvals.c:604:2: error: ‘ar5416Bank6_9160’ undeclared (first use in this function)
>   initvals.c:605:2: error: ‘ar5416Bank6TPC_9160’ undeclared (first use in this function)
>   initvals.c:606:2: error: ‘ar5416Bank7_9160’ undeclared (first use in this function)
>   initvals.c: In function ‘ar9002_hw_print_initvals’:
>   initvals.c:597:2: error: ‘ar9285PciePhy_clkreq_always_on_L1_9285’ undeclared (first use in this function)
>   initvals.c:598:2: error: ‘ar9285PciePhy_clkreq_off_L1_9285’ undeclared (first use in this function)
>   initvals.c:605:2: error: ‘ar9285PciePhy_clkreq_always_on_L1_9285_1_2’ undeclared (first use in this function)
>   initvals.c:606:2: error: ‘ar9285PciePhy_clkreq_off_L1_9285_1_2’ undeclared (first use in this function)
>   initvals.c:613:2: error: ‘ar9287PciePhy_clkreq_always_on_L1_9287_1_1’ undeclared (first use in this function)
>   initvals.c:614:2: error: ‘ar9287PciePhy_clkreq_off_L1_9287_1_1’ undeclared (first use in this function)
>   initvals.c:617:2: error: ‘ar9271Common_normal_cck_fir_coeff_9271’ undeclared (first use in this function)
>   initvals.c:618:2: error: ‘ar9271Common_japan_2484_cck_fir_coeff_9271’ undeclared (first use in this function)
>   initvals.c:619:2: error: ‘ar9271Modes_9271_1_0_only’ undeclared (first use in this function)
>   make: *** [initvals] Error 1
>   $
>
> Add definitions for the missing arrays to avoid
> these compiler errors. Also introduce two new
> macros and use those for printing the arrays.
>
> After these changes, the initvals tool builds without
> errors:
>
>   $ make clean all ATH9K_DIR=/devel/wireless-testing/drivers/net/wireless/ath/ath9k
>   rm -f initvals
>   gcc  -I"/devel/wireless-testing/drivers/net/wireless/ath/ath9k" -o initvals initvals.c sha1.c
>   $
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Thanks, applied and pushed!

  Luis
