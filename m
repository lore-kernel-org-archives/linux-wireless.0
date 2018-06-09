Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14178 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751466AbeFICNb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Jun 2018 22:13:31 -0400
Date: Sat, 9 Jun 2018 10:13:08 +0800
From: kbuild test robot <lkp@intel.com>
To: Luca Coelho <luca@coelho.fi>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Luca Coelho <luciano.coelho@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Subject: Re: [PATCH 1/3] cfg80211: Add support for HE
Message-ID: <201806090754.ae7QWN7P%fengguang.wu@intel.com> (sfid-20180609_041521_886027_EBA9F51D)
References: <20180608071203.20708-2-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
In-Reply-To: <20180608071203.20708-2-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Luca,

I love your patch! Yet something to improve:

[auto build test ERROR on mac80211-next/master]
[also build test ERROR on next-20180608]
[cannot apply to v4.17]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Luca-Coelho/cfg80211-mac80211-add-support-for-IEEE802-11ax/20180609-065018
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
config: x86_64-randconfig-x018-201822 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

Note: the linux-review/Luca-Coelho/cfg80211-mac80211-add-support-for-IEEE802-11ax/20180609-065018 HEAD a5988005673125579d32941fcb33b0d7c9d79ee5 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   In file included from arch/x86/include/asm/bug.h:83:0,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:12,
                    from include/linux/uio.h:13,
                    from include/linux/socket.h:8,
                    from include/uapi/linux/if.h:25,
                    from net/wireless/core.c:11:
   net/wireless/core.c: In function 'wiphy_register':
>> net/wireless/core.c:798:23: error: 'const struct ieee80211_sband_iftype_data' has no member named 'types'; did you mean 'types_mask'?
       if (WARN_ON(!iftd->types))
                          ^
   include/asm-generic/bug.h:112:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    \
                            ^~~~~~~~~
   net/wireless/core.c:800:30: error: 'const struct ieee80211_sband_iftype_data' has no member named 'types'; did you mean 'types_mask'?
       if (WARN_ON(types & iftd->types))
                                 ^
   include/asm-generic/bug.h:112:25: note: in definition of macro 'WARN_ON'
     int __ret_warn_on = !!(condition);    \
                            ^~~~~~~~~
   net/wireless/core.c:807:19: error: 'const struct ieee80211_sband_iftype_data' has no member named 'types'; did you mean 'types_mask'?
       types |= iftd->types;
                      ^~~~~
                      types_mask

vim +798 net/wireless/core.c

   666	
   667		/*
   668		 * if a wiphy has unsupported modes for regulatory channel enforcement,
   669		 * opt-out of enforcement checking
   670		 */
   671		if (wiphy->interface_modes & ~(BIT(NL80211_IFTYPE_STATION) |
   672					       BIT(NL80211_IFTYPE_P2P_CLIENT) |
   673					       BIT(NL80211_IFTYPE_AP) |
   674					       BIT(NL80211_IFTYPE_P2P_GO) |
   675					       BIT(NL80211_IFTYPE_ADHOC) |
   676					       BIT(NL80211_IFTYPE_P2P_DEVICE) |
   677					       BIT(NL80211_IFTYPE_NAN) |
   678					       BIT(NL80211_IFTYPE_AP_VLAN) |
   679					       BIT(NL80211_IFTYPE_MONITOR)))
   680			wiphy->regulatory_flags |= REGULATORY_IGNORE_STALE_KICKOFF;
   681	
   682		if (WARN_ON((wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
   683			    (wiphy->regulatory_flags &
   684						(REGULATORY_CUSTOM_REG |
   685						 REGULATORY_STRICT_REG |
   686						 REGULATORY_COUNTRY_IE_FOLLOW_POWER |
   687						 REGULATORY_COUNTRY_IE_IGNORE))))
   688			return -EINVAL;
   689	
   690		if (WARN_ON(wiphy->coalesce &&
   691			    (!wiphy->coalesce->n_rules ||
   692			     !wiphy->coalesce->n_patterns) &&
   693			    (!wiphy->coalesce->pattern_min_len ||
   694			     wiphy->coalesce->pattern_min_len >
   695				wiphy->coalesce->pattern_max_len)))
   696			return -EINVAL;
   697	
   698		if (WARN_ON(wiphy->ap_sme_capa &&
   699			    !(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME)))
   700			return -EINVAL;
   701	
   702		if (WARN_ON(wiphy->addresses && !wiphy->n_addresses))
   703			return -EINVAL;
   704	
   705		if (WARN_ON(wiphy->addresses &&
   706			    !is_zero_ether_addr(wiphy->perm_addr) &&
   707			    memcmp(wiphy->perm_addr, wiphy->addresses[0].addr,
   708				   ETH_ALEN)))
   709			return -EINVAL;
   710	
   711		if (WARN_ON(wiphy->max_acl_mac_addrs &&
   712			    (!(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME) ||
   713			     !rdev->ops->set_mac_acl)))
   714			return -EINVAL;
   715	
   716		/* assure only valid behaviours are flagged by driver
   717		 * hence subtract 2 as bit 0 is invalid.
   718		 */
   719		if (WARN_ON(wiphy->bss_select_support &&
   720			    (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
   721			return -EINVAL;
   722	
   723		if (WARN_ON(wiphy_ext_feature_isset(&rdev->wiphy,
   724						    NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
   725			    (!rdev->ops->set_pmk || !rdev->ops->del_pmk)))
   726			return -EINVAL;
   727	
   728		if (WARN_ON(!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_FW_ROAM) &&
   729			    rdev->ops->update_connect_params))
   730			return -EINVAL;
   731	
   732		if (wiphy->addresses)
   733			memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
   734	
   735		/* sanity check ifmodes */
   736		WARN_ON(!ifmodes);
   737		ifmodes &= ((1 << NUM_NL80211_IFTYPES) - 1) & ~1;
   738		if (WARN_ON(ifmodes != wiphy->interface_modes))
   739			wiphy->interface_modes = ifmodes;
   740	
   741		res = wiphy_verify_combinations(wiphy);
   742		if (res)
   743			return res;
   744	
   745		/* sanity check supported bands/channels */
   746		for (band = 0; band < NUM_NL80211_BANDS; band++) {
   747			u16 types = 0;
   748	
   749			sband = wiphy->bands[band];
   750			if (!sband)
   751				continue;
   752	
   753			sband->band = band;
   754			if (WARN_ON(!sband->n_channels))
   755				return -EINVAL;
   756			/*
   757			 * on 60GHz band, there are no legacy rates, so
   758			 * n_bitrates is 0
   759			 */
   760			if (WARN_ON(band != NL80211_BAND_60GHZ &&
   761				    !sband->n_bitrates))
   762				return -EINVAL;
   763	
   764			/*
   765			 * Since cfg80211_disable_40mhz_24ghz is global, we can
   766			 * modify the sband's ht data even if the driver uses a
   767			 * global structure for that.
   768			 */
   769			if (cfg80211_disable_40mhz_24ghz &&
   770			    band == NL80211_BAND_2GHZ &&
   771			    sband->ht_cap.ht_supported) {
   772				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
   773				sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
   774			}
   775	
   776			/*
   777			 * Since we use a u32 for rate bitmaps in
   778			 * ieee80211_get_response_rate, we cannot
   779			 * have more than 32 legacy rates.
   780			 */
   781			if (WARN_ON(sband->n_bitrates > 32))
   782				return -EINVAL;
   783	
   784			for (i = 0; i < sband->n_channels; i++) {
   785				sband->channels[i].orig_flags =
   786					sband->channels[i].flags;
   787				sband->channels[i].orig_mag = INT_MAX;
   788				sband->channels[i].orig_mpwr =
   789					sband->channels[i].max_power;
   790				sband->channels[i].band = band;
   791			}
   792	
   793			for (i = 0; i < sband->n_iftype_data; i++) {
   794				const struct ieee80211_sband_iftype_data *iftd;
   795	
   796				iftd = &sband->iftype_data[i];
   797	
 > 798				if (WARN_ON(!iftd->types))
   799					return -EINVAL;
   800				if (WARN_ON(types & iftd->types))
   801					return -EINVAL;
   802	
   803				/* at least one piece of information must be present */
   804				if (WARN_ON(!iftd->he_cap.has_he))
   805					return -EINVAL;
   806	
   807				types |= iftd->types;
   808			}
   809	
   810			have_band = true;
   811		}
   812	
   813		if (!have_band) {
   814			WARN_ON(1);
   815			return -EINVAL;
   816		}
   817	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--AqsLC8rIMeq19msA
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
+AEA

--AqsLC8rIMeq19msA--
