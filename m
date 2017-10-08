Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0026.hostedemail.com ([216.40.44.26]:51069 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751867AbdJHP7h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Oct 2017 11:59:37 -0400
Message-ID: <1507478374.11434.1.camel@perches.com> (sfid-20171008_175941_173964_B758B079)
Subject: Re: [PATCH 1/5] iwlwifi: mvm: do not print security error in
 monitor mode
From: Joe Perches <joe@perches.com>
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 08 Oct 2017 08:59:34 -0700
In-Reply-To: <20170929120305.20551-2-luca@coelho.fi>
References: <20170929120305.20551-1-luca@coelho.fi>
         <20170929120305.20551-2-luca@coelho.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-09-29 at 15:03 +0300, Luca Coelho wrote:
> From: Shaul Triebitz <shaul.triebitz@intel.com>
> 
> In monitor mode we are not expected to decrypt encrypted
> packets (not having the keys).
> Hence we are expected to get an unknown rx security status.
> Keeping the print in monitor mode causes a print for each
> captured packet flooding the dmesg.
[]
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
[]
> @@ -1015,6 +1015,9 @@ struct iwl_mvm {
>  	bool drop_bcn_ap_mode;
>  
>  	struct delayed_work cs_tx_unblock_dwork;
> +
> +	/* does a monitor vif exist (only one can exist hence bool) */
> +	bool monitor_on;

It would be slightly more space efficient to move this above
	struct delayed_work cs_tx_unblock_dwork
adjacent to
	bool drop_bcn_ap_mode
