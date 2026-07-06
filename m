Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3063E51E8
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 23:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783380157; cv=none; b=IQYv0Qp5j4e/+oRRnme4mJ1aNB0LGMcPq9pc+Q6Gn6Kh+DhrmbiIttQpg3eJbxF3HjwiiK3hHTtp+wL81iRtudI2jqXVw/JuneQuyB9lmAhsvlVQEP69GDFarclNtZ6Z5aYnLNg+RJaco+BsTUX0UY8E7jsWPW/2uoNgnKKY5Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783380157; c=relaxed/simple;
	bh=vO4s6xhEMClXGrWPVPOoEKtnPnAfXMwaB7BmgJpbNXU=;
	h=Date:From:To:Cc:Subject:Message-ID; b=hHTgSzJ5oAxCx9TrhAt70M3NgiOjsWbnsfvqfP2kKSMM+wPSKggLciE1cHPLnz0hTmgJxHKIxkXS5lbzruiO70IwubI5sdKIrJI2WiO3UUsxGn0Tn215JytXk3SWaFeL9YUH7O5p+ZIEf/iawxgkAj22JFhNPzFtmwmyCnPs/zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ILtdPw0e; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ILtdPw0e"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783380156; x=1814916156;
  h=date:from:to:cc:subject:message-id;
  bh=vO4s6xhEMClXGrWPVPOoEKtnPnAfXMwaB7BmgJpbNXU=;
  b=ILtdPw0eKRvVsPUqeHmzmGqVXUMNLci9dtQ5viCAEVfnN4vuDya10h2v
   KX9w0f5LeG0IWmOlKg2BciJXUlcNQN157JC648SnJ15QPfJBK/kPBiOVh
   F0YTqhcWQCe7XOgKCZgr/NOubTlSKHehe87kHLSoADKLTBtBzg3u2U7YA
   tLfQHANsCQd86a5TZ7xGuDZg+ZO5fP7AAUnN184jpBrjandFHOR/Pb6Dg
   sdCyAUjKTxp8tAnmDPecfZ0BsZwqQR63knqjceM3wTs8GjObmvS6ly+S8
   NLfZvsWFNFWEjVwokDeBt0ssArSs10x0mIcusmMITgSe8jrVqlQXFR1cp
   w==;
X-CSE-ConnectionGUID: n8B3x4CfTrCF9FosG7KK5A==
X-CSE-MsgGUID: zufuurWOSIuscNdTclgpag==
X-IronPort-AV: E=McAfee;i="6800,10657,11839"; a="84143362"
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="84143362"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2026 16:22:36 -0700
X-CSE-ConnectionGUID: LPmif3oeQreqexYGV2NSpw==
X-CSE-MsgGUID: AUubXpK4QmmDPISb+bVAAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,151,1779174000"; 
   d="scan'208";a="252770615"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 06 Jul 2026 16:22:35 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wgsdw-00000000EqT-3RJu;
	Mon, 06 Jul 2026 23:22:29 +0000
Date: Tue, 07 Jul 2026 07:21:50 +0800
From: kernel test robot <lkp@intel.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: oe-kbuild-all@lists.linux.dev,
 Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org
Subject: [wireless-next:main 2/99] (.text+0x4e00): multiple
 definition of `is_command_pending';
 drivers/net/wireless/marvell/mwifiex/main.o:(.text+0x5880): first defined
 here
Message-ID: <202607070740.1XekJylA-lkp@intel.com>
User-Agent: s-nail v14.9.25
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
head:   2bfd9da88b95d89041c91c06acd1c38258edc38b
commit: 4c477f8bfc1a86c54a719cae475f7fa1973eba0f [2/99] wifi: nxp: add nxpwifi driver for IW61x
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20260707/202607070740.1XekJylA-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260707/202607070740.1XekJylA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607070740.1XekJylA-lkp@intel.com/

All errors (new ones prefixed by >>):

   alpha-linux-ld: drivers/net/wireless/nxp/nxpwifi/main.o: in function `is_command_pending':
>> (.text+0x4e00): multiple definition of `is_command_pending'; drivers/net/wireless/marvell/mwifiex/main.o:(.text+0x5880): first defined here
   alpha-linux-ld: drivers/net/wireless/nxp/nxpwifi/main.o:(.data+0x0): multiple definition of `driver_version'; drivers/net/wireless/marvell/mwifiex/main.o:(.rodata+0x26a): first defined here
   alpha-linux-ld: drivers/net/wireless/nxp/nxpwifi/cfp.o:(.data+0x20): multiple definition of `region_code_index'; drivers/net/wireless/marvell/mwifiex/cfp.o:(.data+0x0): first defined here
>> alpha-linux-ld: drivers/net/wireless/nxp/nxpwifi/wmm.o:(.sdata+0x1c): multiple definition of `tos_to_tid_inv'; drivers/net/wireless/marvell/mwifiex/wmm.o:(.sdata+0x1c): first defined here

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
