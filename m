Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6118C34CFC3
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2026 09:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774518104; cv=none; b=H+tc1J3NXoRS7tr/Bq2XHaQTBTd74LPkz30p5Q3CtGxoeK2gtToJOQAoevWQd2i9cPBC3tzJpx0qSAgSXgepfWMVMLQJEnCmoWhDSXha/grAxYEmgGrlZwrhhLRTiT8XGhGqAPtP7Uvit+Qn1wIH+BghvIOxx5OzhbHiiw2EA68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774518104; c=relaxed/simple;
	bh=Zx9y8XwTtPeFEXKPIT3f8JrBeN6tj267+ZQZMnclteE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HpLNnyYvQeLUKMwWdGola5uA6XBTdXMQsVOZEIVTy0lfcQ7lj2PkPJuQ/X2xCUC9r2jKHEXfxtPIaKw7ed1DT7SEgJgOij+sLm3fiGOv82RUs6JWfzJ0dNX1p2iqkmQWeW4gxQwnEWEr7DurTmjBfpAccM9KuWI/a/XpZxL0Wes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TVBHmtAd; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TVBHmtAd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774518103; x=1806054103;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zx9y8XwTtPeFEXKPIT3f8JrBeN6tj267+ZQZMnclteE=;
  b=TVBHmtAds9C22np8c41ymHY6Wtk+NSXwqfCkU57Wa+zKbqpklCrMvmoF
   3TbCZ5YcXGJ5IazJYgtIIKYEhDfvg3mwywjdURpOuUTJf8qP8BfqdPbs5
   0FGE1n/oGeMH4aYW9P35fzfdc5U3BRC8jaWCEip9DO/TgIMaKX5qbg6+R
   XVmLjddNcdjGP823XqxU3X53Ny3TpaMa2HSCBvxwvE61yUKyOIodhyyf7
   SrLqWVVNyTRBBpVbdARP08v7PbzRn9qOGG4binpCZf6wTarKxGgvyBuOF
   pPUO4twSELxyFSixjZGyx4NGza6+nETkMi0ILG2M7BK5mIVFfgT9sEL16
   g==;
X-CSE-ConnectionGUID: xErAxMeNSE6b9R72RuD7tg==
X-CSE-MsgGUID: tjF2/dsNQRaBOrrXaXxPMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="86944987"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="86944987"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2026 02:41:42 -0700
X-CSE-ConnectionGUID: PnX7rrChQfmeorTq4tdqhA==
X-CSE-MsgGUID: 36RD2GkkTtODpsI2dGSYyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="262870300"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa001.jf.intel.com with ESMTP; 26 Mar 2026 02:41:41 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5hDd-000000007Fd-33uV;
	Thu, 26 Mar 2026 09:41:37 +0000
Date: Thu, 26 Mar 2026 10:41:10 +0100
From: kernel test robot <lkp@intel.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: Fill fw_version member of struct
 wiphy
Message-ID: <202603261021.wmsdP9pa-lkp@intel.com>
References: <60bdb2f8-d5dd-46a3-8679-5b4a5fd0604b@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60bdb2f8-d5dd-46a3-8679-5b4a5fd0604b@gmail.com>

Hi Bitterblue,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main linus/master v7.0-rc5 next-20260325]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bitterblue-Smith/wifi-rtw89-Fill-fw_version-member-of-struct-wiphy/20260326-082721
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/60bdb2f8-d5dd-46a3-8679-5b4a5fd0604b%40gmail.com
patch subject: [PATCH rtw-next] wifi: rtw89: Fill fw_version member of struct wiphy
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20260326/202603261021.wmsdP9pa-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260326/202603261021.wmsdP9pa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603261021.wmsdP9pa-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/realtek/rtw89/fw.c: In function 'rtw89_fw_update_ver':
>> drivers/net/wireless/realtek/rtw89/fw.c:759:21: error: 'RTW89_FW_NORMAL_B' undeclared (first use in this function); did you mean 'RTW89_FW_NORMAL_CE'?
     759 |             type == RTW89_FW_NORMAL_B)
         |                     ^~~~~~~~~~~~~~~~~
         |                     RTW89_FW_NORMAL_CE
   drivers/net/wireless/realtek/rtw89/fw.c:759:21: note: each undeclared identifier is reported only once for each function it appears in


vim +759 drivers/net/wireless/realtek/rtw89/fw.c

   726	
   727	static int rtw89_fw_update_ver(struct rtw89_dev *rtwdev,
   728				       enum rtw89_fw_type type,
   729				       struct rtw89_fw_suit *fw_suit)
   730	{
   731		const struct rtw89_fw_hdr *v0 = (const struct rtw89_fw_hdr *)fw_suit->data;
   732		const struct rtw89_fw_hdr_v1 *v1 = (const struct rtw89_fw_hdr_v1 *)fw_suit->data;
   733	
   734		if (type == RTW89_FW_LOGFMT)
   735			return 0;
   736	
   737		fw_suit->type = type;
   738		fw_suit->hdr_ver = le32_get_bits(v0->w3, FW_HDR_W3_HDR_VER);
   739	
   740		switch (fw_suit->hdr_ver) {
   741		case 0:
   742			rtw89_fw_update_ver_v0(rtwdev, fw_suit, v0);
   743			break;
   744		case 1:
   745			rtw89_fw_update_ver_v1(rtwdev, fw_suit, v1);
   746			break;
   747		default:
   748			rtw89_err(rtwdev, "Unknown firmware header version %u\n",
   749				  fw_suit->hdr_ver);
   750			return -ENOENT;
   751		}
   752	
   753		rtw89_info(rtwdev,
   754			   "Firmware version %u.%u.%u.%u (%08x), cmd version %u, type %u\n",
   755			   fw_suit->major_ver, fw_suit->minor_ver, fw_suit->sub_ver,
   756			   fw_suit->sub_idex, fw_suit->commitid, fw_suit->cmd_ver, type);
   757	
   758		if (type == RTW89_FW_NORMAL || type == RTW89_FW_NORMAL_CE ||
 > 759		    type == RTW89_FW_NORMAL_B)
   760			snprintf(rtwdev->hw->wiphy->fw_version,
   761				 sizeof(rtwdev->hw->wiphy->fw_version),
   762				 "%u.%u.%u.%u",
   763				 fw_suit->major_ver, fw_suit->minor_ver,
   764				 fw_suit->sub_ver, fw_suit->sub_idex);
   765	
   766		return 0;
   767	}
   768	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
