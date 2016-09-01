Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51414 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754406AbcIAQ3v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Sep 2016 12:29:51 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id 105ED40B5A0
        for <linux-wireless@vger.kernel.org>; Thu,  1 Sep 2016 09:29:51 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Ath10k probe response error related to mac80211 commit.
Message-ID: <cf9852df-6d14-baf6-af0a-9cc78c448fde@candelatech.com> (sfid-20160901_182956_271900_20A93AB4)
Date: Thu, 1 Sep 2016 09:29:50 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a variant of the ath10k 10.1 firmware that puts all frames, including management,
over the normal htt packet transport.  This has worked fine for many kernels, but
for reasons that currently escape me, the patch below breaks this firmware.

On air, I see corrupted probe responses, seems the end of the frames are corrupted.

This only breaks AP mode (station mode works fine).

There may be some other similar breakage somewhere, since git bisect could not find this
error and I had to bisect it by hand.

If someone has any idea of why this patch might trigger it, please let me know.
I'll keep digging in the meantime...

Author: Johannes Berg <johannes.berg@intel.com>  2015-11-26 07:26:14
Committer: Johannes Berg <johannes.berg@intel.com>  2015-12-04 05:43:32
Tags: ben-bad-athia-6
Parent: bda95eb1d1581cfd79e9717ebda4b7ccd2265351 (cfg80211: handle add_station auth/assoc flag quirks)
Child:  86c7ec9eb154020797c39e1cc7dafa92da02f603 (mac80211: properly free skb when r-o-c for TX fails)
Branches: master, remotes/origin/master
Follows: ben-good-athia-7
Precedes: ben-bad-5-athai

     Revert "mac80211: don't advertise NL80211_FEATURE_FULL_AP_CLIENT_STATE"

     This reverts commit 45bb780a2147b9995f3d288c44ecb87ca8a330e2,
     the previous two patches fixed the functionality.

     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

----------------------------- net/mac80211/main.c -----------------------------
index 175ffcf..858f6b1 100644
@@ -541,7 +541,8 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
  			   NL80211_FEATURE_HT_IBSS |
  			   NL80211_FEATURE_VIF_TXPOWER |
  			   NL80211_FEATURE_MAC_ON_CREATE |
-			   NL80211_FEATURE_USERSPACE_MPM;
+			   NL80211_FEATURE_USERSPACE_MPM |
+			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;

  	if (!ops->hw_scan)
  		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
