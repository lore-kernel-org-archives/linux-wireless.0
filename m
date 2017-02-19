Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:25590 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbdBSJQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 04:16:07 -0500
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
Subject: RE: [RFC 1/5] iwlwifi: fix drv cleanup on opmode registration
 failure
Date: Sun, 19 Feb 2017 09:16:01 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3A8F4AD47@hasmsx107.ger.corp.intel.com> (sfid-20170219_101634_707863_DB3DA590)
References: <20170217020903.6370-1-mcgrof@kernel.org>
 <20170217020903.6370-2-mcgrof@kernel.org>
In-Reply-To: <20170217020903.6370-2-mcgrof@kernel.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> 
> The firmware async callback handles the device's opmode start call, but
> optionally also allows opmode registration to take care of its opmode start. If
> the firmware callback handles it its error path in case of opmode start failure
> has a few pieces of code missing from the opmode registration. The opmode
> registration hanlder has no cleanup at all. Sync both error paths.
> 
> This should in theory fix a detangled drv from the drv list should either of the
> opmode modules loaded and handled registration for the drv.
> 
> The path of having the opmode registration deal with the drv opmode start is
> actually the more common path. The other path, from the async callback is
> rathe rare (1/8 or so times for me) -- it happens when the the opmode
> driver's init routine completed prior to the driver's async callback opmode
> start call.

I'd claim it should never happen unless you have several devices on the system using the same
opmode, or unless you do:
modprobe iwlwifi  #which will load iwl{d,m}vm
rmmod iwl{d,m}vm #and do _not_ remove iwlwifi
modprobe iwlwifi



> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> ---

Luca is OOO,  but this looks fine to me.


>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> index be466a074c1d..e198d6f5fcea 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -1611,8 +1611,13 @@ int iwl_opmode_register(const char *name, const
> struct iwl_op_mode_ops *ops)
>  			continue;
>  		op->ops = ops;
>  		/* TODO: need to handle exceptional case */
> -		list_for_each_entry(drv, &op->drv, list)
> +		list_for_each_entry(drv, &op->drv, list) {
>  			drv->op_mode = _iwl_op_mode_start(drv, op);
> +			if (!drv->op_mode) {
> +				complete(&drv-
> >request_firmware_complete);
> +				device_release_driver(drv->trans->dev);
> +			}
> +		}
> 
>  		mutex_unlock(&iwlwifi_opmode_table_mtx);
>  		return 0;
> --
> 2.11.0
