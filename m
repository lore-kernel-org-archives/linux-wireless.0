Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2KPWFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 17:05:35 -0500
Date: Sat, 17 Nov 2012 06:05:53 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Hante Meuleman <meuleman@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [wireless-next:master 183/188]
 drivers/net/wireless/brcm80211/brcmfmac/usb.c:1140:2: error: implicit
 declaration of function 'vmalloc'
Message-ID: <50a6b8c1.fzDS16CZ7aSARHrv%fengguang.wu@intel.com> (sfid-20121116_230539_330491_BE1EBA64)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
head:   57527f8d4d71b5167a02fb6713857f55d3974748
commit: b87e2c482510d56563873827783046a8eece5829 [183/188] brcmfmac: code cleanup
config: make ARCH=mips allmodconfig

All error/warnings:

drivers/net/wireless/brcm80211/brcmfmac/usb.c: In function 'brcmf_usb_get_fw':
drivers/net/wireless/brcm80211/brcmfmac/usb.c:1140:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
drivers/net/wireless/brcm80211/brcmfmac/usb.c:1140:18: warning: assignment makes pointer from integer without a cast [enabled by default]
drivers/net/wireless/brcm80211/brcmfmac/usb.c: In function 'brcmf_release_fw':
drivers/net/wireless/brcm80211/brcmfmac/usb.c:1512:3: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors

vim +1140 +/vmalloc drivers/net/wireless/brcm80211/brcmfmac/usb.c

803599d4 Hante Meuleman   2012-09-19  1134  	fw_image = kzalloc(sizeof(*fw_image), GFP_ATOMIC);
803599d4 Hante Meuleman   2012-09-19  1135  	if (!fw_image)
803599d4 Hante Meuleman   2012-09-19  1136  		return -ENOMEM;
803599d4 Hante Meuleman   2012-09-19  1137  	INIT_LIST_HEAD(&fw_image->list);
803599d4 Hante Meuleman   2012-09-19  1138  	list_add_tail(&fw_image->list, &fw_image_list);
803599d4 Hante Meuleman   2012-09-19  1139  	fw_image->fwname = fwname;
803599d4 Hante Meuleman   2012-09-19 @1140  	fw_image->image = vmalloc(fw->size);
803599d4 Hante Meuleman   2012-09-19  1141  	if (!fw_image->image)
71bb244b Arend van Spriel 2012-02-09  1142  		return -ENOMEM;
71bb244b Arend van Spriel 2012-02-09  1143  

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
