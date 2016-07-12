Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34502 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbcGLIOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 04:14:51 -0400
Message-ID: <1468311283.25088.129.camel@coelho.fi> (sfid-20160712_101526_340396_5EFAE900)
From: Luca Coelho <luca@coelho.fi>
To: Arnd Bergmann <arnd@arndb.de>,
	Johannes Berg <johannes.berg@intel.com>,
	kvalo <kvalo@codeaurora.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Intel Linux Wireless <linuxwifi@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Eliad Peller <eliad@wizery.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Tue, 12 Jul 2016 11:14:43 +0300
In-Reply-To: <20160711205020.1587254-1-arnd@arndb.de>
References: <20160711205020.1587254-1-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: add missing type declaration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-07-11 at 22:49 +0200, Arnd Bergmann wrote:
> The iwl-debug.h header relies in implicit inclusion of linux/device.h
> and
> we get a lot of warnings without that:
> 
> drivers/net/wireless/intel/iwlwifi/iwl-debug.h:44:23: error: 'struct
> device' declared inside parameter list will not be visible outside of
> this definition or declaration [-Werror]
>  void __iwl_err(struct device *dev, bool rfkill_prefix, bool
> only_trace,
>                        ^~~~~~
> In file included from drivers/net/wireless/intel/iwlwifi/iwl-eeprom-
> read.h:66:0,
>                  from drivers/net/wireless/intel/iwlwifi/iwl-eeprom-
> read.c:68:
> drivers/net/wireless/intel/iwlwifi/iwl-trans.h: In function
> 'iwl_trans_tx':
> drivers/net/wireless/intel/iwlwifi/iwl-trans.h:1030:348: error:
> passing argument 1 of '__iwl_err' from incompatible pointer type [-
> Werror=incompatible-pointer-types]
>    IWL_ERR(trans, "%s bad state = %d\n", __func__, trans->state);
>                                                                      
>                                                                      
>                                                                      
>                                                                      
>                                                                      
>    ^
> In file included from drivers/net/wireless/intel/iwlwifi/iwl-eeprom-
> read.c:67:0:
> drivers/net/wireless/intel/iwlwifi/iwl-debug.h:44:6: note: expected
> 'struct device *' but argument is of type 'struct device *'
>  void __iwl_err(struct device *dev, bool rfkill_prefix, bool
> only_trace,
>       ^~~~~~~~~
> 
> The easiest workaround is to just declare 'struct device' before its
> first use,
> rather than including the entire header file.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 21cb3222fe56 ("iwlwifi: decouple PCIe transport from
> mac80211")
> ---

Acked-by: Luca Coelho <luciano.coelho@intel.com>

Agree with Kalle that he will take this directly to wireless-drivers-
next.

--
Cheers,
Luca.
