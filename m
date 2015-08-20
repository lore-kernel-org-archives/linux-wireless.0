Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:57431 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbHTHHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:07:45 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: "sujith@msujith.org" <sujith@msujith.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>
Subject: RE: [PATCH v2 2/2] ath9k: fix incorrect calibration initial for
 ar9561
Date: Thu, 20 Aug 2015 07:07:43 +0000
Message-ID: <85a689635dfd4daf80947a946e7d4371@NASANEXM01E.na.qualcomm.com> (sfid-20150820_090749_173415_4627B7D7)
References: <1440033699-11121-1-git-send-email-miaoqing@qca.qualcomm.com>
	<1440033699-11121-2-git-send-email-miaoqing@qca.qualcomm.com>
 <21973.19910.496207.730546@gargle.gargle.HOWL>
In-Reply-To: <21973.19910.496207.730546@gargle.gargle.HOWL>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Sujith.  You mentioned this before,  so need more investigation,  and this patch will be discarded. 

Miaoqing

-----Original Message-----
From: Sujith Manoharan [mailto:sujith@msujith.org] 
Sent: Thursday, August 20, 2015 11:47 AM
To: Pan, Miaoqing
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; ath9k-devel; Valo, Kalle
Subject: Re: [PATCH v2 2/2] ath9k: fix incorrect calibration initial for ar9561

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
