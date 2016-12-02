Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:57103 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755585AbcLBADQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 19:03:16 -0500
Date: Fri, 2 Dec 2016 11:03:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: linux-next: manual merge of the wireless-drivers-next tree with the
 net-next tree
Message-ID: <20161202110313.2104919e@canb.auug.org.au> (sfid-20161202_010353_036397_5636BE9F)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Today's linux-next merge of the wireless-drivers-next tree got a
conflict in:

  drivers/net/wireless/ath/ath10k/mac.c

between commit:

  f3fe4e93dd63 ("mac80211: add a HW flag for supporting HW TX fragmentation")

from the net-next tree and commit:

  ff32eeb86aa1 ("ath10k: advertize hardware packet loss mechanism")

from the wireless-drivers-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

-- 
Cheers,
Stephen Rothwell

diff --cc drivers/net/wireless/ath/ath10k/mac.c
index 717b2fad9a8a,db6ddf974d1d..000000000000
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@@ -8005,7 -7993,7 +7993,8 @@@ int ath10k_mac_register(struct ath10k *
  	ieee80211_hw_set(ar->hw, WANT_MONITOR_VIF);
  	ieee80211_hw_set(ar->hw, CHANCTX_STA_CSA);
  	ieee80211_hw_set(ar->hw, QUEUE_CONTROL);
 +	ieee80211_hw_set(ar->hw, SUPPORTS_TX_FRAG);
+ 	ieee80211_hw_set(ar->hw, REPORTS_LOW_ACK);
  
  	if (!test_bit(ATH10K_FLAG_RAW_MODE, &ar->dev_flags))
  		ieee80211_hw_set(ar->hw, SW_CRYPTO_CONTROL);
