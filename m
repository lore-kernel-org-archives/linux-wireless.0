Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:56255 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750740AbbLTSrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 13:47:13 -0500
Message-ID: <1450637228.3430.30.camel@perches.com> (sfid-20151220_194717_713714_0899263C)
Subject: Re: [patch -next] ath9k: fix ath9k_hw_nvram_check_version()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, kernel-janitors@vger.kernel.org
Date: Sun, 20 Dec 2015 10:47:08 -0800
In-Reply-To: <20151219105919.GB3749@mwanda>
References: <20151219105919.GB3749@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-12-19 at 13:59 +0300, Dan Carpenter wrote:
> There is a type bug so it always returns success.

How many false positives do you have to sift
through to find this sort of error?

> +++ b/drivers/net/wireless/ath/ath9k/eeprom.c
> @@ -206,7 +206,7 @@ bool ath9k_hw_nvram_check_version(struct ath_hw *ah, int version, int minrev)
>  		ath_err(common, "Bad EEPROM VER 0x%04x or REV 0x%04x\n",
>  			ah->eep_ops->get_eeprom_ver(ah),
>  			ah->eep_ops->get_eeprom_rev(ah));
> -		return -EINVAL;
> +		return false;
>  	}
>  
>  	return true;

