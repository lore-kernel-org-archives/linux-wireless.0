Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:47487 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933214AbeE0Jsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 May 2018 05:48:41 -0400
Date: Sun, 27 May 2018 17:48:17 +0800
From: kbuild test robot <lkp@intel.com>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: Re: [PATCH 1/2] cfg80211: last ack singal support in station dump
Message-ID: <201805271659.xmioz6RW%fengguang.wu@intel.com> (sfid-20180527_114926_579329_480C2E12)
References: <1527240005-8508-2-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <1527240005-8508-2-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Balaji,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on mac80211-next/master]
[cannot apply to v4.17-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Balaji-Pothunoori/cfg80211-mac80211-last-ack-singal-support-in-station-dump/20180527-162750
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
config: x86_64-randconfig-x000-201821 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

Note: the linux-review/Balaji-Pothunoori/cfg80211-mac80211-last-ack-singal-support-in-station-dump/20180527-162750 HEAD 7d4f99704af356d198be9638b571119647e26397 builds fine.
      It only hurts bisectibility.

All errors (new ones prefixed by >>):

   In file included from include/linux/kernel.h:11:0,
                    from include/linux/list.h:9,
                    from include/linux/module.h:9,
                    from net//mac80211/sta_info.c:13:
   net//mac80211/sta_info.c: In function 'sta_set_sinfo':
>> net//mac80211/sta_info.c:2314:32: error: 'NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG' undeclared (first use in this function); did you mean 'NL80211_STA_INFO_ACK_SIGNAL_AVG'?
         !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
                                   ^
   include/linux/bitops.h:8:32: note: in definition of macro 'BIT_ULL'
    #define BIT_ULL(nr)  (1ULL << (nr))
                                   ^~
   net//mac80211/sta_info.c:2314:32: note: each undeclared identifier is reported only once for each function it appears in
         !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
                                   ^
   include/linux/bitops.h:8:32: note: in definition of macro 'BIT_ULL'
    #define BIT_ULL(nr)  (1ULL << (nr))
                                   ^~

vim +2314 net//mac80211/sta_info.c

c9c5962b5 Johannes Berg            2016-03-31  2081  
0fdf1493b Johannes Berg            2018-05-18  2082  void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
0fdf1493b Johannes Berg            2018-05-18  2083  		   bool tidstats)
b7ffbd7ef Johannes Berg            2014-06-04  2084  {
b7ffbd7ef Johannes Berg            2014-06-04  2085  	struct ieee80211_sub_if_data *sdata = sta->sdata;
b7ffbd7ef Johannes Berg            2014-06-04  2086  	struct ieee80211_local *local = sdata->local;
b7ffbd7ef Johannes Berg            2014-06-04  2087  	u32 thr = 0;
c9c5962b5 Johannes Berg            2016-03-31  2088  	int i, ac, cpu;
c9c5962b5 Johannes Berg            2016-03-31  2089  	struct ieee80211_sta_rx_stats *last_rxstats;
c9c5962b5 Johannes Berg            2016-03-31  2090  
c9c5962b5 Johannes Berg            2016-03-31  2091  	last_rxstats = sta_get_last_rx_stats(sta);
b7ffbd7ef Johannes Berg            2014-06-04  2092  
b7ffbd7ef Johannes Berg            2014-06-04  2093  	sinfo->generation = sdata->local->sta_generation;
b7ffbd7ef Johannes Berg            2014-06-04  2094  
225b81898 Johannes Berg            2015-01-21  2095  	/* do before driver, so beacon filtering drivers have a
225b81898 Johannes Berg            2015-01-21  2096  	 * chance to e.g. just add the number of filtered beacons
225b81898 Johannes Berg            2015-01-21  2097  	 * (or just modify the value entirely, of course)
225b81898 Johannes Berg            2015-01-21  2098  	 */
225b81898 Johannes Berg            2015-01-21  2099  	if (sdata->vif.type == NL80211_IFTYPE_STATION)
225b81898 Johannes Berg            2015-01-21  2100  		sinfo->rx_beacon = sdata->u.mgd.count_beacon_signal;
225b81898 Johannes Berg            2015-01-21  2101  
2b9a7e1ba Johannes Berg            2014-11-17  2102  	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
2b9a7e1ba Johannes Berg            2014-11-17  2103  
319090bf6 Johannes Berg            2014-11-17  2104  	sinfo->filled |= BIT(NL80211_STA_INFO_INACTIVE_TIME) |
319090bf6 Johannes Berg            2014-11-17  2105  			 BIT(NL80211_STA_INFO_STA_FLAGS) |
319090bf6 Johannes Berg            2014-11-17  2106  			 BIT(NL80211_STA_INFO_BSS_PARAM) |
319090bf6 Johannes Berg            2014-11-17  2107  			 BIT(NL80211_STA_INFO_CONNECTED_TIME) |
976bd9efd Johannes Berg            2015-10-16  2108  			 BIT(NL80211_STA_INFO_RX_DROP_MISC);
976bd9efd Johannes Berg            2015-10-16  2109  
976bd9efd Johannes Berg            2015-10-16  2110  	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
976bd9efd Johannes Berg            2015-10-16  2111  		sinfo->beacon_loss_count = sdata->u.mgd.beacon_loss_count;
976bd9efd Johannes Berg            2015-10-16  2112  		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_LOSS);
976bd9efd Johannes Berg            2015-10-16  2113  	}
b7ffbd7ef Johannes Berg            2014-06-04  2114  
84b00607a Arnd Bergmann            2015-09-30  2115  	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
e5a9f8d04 Johannes Berg            2015-10-16  2116  	sinfo->inactive_time =
b8da6b6a9 Johannes Berg            2016-03-31  2117  		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
2b9a7e1ba Johannes Berg            2014-11-17  2118  
319090bf6 Johannes Berg            2014-11-17  2119  	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
319090bf6 Johannes Berg            2014-11-17  2120  			       BIT(NL80211_STA_INFO_TX_BYTES)))) {
b7ffbd7ef Johannes Berg            2014-06-04  2121  		sinfo->tx_bytes = 0;
2b9a7e1ba Johannes Berg            2014-11-17  2122  		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
e5a9f8d04 Johannes Berg            2015-10-16  2123  			sinfo->tx_bytes += sta->tx_stats.bytes[ac];
319090bf6 Johannes Berg            2014-11-17  2124  		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BYTES64);
b7ffbd7ef Johannes Berg            2014-06-04  2125  	}
2b9a7e1ba Johannes Berg            2014-11-17  2126  
319090bf6 Johannes Berg            2014-11-17  2127  	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_PACKETS))) {
2b9a7e1ba Johannes Berg            2014-11-17  2128  		sinfo->tx_packets = 0;
2b9a7e1ba Johannes Berg            2014-11-17  2129  		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
e5a9f8d04 Johannes Berg            2015-10-16  2130  			sinfo->tx_packets += sta->tx_stats.packets[ac];
319090bf6 Johannes Berg            2014-11-17  2131  		sinfo->filled |= BIT(NL80211_STA_INFO_TX_PACKETS);
2b9a7e1ba Johannes Berg            2014-11-17  2132  	}
2b9a7e1ba Johannes Berg            2014-11-17  2133  
319090bf6 Johannes Berg            2014-11-17  2134  	if (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
319090bf6 Johannes Berg            2014-11-17  2135  			       BIT(NL80211_STA_INFO_RX_BYTES)))) {
c9c5962b5 Johannes Berg            2016-03-31  2136  		sinfo->rx_bytes += sta_get_stats_bytes(&sta->rx_stats);
c9c5962b5 Johannes Berg            2016-03-31  2137  
c9c5962b5 Johannes Berg            2016-03-31  2138  		if (sta->pcpu_rx_stats) {
c9c5962b5 Johannes Berg            2016-03-31  2139  			for_each_possible_cpu(cpu) {
c9c5962b5 Johannes Berg            2016-03-31  2140  				struct ieee80211_sta_rx_stats *cpurxs;
c9c5962b5 Johannes Berg            2016-03-31  2141  
c9c5962b5 Johannes Berg            2016-03-31  2142  				cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
c9c5962b5 Johannes Berg            2016-03-31  2143  				sinfo->rx_bytes += sta_get_stats_bytes(cpurxs);
c9c5962b5 Johannes Berg            2016-03-31  2144  			}
c9c5962b5 Johannes Berg            2016-03-31  2145  		}
0f9c5a61d Johannes Berg            2016-03-31  2146  
319090bf6 Johannes Berg            2014-11-17  2147  		sinfo->filled |= BIT(NL80211_STA_INFO_RX_BYTES64);
2b9a7e1ba Johannes Berg            2014-11-17  2148  	}
2b9a7e1ba Johannes Berg            2014-11-17  2149  
319090bf6 Johannes Berg            2014-11-17  2150  	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_PACKETS))) {
e5a9f8d04 Johannes Berg            2015-10-16  2151  		sinfo->rx_packets = sta->rx_stats.packets;
c9c5962b5 Johannes Berg            2016-03-31  2152  		if (sta->pcpu_rx_stats) {
c9c5962b5 Johannes Berg            2016-03-31  2153  			for_each_possible_cpu(cpu) {
c9c5962b5 Johannes Berg            2016-03-31  2154  				struct ieee80211_sta_rx_stats *cpurxs;
c9c5962b5 Johannes Berg            2016-03-31  2155  
c9c5962b5 Johannes Berg            2016-03-31  2156  				cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
c9c5962b5 Johannes Berg            2016-03-31  2157  				sinfo->rx_packets += cpurxs->packets;
c9c5962b5 Johannes Berg            2016-03-31  2158  			}
c9c5962b5 Johannes Berg            2016-03-31  2159  		}
319090bf6 Johannes Berg            2014-11-17  2160  		sinfo->filled |= BIT(NL80211_STA_INFO_RX_PACKETS);
2b9a7e1ba Johannes Berg            2014-11-17  2161  	}
2b9a7e1ba Johannes Berg            2014-11-17  2162  
319090bf6 Johannes Berg            2014-11-17  2163  	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_RETRIES))) {
e5a9f8d04 Johannes Berg            2015-10-16  2164  		sinfo->tx_retries = sta->status_stats.retry_count;
319090bf6 Johannes Berg            2014-11-17  2165  		sinfo->filled |= BIT(NL80211_STA_INFO_TX_RETRIES);
2b9a7e1ba Johannes Berg            2014-11-17  2166  	}
2b9a7e1ba Johannes Berg            2014-11-17  2167  
319090bf6 Johannes Berg            2014-11-17  2168  	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_FAILED))) {
e5a9f8d04 Johannes Berg            2015-10-16  2169  		sinfo->tx_failed = sta->status_stats.retry_failed;
319090bf6 Johannes Berg            2014-11-17  2170  		sinfo->filled |= BIT(NL80211_STA_INFO_TX_FAILED);
2b9a7e1ba Johannes Berg            2014-11-17  2171  	}
2b9a7e1ba Johannes Berg            2014-11-17  2172  
e5a9f8d04 Johannes Berg            2015-10-16  2173  	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
c9c5962b5 Johannes Berg            2016-03-31  2174  	if (sta->pcpu_rx_stats) {
c9c5962b5 Johannes Berg            2016-03-31  2175  		for_each_possible_cpu(cpu) {
c9c5962b5 Johannes Berg            2016-03-31  2176  			struct ieee80211_sta_rx_stats *cpurxs;
c9c5962b5 Johannes Berg            2016-03-31  2177  
c9c5962b5 Johannes Berg            2016-03-31  2178  			cpurxs = per_cpu_ptr(sta->pcpu_rx_stats, cpu);
e165bc02a Johannes Berg            2017-06-01  2179  			sinfo->rx_dropped_misc += cpurxs->dropped;
c9c5962b5 Johannes Berg            2016-03-31  2180  		}
c9c5962b5 Johannes Berg            2016-03-31  2181  	}
b7ffbd7ef Johannes Berg            2014-06-04  2182  
225b81898 Johannes Berg            2015-01-21  2183  	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
225b81898 Johannes Berg            2015-01-21  2184  	    !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
225b81898 Johannes Berg            2015-01-21  2185  		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX) |
225b81898 Johannes Berg            2015-01-21  2186  				 BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
225b81898 Johannes Berg            2015-01-21  2187  		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
225b81898 Johannes Berg            2015-01-21  2188  	}
225b81898 Johannes Berg            2015-01-21  2189  
30686bf7f Johannes Berg            2015-06-02  2190  	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
30686bf7f Johannes Berg            2015-06-02  2191  	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
319090bf6 Johannes Berg            2014-11-17  2192  		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
c9c5962b5 Johannes Berg            2016-03-31  2193  			sinfo->signal = (s8)last_rxstats->last_signal;
319090bf6 Johannes Berg            2014-11-17  2194  			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
2b9a7e1ba Johannes Berg            2014-11-17  2195  		}
2b9a7e1ba Johannes Berg            2014-11-17  2196  
c9c5962b5 Johannes Berg            2016-03-31  2197  		if (!sta->pcpu_rx_stats &&
c9c5962b5 Johannes Berg            2016-03-31  2198  		    !(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
40d9a38ad Johannes Berg            2015-07-13  2199  			sinfo->signal_avg =
0be6ed133 Johannes Berg            2016-03-31  2200  				-ewma_signal_read(&sta->rx_stats_avg.signal);
319090bf6 Johannes Berg            2014-11-17  2201  			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
b7ffbd7ef Johannes Berg            2014-06-04  2202  		}
2b9a7e1ba Johannes Berg            2014-11-17  2203  	}
2b9a7e1ba Johannes Berg            2014-11-17  2204  
c9c5962b5 Johannes Berg            2016-03-31  2205  	/* for the average - if pcpu_rx_stats isn't set - rxstats must point to
c9c5962b5 Johannes Berg            2016-03-31  2206  	 * the sta->rx_stats struct, so the check here is fine with and without
c9c5962b5 Johannes Berg            2016-03-31  2207  	 * pcpu statistics
c9c5962b5 Johannes Berg            2016-03-31  2208  	 */
c9c5962b5 Johannes Berg            2016-03-31  2209  	if (last_rxstats->chains &&
319090bf6 Johannes Berg            2014-11-17  2210  	    !(sinfo->filled & (BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
319090bf6 Johannes Berg            2014-11-17  2211  			       BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
c9c5962b5 Johannes Berg            2016-03-31  2212  		sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
c9c5962b5 Johannes Berg            2016-03-31  2213  		if (!sta->pcpu_rx_stats)
c9c5962b5 Johannes Berg            2016-03-31  2214  			sinfo->filled |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
c9c5962b5 Johannes Berg            2016-03-31  2215  
c9c5962b5 Johannes Berg            2016-03-31  2216  		sinfo->chains = last_rxstats->chains;
b7ffbd7ef Johannes Berg            2014-06-04  2217  
b7ffbd7ef Johannes Berg            2014-06-04  2218  		for (i = 0; i < ARRAY_SIZE(sinfo->chain_signal); i++) {
e5a9f8d04 Johannes Berg            2015-10-16  2219  			sinfo->chain_signal[i] =
c9c5962b5 Johannes Berg            2016-03-31  2220  				last_rxstats->chain_signal_last[i];
b7ffbd7ef Johannes Berg            2014-06-04  2221  			sinfo->chain_signal_avg[i] =
0be6ed133 Johannes Berg            2016-03-31  2222  				-ewma_signal_read(&sta->rx_stats_avg.chain_signal[i]);
b7ffbd7ef Johannes Berg            2014-06-04  2223  		}
b7ffbd7ef Johannes Berg            2014-06-04  2224  	}
b7ffbd7ef Johannes Berg            2014-06-04  2225  
319090bf6 Johannes Berg            2014-11-17  2226  	if (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE))) {
e5a9f8d04 Johannes Berg            2015-10-16  2227  		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate,
e5a9f8d04 Johannes Berg            2015-10-16  2228  				     &sinfo->txrate);
319090bf6 Johannes Berg            2014-11-17  2229  		sinfo->filled |= BIT(NL80211_STA_INFO_TX_BITRATE);
2b9a7e1ba Johannes Berg            2014-11-17  2230  	}
2b9a7e1ba Johannes Berg            2014-11-17  2231  
319090bf6 Johannes Berg            2014-11-17  2232  	if (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE))) {
a17d93ff3 Ben Greear               2016-12-14  2233  		if (sta_set_rate_info_rx(sta, &sinfo->rxrate) == 0)
319090bf6 Johannes Berg            2014-11-17  2234  			sinfo->filled |= BIT(NL80211_STA_INFO_RX_BITRATE);
2b9a7e1ba Johannes Berg            2014-11-17  2235  	}
b7ffbd7ef Johannes Berg            2014-06-04  2236  
0fdf1493b Johannes Berg            2018-05-18  2237  	if (tidstats && !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
79c892b85 Johannes Berg            2014-11-21  2238  		for (i = 0; i < IEEE80211_NUM_TIDS + 1; i++) {
79c892b85 Johannes Berg            2014-11-21  2239  			struct cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
79c892b85 Johannes Berg            2014-11-21  2240  
0f9c5a61d Johannes Berg            2016-03-31  2241  			sta_set_tidstats(sta, tidstats, i);
79c892b85 Johannes Berg            2014-11-21  2242  		}
8689c051a Arend van Spriel         2018-05-10  2243  	}
79c892b85 Johannes Berg            2014-11-21  2244  
b7ffbd7ef Johannes Berg            2014-06-04  2245  	if (ieee80211_vif_is_mesh(&sdata->vif)) {
b7ffbd7ef Johannes Berg            2014-06-04  2246  #ifdef CONFIG_MAC80211_MESH
319090bf6 Johannes Berg            2014-11-17  2247  		sinfo->filled |= BIT(NL80211_STA_INFO_LLID) |
319090bf6 Johannes Berg            2014-11-17  2248  				 BIT(NL80211_STA_INFO_PLID) |
319090bf6 Johannes Berg            2014-11-17  2249  				 BIT(NL80211_STA_INFO_PLINK_STATE) |
319090bf6 Johannes Berg            2014-11-17  2250  				 BIT(NL80211_STA_INFO_LOCAL_PM) |
319090bf6 Johannes Berg            2014-11-17  2251  				 BIT(NL80211_STA_INFO_PEER_PM) |
319090bf6 Johannes Berg            2014-11-17  2252  				 BIT(NL80211_STA_INFO_NONPEER_PM);
b7ffbd7ef Johannes Berg            2014-06-04  2253  
433f5bc1c Johannes Berg            2015-06-17  2254  		sinfo->llid = sta->mesh->llid;
433f5bc1c Johannes Berg            2015-06-17  2255  		sinfo->plid = sta->mesh->plid;
433f5bc1c Johannes Berg            2015-06-17  2256  		sinfo->plink_state = sta->mesh->plink_state;
b7ffbd7ef Johannes Berg            2014-06-04  2257  		if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
319090bf6 Johannes Berg            2014-11-17  2258  			sinfo->filled |= BIT(NL80211_STA_INFO_T_OFFSET);
433f5bc1c Johannes Berg            2015-06-17  2259  			sinfo->t_offset = sta->mesh->t_offset;
b7ffbd7ef Johannes Berg            2014-06-04  2260  		}
433f5bc1c Johannes Berg            2015-06-17  2261  		sinfo->local_pm = sta->mesh->local_pm;
433f5bc1c Johannes Berg            2015-06-17  2262  		sinfo->peer_pm = sta->mesh->peer_pm;
433f5bc1c Johannes Berg            2015-06-17  2263  		sinfo->nonpeer_pm = sta->mesh->nonpeer_pm;
b7ffbd7ef Johannes Berg            2014-06-04  2264  #endif
b7ffbd7ef Johannes Berg            2014-06-04  2265  	}
b7ffbd7ef Johannes Berg            2014-06-04  2266  
b7ffbd7ef Johannes Berg            2014-06-04  2267  	sinfo->bss_param.flags = 0;
b7ffbd7ef Johannes Berg            2014-06-04  2268  	if (sdata->vif.bss_conf.use_cts_prot)
b7ffbd7ef Johannes Berg            2014-06-04  2269  		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
b7ffbd7ef Johannes Berg            2014-06-04  2270  	if (sdata->vif.bss_conf.use_short_preamble)
b7ffbd7ef Johannes Berg            2014-06-04  2271  		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
b7ffbd7ef Johannes Berg            2014-06-04  2272  	if (sdata->vif.bss_conf.use_short_slot)
b7ffbd7ef Johannes Berg            2014-06-04  2273  		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
785e21a89 Emmanuel Grumbach        2014-09-03  2274  	sinfo->bss_param.dtim_period = sdata->vif.bss_conf.dtim_period;
b7ffbd7ef Johannes Berg            2014-06-04  2275  	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
b7ffbd7ef Johannes Berg            2014-06-04  2276  
b7ffbd7ef Johannes Berg            2014-06-04  2277  	sinfo->sta_flags.set = 0;
b7ffbd7ef Johannes Berg            2014-06-04  2278  	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
b7ffbd7ef Johannes Berg            2014-06-04  2279  				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
b7ffbd7ef Johannes Berg            2014-06-04  2280  				BIT(NL80211_STA_FLAG_WME) |
b7ffbd7ef Johannes Berg            2014-06-04  2281  				BIT(NL80211_STA_FLAG_MFP) |
b7ffbd7ef Johannes Berg            2014-06-04  2282  				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
b7ffbd7ef Johannes Berg            2014-06-04  2283  				BIT(NL80211_STA_FLAG_ASSOCIATED) |
b7ffbd7ef Johannes Berg            2014-06-04  2284  				BIT(NL80211_STA_FLAG_TDLS_PEER);
b7ffbd7ef Johannes Berg            2014-06-04  2285  	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
b7ffbd7ef Johannes Berg            2014-06-04  2286  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
b7ffbd7ef Johannes Berg            2014-06-04  2287  	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
b7ffbd7ef Johannes Berg            2014-06-04  2288  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
a74a8c846 Johannes Berg            2014-07-22  2289  	if (sta->sta.wme)
b7ffbd7ef Johannes Berg            2014-06-04  2290  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
b7ffbd7ef Johannes Berg            2014-06-04  2291  	if (test_sta_flag(sta, WLAN_STA_MFP))
b7ffbd7ef Johannes Berg            2014-06-04  2292  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
b7ffbd7ef Johannes Berg            2014-06-04  2293  	if (test_sta_flag(sta, WLAN_STA_AUTH))
b7ffbd7ef Johannes Berg            2014-06-04  2294  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
b7ffbd7ef Johannes Berg            2014-06-04  2295  	if (test_sta_flag(sta, WLAN_STA_ASSOC))
b7ffbd7ef Johannes Berg            2014-06-04  2296  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
b7ffbd7ef Johannes Berg            2014-06-04  2297  	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
b7ffbd7ef Johannes Berg            2014-06-04  2298  		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
b7ffbd7ef Johannes Berg            2014-06-04  2299  
3b17fbf87 Maxim Altshul            2016-07-11  2300  	thr = sta_get_expected_throughput(sta);
3b17fbf87 Maxim Altshul            2016-07-11  2301  
3b17fbf87 Maxim Altshul            2016-07-11  2302  	if (thr != 0) {
3b17fbf87 Maxim Altshul            2016-07-11  2303  		sinfo->filled |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
3b17fbf87 Maxim Altshul            2016-07-11  2304  		sinfo->expected_throughput = thr;
3b17fbf87 Maxim Altshul            2016-07-11  2305  	}
a78b26fff Venkateswara Naralasetty 2018-02-13  2306  
a78b26fff Venkateswara Naralasetty 2018-02-13  2307  	if (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) &&
a78b26fff Venkateswara Naralasetty 2018-02-13  2308  	    sta->status_stats.ack_signal_filled) {
a78b26fff Venkateswara Naralasetty 2018-02-13  2309  		sinfo->ack_signal = sta->status_stats.last_ack_signal;
a78b26fff Venkateswara Naralasetty 2018-02-13  2310  		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
a78b26fff Venkateswara Naralasetty 2018-02-13  2311  	}
cc60dbbfe Balaji Pothunoori        2018-04-16  2312  
cc60dbbfe Balaji Pothunoori        2018-04-16  2313  	if (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS) &&
cc60dbbfe Balaji Pothunoori        2018-04-16 @2314  	    !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
cc60dbbfe Balaji Pothunoori        2018-04-16  2315  		sinfo->avg_ack_signal =
cc60dbbfe Balaji Pothunoori        2018-04-16  2316  			-(s8)ewma_avg_signal_read(
cc60dbbfe Balaji Pothunoori        2018-04-16  2317  				&sta->status_stats.avg_ack_signal);
cc60dbbfe Balaji Pothunoori        2018-04-16  2318  		sinfo->filled |=
cc60dbbfe Balaji Pothunoori        2018-04-16  2319  			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
cc60dbbfe Balaji Pothunoori        2018-04-16  2320  	}
3b17fbf87 Maxim Altshul            2016-07-11  2321  }
3b17fbf87 Maxim Altshul            2016-07-11  2322  

:::::: The code at line 2314 was first introduced by commit
:::::: cc60dbbfed8ff0bd4c530ee48e9e915333a35470 mac80211: average ack rssi support for data frames

:::::: TO: Balaji Pothunoori <bpothuno@codeaurora.org>
:::::: CC: Johannes Berg <johannes.berg@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--UlVJffcvxoiEqYs2
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICERxClsAAy5jb25maWcAjFxLc+S2rt7nV3RNNucskvgVZ1K3vKAkqpvTenBIqh/eqBy7
Z+KK7Z5rt08y//4CpNQiKajPzWJiAeBDJAB+AKj+8YcfZ+z9sH++Ozze3z09fZ993b3sXu8O
u4fZl8en3f/MsnpW1WbGM2F+BuHi8eX9n1/++XjdXl/Nrn4+/+3ns59e769ny93ry+5plu5f
vjx+fYcOHvcvP/z4Q1pXuZiDbCLMzff+cWObB8/Dg6i0UU1qRF21GU/rjKuBWTdGNqbNa1Uy
c/Nh9/Tl+uonmM1P11cfehmm0gW0zN3jzYe71/s/cca/3NvJvXWzbx92Xxzl2LKo02XGZasb
KWvlTVgbli6NYikf88qyGR7s2GXJZKuqrIWX1m0pqpuLj6cE2Obm8oIWSOtSMjN0NNFPIAbd
nV/3chXnWZuVrEVReA3Dh8lanp5bdsGruVkMvDmvuBJpmzRzktgqXjAjVryVtagMV3ostlhz
MV94S6XWmpftJl3MWZa1rJjXSphFOW6ZskIkCiYL+1iwbbS+C6bbVDZ2ChuKx9IFbwtRwW6J
W05I5KKAKbdyLlXtzW/B4H00N41sJbBxDKY4i1asZ/EygadcKG3adNFUywk5yeacFnPzEQlX
FbP6LmutRVLEU9aNlhy2eYK9ZpVpFw2MIkvY0AXMmZKwi8sKK2mKZBC5rWGlQAkuL7xmDRi8
bTyai9V/3dbSiBKWNwOLhbUW1XxKMuOoMLgMrAATmxJrYDMS7ulRLjYtZ6rYwnNbck9P5Nww
WAfQ2hUv9M3V0Xeoz+26Vt4SJ40oMpgob/nGtdGB9ZoFbDC+Ql7DP61hGhuD5/pxNree8Gn2
tju8fxt8WaLqJa9amJIupe+2YL14tYKXAkcCK2M8o04V7Jy1UgG79+ED9N5zHK01XJvZ49vs
ZX/AAT2PxIoVWBdoB7YjyLBVpo50eAkaxYt2fiskzUmAc0GzituS0ZzN7VSLifGLW3Tyx3f1
ZuW/asy3czslgDMk1sqf5bhJfbrHK6JDOENYU4Bp1dpUrISN+9fL/mX3b2/79JpJoqXe6pWQ
nqZ3BPx/agpPkWsNSl5+bnjDaerQZNAZq01gELXatszA2bQg5tBoDk40suhon6wBWgaOAtYZ
idNUcCcm8AuWaBTnvemAHc7e3v94+/522D0PptO7dzRTa+xjz48svajXNCdd+AqNlKwuGZyL
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
lgz0BsP4P0ZtAxqusAEA

--UlVJffcvxoiEqYs2--
