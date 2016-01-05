Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:49889 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbcAEM5n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 07:57:43 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: kbuild test robot <lkp@intel.com>
CC: "kbuild-all@01.org" <kbuild-all@01.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH 2/4] mwifiex: enable pcie MSIx interrupt mode support
Date: Tue, 5 Jan 2016 12:57:38 +0000
Message-ID: <20d9447a788a4a4daf709bd4d2622971@SC-EXCH04.marvell.com> (sfid-20160105_135757_182120_DBF946EE)
References: <1451571855-29449-2-git-send-email-akarwar@marvell.com>
 <201601010258.TdInjVcJ%fengguang.wu@intel.com>
In-Reply-To: <201601010258.TdInjVcJ%fengguang.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: kbuild test robot [mailto:lkp@intel.com]
> Sent: Thursday, December 31, 2015 11:33 PM
> To: Amitkumar Karwar
> Cc: kbuild-all@01.org; linux-wireless@vger.kernel.org; Cathy Luo;
> Nishant Sarmukadam; Xinming Hu; Amitkumar Karwar
> Subject: Re: [PATCH 2/4] mwifiex: enable pcie MSIx interrupt mode
> support
> 
> Hi Xinming,
> 
> [auto build test ERROR on wireless-drivers-next/master] [also build test
> ERROR on next-20151231] [cannot apply to v4.4-rc7] [if your patch is
> applied to the wrong git tree, please drop us a note to help improving
> the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Amitkumar-
> Karwar/mwifiex-fix-missing-debug-messages/20151231-222922
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-
> drivers-next.git master
> config: mips-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-
> tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=mips
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from
> drivers/net/wireless/marvell/mwifiex/main.h:45:0,
>                     from drivers/net/wireless/marvell/mwifiex/main.c:20:
> >> drivers/net/wireless/marvell/mwifiex/pcie.h:342:20: error: array type
> has incomplete element type 'struct msix_entry'
>      struct msix_entry msix_entries[MWIFIEX_NUM_MSIX_VECTORS];
>                        ^
> 
> vim +342 drivers/net/wireless/marvell/mwifiex/pcie.h
> 
>    336		u8 *sleep_cookie_vbase;
>    337		dma_addr_t sleep_cookie_pbase;
>    338		void __iomem *pci_mmap;
>    339		void __iomem *pci_mmap1;
>    340		int msi_enable;
>    341		int msix_enable;
>  > 342		struct msix_entry
> msix_entries[MWIFIEX_NUM_MSIX_VECTORS];
>    343		struct mwifiex_msix_context
> msix_ctx[MWIFIEX_NUM_MSIX_VECTORS];
>    344		struct mwifiex_msix_context share_irq_ctx;
>    345	};
> 

"struct msix_entry" has been defined in "include/linux/pci.h". We have already included this file. 
Any suggestions to fix this MIPS specific compilation error? OR it's just a false alarm.

Regards,
Amitkumar Karwar
