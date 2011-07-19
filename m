Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:32200 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1GSVm6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 17:42:58 -0400
Message-ID: <4E25FA60.7040807@gnu.org> (sfid-20110719_234302_063697_7FDE84C7)
Date: Tue, 19 Jul 2011 17:42:56 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Kernel oops in code added by "cfg80211: allow userspace to control
 supported rates in scan"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

The current wireless-testing.git has a problem.  I'm trying to run 
wpa_supplicant on an interface created by carl9170 (with nl80211 
driver), and it oopses in nl80211_trigger_scan().  It turns out it 
oopses here:

for (i = 0; i < IEEE80211_NUM_BANDS; i++)
       request->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;

Here's the self-explanatory debug output I added:

[  460.190157] IEEE80211_NUM_BANDS = 2
[  460.193636] request = ffff8801246dc500
[  460.197373] request->rates = ffff8801246dc520
[  460.201748] wiphy = ffff8800b78b84e0
[  460.205317] wiphy->bands = ffff8800b78b8590
[  460.209489] i = 0, wiphy->bands[i] = ffffffffa00a80a0
[  460.214559] i = 1, wiphy->bands[i] =           (null)

wiphy->bands[1] is NULL, so wiphy->bands[1]->n_bitrates is invalid.

Likewise, if I run "iwconfig wlanX scan", I get an oops in 
cfg80211_wext_siwscan() on line 866:

for (i = 0; i < IEEE80211_NUM_BANDS; i++)
      creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;

Both pieces of code were added by:

commit 58389c69150e6032504dfcd3edca6b1975c8b5bc
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Jul 18 18:08:35 2011 +0200

     cfg80211: allow userspace to control supported rates in scan

-- 
Regards,
Pavel Roskin
