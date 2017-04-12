Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:26446 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752956AbdDLPSV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:18:21 -0400
Date: Wed, 12 Apr 2017 23:17:41 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org
Subject: [mac80211-next:bpf 9/9] net/mac80211/iface.c:1113:40: sparse:
 incompatible types in comparison expression (different address spaces)
Message-ID: <201704122335.dadhdBZo%fengguang.wu@intel.com> (sfid-20170412_171825_825328_72CEF08B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git bpf
head:   772b164e17bd40659b5a45e26389e4d9418162e4
commit: 772b164e17bd40659b5a45e26389e4d9418162e4 [9/9] mac80211: support bpf monitor filter
reproduce:
        # apt-get install sparse
        git checkout 772b164e17bd40659b5a45e26389e4d9418162e4
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> net/mac80211/iface.c:1113:40: sparse: incompatible types in comparison expression (different address spaces)
   net/mac80211/iface.c:1115:17: sparse: incompatible types in comparison expression (different address spaces)
--
   include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> net/mac80211/cfg.c:110:40: sparse: incompatible types in comparison expression (different address spaces)
   net/mac80211/cfg.c:113:25: sparse: incompatible types in comparison expression (different address spaces)
--
   include/linux/compiler.h:264:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> net/mac80211/rx.c:573:26: sparse: incompatible types in comparison expression (different address spaces)

vim +1113 net/mac80211/iface.c

  1097	static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
  1098	{
  1099		int i;
  1100	
  1101		/* free extra data */
  1102		ieee80211_free_keys(sdata, false);
  1103	
  1104		ieee80211_debugfs_remove_netdev(sdata);
  1105	
  1106		for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
  1107			__skb_queue_purge(&sdata->fragments[i].skb_list);
  1108		sdata->fragment_next = 0;
  1109	
  1110		if (ieee80211_vif_is_mesh(&sdata->vif)) {
  1111			ieee80211_mesh_teardown_sdata(sdata);
  1112		} else if (sdata->vif.type == NL80211_IFTYPE_MONITOR) {
> 1113			struct bpf_prog *old = rtnl_dereference(sdata->u.mntr.filter);
  1114	
  1115			RCU_INIT_POINTER(sdata->u.mntr.filter, NULL);
  1116			if (old)
  1117				bpf_prog_put(old);
  1118		}
  1119	}
  1120	
  1121	static void ieee80211_uninit(struct net_device *dev)

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
