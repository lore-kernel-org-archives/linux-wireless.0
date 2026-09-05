Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C002FC00D
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788569376; cv=none; b=sYxGQHvN/jt6Q5Hklv3llmqqy8qoE4L43I9+FzZ4saqR6zgaP89rkdQBal3WdvqL5RciD/zOBQEYnaNTHWm1mINXDC+h1EXwfwU7RZUcm/fyRbTMZMiGyGULjW/CkP/uX5SRW8rwU30pAbSH9vyCOT36xyvEe8j8UIyNR5fSStA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788569376; c=relaxed/simple;
	bh=heZDEJI+RyL9PKZ2dHZWXmJNf2c5dwx1beAvC+LLQOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWnL4XpMhJr5YiwAa2MTrZ7XCiU2D5cJNWA9IG0Qro+oSxqqyhnKprxwy4iOXxJZqunaJgpS4ZsfbhoVHZanktNSJS6NHSdWuC7F+LeMfpjTuQLMKAiDf4qzKmwD7cLixooIqqkd8BteUHnBWGcrFGkEAf/HVb7ES006en/M4xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b/1NZnTB; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b/1NZnTB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788569374; x=1820105374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=heZDEJI+RyL9PKZ2dHZWXmJNf2c5dwx1beAvC+LLQOg=;
  b=b/1NZnTBxEA60Al4iD56MbiiytdXFJpGk3EuziZ6Z6b3XftwVYWqjuA6
   frAsf3rv8AXfCM6sBM+lipDhOW4r1ML6/FDVv9gUSNaXTmai5jJ281ma3
   62HiYOOL5snZceiYGX3JDCIhQ7yYEhhGiqyXcShOz3JQkusO3jjObAznH
   H360dJMqjqDOSzN2dWB4b9sIKoZZrWNWhMRF754PfUx6RJ4c1ZpDi4zHW
   OFi1rS+V1Vb88MyOd/t4NlQ75ZTZjs3dqX6NEYe9RFqYXzk8QBZdc3gyF
   DWoEFA75AJBrU+PaMLA+wdUZYetBO8qFlomYmjcCyWjPhV8Pk59Hvm0do
   w==;
X-CSE-ConnectionGUID: ZwgbQ27JQpqDBWNJePWpPA==
X-CSE-MsgGUID: FmjjkpSwTCyORstenCanhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="89129728"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="89129728"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 17:49:34 -0700
X-CSE-ConnectionGUID: bkGHgv6oQFOKTiSCvuwyow==
X-CSE-MsgGUID: CONcr+o8Qp2Fn+uQDT5H7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="295052020"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 04 Sep 2026 17:49:32 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2eb4-00000000APG-0NdZ;
	Sat, 05 Sep 2026 00:49:30 +0000
Date: Sat, 5 Sep 2026 08:49:22 +0800
From: kernel test robot <lkp@intel.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>,
	i.mafifi17@gmail.com
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: Download the reserved page
 synchronously
Message-ID: <202609050825.gGIFwsGa-lkp@intel.com>
References: <fd7bbc79-03f9-4932-ada8-f555392d4485@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd7bbc79-03f9-4932-ada8-f555392d4485@gmail.com>

Hi Bitterblue,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main linus/master v7.3-rc1 next-20260904]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bitterblue-Smith/wifi-rtw88-usb-Download-the-reserved-page-synchronously/20260904-002447
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/fd7bbc79-03f9-4932-ada8-f555392d4485%40gmail.com
patch subject: [PATCH rtw-next] wifi: rtw88: usb: Download the reserved page synchronously
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20260905/202609050825.gGIFwsGa-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050825.gGIFwsGa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609050825.gGIFwsGa-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/realtek/rtw88/usb.c: In function 'rtw_usb_write_data_rsvd_page':
>> drivers/net/wireless/realtek/rtw88/usb.c:623:48: error: passing argument 3 of 'rtw_tx_fill_tx_desc' from incompatible pointer type [-Wincompatible-pointer-types]
     623 |         rtw_tx_fill_tx_desc(rtwdev, &pkt_info, pkt_desc);
         |                                                ^~~~~~~~
         |                                                |
         |                                                struct rtw_tx_desc *
   In file included from drivers/net/wireless/realtek/rtw88/usb.c:12:
   drivers/net/wireless/realtek/rtw88/tx.h:99:76: note: expected 'struct sk_buff *' but argument is of type 'struct rtw_tx_desc *'
      99 |                          struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb);
         |                                                            ~~~~~~~~~~~~~~~~^~~
>> drivers/net/wireless/realtek/rtw88/usb.c:624:56: error: passing argument 3 of 'rtw_tx_fill_txdesc_checksum' from incompatible pointer type [-Wincompatible-pointer-types]
     624 |         rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, pkt_desc);
         |                                                        ^~~~~~~~
         |                                                        |
         |                                                        struct rtw_tx_desc *
   drivers/net/wireless/realtek/rtw88/tx.h:136:52: note: expected 'u8 *' {aka 'unsigned char *'} but argument is of type 'struct rtw_tx_desc *'
     136 |                                                u8 *txdesc)
         |                                                ~~~~^~~~~~


vim +/rtw_tx_fill_tx_desc +623 drivers/net/wireless/realtek/rtw88/usb.c

   600	
   601	static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
   602						u32 size)
   603	{
   604		const struct rtw_chip_info *chip = rtwdev->chip;
   605		struct rtw_tx_pkt_info pkt_info = {0};
   606		struct rtw_tx_desc *pkt_desc;
   607		struct sk_buff *skb;
   608		int ret;
   609	
   610		pkt_info.tx_pkt_size = size;
   611		pkt_info.qsel = TX_DESC_QSEL_BEACON;
   612		pkt_info.offset = chip->tx_pkt_desc_sz;
   613		pkt_info.ls = true;
   614	
   615		skb = dev_alloc_skb(chip->tx_pkt_desc_sz + size);
   616		if (!skb)
   617			return -ENOMEM;
   618	
   619		skb_reserve(skb, chip->tx_pkt_desc_sz);
   620		skb_put_data(skb, buf, size);
   621		pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
   622		memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
 > 623		rtw_tx_fill_tx_desc(rtwdev, &pkt_info, pkt_desc);
 > 624		rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, pkt_desc);
   625	
   626		/* Download the beacon/reserved page synchronously so that the caller's
   627		 * subsequent BCN_VALID poll observes the completed transfer instead of
   628		 * racing the async TX path.
   629		 */
   630		ret = rtw_usb_write_port_sync(rtwdev, pkt_info.qsel, skb);
   631		if (ret)
   632			rtw_err(rtwdev, "failed to download rsvd page over USB, ret=%d\n",
   633				ret);
   634	
   635		dev_kfree_skb_any(skb);
   636	
   637		return ret;
   638	}
   639	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
