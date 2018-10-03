Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84305C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 522DE2064E
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 522DE2064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbeJCOMf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:12:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:33110 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbeJCOMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:12:35 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2018 00:25:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,335,1534834800"; 
   d="scan'208";a="94192628"
Received: from dhenry-mobl.ger.corp.intel.com ([10.252.4.16])
  by fmsmga004.fm.intel.com with ESMTP; 03 Oct 2018 00:24:44 -0700
Message-ID: <2787bccf20b6f647de9f4cafae5fd223e771b167.camel@intel.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        linux-kernel@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 03 Oct 2018 10:24:44 +0300
In-Reply-To: <20181003071513.13004-3-kai.heng.feng@canonical.com>
References: <20181003071513.13004-3-kai.heng.feng@canonical.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-03 at 15:15 +0800, Kai-Heng Feng wrote:
> To avoid the firmware loading race between Bluetooth and WiFi on Intel
> 8260, load firmware exclusively when BT_INTEL is enabled.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---

Where is this coming from? Can you explain what "the firmware loading
race" is?


>  .../net/wireless/intel/iwlwifi/pcie/trans.c   | 37 ++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index cc8c53dc0ab6..c30d3989e2a8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -71,6 +71,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/module.h>
> +#include <linux/intel-wifi-bt.h>

I don't see this upstream.  Is it something that was recently added?
Looks odd...

Regardless, this should also be protected on CONFIG_BT_INTEL.


>  #include "iwl-drv.h"
>  #include "iwl-trans.h"
> @@ -1335,6 +1336,10 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>  	bool hw_rfkill;
>  	int ret;
>  
> +#if IS_ENABLED(CONFIG_BT_INTEL)
> +	void (*firmware_lock_func)(void);
> +	void (*firmware_unlock_func)(void);
> +#endif
>  	/* This may fail if AMT took ownership of the device */
>  	if (iwl_pcie_prepare_card_hw(trans)) {
>  		IWL_WARN(trans, "Exit HW not ready\n");
> @@ -1394,6 +1399,7 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>  	 * RF-Kill switch is toggled, we will find out after having loaded
>  	 * the firmware and return the proper value to the caller.
>  	 */
> +

Stray empty line.

>  	iwl_enable_fw_load_int(trans);
>  
>  	/* really make sure rfkill handshake bits are cleared */
> @@ -1401,8 +1407,37 @@ static int iwl_trans_pcie_start_fw(struct iwl_trans *trans,
>  	iwl_write32(trans, CSR_UCODE_DRV_GP1_CLR, CSR_UCODE_SW_BIT_RFKILL);
>  
>  	/* Load the given image to the HW */
> -	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000)
> +	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_8000) {
> +#if IS_ENABLED(CONFIG_BT_INTEL)
> +		firmware_lock_func = symbol_request(btintel_firmware_lock);
> +		firmware_unlock_func = symbol_request(btintel_firmware_unlock);
> +		if (!firmware_lock_func || !firmware_unlock_func) {
> +			if (firmware_lock_func) {
> +				symbol_put(btintel_firmware_lock);
> +				firmware_lock_func = NULL;
> +			}
> +
> +			if (firmware_unlock_func) {
> +				symbol_put(btintel_firmware_unlock);
> +				firmware_unlock_func = NULL;
> +			}
> +		}
> +
> +		if (firmware_lock_func)
> +			firmware_lock_func();
> +#endif
>  		ret = iwl_pcie_load_given_ucode_8000(trans, fw);
> +
> +#if IS_ENABLED(CONFIG_BT_INTEL)
> +		if (firmware_unlock_func) {
> +			firmware_unlock_func();
> +			symbol_put(btintel_firmware_lock);
> +			firmware_lock_func = NULL;
> +			symbol_put(btintel_firmware_unlock);
> +			firmware_unlock_func = NULL;
> +		}
> +#endif
> +	}
>  	else
>  		ret = iwl_pcie_load_given_ucode(trans, fw);
>  

I'm not sure I like adding this BT-specific stuff here, especially not
without a detailed explanation.

Did you also send the other patches in this series to linux-wireless? I
can't see them...

--
Cheers,
Luca.

