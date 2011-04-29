Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760457Ab1D2RkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 13:40:06 -0400
Subject: Re: [PATCH 2.6.38 3/4] iwl3945: disable hw scan by default
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@kernel.org, kernel@lists.fedoraproject.org,
	Kyle McMartin <kmcmartin@redhat.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 29 Apr 2011 12:41:32 -0500
In-Reply-To: <1303992495-7337-4-git-send-email-sgruszka@redhat.com>
References: <1303992495-7337-1-git-send-email-sgruszka@redhat.com>
	 <1303992495-7337-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1304098893.1921.32.camel@dcbw.foobar.com> (sfid-20110429_194030_630204_505E862A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-28 at 14:08 +0200, Stanislaw Gruszka wrote:
> commit 0263aa45293838b514b8af674a03faf040991a90 upstream.
> 
> After new NetworkManager 0.8.996 changes, hardware scanning is causing
> microcode errors as reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=683571
> and sometimes kernel crashes:
> https://bugzilla.redhat.com/show_bug.cgi?id=688252

Note that the only difference with NM 0.8.996 here is that
wpa_supplicant 0.7 + nl80211 is used rather than WEXT, so this issue is
likely related to the change from WEXT -> nl80211, if anything...

Dan

> Also with hw scan there are very bad performance on some systems
> as reported here:
> https://bugzilla.redhat.com/show_bug.cgi?id=671366
> 
> Since Intel no longer supports 3945, there is no chance to get proper
> firmware fixes, we need workaround problems by disable hardware scanning
> by default.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index cf0699a..a8340f7 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -94,6 +94,7 @@ MODULE_LICENSE("GPL");
>  struct iwl_mod_params iwl3945_mod_params = {
>  	.sw_crypto = 1,
>  	.restart_fw = 1,
> +	.disable_hw_scan = 1,
>  	/* the rest are 0 by default */
>  };
>  
> @@ -4317,7 +4318,7 @@ MODULE_PARM_DESC(debug, "debug output mask");
>  #endif
>  module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
>  		   int, S_IRUGO);
> -MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
> +MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 1)");
>  module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
>  MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
>  


