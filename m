Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:48145 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751097AbdBSJsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 04:48:05 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "ming.lei@canonical.com" <ming.lei@canonical.com>,
        "zajec5@gmail.com" <zajec5@gmail.com>
CC: "jeyu@redhat.com" <jeyu@redhat.com>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC 2/5] iwlwifi: fix request_module() use
Date: Sun, 19 Feb 2017 09:47:59 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AE27@hasmsx107.ger.corp.intel.com> (sfid-20170219_104848_425198_EBBA295E)
References: <20170217020903.6370-1-mcgrof@kernel.org>
 <20170217020903.6370-3-mcgrof@kernel.org>
In-Reply-To: <20170217020903.6370-3-mcgrof@kernel.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> The return value of request_module() being 0 does not mean that the driver
> which was requested has loaded. To properly check that the driver was
> loaded each driver can use internal mechanisms to vet the driver is now
> present. The helper try_then_request_module() was added to help with
> this, allowing drivers to specify their own validation as the first argument.
> 
> On iwlwifi the use case is a bit more complicated given that the value we
> need to check for is protected with a mutex later used on the
> module_init() of the module we are asking for. If we were to lock and
> request_module() we'd deadlock. iwlwifi needs its own wrapper then so it
> can handle its special locking requirements.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>

I don't see the problem with the current code. We don't assume that everything has been
loaded immediately after request_module returns. We just free the intermediate firmware
structures that won't be using anymore. What happens here is that after request_module
returns, we patiently wait until it is loaded, and when that happens, iwl{d,m}vm's init function
will be called. That one is the one that continues the flow by calling:

	ret = iwl_opmode_register("iwlmvm", &iwl_mvm_ops);

(for the iwlmvm case).

Where am I wrong here?


> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 34 ++++++++++++++++++++---
> -----
>  1 file changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> index e198d6f5fcea..6beb92d19ea7 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -1231,6 +1231,29 @@ static void _iwl_op_mode_stop(struct iwl_drv
> *drv)
>  	}
>  }
> 
> +static void iwlwifi_try_load_op(struct iwlwifi_opmode_table *op,
> +				struct iwl_drv *drv)
> +{
> +	int ret = 0;
> +
> +	ret = request_module("%s", op->name);
> +	if (ret)
> +		goto out;
> +
> +	mutex_lock(&iwlwifi_opmode_table_mtx);
> +	if (!op->ops)
> +		ret = -ENOENT;
> +	mutex_unlock(&iwlwifi_opmode_table_mtx);
> +
> +out:
> +#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
> +	if (ret)
> +		IWL_ERR(drv,
> +			"failed to load module %s (error %d), is dynamic
> loading enabled?\n",
> +			op->name, ret);
> +#endif
> +}
> +
>  /**
>   * iwl_req_fw_callback - callback when firmware was loaded
>   *
> @@ -1471,15 +1494,8 @@ static void iwl_req_fw_callback(const struct
> firmware *ucode_raw, void *context)
>  	 * else from proceeding if the module fails to load
>  	 * or hangs loading.
>  	 */
> -	if (load_module) {
> -		err = request_module("%s", op->name);
> -#ifdef CONFIG_IWLWIFI_OPMODE_MODULAR
> -		if (err)
> -			IWL_ERR(drv,
> -				"failed to load module %s (error %d), is
> dynamic loading enabled?\n",
> -				op->name, err);
> -#endif
> -	}
> +	if (load_module)
> +		iwlwifi_try_load_op(op, drv);
>  	goto free;
> 
>   try_again:
> --
> 2.11.0
