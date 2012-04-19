Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:41353 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2DSEuB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 00:50:01 -0400
Message-ID: <4F8F9977.9040703@hartkopp.net> (sfid-20120419_065008_126318_61EE9937)
Date: Thu, 19 Apr 2012 06:49:59 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: net-next iwlwifi breaks compile - was Re: pull request: wireless-next
 2012-04-18
References: <20120418190521.GB2436@tuxdriver.com> <20120418.153653.2130740499995307564.davem@davemloft.net>
In-Reply-To: <20120418.153653.2130740499995307564.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18.04.2012 21:36, David Miller wrote:

> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 18 Apr 2012 15:05:22 -0400
> 
>> Another batch of wireless updates intended for 3.5...
>>
>> Highlights include some wl12xx refactoring, NFC HCI and SHDLC updates,
>> an ath6kl pull, some mesh updates, and the usual updates to iwlwifi,
>> ath9k, brcm80211, mwifiex, libertas, and other drivers.
>>
>> Please let me know if there are problems!
> 
> Also pulled, thanks a lot.


Commit "iwlwifi: move scan related declarations out of iwl-core.h"

http://git.kernel.org/?p=linux/kernel/git/davem/net-next.git;a=commitdiff;h=8fb96d6e176cbf0a97b2391fa1fa09e608ee86f8

breaks the compile when CONFIG_IWLWIFI_DEBUGFS is not set, see:

  CC [M]  drivers/net/wireless/iwlwifi/iwl-agn-tt.o
In file included from drivers/net/wireless/iwlwifi/iwl-agn-tt.c:40:0:
drivers/net/wireless/iwlwifi/iwl-core.h:97:19: error: static declaration of 'iwl_alloc_traffic_mem' follows non-static declaration
drivers/net/wireless/iwlwifi/iwl-agn.h:513:5: note: previous declaration of 'iwl_alloc_traffic_mem' was here
make[4]: *** [drivers/net/wireless/iwlwifi/iwl-agn-tt.o] Error 1
make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

Please check these kind of source reorganizations with different CONFIG settings too.

Regards,
Oliver
