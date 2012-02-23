Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:37075 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138Ab2BWQGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 11:06:05 -0500
Subject: Re: [PATCH 1/6] iwlwifi: dump stack when fail to gain access to
 the device
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 06:55:17 -0800
Message-ID: <1330008917.7290.92.camel@wwguy-huron> (sfid-20120223_170609_960999_E6C0DCED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

We are doing major driver re-factor works internally, I understand your
patches are important and these patches improve the quality of the
driver. I just wonder if it is ok for you to allow us to merge your
patches into our internal development tree first, then I will push these
patches upstream for you. By doing so, we can make sure your patches can
fully integrated with our on-going driver re-factor work and not cause
any conflict.

Linville, would it be ok for you?
 
Thanks in advance
Wey


On Thu, 2012-02-23 at 11:16 +0100, Stanislaw Gruszka wrote:
> Print dump stack when the device is not responding. This should give
> some more clue about the reason of failure. Also change the message we
> print, since "MAC in deep sleep" is kinda confusing.
> 
> On the way add unlikely(), as fail to gain NIC access is hmm ...
> unlikely.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-io.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-io.c b/drivers/net/wireless/iwlwifi/iwl-io.c
> index e2e3b5c..71015a3 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-io.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-io.c
> @@ -121,10 +121,10 @@ int iwl_grab_nic_access_silent(struct iwl_trans *trans)
>  int iwl_grab_nic_access(struct iwl_trans *trans)
>  {
>  	int ret = iwl_grab_nic_access_silent(trans);
> -	if (ret) {
> +	if (unlikely(ret)) {
>  		u32 val = iwl_read32(trans, CSR_GP_CNTRL);
> -		IWL_ERR(trans,
> -			"MAC is in deep sleep!. CSR_GP_CNTRL = 0x%08X\n", val);
> +		WARN_ONCE(1, "Timeout waiting for ucode processor access "
> +			     "(CSR_GP_CNTRL 0x%08x)\n", val);
>  	}
>  
>  	return ret;


