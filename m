Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:53718 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753408AbcDNHrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 03:47:19 -0400
Message-ID: <1460620028.19090.12.camel@perches.com> (sfid-20160414_094722_390410_9F0767C0)
Subject: Re: [PATCH v2 1/5] ath10k: fix checkpatch warnings related to spaces
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 14 Apr 2016 00:47:08 -0700
In-Reply-To: <20160413111320.18823.25021.stgit@potku.adurom.net>
References: <20160413111247.18823.15952.stgit@potku.adurom.net>
	 <20160413111320.18823.25021.stgit@potku.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-13 at 14:13 +0300, Kalle Valo wrote:
> Fix checkpatch warnings about use of spaces with operators:
> spaces preferred around that '*' (ctx:VxV)
> This has been recently added to checkpatch.

Trivia: That's not a particularly recent change.

> diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
[]
> @@ -5342,7 +5342,7 @@ enum wmi_sta_ps_param_pspoll_count {
>  #define WMI_UAPSD_AC_TYPE_TRIG 1
>  
>  #define WMI_UAPSD_AC_BIT_MASK(ac, type) \
> -	((type ==  WMI_UAPSD_AC_TYPE_DELI) ? (1<<(ac<<1)) : (1<<((ac<<1)+1)))
> +	((type ==  WMI_UAPSD_AC_TYPE_DELI) ? (1 << (ac << 1)) : (1 << ((ac << 1) + 1)))

There are a bunch of unnecessary parentheses here.
This could also use the BIT macro:

#define WMI_UAPSD_AC_BIT_MASK(ac, type) \
	(type == WMI_UAPSD_AC_TYPE_DELI ? BIT(ac << 1) : BIT((ac << 1) + 1))

