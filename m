Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09C3CBE74
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787902855; cv=none; b=WtSB38oIsXiaPiYeqOKH/IjkTfMXuncsHJ9Uiarc/ghwmDL/KobuLvh8pZJ/Ok8PfJ+x58stU+edwk6f/OfvvuumHvvVpbxRurB+nnFQVsbkQbCqeFiKfa03L+2MrNjOuZ+uVG1P1hFd+2fNmcSyYfgTXIVM02T4iD57oZQ5Ey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787902855; c=relaxed/simple;
	bh=Fzg4C2XBSsG3+gxax1UcohuhsDQhZoPjQ+UDQxQA1EE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bp8Km5BbgmFd5EwgU7bNqCK1k2brhYCwYkiadttizntQcT4Vh/IszazeHUNuKRIf1T0EhAyEEFRzygooiI1K5CtkpsFid2wrlter7dj5QNcgYpxWfXA3oWeHtUTXbOxmM9/ljMIhrzTL1VFh7/pK2I3x/ihAwiSjbIuYXkT1ZhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=glmO9hNG; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="glmO9hNG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787902853; x=1819438853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Fzg4C2XBSsG3+gxax1UcohuhsDQhZoPjQ+UDQxQA1EE=;
  b=glmO9hNG7gESgU4Qrk4eNcIDQj6A2amghrtC0gQtB2k/XHFdDPpglApB
   2tqZhPPDdA5nOMpj2otE+25Yqh/vhvCJNtRoPvKyIteq1VYi46Ry8v/1J
   dgCOuV/wjnGEYijfxrTg329zdwVZKgJDB8K9Cw+xaAgxXRzVIW3bXy7D7
   lO/8PPXehOElzlsld+eAvhsQBXhdiRUMMl7cm4SHVD3vEX+65DtACOzao
   g0hTIbiEul7Kp59inMpHIHW3466oWfP/J0u8Tyv06cOsovQcZ7g3yp5Eq
   uWF1BkRU0EuqnbFdXilvjnYOy5XLtjYCSBeQrX8M/gi6qjCdcZ4oXgsiw
   w==;
X-CSE-ConnectionGUID: yUhPmAqNTTm739qCUkJfhA==
X-CSE-MsgGUID: DTtMqLFeQQewlliRRhawug==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="88173653"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="88173653"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 00:40:53 -0700
X-CSE-ConnectionGUID: Z2gUKGXPRjqmhCdOVNk/yA==
X-CSE-MsgGUID: 3GsM/yrgSsK0+JCGr1bIBw==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 3532383e6126) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 28 Aug 2026 00:40:48 -0700
Received: from kbuild by 3532383e6126 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wzrCf-00000000Ab7-2PeG;
	Fri, 28 Aug 2026 07:40:45 +0000
Date: Fri, 28 Aug 2026 15:39:48 +0800
From: kernel test robot <lkp@intel.com>
To: Eason Lai <eason.lai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, kun.wu@mediatek.com,
	deren.wu@mediatek.com, sean.wang@mediatek.com,
	quan.zhou@mediatek.com, ryder.lee@mediatek.com,
	leon.yen@mediatek.com, litien.chang@mediatek.com,
	jb.tsai@mediatek.com, michael.shih@mediatek.com,
	eason.lai@mediatek.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] wifi: mt76: mt7928: Add debugfs for stats to provide
 debug purpose
Message-ID: <202608281532.s7sXQ2Cc-lkp@intel.com>
References: <20260827084427.1624598-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827084427.1624598-1-eason.lai@mediatek.com>

Hi Eason,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on linus/master next-20260826]
[cannot apply to wireless/main v7.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Eason-Lai/wifi-mt76-mt7928-Add-debugfs-for-stats-to-provide-debug-purpose/20260827-164427
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260827084427.1624598-1-eason.lai%40mediatek.com
patch subject: [PATCH v3] wifi: mt76: mt7928: Add debugfs for stats to provide debug purpose
config: sparc-randconfig-r073-20260828 (https://download.01.org/0day-ci/archive/20260828/202608281532.s7sXQ2Cc-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 14.3.0
smatch: v0.5.0-9187-g5189e3fb

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608281532.s7sXQ2Cc-lkp@intel.com/

smatch warnings:
drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:437 mt792x_stats() warn: inconsistent indenting
drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c:540 mt792x_stats() error: testing array offset 'band_idx' after use.

vim +437 drivers/net/wireless/mediatek/mt76/mt7925/debugfs.c

   415	
   416	static int mt792x_stats(struct seq_file *s, void *data)
   417	{
   418		s8 rssi = 0;
   419		u8 band_idx = 0;
   420		bool wtbl_rate_valid = false;
   421		int ret = 0;
   422		int i = 0;
   423		u32 stats_value = 0;
   424		u32 tx_link_speed_kbps = 0;
   425		u64 tx_total = 0;
   426		u64 tx_fail = 0;
   427		u64 tx_per = 0;
   428		u32 tx_per_rem = 0;
   429		/* UNI_CMD_MIB_DATA */
   430		u64 mib_values[ARRAY_SIZE(stats_query_mib_counters)];
   431		struct mt792x_dev *dev = dev_get_drvdata(s->private);
   432		struct mt7925_wtbl_rate wtbl_rate;
   433		struct mt7925_sta_stats *stats = NULL;
   434	
   435		band_idx = dev->mphy.band_idx;
   436	
 > 437		 stats = kzalloc(sizeof(*stats), GFP_KERNEL);
   438		if (!stats)
   439			return -ENOMEM;
   440	
   441		/* Get STA_STATS */
   442		mt792x_mutex_acquire(dev);
   443		ret = mt792x_mcu_get_stat(dev, stats);
   444		mt792x_mutex_release(dev);
   445		if (ret)
   446			goto out;
   447	
   448		/* Get MIB_STATS */
   449		mt792x_mutex_acquire(dev);
   450		ret = mt7925_mcu_get_mib_info(dev, band_idx, stats_query_mib_counters,
   451					      ARRAY_SIZE(stats_query_mib_counters), mib_values);
   452		mt792x_mutex_release(dev);
   453		if (ret)
   454			goto out;
   455	
   456		/* Get Link_Speed and RSSI */
   457		mt792x_mutex_acquire(dev);
   458		ret = mt7925_mcu_get_link_quality(dev, stats->bss_idx, &rssi, &tx_link_speed_kbps);
   459		mt792x_mutex_release(dev);
   460		if (ret)
   461			goto out;
   462	
   463		/* Get the firmware auto-rate table (best effort; do not abort the
   464		 * whole stats dump if the WTBL query is not available).
   465		 */
   466		mt792x_mutex_acquire(dev);
   467		if (!mt792x_mcu_get_wtbl_rate(dev, stats->wtbl_idx, &wtbl_rate))
   468			wtbl_rate_valid = true;
   469		mt792x_mutex_release(dev);
   470	
   471		/* Print STA_STATS info */
   472		seq_printf(s, "(STA) connected AP MAC Address = %pM\n", stats->mac_addr);
   473		seq_printf(s, "%-22s  BssIdx = [%u]\n", " ", stats->bss_idx);
   474		seq_printf(s, "%-22s  StaRecIdx = [%u]\n",
   475			   " ", stats->sta_idx);
   476		seq_printf(s, "%-22s  RSSI = %d\n", " ", rssi);
   477		seq_printf(s, "%-22s  Link_Speed = %u (kbit/s)\n", " ", tx_link_speed_kbps);
   478	
   479		seq_printf(s, "%-22s  temperature = %u\n",
   480			   " ", stats->temperature);
   481	
   482		stats_value = le32_to_cpu(stats->transmit_count) - le32_to_cpu(stats->transmit_fail_count);
   483		seq_printf(s, "%-22s  Tx success = %u\n",
   484			   " ", stats_value);
   485	
   486		stats_value = le32_to_cpu(stats->tx_fail_count) - le32_to_cpu(stats->tx_life_timeout_count);
   487		seq_printf(s, "%-22s  Tx fail to Rcv ACK after retry = %u\n",
   488			   " ", stats_value);
   489	
   490		seq_printf(s, "%-22s  Rx Mpdu = %u\n",
   491			   " ", le32_to_cpu(stats->mib[band_idx].rx_mpdu_cnt));
   492	
   493		seq_printf(s, "%-22s  Rx Fcs Error = %u (MPDU)\n",
   494			   " ", le32_to_cpu(stats->mib[band_idx].fcs_error));
   495		seq_printf(s, "%-22s  Rx FIFO full = %u (MPDU)\n",
   496			   " ", le32_to_cpu(stats->mib[band_idx].rx_fifo_full));
   497	
   498		for (i = 0; i < STAT_MIB_CNT_TRX_AGG_RANGE_MAX_NUM; i++)
   499			seq_printf(s, "%-22s  TRX_AGG_RANGE[%d] = %u (PPDU)\n",
   500				   " ", i, le32_to_cpu(stats->mib[band_idx].tx_range_ampdu_cnt[i]));
   501	
   502		seq_printf(s, "%-22s  MPDUs in AMPDUs transmitted = %u (MPDU)\n",
   503			   " ", le32_to_cpu(stats->mib[band_idx].ampdu_tx_sf_cnt));
   504		seq_printf(s, "%-22s  MPDUs in AMPDUs transmitted with ACK reply = %u (MPDU)\n",
   505			   " ", le32_to_cpu(stats->mib[band_idx].ampdu_tx_ack_sf_cnt));
   506		seq_printf(s, "%-22s  rate1_tx_cnt = %u\n",
   507			   " ", le32_to_cpu(stats->rate1_tx_cnt));
   508		seq_printf(s, "%-22s  rate1_fail_cnt = %u\n",
   509			   " ", le32_to_cpu(stats->rate1_fail_cnt));
   510		seq_printf(s, "%-22s  train_up = %u\n",
   511			   " ", le16_to_cpu(stats->train_up));
   512		seq_printf(s, "%-22s  train_down = %u\n",
   513			   " ", le16_to_cpu(stats->train_down));
   514		seq_printf(s, "%-22s  is_force_tx_stream = %u\n",
   515			   " ", stats->is_force_tx_stream);
   516		seq_printf(s, "%-22s  is_force_se_off = %u\n",
   517			   " ", stats->is_force_se_off);
   518		seq_printf(s, "%-22s  max_ampdu_factor = %u\n",
   519			   " ", stats->max_ampdu_factor);
   520		seq_printf(s, "%-22s  tx_rate_up_penalty = %u\n",
   521			   " ", stats->tx_rate_up_penalty);
   522		seq_printf(s, "%-22s  low_traffic_mode = %u\n",
   523			   " ", stats->low_traffic_mode);
   524		seq_printf(s, "%-22s  low_traffic_count = %u\n",
   525			   " ", stats->low_traffic_count);
   526		seq_printf(s, "%-22s  low_traffic_dashboard = %u\n",
   527			   " ", stats->low_traffic_dashboard);
   528		seq_printf(s, "%-22s  dynamic_sgi_state = %u\n",
   529			   " ", stats->dynamic_sgi_state);
   530		seq_printf(s, "%-22s  dynamic_sgi_score = %u\n",
   531			   " ", stats->dynamic_sgi_score);
   532		seq_printf(s, "%-22s  dynamic_bw_state = %u\n",
   533			   " ", stats->dynamic_bw_state);
   534		seq_printf(s, "%-22s  dynamic_gband_256qam_state = %u\n",
   535			   " ", stats->dynamic_gband_256qam_state);
   536		seq_printf(s, "%-22s  vht_non_sp_rate_state = %u\n",
   537			   " ", stats->vht_non_sp_rate_state);
   538	
   539		/* Decode the TX Vector BBP latch to show the current TX MCS rate */
 > 540		if (band_idx < MT7925_STA_STATS_BAND_NUM)
   541			mt7925_print_last_tx_rate(s, stats->tx_vector[band_idx].txv);
   542	
   543		/* Dump the whole firmware auto-rate table and mark the entry currently */
   544		if (wtbl_rate_valid)
   545			mt7925_dump_auto_rate_table(s, &wtbl_rate);
   546	
   547		seq_puts(s, "\nmib state:\n");
   548		/* ===Rx Related Counters=== */
   549		seq_puts(s, "=== Rx Related Counters ===\n");
   550		seq_printf(s, "%-22s  Rx with CRC = %llu (MPDU)\n",
   551			   " ", mib_values[QUERY_MIB_CNT_RX_FCS_ERR]);
   552		seq_printf(s, "%-22s  Rx drop due to out of resource = %llu (MPDU)\n",
   553			   " ", mib_values[QUERY_MIB_CNT_RX_FIFO_OVERFLOW]);
   554		seq_printf(s, "%-22s  Rx Mpdu = %llu (MPDU)\n",
   555			   " ", mib_values[QUERY_MIB_CNT_RX_MPDU]);
   556		seq_printf(s, "%-22s  Rx AMpdu = %llu (PPDU)\n",
   557			   " ", mib_values[QUERY_MIB_CNT_AMPDU_RX_COUNT]);
   558		seq_printf(s, "%-22s  Rx PF Drop = %llu (MPDU)\n",
   559			   " ", mib_values[QUERY_MIB_CNT_PF_DROP]);
   560		seq_printf(s, "%-22s  Rx Len Mismatch = %llu (PPDU)\n",
   561			   " ", mib_values[QUERY_MIB_CNT_LEN_MISMATCH]);
   562	
   563		/* ===Phy/Timing Related Counters=== */
   564		seq_puts(s, "\n=== Phy/Timing Related Counters ===\n");
   565		seq_printf(s, "%-22s  ChannelIdleCnt = %llu\n",
   566			   " ", mib_values[QUERY_MIB_CNT_CHANNEL_IDLE]);
   567		seq_printf(s, "%-22s  CCA_NAV_Tx_Time = %llu\n",
   568			   " ", mib_values[QUERY_MIB_CNT_CCA_NAV_TX_TIME]);
   569		seq_printf(s, "%-22s  Rx_MDRDY_CNT = %llu (PPDU)\n",
   570			   " ", mib_values[QUERY_MIB_CNT_MDRDY]);
   571		seq_printf(s, "%-22s  CCK_MDRDY = %llu\n",
   572			   " ", mib_values[QUERY_MIB_CNT_RX_CCK_MDRDY_TIME]);
   573		seq_printf(s, "%-22s  OFDM_MDRDY = %llu\n",
   574			   " ", mib_values[QUERY_MIB_CNT_RX_OFDM_LG_MIXED_MDRDY_TIME]);
   575		seq_printf(s, "%-22s  OFDM_GREEN_MDRDY = %llu\n",
   576			   " ", mib_values[QUERY_MIB_CNT_RX_OFDM_GREEN_MDRDY_TIME]);
   577		seq_printf(s, "%-22s  Prim CCA Time = %llu\n",
   578			   " ", mib_values[QUERY_MIB_CNT_P_CCA_TIME]);
   579		seq_printf(s, "%-22s  Sec CCA Time = %llu\n",
   580			   " ", mib_values[QUERY_MIB_CNT_S_CCA_TIME]);
   581		seq_printf(s, "%-22s  Prim ED Time = %llu\n",
   582			   " ", mib_values[QUERY_MIB_CNT_P_ED_TIME]);
   583	
   584		/* ===Tx Related Counters(Generic)=== */
   585		seq_puts(s, "\n=== Tx Related Counters(Generic) ===\n");
   586		seq_printf(s, "%-22s  BeaconTxCnt = %llu\n",
   587			   " ", mib_values[QUERY_MIB_CNT_BCN_TX]);
   588		seq_printf(s, "%-22s  Tx 40MHz Cnt = %llu  (MPDU)\n",
   589			   " ", mib_values[QUERY_MIB_CNT_TX_BW_40MHZ]);
   590		seq_printf(s, "%-22s  Tx 80MHz Cnt = %llu  (MPDU)\n",
   591			   " ", mib_values[QUERY_MIB_CNT_TX_BW_80MHZ]);
   592		seq_printf(s, "%-22s  Tx 160MHz Cnt = %llu  (MPDU)\n",
   593			   " ", mib_values[QUERY_MIB_CNT_TX_BW_160MHZ]);
   594	
   595		/* ===BSSID[0] Related Counters=== */
   596		seq_puts(s, "\n=== BSSID[0] Related Counters ===\n");
   597		seq_printf(s, "%-22s  BA Miss Cnt = %llu  (PPDU)\n",
   598			   " ", mib_values[QUERY_MIB_CNT_BSS0_BA_MISS]);
   599		seq_printf(s, "%-22s  RTS Tx Cnt = %llu  (MPDU)\n",
   600			   " ", mib_values[QUERY_MIB_CNT_BSS0_RTS_TX_CNT]);
   601		seq_printf(s, "%-22s  Frame Retry Cnt = %llu (MPDU)\n",
   602			   " ", mib_values[QUERY_MIB_CNT_BSS0_FRAME_RETRY]);
   603		seq_printf(s, "%-22s  Frame Retry 2 Cnt = %llu (MPDU)\n",
   604			   " ", mib_values[QUERY_MIB_CNT_BSS0_FRAME_RETRY_2]);
   605		seq_printf(s, "%-22s  RTS Retry Cnt = %llu (MPDU)\n",
   606			   " ", mib_values[QUERY_MIB_CNT_BSS0_RTS_RETRY]);
   607		seq_printf(s, "%-22s  Ack Failed Cnt = %llu (PPDU)\n",
   608			   " ", mib_values[QUERY_MIB_CNT_BSS0_ACK_FAIL]);
   609	
   610		/* ===AMPDU Related Counters=== */
   611		seq_puts(s, "\n=== AMPDU Related Counters ===\n");
   612		seq_printf(s, "%-22s  Tx AMPDU_Pkt_Cnt = %llu  (PPDU)\n",
   613			   " ", mib_values[QUERY_MIB_CNT_AMPDU]);
   614		seq_printf(s, "%-22s  Tx AMPDU_MPDU_Pkt_Cnt = %llu  (MPDU)\n",
   615			   " ", mib_values[QUERY_MIB_CNT_AMPDU_MPDU]);
   616		seq_printf(s, "%-22s  AMPDU Tx success = %llu (MPDU)\n",
   617			   " ", mib_values[QUERY_MIB_CNT_AMPDU_ACKED]);
   618	
   619		tx_total = mib_values[QUERY_MIB_CNT_AMPDU_MPDU];
   620		tx_fail =  mib_values[QUERY_MIB_CNT_AMPDU_MPDU] - mib_values[QUERY_MIB_CNT_AMPDU_ACKED];
   621		tx_per = tx_total == 0 ? 0 : div64_u64(1000 * tx_fail, tx_total);
   622		seq_printf(s, "%-22s  AMPDU Tx fail count   = %llu  (MPDU), PER=%llu.%1llu%%\n",
   623			   " ",
   624			   tx_fail,
   625			   div_u64_rem(tx_per, 10, &tx_per_rem), (u64)tx_per_rem);
   626	
   627	out:
   628		kfree(stats);
   629		return ret;
   630	}
   631	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
