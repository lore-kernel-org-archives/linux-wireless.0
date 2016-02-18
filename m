Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:60111 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425406AbcBRKeF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 05:34:05 -0500
Date: Thu, 18 Feb 2016 18:33:32 +0800
From: kbuild test robot <lkp@intel.com>
To: Leo Kim <leo.kim@atmel.com>
Cc: kbuild-all@01.org, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 05/24] staging: wilc1000: removes potential null
 dereference
Message-ID: <201602181805.QPHUvJIo%fengguang.wu@intel.com> (sfid-20160218_113412_374604_BCF2B499)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455780455-21365-5-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Leo,

[auto build test WARNING on staging/staging-testing]
[also build test WARNING on next-20160217]
[cannot apply to v4.5-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Leo-Kim/staging-wilc1000-wilc_wlan-c-removes-PRINT_ER/20160218-153737


coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:1153:6-35: alloc with no test, possible model on line 1158
   drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:1192:6-35: alloc with no test, possible model on line 1197

vim +1153 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c

1f435d2e Glen Lee   2015-12-21  1147  				if (!g_gtk_keys_saved && netdev == wl->vif[0]->ndev) {
c5c77ba1 Johnny Kim 2015-05-11  1148  					g_add_gtk_key_params.key_idx = key_index;
c5c77ba1 Johnny Kim 2015-05-11  1149  					g_add_gtk_key_params.pairwise = pairwise;
c5c77ba1 Johnny Kim 2015-05-11  1150  					if (!mac_addr) {
c5c77ba1 Johnny Kim 2015-05-11  1151  						g_add_gtk_key_params.mac_addr = NULL;
c5c77ba1 Johnny Kim 2015-05-11  1152  					} else {
f3052587 Glen Lee   2015-09-10 @1153  						g_add_gtk_key_params.mac_addr = kmalloc(ETH_ALEN, GFP_KERNEL);
c5c77ba1 Johnny Kim 2015-05-11  1154  						memcpy(g_add_gtk_key_params.mac_addr, mac_addr, ETH_ALEN);
c5c77ba1 Johnny Kim 2015-05-11  1155  					}
c5c77ba1 Johnny Kim 2015-05-11  1156  					g_key_gtk_params.key_len = params->key_len;
c5c77ba1 Johnny Kim 2015-05-11  1157  					g_key_gtk_params.seq_len = params->seq_len;
f3052587 Glen Lee   2015-09-10 @1158  					g_key_gtk_params.key =  kmalloc(params->key_len, GFP_KERNEL);
bf287244 Leo Kim    2016-02-18  1159  					if (!g_key_gtk_params.key)
bf287244 Leo Kim    2016-02-18  1160  						return -ENOMEM;
c5c77ba1 Johnny Kim 2015-05-11  1161  					memcpy(g_key_gtk_params.key, params->key, params->key_len);

:::::: The code at line 1153 was first introduced by commit
:::::: f3052587e31ce8ac11c069d942a5cefb18025037 staging: wilc1000: remove kmalloc wrapper

:::::: TO: Glen Lee <glen.lee@atmel.com>
:::::: CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
