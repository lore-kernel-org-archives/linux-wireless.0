Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbcBWKDk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:03:40 -0500
From: "Kolli, Anilkumar" <akolli@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	kbuild test robot <lkp@intel.com>
CC: "kbuild-all@01.org" <kbuild-all@01.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath10k: Reduce number of peers to support peer stats
 feature
Date: Tue, 23 Feb 2016 10:03:32 +0000
Message-ID: <2f5a14dd58c0415d9e05bcfc8906ca58@aphydexm01a.ap.qualcomm.com> (sfid-20160223_110345_638253_6BE79C67)
References: <1456210197-27892-1-git-send-email-akolli@qti.qualcomm.com>
 <201602231517.vRn3Bvit%fengguang.wu@intel.com>
In-Reply-To: <201602231517.vRn3Bvit%fengguang.wu@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This patch depends on 'ath10k: add support for parsing per STA rx_duration for 10.2.4',
Which is part of ath.git pending branch.

Thanks,
Anil.


-----Original Message-----
From: kbuild test robot [mailto:lkp@intel.com] 
Sent: Tuesday, February 23, 2016 12:40 PM
To: Kolli, Anilkumar
Cc: kbuild-all@01.org; ath10k@lists.infradead.org; linux-wireless@vger.kernel.org; Kolli, Anilkumar
Subject: Re: [PATCH] ath10k: Reduce number of peers to support peer stats feature

Hi Anilkumar,

[auto build test ERROR on wireless-drivers-next/master] [also build test ERROR on v4.5-rc5 next-20160223] [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/akolli-qti-qualcomm-com/ath10k-Reduce-number-of-peers-to-support-peer-stats-feature/20160223-145312
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
config: xtensa-allyesconfig (attached as .config)
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All errors (new ones prefixed by >>):

   drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_init_firmware_features':
>> drivers/net/wireless/ath/ath10k/core.c:1481:16: error: 
>> 'WMI_SERVICE_PEER_STATS' undeclared (first use in this function)
      if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
                   ^
   drivers/net/wireless/ath/ath10k/core.c:1481:16: note: each undeclared identifier is reported only once for each function it appears in
--
   drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_10_2_op_gen_init':
>> drivers/net/wireless/ath/ath10k/wmi.c:5464:15: error: 
>> 'WMI_SERVICE_PEER_STATS' undeclared (first use in this function)
     if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
                  ^
   drivers/net/wireless/ath/ath10k/wmi.c:5464:15: note: each undeclared identifier is reported only once for each function it appears in

vim +/WMI_SERVICE_PEER_STATS +1481 drivers/net/wireless/ath/ath10k/core.c

  1475				WMI_STAT_PEER;
  1476			ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
  1477			break;
  1478		case ATH10K_FW_WMI_OP_VERSION_10_1:
  1479		case ATH10K_FW_WMI_OP_VERSION_10_2:
  1480		case ATH10K_FW_WMI_OP_VERSION_10_2_4:
> 1481			if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map)) {
  1482				ar->max_num_peers = TARGET_10X_TX_STATS_NUM_PEERS;
  1483				ar->max_num_stations = TARGET_10X_TX_STATS_NUM_STATIONS;
  1484			} else {

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
