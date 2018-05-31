Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbeEaGM5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 May 2018 02:12:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 31 May 2018 11:42:55 +0530
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: last ack singal support in station dump
In-Reply-To: <201805271659.xmioz6RW%fengguang.wu@intel.com>
References: <1527240005-8508-2-git-send-email-bpothuno@codeaurora.org>
 <201805271659.xmioz6RW%fengguang.wu@intel.com>
Message-ID: <d4c3a4fa2621c621a32a1a2aea4e12e5@codeaurora.org> (sfid-20180531_081304_212047_A8BD168C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-05-27 15:18, kbuild test robot wrote:
> Hi Balaji,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on mac80211-next/master]
> [cannot apply to v4.17-rc6]
> [if your patch is applied to the wrong git tree, please drop us a note
> to help improve the system]
> 
> url:
> https://github.com/0day-ci/linux/commits/Balaji-Pothunoori/cfg80211-mac80211-last-ack-singal-support-in-station-dump/20180527-162750
> base:
> https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
> master
> config: x86_64-randconfig-x000-201821 (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
> 
> Note: the
> linux-review/Balaji-Pothunoori/cfg80211-mac80211-last-ack-singal-support-in-station-dump/20180527-162750
> HEAD 7d4f99704af356d198be9638b571119647e26397 builds fine.
>       It only hurts bisectibility.
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/kernel.h:11:0,
>                     from include/linux/list.h:9,
>                     from include/linux/module.h:9,
>                     from net//mac80211/sta_info.c:13:
>    net//mac80211/sta_info.c: In function 'sta_set_sinfo':
>>> net//mac80211/sta_info.c:2314:32: error: 
>>> 'NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG' undeclared (first use in this 
>>> function); did you mean 'NL80211_STA_INFO_ACK_SIGNAL_AVG'?

Yes, It is "NL80211_STA_INFO_ACK_SIGNAL_AVG" and i could see this patch 
is building on top of https://patchwork.kernel.org/patch/10343163/ which 
is incorrect.
This patch has to build with its subsequent patch 
https://patchwork.kernel.org/patch/10426699/


>          !(sinfo->filled & 
> BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
>                                    ^
>    include/linux/bitops.h:8:32: note: in definition of macro 'BIT_ULL'
>     #define BIT_ULL(nr)  (1ULL << (nr))
>                                    ^~
>    net//mac80211/sta_info.c:2314:32: note: each undeclared identifier
> is reported only once for each function it appears in
>          !(sinfo->filled & 
> BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
>                                    ^
>    include/linux/bitops.h:8:32: note: in definition of macro 'BIT_ULL'
>     #define BIT_ULL(nr)  (1ULL << (nr))
>                                    ^~
> 
> vim +2314 net//mac80211/sta_info.c
> 
> c9c5962b5 Johannes Berg            2016-03-31  2081
> 0fdf1493b Johannes Berg            2018-05-18  2082  void
> sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo,
> 0fdf1493b Johannes Berg            2018-05-18  2083  		   bool 
> tidstats)
> b7ffbd7ef Johannes Berg            2014-06-04  2084  {
> b7ffbd7ef Johannes Berg            2014-06-04  2085  	struct
> ieee80211_sub_if_data *sdata = sta->sdata;
> b7ffbd7ef Johannes Berg            2014-06-04  2086  	struct
> ieee80211_local *local = sdata->local;
> b7ffbd7ef Johannes Berg            2014-06-04  2087  	u32 thr = 0;
> c9c5962b5 Johannes Berg            2016-03-31  2088  	int i, ac, cpu;
> c9c5962b5 Johannes Berg            2016-03-31  2089  	struct
> ieee80211_sta_rx_stats *last_rxstats;
> c9c5962b5 Johannes Berg            2016-03-31  2090
> c9c5962b5 Johannes Berg            2016-03-31  2091  	last_rxstats =
> sta_get_last_rx_stats(sta);
> b7ffbd7ef Johannes Berg            2014-06-04  2092
> b7ffbd7ef Johannes Berg            2014-06-04  2093
> 	sinfo->generation = sdata->local->sta_generation;
> b7ffbd7ef Johannes Berg            2014-06-04  2094
> 225b81898 Johannes Berg            2015-01-21  2095  	/* do before
> driver, so beacon filtering drivers have a
> 225b81898 Johannes Berg            2015-01-21  2096  	 * chance to
> e.g. just add the number of filtered beacons
> 225b81898 Johannes Berg            2015-01-21  2097  	 * (or just
> modify the value entirely, of course)
> 225b81898 Johannes Berg            2015-01-21  2098  	 */
> 225b81898 Johannes Berg            2015-01-21  2099  	if
> (sdata->vif.type == NL80211_IFTYPE_STATION)
> 225b81898 Johannes Berg            2015-01-21  2100
> 		sinfo->rx_beacon = sdata->u.mgd.count_beacon_signal;
> 225b81898 Johannes Berg            2015-01-21  2101
> 2b9a7e1ba Johannes Berg            2014-11-17  2102
> 	drv_sta_statistics(local, sdata, &sta->sta, sinfo);
> 2b9a7e1ba Johannes Berg            2014-11-17  2103
> 319090bf6 Johannes Berg            2014-11-17  2104  	sinfo->filled |=
> BIT(NL80211_STA_INFO_INACTIVE_TIME) |
> 319090bf6 Johannes Berg            2014-11-17  2105  			
> BIT(NL80211_STA_INFO_STA_FLAGS) |
> 319090bf6 Johannes Berg            2014-11-17  2106  			
> BIT(NL80211_STA_INFO_BSS_PARAM) |
> 319090bf6 Johannes Berg            2014-11-17  2107  			
> BIT(NL80211_STA_INFO_CONNECTED_TIME) |
> 976bd9efd Johannes Berg            2015-10-16  2108  			
> BIT(NL80211_STA_INFO_RX_DROP_MISC);
> 976bd9efd Johannes Berg            2015-10-16  2109
> 976bd9efd Johannes Berg            2015-10-16  2110  	if
> (sdata->vif.type == NL80211_IFTYPE_STATION) {
> 976bd9efd Johannes Berg            2015-10-16  2111
> 		sinfo->beacon_loss_count = sdata->u.mgd.beacon_loss_count;
> 976bd9efd Johannes Berg            2015-10-16  2112  		sinfo->filled
> |= BIT(NL80211_STA_INFO_BEACON_LOSS);
> 976bd9efd Johannes Berg            2015-10-16  2113  	}
> b7ffbd7ef Johannes Berg            2014-06-04  2114
> 84b00607a Arnd Bergmann            2015-09-30  2115
> 	sinfo->connected_time = ktime_get_seconds() - sta->last_connected;
> e5a9f8d04 Johannes Berg            2015-10-16  2116  
> 	sinfo->inactive_time =
> b8da6b6a9 Johannes Berg            2016-03-31  2117
> 		jiffies_to_msecs(jiffies - ieee80211_sta_last_active(sta));
> 2b9a7e1ba Johannes Berg            2014-11-17  2118
> 319090bf6 Johannes Berg            2014-11-17  2119  	if
> (!(sinfo->filled & (BIT(NL80211_STA_INFO_TX_BYTES64) |
> 319090bf6 Johannes Berg            2014-11-17  2120  			
> BIT(NL80211_STA_INFO_TX_BYTES)))) {
> b7ffbd7ef Johannes Berg            2014-06-04  2121  		sinfo->tx_bytes 
> = 0;
> 2b9a7e1ba Johannes Berg            2014-11-17  2122  		for (ac = 0; ac
> < IEEE80211_NUM_ACS; ac++)
> e5a9f8d04 Johannes Berg            2015-10-16  2123
> 			sinfo->tx_bytes += sta->tx_stats.bytes[ac];
> 319090bf6 Johannes Berg            2014-11-17  2124  		sinfo->filled
> |= BIT(NL80211_STA_INFO_TX_BYTES64);
> b7ffbd7ef Johannes Berg            2014-06-04  2125  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2126
> 319090bf6 Johannes Berg            2014-11-17  2127  	if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_PACKETS))) {
> 2b9a7e1ba Johannes Berg            2014-11-17  2128  
> 		sinfo->tx_packets = 0;
> 2b9a7e1ba Johannes Berg            2014-11-17  2129  		for (ac = 0; ac
> < IEEE80211_NUM_ACS; ac++)
> e5a9f8d04 Johannes Berg            2015-10-16  2130
> 			sinfo->tx_packets += sta->tx_stats.packets[ac];
> 319090bf6 Johannes Berg            2014-11-17  2131  		sinfo->filled
> |= BIT(NL80211_STA_INFO_TX_PACKETS);
> 2b9a7e1ba Johannes Berg            2014-11-17  2132  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2133
> 319090bf6 Johannes Berg            2014-11-17  2134  	if
> (!(sinfo->filled & (BIT(NL80211_STA_INFO_RX_BYTES64) |
> 319090bf6 Johannes Berg            2014-11-17  2135  			
> BIT(NL80211_STA_INFO_RX_BYTES)))) {
> c9c5962b5 Johannes Berg            2016-03-31  2136  		sinfo->rx_bytes
> += sta_get_stats_bytes(&sta->rx_stats);
> c9c5962b5 Johannes Berg            2016-03-31  2137
> c9c5962b5 Johannes Berg            2016-03-31  2138  		if 
> (sta->pcpu_rx_stats) {
> c9c5962b5 Johannes Berg            2016-03-31  2139
> 			for_each_possible_cpu(cpu) {
> c9c5962b5 Johannes Berg            2016-03-31  2140  				struct
> ieee80211_sta_rx_stats *cpurxs;
> c9c5962b5 Johannes Berg            2016-03-31  2141
> c9c5962b5 Johannes Berg            2016-03-31  2142  				cpurxs =
> per_cpu_ptr(sta->pcpu_rx_stats, cpu);
> c9c5962b5 Johannes Berg            2016-03-31  2143
> 				sinfo->rx_bytes += sta_get_stats_bytes(cpurxs);
> c9c5962b5 Johannes Berg            2016-03-31  2144  			}
> c9c5962b5 Johannes Berg            2016-03-31  2145  		}
> 0f9c5a61d Johannes Berg            2016-03-31  2146
> 319090bf6 Johannes Berg            2014-11-17  2147  		sinfo->filled
> |= BIT(NL80211_STA_INFO_RX_BYTES64);
> 2b9a7e1ba Johannes Berg            2014-11-17  2148  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2149
> 319090bf6 Johannes Berg            2014-11-17  2150  	if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_PACKETS))) {
> e5a9f8d04 Johannes Berg            2015-10-16  2151
> 		sinfo->rx_packets = sta->rx_stats.packets;
> c9c5962b5 Johannes Berg            2016-03-31  2152  		if 
> (sta->pcpu_rx_stats) {
> c9c5962b5 Johannes Berg            2016-03-31  2153
> 			for_each_possible_cpu(cpu) {
> c9c5962b5 Johannes Berg            2016-03-31  2154  				struct
> ieee80211_sta_rx_stats *cpurxs;
> c9c5962b5 Johannes Berg            2016-03-31  2155
> c9c5962b5 Johannes Berg            2016-03-31  2156  				cpurxs =
> per_cpu_ptr(sta->pcpu_rx_stats, cpu);
> c9c5962b5 Johannes Berg            2016-03-31  2157
> 				sinfo->rx_packets += cpurxs->packets;
> c9c5962b5 Johannes Berg            2016-03-31  2158  			}
> c9c5962b5 Johannes Berg            2016-03-31  2159  		}
> 319090bf6 Johannes Berg            2014-11-17  2160  		sinfo->filled
> |= BIT(NL80211_STA_INFO_RX_PACKETS);
> 2b9a7e1ba Johannes Berg            2014-11-17  2161  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2162
> 319090bf6 Johannes Berg            2014-11-17  2163  	if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_RETRIES))) {
> e5a9f8d04 Johannes Berg            2015-10-16  2164
> 		sinfo->tx_retries = sta->status_stats.retry_count;
> 319090bf6 Johannes Berg            2014-11-17  2165  		sinfo->filled
> |= BIT(NL80211_STA_INFO_TX_RETRIES);
> 2b9a7e1ba Johannes Berg            2014-11-17  2166  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2167
> 319090bf6 Johannes Berg            2014-11-17  2168  	if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_FAILED))) {
> e5a9f8d04 Johannes Berg            2015-10-16  2169
> 		sinfo->tx_failed = sta->status_stats.retry_failed;
> 319090bf6 Johannes Berg            2014-11-17  2170  		sinfo->filled
> |= BIT(NL80211_STA_INFO_TX_FAILED);
> 2b9a7e1ba Johannes Berg            2014-11-17  2171  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2172
> e5a9f8d04 Johannes Berg            2015-10-16  2173
> 	sinfo->rx_dropped_misc = sta->rx_stats.dropped;
> c9c5962b5 Johannes Berg            2016-03-31  2174  	if 
> (sta->pcpu_rx_stats) {
> c9c5962b5 Johannes Berg            2016-03-31  2175
> 		for_each_possible_cpu(cpu) {
> c9c5962b5 Johannes Berg            2016-03-31  2176  			struct
> ieee80211_sta_rx_stats *cpurxs;
> c9c5962b5 Johannes Berg            2016-03-31  2177
> c9c5962b5 Johannes Berg            2016-03-31  2178  			cpurxs =
> per_cpu_ptr(sta->pcpu_rx_stats, cpu);
> e165bc02a Johannes Berg            2017-06-01  2179
> 			sinfo->rx_dropped_misc += cpurxs->dropped;
> c9c5962b5 Johannes Berg            2016-03-31  2180  		}
> c9c5962b5 Johannes Berg            2016-03-31  2181  	}
> b7ffbd7ef Johannes Berg            2014-06-04  2182
> 225b81898 Johannes Berg            2015-01-21  2183  	if
> (sdata->vif.type == NL80211_IFTYPE_STATION &&
> 225b81898 Johannes Berg            2015-01-21  2184  	
> !(sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)) {
> 225b81898 Johannes Berg            2015-01-21  2185  		sinfo->filled
> |= BIT(NL80211_STA_INFO_BEACON_RX) |
> 225b81898 Johannes Berg            2015-01-21  2186  				
> BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
> 225b81898 Johannes Berg            2015-01-21  2187
> 		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
> 225b81898 Johannes Berg            2015-01-21  2188  	}
> 225b81898 Johannes Berg            2015-01-21  2189
> 30686bf7f Johannes Berg            2015-06-02  2190  	if
> (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
> 30686bf7f Johannes Berg            2015-06-02  2191  	
> ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
> 319090bf6 Johannes Berg            2014-11-17  2192  		if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
> c9c5962b5 Johannes Berg            2016-03-31  2193  			sinfo->signal
> = (s8)last_rxstats->last_signal;
> 319090bf6 Johannes Berg            2014-11-17  2194  			sinfo->filled
> |= BIT(NL80211_STA_INFO_SIGNAL);
> 2b9a7e1ba Johannes Berg            2014-11-17  2195  		}
> 2b9a7e1ba Johannes Berg            2014-11-17  2196
> c9c5962b5 Johannes Berg            2016-03-31  2197  		if
> (!sta->pcpu_rx_stats &&
> c9c5962b5 Johannes Berg            2016-03-31  2198  		
> !(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL_AVG))) {
> 40d9a38ad Johannes Berg            2015-07-13  2199  
> 			sinfo->signal_avg =
> 0be6ed133 Johannes Berg            2016-03-31  2200
> 				-ewma_signal_read(&sta->rx_stats_avg.signal);
> 319090bf6 Johannes Berg            2014-11-17  2201  			sinfo->filled
> |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
> b7ffbd7ef Johannes Berg            2014-06-04  2202  		}
> 2b9a7e1ba Johannes Berg            2014-11-17  2203  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2204
> c9c5962b5 Johannes Berg            2016-03-31  2205  	/* for the
> average - if pcpu_rx_stats isn't set - rxstats must point to
> c9c5962b5 Johannes Berg            2016-03-31  2206  	 * the
> sta->rx_stats struct, so the check here is fine with and without
> c9c5962b5 Johannes Berg            2016-03-31  2207  	 * pcpu 
> statistics
> c9c5962b5 Johannes Berg            2016-03-31  2208  	 */
> c9c5962b5 Johannes Berg            2016-03-31  2209  	if
> (last_rxstats->chains &&
> 319090bf6 Johannes Berg            2014-11-17  2210  	
> !(sinfo->filled & (BIT(NL80211_STA_INFO_CHAIN_SIGNAL) |
> 319090bf6 Johannes Berg            2014-11-17  2211  			
> BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG)))) {
> c9c5962b5 Johannes Berg            2016-03-31  2212  		sinfo->filled
> |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL);
> c9c5962b5 Johannes Berg            2016-03-31  2213  		if 
> (!sta->pcpu_rx_stats)
> c9c5962b5 Johannes Berg            2016-03-31  2214  			sinfo->filled
> |= BIT(NL80211_STA_INFO_CHAIN_SIGNAL_AVG);
> c9c5962b5 Johannes Berg            2016-03-31  2215
> c9c5962b5 Johannes Berg            2016-03-31  2216  		sinfo->chains =
> last_rxstats->chains;
> b7ffbd7ef Johannes Berg            2014-06-04  2217
> b7ffbd7ef Johannes Berg            2014-06-04  2218  		for (i = 0; i <
> ARRAY_SIZE(sinfo->chain_signal); i++) {
> e5a9f8d04 Johannes Berg            2015-10-16  2219  
> 			sinfo->chain_signal[i] =
> c9c5962b5 Johannes Berg            2016-03-31  2220
> 				last_rxstats->chain_signal_last[i];
> b7ffbd7ef Johannes Berg            2014-06-04  2221
> 			sinfo->chain_signal_avg[i] =
> 0be6ed133 Johannes Berg            2016-03-31  2222
> 				-ewma_signal_read(&sta->rx_stats_avg.chain_signal[i]);
> b7ffbd7ef Johannes Berg            2014-06-04  2223  		}
> b7ffbd7ef Johannes Berg            2014-06-04  2224  	}
> b7ffbd7ef Johannes Berg            2014-06-04  2225
> 319090bf6 Johannes Berg            2014-11-17  2226  	if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_TX_BITRATE))) {
> e5a9f8d04 Johannes Berg            2015-10-16  2227
> 		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate,
> e5a9f8d04 Johannes Berg            2015-10-16  2228  				     
> &sinfo->txrate);
> 319090bf6 Johannes Berg            2014-11-17  2229  		sinfo->filled
> |= BIT(NL80211_STA_INFO_TX_BITRATE);
> 2b9a7e1ba Johannes Berg            2014-11-17  2230  	}
> 2b9a7e1ba Johannes Berg            2014-11-17  2231
> 319090bf6 Johannes Berg            2014-11-17  2232  	if
> (!(sinfo->filled & BIT(NL80211_STA_INFO_RX_BITRATE))) {
> a17d93ff3 Ben Greear               2016-12-14  2233  		if
> (sta_set_rate_info_rx(sta, &sinfo->rxrate) == 0)
> 319090bf6 Johannes Berg            2014-11-17  2234  			sinfo->filled
> |= BIT(NL80211_STA_INFO_RX_BITRATE);
> 2b9a7e1ba Johannes Berg            2014-11-17  2235  	}
> b7ffbd7ef Johannes Berg            2014-06-04  2236
> 0fdf1493b Johannes Berg            2018-05-18  2237  	if (tidstats &&
> !cfg80211_sinfo_alloc_tid_stats(sinfo, GFP_KERNEL)) {
> 79c892b85 Johannes Berg            2014-11-21  2238  		for (i = 0; i <
> IEEE80211_NUM_TIDS + 1; i++) {
> 79c892b85 Johannes Berg            2014-11-21  2239  			struct
> cfg80211_tid_stats *tidstats = &sinfo->pertid[i];
> 79c892b85 Johannes Berg            2014-11-21  2240
> 0f9c5a61d Johannes Berg            2016-03-31  2241
> 			sta_set_tidstats(sta, tidstats, i);
> 79c892b85 Johannes Berg            2014-11-21  2242  		}
> 8689c051a Arend van Spriel         2018-05-10  2243  	}
> 79c892b85 Johannes Berg            2014-11-21  2244
> b7ffbd7ef Johannes Berg            2014-06-04  2245  	if
> (ieee80211_vif_is_mesh(&sdata->vif)) {
> b7ffbd7ef Johannes Berg            2014-06-04  2246  #ifdef 
> CONFIG_MAC80211_MESH
> 319090bf6 Johannes Berg            2014-11-17  2247  		sinfo->filled
> |= BIT(NL80211_STA_INFO_LLID) |
> 319090bf6 Johannes Berg            2014-11-17  2248  				
> BIT(NL80211_STA_INFO_PLID) |
> 319090bf6 Johannes Berg            2014-11-17  2249  				
> BIT(NL80211_STA_INFO_PLINK_STATE) |
> 319090bf6 Johannes Berg            2014-11-17  2250  				
> BIT(NL80211_STA_INFO_LOCAL_PM) |
> 319090bf6 Johannes Berg            2014-11-17  2251  				
> BIT(NL80211_STA_INFO_PEER_PM) |
> 319090bf6 Johannes Berg            2014-11-17  2252  				
> BIT(NL80211_STA_INFO_NONPEER_PM);
> b7ffbd7ef Johannes Berg            2014-06-04  2253
> 433f5bc1c Johannes Berg            2015-06-17  2254  		sinfo->llid =
> sta->mesh->llid;
> 433f5bc1c Johannes Berg            2015-06-17  2255  		sinfo->plid =
> sta->mesh->plid;
> 433f5bc1c Johannes Berg            2015-06-17  2256
> 		sinfo->plink_state = sta->mesh->plink_state;
> b7ffbd7ef Johannes Berg            2014-06-04  2257  		if
> (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
> 319090bf6 Johannes Berg            2014-11-17  2258  			sinfo->filled
> |= BIT(NL80211_STA_INFO_T_OFFSET);
> 433f5bc1c Johannes Berg            2015-06-17  2259
> 			sinfo->t_offset = sta->mesh->t_offset;
> b7ffbd7ef Johannes Berg            2014-06-04  2260  		}
> 433f5bc1c Johannes Berg            2015-06-17  2261  		sinfo->local_pm
> = sta->mesh->local_pm;
> 433f5bc1c Johannes Berg            2015-06-17  2262  		sinfo->peer_pm
> = sta->mesh->peer_pm;
> 433f5bc1c Johannes Berg            2015-06-17  2263
> 		sinfo->nonpeer_pm = sta->mesh->nonpeer_pm;
> b7ffbd7ef Johannes Berg            2014-06-04  2264  #endif
> b7ffbd7ef Johannes Berg            2014-06-04  2265  	}
> b7ffbd7ef Johannes Berg            2014-06-04  2266
> b7ffbd7ef Johannes Berg            2014-06-04  2267
> 	sinfo->bss_param.flags = 0;
> b7ffbd7ef Johannes Berg            2014-06-04  2268  	if
> (sdata->vif.bss_conf.use_cts_prot)
> b7ffbd7ef Johannes Berg            2014-06-04  2269
> 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_CTS_PROT;
> b7ffbd7ef Johannes Berg            2014-06-04  2270  	if
> (sdata->vif.bss_conf.use_short_preamble)
> b7ffbd7ef Johannes Berg            2014-06-04  2271
> 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
> b7ffbd7ef Johannes Berg            2014-06-04  2272  	if
> (sdata->vif.bss_conf.use_short_slot)
> b7ffbd7ef Johannes Berg            2014-06-04  2273
> 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
> 785e21a89 Emmanuel Grumbach        2014-09-03  2274
> 	sinfo->bss_param.dtim_period = sdata->vif.bss_conf.dtim_period;
> b7ffbd7ef Johannes Berg            2014-06-04  2275
> 	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
> b7ffbd7ef Johannes Berg            2014-06-04  2276
> b7ffbd7ef Johannes Berg            2014-06-04  2277  
> 	sinfo->sta_flags.set = 0;
> b7ffbd7ef Johannes Berg            2014-06-04  2278
> 	sinfo->sta_flags.mask = BIT(NL80211_STA_FLAG_AUTHORIZED) |
> b7ffbd7ef Johannes Berg            2014-06-04  2279
> 				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
> b7ffbd7ef Johannes Berg            2014-06-04  2280
> 				BIT(NL80211_STA_FLAG_WME) |
> b7ffbd7ef Johannes Berg            2014-06-04  2281
> 				BIT(NL80211_STA_FLAG_MFP) |
> b7ffbd7ef Johannes Berg            2014-06-04  2282
> 				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
> b7ffbd7ef Johannes Berg            2014-06-04  2283
> 				BIT(NL80211_STA_FLAG_ASSOCIATED) |
> b7ffbd7ef Johannes Berg            2014-06-04  2284
> 				BIT(NL80211_STA_FLAG_TDLS_PEER);
> b7ffbd7ef Johannes Berg            2014-06-04  2285  	if
> (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
> b7ffbd7ef Johannes Berg            2014-06-04  2286
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
> b7ffbd7ef Johannes Berg            2014-06-04  2287  	if
> (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
> b7ffbd7ef Johannes Berg            2014-06-04  2288
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_SHORT_PREAMBLE);
> a74a8c846 Johannes Berg            2014-07-22  2289  	if (sta->sta.wme)
> b7ffbd7ef Johannes Berg            2014-06-04  2290
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_WME);
> b7ffbd7ef Johannes Berg            2014-06-04  2291  	if
> (test_sta_flag(sta, WLAN_STA_MFP))
> b7ffbd7ef Johannes Berg            2014-06-04  2292
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
> b7ffbd7ef Johannes Berg            2014-06-04  2293  	if
> (test_sta_flag(sta, WLAN_STA_AUTH))
> b7ffbd7ef Johannes Berg            2014-06-04  2294
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
> b7ffbd7ef Johannes Berg            2014-06-04  2295  	if
> (test_sta_flag(sta, WLAN_STA_ASSOC))
> b7ffbd7ef Johannes Berg            2014-06-04  2296
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
> b7ffbd7ef Johannes Berg            2014-06-04  2297  	if
> (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
> b7ffbd7ef Johannes Berg            2014-06-04  2298
> 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
> b7ffbd7ef Johannes Berg            2014-06-04  2299
> 3b17fbf87 Maxim Altshul            2016-07-11  2300  	thr =
> sta_get_expected_throughput(sta);
> 3b17fbf87 Maxim Altshul            2016-07-11  2301
> 3b17fbf87 Maxim Altshul            2016-07-11  2302  	if (thr != 0) {
> 3b17fbf87 Maxim Altshul            2016-07-11  2303  		sinfo->filled
> |= BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT);
> 3b17fbf87 Maxim Altshul            2016-07-11  2304
> 		sinfo->expected_throughput = thr;
> 3b17fbf87 Maxim Altshul            2016-07-11  2305  	}
> a78b26fff Venkateswara Naralasetty 2018-02-13  2306
> a78b26fff Venkateswara Naralasetty 2018-02-13  2307  	if
> (!(sinfo->filled & BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL)) &&
> a78b26fff Venkateswara Naralasetty 2018-02-13  2308  	
> sta->status_stats.ack_signal_filled) {
> a78b26fff Venkateswara Naralasetty 2018-02-13  2309
> 		sinfo->ack_signal = sta->status_stats.last_ack_signal;
> a78b26fff Venkateswara Naralasetty 2018-02-13  2310  		sinfo->filled
> |= BIT_ULL(NL80211_STA_INFO_ACK_SIGNAL);
> a78b26fff Venkateswara Naralasetty 2018-02-13  2311  	}
> cc60dbbfe Balaji Pothunoori        2018-04-16  2312
> cc60dbbfe Balaji Pothunoori        2018-04-16  2313  	if
> (ieee80211_hw_check(&sta->local->hw, REPORTS_TX_ACK_STATUS) &&
> cc60dbbfe Balaji Pothunoori        2018-04-16 @2314  	
> !(sinfo->filled & BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG))) {
> cc60dbbfe Balaji Pothunoori        2018-04-16  2315  
> 		sinfo->avg_ack_signal =
> cc60dbbfe Balaji Pothunoori        2018-04-16  2316
> 			-(s8)ewma_avg_signal_read(
> cc60dbbfe Balaji Pothunoori        2018-04-16  2317
> 				&sta->status_stats.avg_ack_signal);
> cc60dbbfe Balaji Pothunoori        2018-04-16  2318  		sinfo->filled |=
> cc60dbbfe Balaji Pothunoori        2018-04-16  2319
> 			BIT_ULL(NL80211_STA_INFO_DATA_ACK_SIGNAL_AVG);
> cc60dbbfe Balaji Pothunoori        2018-04-16  2320  	}
> 3b17fbf87 Maxim Altshul            2016-07-11  2321  }
> 3b17fbf87 Maxim Altshul            2016-07-11  2322
> 
> :::::: The code at line 2314 was first introduced by commit
> :::::: cc60dbbfed8ff0bd4c530ee48e9e915333a35470 mac80211: average ack
> rssi support for data frames
> 
> :::::: TO: Balaji Pothunoori <bpothuno@codeaurora.org>
> :::::: CC: Johannes Berg <johannes.berg@intel.com>
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology 
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel 
> Corporation

Regards,
Balaji.
