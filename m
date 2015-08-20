Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:51894 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbHTELv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 00:11:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21973.19910.496207.730546@gargle.gargle.HOWL> (sfid-20150820_061155_051278_0D6AFD7C)
Date: Thu, 20 Aug 2015 09:17:18 +0530
To: <miaoqing@qti.qualcomm.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<ath9k-devel@qca.qualcomm.com>, <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH v2 2/2] ath9k: fix incorrect calibration initial for ar9561
In-Reply-To: <1440033699-11121-2-git-send-email-miaoqing@qca.qualcomm.com>
References: <1440033699-11121-1-git-send-email-miaoqing@qca.qualcomm.com>
	<1440033699-11121-2-git-send-email-miaoqing@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@qti.qualcomm.com wrote:
> -	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9565(ah))
> +	if (AR_SREV_9485(ah) || AR_SREV_9462(ah) || AR_SREV_9565(ah) ||
> +	    AR_SREV_9561(ah))
>  		priv_ops->init_cal = ar9003_hw_init_cal_pcoem;
>  	else
>  		priv_ops->init_cal = ar9003_hw_init_cal_soc;

Are you sure about this ? AR9561 is not a PCOEM chip, IIRC.
Maybe the SoC routine is missing some code changes for AR956x ?

Sujith
