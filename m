Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:45411 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbcGHBcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2016 21:32:17 -0400
Date: Fri, 8 Jul 2016 11:32:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avraham Stern <avraham.stern@intel.com>,
	David Spinadel <david.spinadel@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Subject: linux-next: build warning after merge of the wireless-drivers-next
 tree
Message-ID: <20160708113214.7f371cb3@canb.auug.org.au> (sfid-20160708_033249_698594_1331177D)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(arm multi_v7_defconfig, x86_64 allmodconfig) produced this warning:

drivers/net/wireless/marvell/mwifiex/scan.c: In function 'mwifiex_cancel_scan':
drivers/net/wireless/marvell/mwifiex/scan.c:2031:44: warning: passing argument 2 of 'cfg80211_scan_done' makes pointer from integer without a cast [-Wint-conversion]
     cfg80211_scan_done(priv->scan_request, 1);
                                            ^
In file included from include/net/mac80211.h:23:0,
                 from drivers/net/wireless/marvell/mwifiex/decl.h:30,
                 from drivers/net/wireless/marvell/mwifiex/scan.c:20:
include/net/cfg80211.h:4104:6: note: expected 'struct cfg80211_scan_info *' but argument is of type 'int'
 void cfg80211_scan_done(struct cfg80211_scan_request *request,
      ^

Introduced by commit

  a9c790ba23eb ("mwifiex: factor out mwifiex_cancel_scan")

interacting with commit

  1d76250bd34a ("nl80211: support beacon report scanning")

from the net-next (and mac80211-next) tree.

This will need some merge fix patch ... please send me or Dave one.

-- 
Cheers,
Stephen Rothwell
