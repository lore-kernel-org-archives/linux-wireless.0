Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54417 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab1I3UAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 16:00:41 -0400
Date: Fri, 30 Sep 2011 15:57:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mac80211: pass vif param to conf_tx() callback
Message-ID: <20110930195706.GE2526@tuxdriver.com> (sfid-20110930_220050_703145_E71189A1)
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
 <1316970415-23239-3-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1316970415-23239-3-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 25, 2011 at 08:06:55PM +0300, Eliad Peller wrote:
> tx params should be configured per interface.
> Add ieee80211_vif param to the conf_tx callback,
> and update all the drivers that use this callback.
> 
> The following spatch was used:
> @rule1@
> struct ieee80211_ops ops;
> identifier conf_tx_op;
> @@
> 	ops.conf_tx = conf_tx_op;
> 
> @rule2@
> identifier rule1.conf_tx_op;
> identifier hw, queue, params;
> @@
> 	conf_tx_op (
> -		struct ieee80211_hw *hw,
> +		struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> 		u16 queue,
> 		const struct ieee80211_tx_queue_params *params) {...}
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

You really need to compile patches before submitting them...

  CC [M]  drivers/net/wireless/iwlegacy/iwl3945-base.o
drivers/net/wireless/iwlegacy/iwl3945-base.c:3522:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/iwlegacy/iwl-4965.o
drivers/net/wireless/iwlegacy/iwl-4965.c:2125:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn.o
drivers/net/wireless/iwlwifi/iwl-agn.c:3092:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/rt2x00/rt2500pci.o
drivers/net/wireless/rt2x00/rt2500pci.c:2005:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/rt2x00/rt2800pci.o
drivers/net/wireless/rt2x00/rt2800pci.c:1021:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/rt2x00/rt2500usb.o
drivers/net/wireless/rt2x00/rt2500usb.c:1824:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/rt2x00/rt2800usb.o
drivers/net/wireless/rt2x00/rt2800usb.c:766:2: warning: initialization from incompatible pointer type

  CC [M]  drivers/net/wireless/mwl8k.o
drivers/net/wireless/mwl8k.c: In function ‘mwl8k_reload_firmware’:
drivers/net/wireless/mwl8k.c:5466:3: warning: passing argument 2 of ‘mwl8k_conf_tx’ makes pointer from integer without a cast
drivers/net/wireless/mwl8k.c:4918:12: note: expected ‘struct ieee80211_vif *’ but argument is of type ‘int’
drivers/net/wireless/mwl8k.c:5466:3: warning: passing argument 3 of ‘mwl8k_conf_tx’ makes integer from pointer without a cast
drivers/net/wireless/mwl8k.c:4918:12: note: expected ‘u16’ but argument is of type ‘struct ieee80211_tx_queue_params *’
drivers/net/wireless/mwl8k.c:5466:3: error: too few arguments to function ‘mwl8k_conf_tx’
drivers/net/wireless/mwl8k.c:4918:12: note: declared here
make[1]: *** [drivers/net/wireless/mwl8k.o] Error 1
make: *** [drivers/net/wireless/] Error 2

Feel free to submit a new patch that doesn't introduce warnings or break the build...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
