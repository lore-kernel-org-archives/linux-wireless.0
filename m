Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793342917;
	b=LFKV1qcqRr8383nCLQDYtrOl1WeaVWYcMzOT2sUwYVIa2FFTkBYtsdSjSjOSsUny7am5
	 buZMRHQhDzT2JmDYtbp4iaZaQcW0Rt43mHSf9p7DYwaL9jxuOskWsgks/7qCcfji06siB
	 xppC0nkkjWq5TCcmULlE3u3FOFS2U1MfQ0zIX3x2Chdf5ptKhZ2NvkHeOMxNFd40M8she
	 DC7DJ1YmBnpwfYWShUqmx0DtAZJjCpOADvnaGJ8IaOVSkcjmGnVUwMnocFyLzgAr1wS+D
	 9ECwRynIiF6vRuaBTK4lBAAmT4L7k+Wu9lNecWaxEz/zDz/xuTUjEu8lVMvciHu2rGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793342917;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=cf6iy9oHtlZWbLxZ+1iZWA1366GURTBJ3phBMmkuzYc=;
	b=LzEhUDwwar3yE3q4x1XG+lvYRjaNlW0/+lJTyWtS/lrGjb82rjsvjXNotODnX9Koe8Ce
	 BhS9eeEmrG+k8GWxi0kTCTgx0+uw9t+X2cWPr+wbETUAzi6QyXTUhn5wTrH84Qlc/RE+V
	 /Tp8X08NGNwmg4VvoGdQc9GoiWo4FQlZiCmiYYgCfW1Mhbbna7EMSIX5DzG0Rxhb6WsWW
	 OXRs3CZiojjyjtkAu5Y+MU0k1oBDJLY1auBzbG88dP/j5VMji38iKX9AAyCTy52BGlOs2
	 HFXF0vhuhamDUECn6ipV7O+TjFgh5odpqpREV/mNNdNkp8MhjbqiKPS/oKTwEDjy2SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ngeg+OuW;
	arc=none smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DE4606A31C;
	Fri, 30 Oct 2026 06:48:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39DE4606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ngeg+OuW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793342915; x=1824878915;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IUQk8g38/sUWUuvYSNz6J7vGLBBv85cH4vsW/TIJkXM=;
  b=Ngeg+OuWkNGPl7Yav9Ji2fjgBgncte974V6wLO+zhW/Y3JyfInr2gynr
   n7dDbIiaIQdyd/2CvXGTPa7/EMd3q+WvcRsT+fRlfCOT5dbOeYqPFHrim
   BO409PMTiYmhKF20EQiaekBZ7pO6neE0GMmqHqyZLMs2Gi70Nsw3rBYgL
   J825VNKOGmyCz+Hnq70BtCeWwb16nk3TG0fPTorJ4djeHBUPdjOvQXoHx
   SOPLFi9xWmwfJHomVIY7bm4DYRKPdjB0N6Km7onBOfDgxLIlFkRQ4sWI/
   tenCIFoKxeGX8Oerfss6NNpLAdz23pV5dHZa6LieBfO7IuXwImdqvSsgl
   w==;
X-CSE-ConnectionGUID: hgqjGI6mTBi6QY73BrLHww==
X-CSE-MsgGUID: VZ0U1mTUSZy/mCKM3VD63w==
X-IronPort-AV: E=McAfee;i="6800,10657,11950"; a="1983091"
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="1983091"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 23:48:35 -0700
X-CSE-ConnectionGUID: oU40DDAvSRukqBvV7Q+8sg==
X-CSE-MsgGUID: UPMs6LhdT6+Q24nOkaQW6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,185,1787036400"; 
   d="scan'208";a="7189165"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa011.fm.intel.com with ESMTP; 29 Oct 2026 23:48:33 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMgPe-00000000bOq-1sbR;
	Fri, 30 Oct 2026 06:48:30 +0000
Date: Fri, 30 Oct 2026 14:47:35 +0800
From: kernel test robot <lkp@intel.com>
To: Krzysztof Kozlowski <krzk@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] wifi: ath10k: Drop unused qmi_elem_info arrays
Message-ID: <202610301453.rMXyuD6F-lkp@intel.com>
References: <20261029111127.85147-2-krzysztof.kozlowski@oss.qualcomm.com>
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
In-Reply-To: <20261029111127.85147-2-krzysztof.kozlowski@oss.qualcomm.com>

Hi Krzysztof,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ath/ath-next]
[also build test WARNING on wireless/main wireless-next/main linus/master v7.3 next-20261029]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Krzysztof-Kozlowski/wifi-ath10k-Drop-unused-qmi_elem_info-arrays/20261029-121128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ath/ath.git ath-next
patch link:    https://lore.kernel.org/r/20261029111127.85147-2-krzysztof.kozlowski%40oss.qualcomm.com
patch subject: [PATCH] wifi: ath10k: Drop unused qmi_elem_info arrays
config: arm64-defconfig (https://download.01.org/0day-ci/archive/20261030/202610301453.rMXyuD6F-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261030/202610301453.rMXyuD6F-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610301453.rMXyuD6F-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c:229:35: warning: 'wlfw_mem_seg_resp_s_v01_ei' defined but not used [-Wunused-const-variable=]
     229 | static const struct qmi_elem_info wlfw_mem_seg_resp_s_v01_ei[] = {
         |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c:188:35: warning: 'wlfw_mem_seg_s_v01_ei' defined but not used [-Wunused-const-variable=]
     188 | static const struct qmi_elem_info wlfw_mem_seg_s_v01_ei[] = {
         |                                   ^~~~~~~~~~~~~~~~~~~~~


vim +/wlfw_mem_seg_resp_s_v01_ei +229 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c

bc17d4b90cdd3e5 Govind Singh 2018-10-11  187  
11e1fcf2b494da8 Jeff Johnson 2022-09-14 @188  static const struct qmi_elem_info wlfw_mem_seg_s_v01_ei[] = {
bc17d4b90cdd3e5 Govind Singh 2018-10-11  189  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  190  		.data_type      = QMI_UNSIGNED_4_BYTE,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  191  		.elem_len       = 1,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  192  		.elem_size      = sizeof(u32),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  193  		.array_type     = NO_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  194  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  195  		.offset         = offsetof(struct wlfw_mem_seg_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  196  					   size),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  197  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  198  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  199  		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  200  		.elem_len       = 1,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  201  		.elem_size      = sizeof(enum wlfw_mem_type_enum_v01),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  202  		.array_type     = NO_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  203  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  204  		.offset         = offsetof(struct wlfw_mem_seg_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  205  					   type),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  206  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  207  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  208  		.data_type      = QMI_DATA_LEN,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  209  		.elem_len       = 1,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  210  		.elem_size      = sizeof(u8),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  211  		.array_type     = NO_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  212  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  213  		.offset         = offsetof(struct wlfw_mem_seg_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  214  					   mem_cfg_len),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  215  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  216  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  217  		.data_type      = QMI_STRUCT,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  218  		.elem_len       = QMI_WLFW_MAX_NUM_MEM_CFG_V01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  219  		.elem_size      = sizeof(struct wlfw_mem_cfg_s_v01),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  220  		.array_type       = VAR_LEN_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  221  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  222  		.offset         = offsetof(struct wlfw_mem_seg_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  223  					   mem_cfg),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  224  		.ei_array      = wlfw_mem_cfg_s_v01_ei,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  225  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  226  	{}
bc17d4b90cdd3e5 Govind Singh 2018-10-11  227  };
bc17d4b90cdd3e5 Govind Singh 2018-10-11  228  
11e1fcf2b494da8 Jeff Johnson 2022-09-14 @229  static const struct qmi_elem_info wlfw_mem_seg_resp_s_v01_ei[] = {
bc17d4b90cdd3e5 Govind Singh 2018-10-11  230  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  231  		.data_type      = QMI_UNSIGNED_8_BYTE,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  232  		.elem_len       = 1,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  233  		.elem_size      = sizeof(u64),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  234  		.array_type     = NO_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  235  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  236  		.offset         = offsetof(struct wlfw_mem_seg_resp_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  237  					   addr),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  238  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  239  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  240  		.data_type      = QMI_UNSIGNED_4_BYTE,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  241  		.elem_len       = 1,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  242  		.elem_size      = sizeof(u32),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  243  		.array_type     = NO_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  244  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  245  		.offset         = offsetof(struct wlfw_mem_seg_resp_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  246  					   size),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  247  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  248  	{
bc17d4b90cdd3e5 Govind Singh 2018-10-11  249  		.data_type      = QMI_SIGNED_4_BYTE_ENUM,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  250  		.elem_len       = 1,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  251  		.elem_size      = sizeof(enum wlfw_mem_type_enum_v01),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  252  		.array_type     = NO_ARRAY,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  253  		.tlv_type       = 0,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  254  		.offset         = offsetof(struct wlfw_mem_seg_resp_s_v01,
bc17d4b90cdd3e5 Govind Singh 2018-10-11  255  					   type),
bc17d4b90cdd3e5 Govind Singh 2018-10-11  256  	},
bc17d4b90cdd3e5 Govind Singh 2018-10-11  257  	{}
bc17d4b90cdd3e5 Govind Singh 2018-10-11  258  };
bc17d4b90cdd3e5 Govind Singh 2018-10-11  259  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
