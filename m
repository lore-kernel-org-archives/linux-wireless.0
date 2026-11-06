Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793925292;
	b=y1cpl9X3J9xa2FHx0jac36kB9bld1zgRtMYce8oK5IiVBwzfV4R0JyFPH2kPx55mrkyw
	 Nq4+fmAn0DB3WrIivB2JJ9sTQTH6YgY52JGNoLTH+QX9unIxd8qjj4tJ8+AlCMc6+OpOi
	 Jg6HA7pds9mo2bWEx+O6thESE3de0dIoUpzhcKlv4PIsWCjpo3WT+9TMNdWWuPdY+5198
	 Ibjz90BjUDgUZblmc3OWl6z3nHwtB20gbysYMVJrVdZc5nspLdv6YDmnlrfAGAHYzU/Tt
	 DlXLsPMwV3OKypz8GUwlY8zs38B/425c/J9BSQOzgy/neYSafztzSZ8XMEd6PF6qQ2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793925292;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=BDCPQwMl5ZbMSL1BG+OKV9Y6I1wzqmu2D+Tl1vlMKA8=;
	b=zvyMBeYSJTlCDgwopGQNak6/4rEbbWnyiOstCH4Lp9uWnsXO4/KVV6k+xTwNSdAkJ9fW
	 M/a2GkOJuYN0J/by08zpIh2Nh9Zk1PaWo/uGESnocGQyRrSm0Al99fHv2xVAIW6MjPvV6
	 LITkDbnJCaGFIW3wsibgJoyQfla/euaAWeZ/oE05CeMpiY69poNkKjDiOInP42WjEQ52f
	 ZLzvlF5/cAODoRMZOBVHVFztx4UyaD0oV3I53+PFVY2wJ1ejrcCpR0VjsdrATXZqEXXuF
	 QmB0Piy8cMNLyVSpoV7sYYgUKHfXwy77gZi9sbE2vN2RNmtz7fIy9/N314GyM5Pc3qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IaA+BlTd;
	arc=none smtp.remote-ip=198.175.65.13
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C55606A33B
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 00:34:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03C55606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=IaA+BlTd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793925291; x=1825461291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SOB9M6TJU1a3PJhWDum57mlUDjOGaJ0rlgoRWpTwrDw=;
  b=IaA+BlTduIx2CwSrgGvLRKTTurbpA46Kg2iQ50umZ7PtqhB6UUwJCeXu
   Imaz5L/KVoobUpm/M7YF2GD9v/ZgpW05ijZndsK60dR7QJ2amUXZGNIAn
   DzXnoYnQFBfU3FJjDVN9vhVIgJWjuaPrnortw03asjNktfuronXhou3Pi
   vS8IbciVRNE0FIpZbJgFpAWoa8prJ9jzwodc6z6LThq5NpGbnxjuwxBoH
   A27B6aqWarsxlhjDdpCxfkoe9+TbmQTe3K9UKxDQfKBCS5VATu437Qblq
   vkmcEmWpB41X5lEMQUIbX/t+1U8wgb4d58SzNm37/Qe0hKLLhn9PnIkK8
   w==;
X-CSE-ConnectionGUID: WwVyfJt/T9eFZYCQpun6ew==
X-CSE-MsgGUID: 9vOFyBB3TNiuLGsq6oEl/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2613097"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2613097"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 16:34:51 -0800
X-CSE-ConnectionGUID: i55uCnbIRwCGTG3fJzDP2g==
X-CSE-MsgGUID: zc/tS+8KSc+j1K2c1kWj/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7566228"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 05 Nov 2026 16:34:48 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xP7un-00000000n6J-2WwR;
	Fri, 06 Nov 2026 00:34:45 +0000
Date: Fri, 6 Nov 2026 08:34:01 +0800
From: kernel test robot <lkp@intel.com>
To: JB Tsai <jb.tsai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, Sean.Wang@mediatek.com,
	James-LY.Huang@mediatek.com, jb.tsai@mediatek.com
Subject: Re: [PATCH 7/9] wifi: mt76: mt7925: inject the deauth for an
 aging-timeout SAP event
Message-ID: <202611060815.93tauu28-lkp@intel.com>
References: <20261104092344.1932406-7-jb.tsai@mediatek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104092344.1932406-7-jb.tsai@mediatek.com>

Hi JB,

kernel test robot noticed the following build warnings:

[auto build test WARNING on wireless-next/main]
[also build test WARNING on linus/master v7.4-rc1 next-20261105]
[cannot apply to wireless/main]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/JB-Tsai/wifi-mt76-mt7925-bound-P2P-off-channel-mgmt-TX-lifetime/20261104-172337
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20261104092344.1932406-7-jb.tsai%40mediatek.com
patch subject: [PATCH 7/9] wifi: mt76: mt7925: inject the deauth for an aging-timeout SAP event
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20261106/202611060815.93tauu28-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261106/202611060815.93tauu28-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611060815.93tauu28-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/net/wireless/mediatek/mt76/mt7925/p2p.c: In function 'mt7925_mcu_sap_aging_timeout':
>> drivers/net/wireless/mediatek/mt76/mt7925/p2p.c:483:9: warning: alignment 1 of 'struct <anonymous>' is less than 2 [-Wpacked-not-aligned]
     483 |         } __packed deauth = {};
         |         ^


vim +483 drivers/net/wireless/mediatek/mt76/mt7925/p2p.c

   468	
   469	/* FW reported that a peer of our AP/GO aged out (no traffic/no ack for the FW
   470	 * inactivity period); the expected reaction is a deauth with
   471	 * REASON_CODE_DISASSOC_INACTIVITY. Here the AP MLME lives in
   472	 * wpa_supplicant (softmac, device_ap_sme=0), so instead of tearing the
   473	 * STA down in the driver we synthesize the deauth frame the GO would
   474	 * have received from the GC and hand it to userspace via
   475	 * NL80211_CMD_FRAME.
   476	 */
   477	static void
   478	mt7925_mcu_sap_aging_timeout(struct mt792x_dev *dev, u16 wlan_idx)
   479	{
   480		struct {
   481			struct ieee80211_hdr_3addr hdr;
   482			__le16 reason_code;
 > 483		} __packed deauth = {};
   484		u8 peer[ETH_ALEN], own[ETH_ALEN], bssid[ETH_ALEN];
   485		struct ieee80211_chanctx_conf *ctx;
   486		struct mt792x_bss_conf *mconf;
   487		struct mt792x_link_sta *mlink;
   488		struct ieee80211_vif *vif;
   489		struct ieee80211_sta *sta;
   490		struct mt792x_vif *mvif;
   491		struct mt792x_sta *msta;
   492		struct mt76_wcid *wcid;
   493		struct wireless_dev *wdev;
   494		int freq = 0;
   495		u8 link_id;
   496	
   497		rcu_read_lock();
   498	
   499		wcid = mt76_wcid_ptr(dev, wlan_idx);
   500		if (!wcid || !wcid->sta)
   501			goto unlock;
   502	
   503		mlink = container_of(wcid, struct mt792x_link_sta, wcid);
   504		msta = mlink->sta;
   505		if (!msta || !msta->vif)
   506			goto unlock;
   507	
   508		vif = container_of((void *)msta->vif, struct ieee80211_vif, drv_priv);
   509		if (vif->type != NL80211_IFTYPE_AP &&
   510		    vif->type != NL80211_IFTYPE_P2P_GO)
   511			goto unlock;
   512	
   513		mvif = (struct mt792x_vif *)vif->drv_priv;
   514		sta = container_of((void *)msta, struct ieee80211_sta, drv_priv);
   515		link_id = wcid->link_id;
   516	
   517		ether_addr_copy(peer, sta->addr);
   518		ether_addr_copy(own, vif->addr);
   519		ether_addr_copy(bssid, vif->bss_conf.bssid);
   520		mconf = &mvif->bss_conf;
   521	
   522		if (ieee80211_vif_is_mld(vif) && link_id < IEEE80211_LINK_UNSPECIFIED) {
   523			struct ieee80211_link_sta *link_sta;
   524			struct ieee80211_bss_conf *link_conf;
   525			struct mt792x_bss_conf *link_mconf;
   526	
   527			link_sta = rcu_dereference(sta->link[link_id]);
   528			if (link_sta)
   529				ether_addr_copy(peer, link_sta->addr);
   530	
   531			link_conf = rcu_dereference(vif->link_conf[link_id]);
   532			if (link_conf) {
   533				ether_addr_copy(own, link_conf->addr);
   534				ether_addr_copy(bssid, link_conf->bssid);
   535			}
   536	
   537			link_mconf = rcu_dereference(mvif->link_conf[link_id]);
   538			if (link_mconf)
   539				mconf = link_mconf;
   540		}
   541	
   542		ctx = mconf->mt76.ctx;
   543		if (ctx && ctx->def.chan)
   544			freq = ctx->def.chan->center_freq;
   545		else if (dev->mphy.chandef.chan)
   546			freq = dev->mphy.chandef.chan->center_freq;
   547	
   548		rcu_read_unlock();
   549	
   550		deauth.hdr.frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
   551						       IEEE80211_STYPE_DEAUTH);
   552		ether_addr_copy(deauth.hdr.addr1, own);	/* DA: the GO itself */
   553		ether_addr_copy(deauth.hdr.addr2, peer);	/* SA: the aged-out GC */
   554		ether_addr_copy(deauth.hdr.addr3, bssid);
   555		deauth.reason_code = cpu_to_le16(WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY);
   556	
   557		wdev = ieee80211_vif_to_wdev(vif);
   558		if (!wdev)
   559			return;
   560	
   561		cfg80211_rx_mgmt_khz(wdev, MHZ_TO_KHZ(freq), 0, (const u8 *)&deauth,
   562				     sizeof(deauth), 0);
   563	
   564		return;
   565	
   566	unlock:
   567		rcu_read_unlock();
   568	}
   569	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
