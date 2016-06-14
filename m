Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:9643 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbcFNSug (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2016 14:50:36 -0400
Date: Wed, 15 Jun 2016 02:48:32 +0800
From: kbuild test robot <lkp@intel.com>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, johannes@sipsolutions.net,
	arnagara@codeaurora.org,
	Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] mac80211: store tx power value from user to station
Message-ID: <201606150209.vv1R4ZUm%fengguang.wu@intel.com> (sfid-20160614_205053_385428_E109ABDE)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
In-Reply-To: <1465926277-6509-1-git-send-email-arnagara@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[auto build test WARNING on mac80211/master]
[also build test WARNING on v4.7-rc3]
[cannot apply to mac80211-next/master next-20160614]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Ashok-Raj-Nagarajan/cfg80211-Add-support-to-set-tx-power-for-a-station-associated/20160615-014826
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'
>> include/net/mac80211.h:3640: warning: No description found for parameter 'sta_set_txpwr'

vim +/sta_set_txpwr +3640 include/net/mac80211.h

a7a6bdd0 Arik Nemtsov  2014-11-09  3624  
a7a6bdd0 Arik Nemtsov  2014-11-09  3625  	int (*tdls_channel_switch)(struct ieee80211_hw *hw,
a7a6bdd0 Arik Nemtsov  2014-11-09  3626  				   struct ieee80211_vif *vif,
a7a6bdd0 Arik Nemtsov  2014-11-09  3627  				   struct ieee80211_sta *sta, u8 oper_class,
a7a6bdd0 Arik Nemtsov  2014-11-09  3628  				   struct cfg80211_chan_def *chandef,
8a4d32f3 Arik Nemtsov  2014-11-09  3629  				   struct sk_buff *tmpl_skb, u32 ch_sw_tm_ie);
a7a6bdd0 Arik Nemtsov  2014-11-09  3630  	void (*tdls_cancel_channel_switch)(struct ieee80211_hw *hw,
a7a6bdd0 Arik Nemtsov  2014-11-09  3631  					   struct ieee80211_vif *vif,
a7a6bdd0 Arik Nemtsov  2014-11-09  3632  					   struct ieee80211_sta *sta);
8a4d32f3 Arik Nemtsov  2014-11-09  3633  	void (*tdls_recv_channel_switch)(struct ieee80211_hw *hw,
8a4d32f3 Arik Nemtsov  2014-11-09  3634  					 struct ieee80211_vif *vif,
8a4d32f3 Arik Nemtsov  2014-11-09  3635  					 struct ieee80211_tdls_ch_sw_params *params);
ba8c3d6f Felix Fietkau 2015-03-27  3636  
ba8c3d6f Felix Fietkau 2015-03-27  3637  	void (*wake_tx_queue)(struct ieee80211_hw *hw,
ba8c3d6f Felix Fietkau 2015-03-27  3638  			      struct ieee80211_txq *txq);
f59374eb Sara Sharon   2016-03-02  3639  	void (*sync_rx_queues)(struct ieee80211_hw *hw);
f0706e82 Jiri Benc     2007-05-05 @3640  };
f0706e82 Jiri Benc     2007-05-05  3641  
75a5f0cc Johannes Berg 2007-09-18  3642  /**
ad28757e Ben Greear    2014-10-22  3643   * ieee80211_alloc_hw_nm - Allocate a new hardware device
ad28757e Ben Greear    2014-10-22  3644   *
ad28757e Ben Greear    2014-10-22  3645   * This must be called once for each hardware device. The returned pointer
ad28757e Ben Greear    2014-10-22  3646   * must be used to refer to this device when calling other functions.
ad28757e Ben Greear    2014-10-22  3647   * mac80211 allocates a private data area for the driver pointed to by
ad28757e Ben Greear    2014-10-22  3648   * @priv in &struct ieee80211_hw, the size of this area is given as

:::::: The code at line 3640 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--uAKRQypu60I7Lcqm
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
zQ2eZCemZF4Hl5eeVigA/wES0bmbAVoAAA==

--uAKRQypu60I7Lcqm--
