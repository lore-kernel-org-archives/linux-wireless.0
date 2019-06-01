Return-Path: <SRS0=uUVM=UA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DAAC28CC3
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Jun 2019 22:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03F8C277C4
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Jun 2019 22:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfFAWvw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Jun 2019 18:51:52 -0400
Received: from smtprelay0136.hostedemail.com ([216.40.44.136]:33853 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726149AbfFAWvw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Jun 2019 18:51:52 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id C1BEE18029120;
        Sat,  1 Jun 2019 22:51:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: idea06_4a372f3a4ea18
X-Filterd-Recvd-Size: 2863
Received: from XPS-9350 (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Sat,  1 Jun 2019 22:51:49 +0000 (UTC)
Message-ID: <39d56df83cc8de95969c6ba3003d8101caedc045.camel@perches.com>
Subject: Re: [PATCH 11/11] rtw88: debug: dump tx power indexes in use
From:   Joe Perches <joe@perches.com>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org
Date:   Sat, 01 Jun 2019 15:51:43 -0700
In-Reply-To: <1559116487-5244-12-git-send-email-yhchuang@realtek.com>
References: <1559116487-5244-1-git-send-email-yhchuang@realtek.com>
         <1559116487-5244-12-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-05-29 at 15:54 +0800, yhchuang@realtek.com wrote:
> From: Zong-Zhe Yang <kevin_yang@realtek.com>
> 
> Add a read entry in debugfs to dump current tx power
> indexes in use for each path and each rate section.
> The corresponding power bases, power by rate, and
> power limit are also included.
> 
> Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/debug.c | 112 +++++++++++++++++++++++++++++
>  1 file changed, 112 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/debug.c b/drivers/net/wireless/realtek/rtw88/debug.c
> index f0ae260..ee2937c2 100644
> --- a/drivers/net/wireless/realtek/rtw88/debug.c
> +++ b/drivers/net/wireless/realtek/rtw88/debug.c
> @@ -8,6 +8,7 @@
>  #include "sec.h"
>  #include "fw.h"
>  #include "debug.h"
> +#include "phy.h"
>  
>  #ifdef CONFIG_RTW88_DEBUGFS
>  
> @@ -460,6 +461,112 @@ static int rtw_debug_get_rf_dump(struct seq_file *m, void *v)
>  	return 0;
>  }
>  
> +static void rtw_print_cck_rate_txt(struct seq_file *m, u8 rate)
> +{
> +	static const char * const
> +	cck_rate[] = {"1M", "2M", "5.5M", "11M"};
> +	u8 idx = rate - DESC_RATE1M;
> +
> +	seq_printf(m, "%5s%-5s", "CCK_", cck_rate[idx]);

Why use %5s instead of just embedding the prefix directly?
Also why use %5s at all when the length is 4?

I think it'd be more sensible as:

	seq_printf(m, " CCK_%-5s", cck_rate[idx]);

> +}
> +
> +static void rtw_print_ofdm_rate_txt(struct seq_file *m, u8 rate)
> +{
> +	static const char * const
> +	ofdm_rate[] = {"6M", "9M", "12M", "18M", "24M", "36M", "48M", "54M"};
> +	u8 idx = rate - DESC_RATE6M;
> +
> +	seq_printf(m, "%6s%-4s", "OFDM_", ofdm_rate[idx]);

here too

> +}
> +
> +static void rtw_print_ht_rate_txt(struct seq_file *m, u8 rate)
> +{
> +	u8 mcs_n = rate - DESC_RATEMCS0;
> +
> +	seq_printf(m, "%4s%-6u", "MCS", mcs_n);

and here, etc...



