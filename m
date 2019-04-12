Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA9EC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 17:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD9392086D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 17:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfDLRxh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 13:53:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:38292 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbfDLRxg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 13:53:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Apr 2019 10:53:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,342,1549958400"; 
   d="scan'208";a="223019626"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2019 10:53:35 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hF0Mo-0001Kn-Ew; Sat, 13 Apr 2019 01:53:34 +0800
Date:   Sat, 13 Apr 2019 01:52:49 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Tamizh chelvam <tamizhr@codeaurora.org>
Cc:     kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: Re: [PATCHv3 2/2] mac80211: Implement API to configure station
 specific rssi threshold
Message-ID: <201904130145.GoWi9hOy%lkp@intel.com>
References: <1554831488-27065-3-git-send-email-tamizhr@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554831488-27065-3-git-send-email-tamizhr@codeaurora.org>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tamizh,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on next-20190412]
[cannot apply to v5.1-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Tamizh-chelvam/cfg80211-Add-support-to-configure-station-specific-RSSI-threshold-for-AP-mode/20190412-225220
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'


sparse warnings: (new ones prefixed by >>)

>> net/mac80211/cfg.c:3947:17: sparse: incompatible types in comparison expression (different address spaces)
--
>> net/mac80211/rx.c:1735:13: sparse: context imbalance in 'ieee80211_sta_rx_signal_thold_check' - wrong count at exit

vim +3947 net/mac80211/cfg.c

  3940	
  3941	void sta_mon_rssi_config_free(struct sta_info *sta)
  3942	{
  3943		struct sta_mon_rssi_config *old_rssi_config;
  3944	
  3945		if (sta->rssi_config) {
  3946			old_rssi_config = sta->rssi_config;
> 3947			RCU_INIT_POINTER(sta->rssi_config, NULL);
  3948			kfree_rcu(old_rssi_config, rcu_head);
  3949		}
  3950	}
  3951	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
