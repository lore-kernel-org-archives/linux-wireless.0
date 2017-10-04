Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3852 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbdJDQPe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 12:15:34 -0400
Message-ID: <1507133714.908.90.camel@intel.com> (sfid-20171004_181622_307275_B7C30C82)
Subject: Re: [PATCH 1/3] wireless: iwlwifi: use bool instead of int
From: Luciano Coelho <luciano.coelho@intel.com>
To: Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
        <christoph@boehmwalder.at>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Oct 2017 19:15:14 +0300
In-Reply-To: <20171004155700.18048-2-christoph@boehmwalder.at>
References: <20171004155700.18048-1-christoph@boehmwalder.at>
         <20171004155700.18048-2-christoph@boehmwalder.at>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-04 at 17:56 +0200, Christoph Böhmwalder wrote:
> Change a usage of int in a boolean context to use the bool type
> instead, as it
> makes the intent of the function clearer and helps clarify its
> semantics.
> 
> Also eliminate the if/else and just return the boolean result
> directly,
> making the code more readable.
> 
> Signed-off-by: Christoph Böhmwalder <christoph@boehmwalder.at>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> index b7cd813ba70f..0eb815ae97e8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c
> @@ -267,14 +267,12 @@ int iwl_phy_db_set_section(struct iwl_phy_db
> *phy_db,
>  }
>  IWL_EXPORT_SYMBOL(iwl_phy_db_set_section);
>  
> -static int is_valid_channel(u16 ch_id)
> +static bool is_valid_channel(u16 ch_id)
>  {
> -	if (ch_id <= 14 ||
> -	    (36 <= ch_id && ch_id <= 64 && ch_id % 4 == 0) ||
> -	    (100 <= ch_id && ch_id <= 140 && ch_id % 4 == 0) ||
> -	    (145 <= ch_id && ch_id <= 165 && ch_id % 4 == 1))
> -		return 1;
> -	return 0;
> +	return (ch_id <= 14 ||
> +	       (36 <= ch_id && ch_id <= 64 && ch_id % 4 == 0) ||
> +	       (100 <= ch_id && ch_id <= 140 && ch_id % 4 == 0) ||
> +	       (145 <= ch_id && ch_id <= 165 && ch_id % 4 == 1));
>  }
>  
>  static u8 ch_id_to_ch_index(u16 ch_id)

This actually makes some sense, and I would probably apply it if it
were part of a patchset that actually does something useful.

--
Luca.
