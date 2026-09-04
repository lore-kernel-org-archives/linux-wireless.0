Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA89B3EC815
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 22:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788559810; cv=none; b=JtuLMqqDij0OG3G/O/Hh/YMF8qgpDuBdWMTZ+eVDQKlcjG3rSgSjX25YAxQmG7a2oPsWd5Tbr+nCZbm3MSlTUt4KPY6R33VZxP6JYTwA53enfk4/6TSN0bHQwxlpnPzZ9FdwdJr1CDU8tT4ExHD6cjMoRSaNKcqabYnlATWeLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788559810; c=relaxed/simple;
	bh=xrFcTPU7LdaBc+ex5en3r8tSpTx2+sxZOlvsV7U/qOo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QsFuNtnidPZM5bmFNnseXkTgCfUXNHs98u9EeZeH+M++WNZhPTt2XLoTL5wtvZfskZiaqGFfi9axC4beXB+xVWREBByDaYB8QceM/S9emyyXy90TgiPQX1+4BmCkYQ7u3pxOVrU2mku4WqKrIGHkt3cmx0CG+vcygd9FrXDIwWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d8tAuWCX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d8tAuWCX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788559807; x=1820095807;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xrFcTPU7LdaBc+ex5en3r8tSpTx2+sxZOlvsV7U/qOo=;
  b=d8tAuWCXn7wHWJuuDfhv8WIqjXQpCsdb3JhVn4dJ0ouDzKDFAU8wJugD
   SDhTxj3UREHoUmvm5XbSMkdzVGyv1Rqk40jrKC2PyNZYXGSLDB6SjEiO8
   OmuhtTvY4+xipJZvhj+1jdsM469C1wsvCDX5G7oPHPEHN0OMJVAKuFDmo
   0ceBwUQYdjRP6RRVKTBQkNL5R9goHti1atEMe4fBFa+EQ8AG6jYujE4Ll
   yMklQriaZtZviju/TwBouI0DdEpmKOu2m/ajG69vwD2l0Ojwhofk0D8+/
   BIpReWQd9pp6bB8mT8NyVXd/Opltwg63/zv1pS0cqRo+FqHTSoJk4hFCI
   g==;
X-CSE-ConnectionGUID: EItS7PvgSxS74OuEIjGABA==
X-CSE-MsgGUID: F97FVtqgQf2db+r8DSH4ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11896"; a="106434737"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="106434737"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 15:10:06 -0700
X-CSE-ConnectionGUID: iQUx5CfTS+KOh2u6wkvTvw==
X-CSE-MsgGUID: jZRCj0nvRi+L7traavRZPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="266896801"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 04 Sep 2026 15:10:04 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2c6j-00000000AD8-3tIz;
	Fri, 04 Sep 2026 22:10:01 +0000
Date: Sat, 5 Sep 2026 06:09:49 +0800
From: kernel test robot <lkp@intel.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>, i.mafifi17@gmail.com
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: Download the reserved page
 synchronously
Message-ID: <202609050523.VXiKq456-lkp@intel.com>
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
[also build test ERROR on wireless/main linus/master v7.3-rc1 next-20260903]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bitterblue-Smith/wifi-rtw88-usb-Download-the-reserved-page-synchronously/20260904-002447
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/fd7bbc79-03f9-4932-ada8-f555392d4485%40gmail.com
patch subject: [PATCH rtw-next] wifi: rtw88: usb: Download the reserved page synchronously
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20260905/202609050523.VXiKq456-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 0edd1b088cc36b4faee80358c925a91e16006258)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260905/202609050523.VXiKq456-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609050523.VXiKq456-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/net/wireless/realtek/rtw88/usb.c:623:41: error: incompatible pointer types passing 'struct rtw_tx_desc *' to parameter of type 'struct sk_buff *' [-Wincompatible-pointer-types]
     623 |         rtw_tx_fill_tx_desc(rtwdev, &pkt_info, pkt_desc);
         |                                                ^~~~~~~~
   drivers/net/wireless/realtek/rtw88/tx.h:99:55: note: passing argument to parameter 'skb' here
      99 |                          struct rtw_tx_pkt_info *pkt_info, struct sk_buff *skb);
         |                                                                            ^
>> drivers/net/wireless/realtek/rtw88/usb.c:624:49: error: incompatible pointer types passing 'struct rtw_tx_desc *' to parameter of type 'u8 *' (aka 'unsigned char *') [-Wincompatible-pointer-types]
     624 |         rtw_tx_fill_txdesc_checksum(rtwdev, &pkt_info, pkt_desc);
         |                                                        ^~~~~~~~
   drivers/net/wireless/realtek/rtw88/tx.h:136:17: note: passing argument to parameter 'txdesc' here
     136 |                                                u8 *txdesc)
         |                                                    ^
   2 errors generated.


vim +623 drivers/net/wireless/realtek/rtw88/usb.c

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
