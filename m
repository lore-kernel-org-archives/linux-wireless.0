Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45587 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab2FZUXc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 16:23:32 -0400
Date: Mon, 25 Jun 2012 15:07:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Panayiotis Karabassis <panayk@gmail.com>
Cc: linux-wireless@vger.kernel.org, shafi.wireless@gmail.com,
	fynivx@gmail.com, gilleshabran@gmail.com
Subject: Re: [PATCH] ath9k: enable serialize_regmode for non-PCIE AR9287
Message-ID: <20120625190730.GB9177@tuxdriver.com> (sfid-20120626_222336_752710_3D37CEB5)
References: <1340476984-19516-1-git-send-email-panayk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1340476984-19516-1-git-send-email-panayk@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 23, 2012 at 09:43:04PM +0300, Panayiotis Karabassis wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=42903
> 
> Based on the work of <fynivx@gmail.com>

Needs a "Signed-off-by: ...' line.

> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index a42c26f..ebfb2a3 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -614,7 +614,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
>  
>  	if (NR_CPUS > 1 && ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
>  		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
> -		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah)) &&
> +		    ((AR_SREV_9160(ah) || AR_SREV_9280(ah) || AR_SREV_9287(ah)) &&
>  		     !ah->is_pciexpress)) {
>  			ah->config.serialize_regmode =
>  				SER_REG_MODE_ON;
> -- 
> 1.7.10
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
