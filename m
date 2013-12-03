Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29267 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3LCQhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 11:37:21 -0500
Date: Tue, 3 Dec 2013 19:37:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Max.Stepanov@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mac80211: add generic cipher scheme support
Message-ID: <20131203163712.GA1857@elgon.mountain> (sfid-20131203_173739_381608_19BDFAE3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Max Stepanov,

The patch 2475b1cc0d52: "mac80211: add generic cipher scheme support"
from Mar 24, 2013, leads to the following
static checker warning: "net/mac80211/cfg.c:305 ieee80211_get_key()
	 warn: buffer overflow 'sta->ptk' 4 <= 5"

net/mac80211/cfg.c
   279  static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
   280                               u8 key_idx, bool pairwise, const u8 *mac_addr,
   281                               void *cookie,
   282                               void (*callback)(void *cookie,
   283                                                struct key_params *params))
   284  {
   285          struct ieee80211_sub_if_data *sdata;
   286          struct sta_info *sta = NULL;
   287          u8 seq[6] = {0};
   288          struct key_params params;
   289          struct ieee80211_key *key = NULL;
   290          u64 pn64;
   291          u32 iv32;
   292          u16 iv16;
   293          int err = -ENOENT;
   294  
   295          sdata = IEEE80211_DEV_TO_SUB_IF(dev);
   296  
   297          rcu_read_lock();
   298  
   299          if (mac_addr) {
   300                  sta = sta_info_get_bss(sdata, mac_addr);
   301                  if (!sta)
   302                          goto out;
   303  
   304                  if (pairwise)
   305                          key = rcu_dereference(sta->ptk[key_idx]);
   306                  else if (key_idx < NUM_DEFAULT_KEYS)
   307                          key = rcu_dereference(sta->gtk[key_idx]);

key_idx is a number between 0 and 5.
NUM_DEFAULT_KEYS is 4.
->ptk has 4 elements.
->gtk has 6 elements.

I looked but I didn't see that "pairwise" implied that key_idx is less
than 4.  These are set in nl80211_get_key().

   308          } else
   309                  key = rcu_dereference(sdata->keys[key_idx]);
   310  
   311          if (!key)
   312                  goto out;

regards,
dan carpenter

