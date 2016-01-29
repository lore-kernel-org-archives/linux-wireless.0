Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61904 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbcA2MJS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 07:09:18 -0500
Date: Fri, 29 Jan 2016 20:08:30 +0800
From: kbuild test robot <lkp@intel.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <hrogge@gmail.com>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Subject: Re: [PATCH v2 3/3] mac80211: Unify mesh and mpp path removal function
Message-ID: <201601292046.1EmSMGRP%fengguang.wu@intel.com> (sfid-20160129_130922_710761_00E9ED6C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454062138-18012-4-git-send-email-henning.rogge@fkie.fraunhofer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Henning,

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v4.5-rc1 next-20160129]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Henning-Rogge/mac80211-add-cleanup-path-for-MPP-table-entries/20160129-181045
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:228:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)
>> net/mac80211/mesh_pathtbl.c:60:10: sparse: incompatible types in comparison expression (different address spaces)

vim +60 net/mac80211/mesh_pathtbl.c

    44	static struct mesh_table __rcu *mpp_paths; /* Store paths for MPP&MAP */
    45	
    46	int mesh_paths_generation;
    47	int mpp_paths_generation;
    48	
    49	/* This lock will have the grow table function as writer and add / delete nodes
    50	 * as readers. RCU provides sufficient protection only when reading the table
    51	 * (i.e. doing lookups).  Adding or adding or removing nodes requires we take
    52	 * the read lock or we risk operating on an old table.  The write lock is only
    53	 * needed when modifying the number of buckets a table.
    54	 */
    55	static DEFINE_RWLOCK(pathtbl_resize_lock);
    56	
    57	
    58	static inline struct mesh_table *resize_dereference_paths(struct mesh_table *table)
    59	{
  > 60	  return rcu_dereference_protected(table,
    61	    lockdep_is_held(&pathtbl_resize_lock));
    62	}
    63	
    64	static inline struct mesh_table *resize_dereference_mesh_paths(void)
    65	{
    66		return resize_dereference_paths(mesh_paths);
    67	}
    68	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
