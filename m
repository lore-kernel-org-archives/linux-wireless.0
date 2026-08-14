Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2959547ACFA
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 14:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786719055; cv=none; b=kqy/VWRzMxjHA1dI/7E0JjUazmJcsSF21DJans/JpQReoQwvIdoTlq5BRVsa5UShbsIT7ZXPqelny1MKzRdJGI3c1OcT4XVV6e3rt4DyE1NxP6R3ZL8ZAn2VQHoDZFfVJ14C5H907E8VWIkDD/BXn2PrP6A3XYtI+X6Rnnq3V+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786719055; c=relaxed/simple;
	bh=hwtSLYtWAOoEfupI9+8iMQv7c54WYRNhB2Aq3XI54ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhV22CeOMyFMuLVjf+j4XEJG75HiHYB8ie+WypiXUi6Dt+68YplCLAuI5L5w4Daouk5LRChxNGXdxfiU/2NcQjmUq4ZUxhZ3/cDVYAV/kK4/oWTP5JbRYliUCoUBiILgysZ0JKFQDtDNRXACt5lfmfBqDemL8gS8joZsccOcx3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0njz93l; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0njz93l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786719048; x=1818255048;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hwtSLYtWAOoEfupI9+8iMQv7c54WYRNhB2Aq3XI54ug=;
  b=Q0njz93lPIg2LAaoXFCMPjfuo3ZLN4QAZkLsnD//atBCLEUhtMaiCGo+
   mVeyvXsOOFiLOye8O1O3Hfv0WLEq0nZbREavuTn+p1QM40T645jl2I5ME
   r81l02YGoY44EWjwkyK5U82ZPBg5T+majkVAbX1zG4GpUsSyvJAS01zeX
   lAbPQJGfCC/4vlsunAbIb4LZVxJjZIvMqTt2vopcsIzbKgCIwlmKHe7/E
   TNRNahGuIe688hQJkXHNInsdeeeLP8ixEFuDlgge6CKFDpX90nkOrCYEj
   hYD4M47MXw/Eb92s2xC7PtnIvQjBkKotfhUlIdFf+E3NfdriKFDT6t86l
   w==;
X-CSE-ConnectionGUID: mnmk2o4ERf2RBFLazyf6JA==
X-CSE-MsgGUID: SGJTfOAhRB+gGB1LHFwTCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="104831988"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="104831988"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 07:50:43 -0700
X-CSE-ConnectionGUID: BesPaAqZQlelEZ6+U4DL3g==
X-CSE-MsgGUID: UqIunrVtRFGM4YozDZhUAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="289043298"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by fmviesa001.fm.intel.com with ESMTP; 14 Aug 2026 07:50:42 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wutF2-000000006Hd-3Frm;
	Fri, 14 Aug 2026 14:50:40 +0000
Date: Fri, 14 Aug 2026 16:50:16 +0200
From: kernel test robot <lkp@intel.com>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 10/10] wifi: mt76: mt7996: fix out-of-bounds link array
 access in mt7996_tx()
Message-ID: <202608141616.AvOMG8CW-lkp@intel.com>
References: <20260801145334.1166751-10-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801145334.1166751-10-nbd@nbd.name>

Hi Felix,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless/main]
[also build test ERROR on linus/master v7.2-rc7]
[cannot apply to wireless-next/main next-20260813]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Felix-Fietkau/wifi-mt76-mt7915-handle-MCU-PS-sync-events/20260807-020152
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git main
patch link:    https://lore.kernel.org/r/20260801145334.1166751-10-nbd%40nbd.name
patch subject: [PATCH 10/10] wifi: mt76: mt7996: fix out-of-bounds link array access in mt7996_tx()
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260814/202608141616.AvOMG8CW-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260814/202608141616.AvOMG8CW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608141616.AvOMG8CW-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/mediatek/mt76/tx.c: In function 'mt76_txq_send_burst':
>> drivers/net/wireless/mediatek/mt76/tx.c:501:21: error: implicit declaration of function 'ieee80211_txq_aql_pending'; did you mean 'ieee80211_txq_get_depth'? [-Wimplicit-function-declaration]
     501 |                 if (ieee80211_txq_aql_pending(phy->hw, txq))
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~
         |                     ieee80211_txq_get_depth


vim +501 drivers/net/wireless/mediatek/mt76/tx.c

   484	
   485	static int
   486	mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
   487			    struct mt76_txq *mtxq, struct mt76_wcid *wcid)
   488	{
   489		struct mt76_dev *dev = phy->dev;
   490		struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
   491		enum mt76_txq_id qid = mt76_txq_get_qid(txq);
   492		struct ieee80211_tx_info *info;
   493		struct sk_buff *skb;
   494		int n_frames = 1;
   495		bool stop = false;
   496		int idx;
   497	
   498		if (test_bit(MT_WCID_FLAG_PS, &wcid->flags)) {
   499			if (!(dev->drv->drv_flags & MT_DRV_HW_PS_BUFFERING))
   500				return 0;
 > 501			if (ieee80211_txq_aql_pending(phy->hw, txq))
   502				return 0;
   503		}
   504	
   505		if (atomic_read(&wcid->non_aql_packets) >= MT_MAX_NON_AQL_PKT)
   506			return 0;
   507	
   508		skb = mt76_txq_dequeue(phy, mtxq);
   509		if (!skb)
   510			return 0;
   511	
   512		info = IEEE80211_SKB_CB(skb);
   513		if (!(wcid->tx_info & MT_WCID_TX_INFO_SET))
   514			ieee80211_get_tx_rates(txq->vif, txq->sta, skb,
   515					       info->control.rates, 1);
   516	
   517		spin_lock(&q->lock);
   518		idx = __mt76_tx_queue_skb(phy, qid, skb, wcid, txq->sta, &stop);
   519		spin_unlock(&q->lock);
   520		if (idx < 0)
   521			return idx;
   522	
   523		if (test_bit(MT_WCID_FLAG_PS, &wcid->flags))
   524			goto out;
   525	
   526		do {
   527			if (test_bit(MT76_RESET, &phy->state) || phy->offchannel)
   528				break;
   529	
   530			if (stop || mt76_txq_stopped(q))
   531				break;
   532	
   533			skb = mt76_txq_dequeue(phy, mtxq);
   534			if (!skb)
   535				break;
   536	
   537			info = IEEE80211_SKB_CB(skb);
   538			if (!(wcid->tx_info & MT_WCID_TX_INFO_SET))
   539				ieee80211_get_tx_rates(txq->vif, txq->sta, skb,
   540						       info->control.rates, 1);
   541	
   542			spin_lock(&q->lock);
   543			idx = __mt76_tx_queue_skb(phy, qid, skb, wcid, txq->sta, &stop);
   544			spin_unlock(&q->lock);
   545			if (idx < 0)
   546				break;
   547	
   548			n_frames++;
   549		} while (1);
   550	
   551	out:
   552		spin_lock(&q->lock);
   553		dev->queue_ops->kick(dev, q);
   554		spin_unlock(&q->lock);
   555	
   556		return n_frames;
   557	}
   558	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
