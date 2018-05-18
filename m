Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:30794 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbeERPCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 11:02:54 -0400
Date: Fri, 18 May 2018 23:02:44 +0800
From: kbuild test robot <lkp@intel.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [mac80211-next:master 20/20] net/wireless/nl80211.c:4802:48: sparse:
 incorrect type in argument 1 (different base types)
Message-ID: <201805182336.tAJNrmeL%fengguang.wu@intel.com> (sfid-20180518_170258_192666_83AA0FA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
head:   7ea3e110f2f8ba23f330c2f702f556acd539bcb8
commit: 7ea3e110f2f8ba23f330c2f702f556acd539bcb8 [20/20] cfg80211: release station info tidstats where needed
reproduce:
        # apt-get install sparse
        git checkout 7ea3e110f2f8ba23f330c2f702f556acd539bcb8
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/wireless/nl80211.c:4802:48: sparse: incorrect type in argument 1 (different base types) @@    expected struct station_info *sinfo @@    got struct statiostruct station_info *sinfo @@
   net/wireless/nl80211.c:4802:48:    expected struct station_info *sinfo
   net/wireless/nl80211.c:4802:48:    got struct station_info [addressable] sinfo
   net/wireless/nl80211.c:7587:33: sparse: expression using sizeof(void)
   net/wireless/nl80211.c:7587:33: sparse: expression using sizeof(void)
   net/wireless/nl80211.c: In function 'nl80211_get_station':
   net/wireless/nl80211.c:4802:34: error: incompatible type for argument 1 of 'cfg80211_sinfo_release_content'
      cfg80211_sinfo_release_content(sinfo);
                                     ^~~~~
   In file included from net/wireless/nl80211.c:24:0:
   include/net/cfg80211.h:5721:20: note: expected 'struct station_info *' but argument is of type 'struct station_info'
    static inline void cfg80211_sinfo_release_content(struct station_info *sinfo)
                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

vim +4802 net/wireless/nl80211.c

  4776	
  4777	static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
  4778	{
  4779		struct cfg80211_registered_device *rdev = info->user_ptr[0];
  4780		struct net_device *dev = info->user_ptr[1];
  4781		struct station_info sinfo;
  4782		struct sk_buff *msg;
  4783		u8 *mac_addr = NULL;
  4784		int err;
  4785	
  4786		memset(&sinfo, 0, sizeof(sinfo));
  4787	
  4788		if (!info->attrs[NL80211_ATTR_MAC])
  4789			return -EINVAL;
  4790	
  4791		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
  4792	
  4793		if (!rdev->ops->get_station)
  4794			return -EOPNOTSUPP;
  4795	
  4796		err = rdev_get_station(rdev, dev, mac_addr, &sinfo);
  4797		if (err)
  4798			return err;
  4799	
  4800		msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
  4801		if (!msg) {
> 4802			cfg80211_sinfo_release_content(sinfo);
  4803			return -ENOMEM;
  4804		}
  4805	
  4806		if (nl80211_send_station(msg, NL80211_CMD_NEW_STATION,
  4807					 info->snd_portid, info->snd_seq, 0,
  4808					 rdev, dev, mac_addr, &sinfo) < 0) {
  4809			nlmsg_free(msg);
  4810			return -ENOBUFS;
  4811		}
  4812	
  4813		return genlmsg_reply(msg, info);
  4814	}
  4815	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
