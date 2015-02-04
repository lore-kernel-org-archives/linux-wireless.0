Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50084 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbbBDHpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 02:45:19 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/8] ath10k:  make dbglog debug messages be 'warn' level.
References: <1421087564-10384-1-git-send-email-greearb@candelatech.com>
	<1421087564-10384-4-git-send-email-greearb@candelatech.com>
Date: Wed, 4 Feb 2015 09:44:51 +0200
In-Reply-To: <1421087564-10384-4-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Mon, 12 Jan 2015 10:32:40
	-0800")
Message-ID: <87mw4uunm4.fsf@kamboji.qca.qualcomm.com> (sfid-20150204_084522_542851_37F57066)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This only happens on firmware crash, and it appears this
> logic is not always perfect, so make sure the information
> is printed to logs at higher level.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 0f7e845..dee0d5a 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1132,9 +1132,8 @@ static void ath10k_pci_dump_dbglog(struct ath10k *ar)
>  		return;
>  	}
>  
> -	ath10k_dbg(ar, ATH10K_DBG_PCI,
> -		   "debug log header, dbuf: 0x%x  dropped: %i\n",
> -		   le32_to_cpu(dbg_hdr.dbuf), le32_to_cpu(dbg_hdr.dropped));
> +	ath10k_warn(ar, "debug log header, dbuf: 0x%x  dropped: %i\n",
> +		    le32_to_cpu(dbg_hdr.dbuf), le32_to_cpu(dbg_hdr.dropped));
>  	dbufp = le32_to_cpu(dbg_hdr.dbuf);

I think a new debug level is more approriate, this is just spamming the
logs unnecessary.

-- 
Kalle Valo
