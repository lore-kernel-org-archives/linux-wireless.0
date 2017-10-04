Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0031.hostedemail.com ([216.40.44.31]:60487 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751135AbdJDQO2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 12:14:28 -0400
Message-ID: <1507133664.4434.7.camel@perches.com> (sfid-20171004_181529_479115_C8841C4A)
Subject: Re: [PATCH 3/3] wireless: iwlwifi: wrap macro into braces
From: Joe Perches <joe@perches.com>
To: Christoph =?ISO-8859-1?Q?B=F6hmwalder?=
        <christoph@boehmwalder.at>, johannes.berg@intel.com,
        emmanuel.grumbach@intel.com, luciano.coelho@intel.com,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Oct 2017 09:14:24 -0700
In-Reply-To: <20171004155700.18048-4-christoph@boehmwalder.at>
References: <20171004155700.18048-1-christoph@boehmwalder.at>
         <20171004155700.18048-4-christoph@boehmwalder.at>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-04 at 17:57 +0200, Christoph Böhmwalder wrote:
> Macros should always be wrapped in braces, so fix this instance.
> 
> Signed-off-by: Christoph Böhmwalder <christoph@boehmwalder.at>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
> index efb1998dcabd..0211963b3e71 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
> @@ -252,7 +252,7 @@ IWL_EXPORT_SYMBOL(iwl_force_nmi);
>  
>  static const char *get_rfh_string(int cmd)
>  {
> -#define IWL_CMD(x) case x: return #x
> +#define IWL_CMD(x) { case x: return #x; }

I think this unnecessary.  Maybe:
http://lists.infradead.org/pipermail/ath10k/2017-February/009335.html

>  #define IWL_CMD_MQ(arg, reg, q) { if (arg == reg(q)) return #reg; }

But this should use do { ... } while (0)
