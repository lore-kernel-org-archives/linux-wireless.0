Return-Path: <SRS0=xn0B=OS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1369C07E85
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Dec 2018 09:17:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 936242082D
	for <linux-wireless@archiver.kernel.org>; Sun,  9 Dec 2018 09:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 936242082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbeLIJOD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 9 Dec 2018 04:14:03 -0500
Received: from mga05.intel.com ([192.55.52.43]:30290 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726079AbeLIJOC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Dec 2018 04:14:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2018 01:12:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,334,1539673200"; 
   d="gz'50?scan'50,208,50";a="97327362"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 09 Dec 2018 01:12:57 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gVv8y-000G6P-Tw; Sun, 09 Dec 2018 17:12:56 +0800
Date:   Sun, 9 Dec 2018 17:12:17 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     kbuild-all@01.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: Re: [PATCH 3/5] cfg80211: Move Multiple BSS info to struct
 cfg80211_bss to be visible
Message-ID: <201812091728.IvdwxBoy%fengguang.wu@intel.com>
References: <1544184650-14124-3-git-send-email-jouni@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1544184650-14124-3-git-send-email-jouni@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Sara,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v4.20-rc5 next-20181207]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Jouni-Malinen/cfg80211-Parsing-of-Multiple-BSSID-information-in-scanning/20181208-040803
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   kernel/resource.c:337: warning: Function parameter or member 'flags' not described in 'find_next_iomem_res'
   kernel/resource.c:337: warning: Function parameter or member 'desc' not described in 'find_next_iomem_res'
   kernel/resource.c:337: warning: Function parameter or member 'first_lvl' not described in 'find_next_iomem_res'
   kernel/resource.c:337: warning: Function parameter or member 'res' not described in 'find_next_iomem_res'
   kernel/resource.c:409: warning: Function parameter or member 'arg' not described in 'walk_iomem_res_desc'
   kernel/resource.c:409: warning: Function parameter or member 'func' not described in 'walk_iomem_res_desc'
   kernel/resource.c:409: warning: Function parameter or member 'arg' not described in 'walk_iomem_res_desc'
   kernel/resource.c:409: warning: Function parameter or member 'func' not described in 'walk_iomem_res_desc'
   include/linux/rcutree.h:1: warning: no structured comments found
   kernel/rcu/tree.c:684: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/srcu.h:175: warning: Function parameter or member 'p' not described in 'srcu_dereference_notrace'
   include/linux/srcu.h:175: warning: Function parameter or member 'sp' not described in 'srcu_dereference_notrace'
   include/linux/gfp.h:1: warning: no structured comments found
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.connect' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.keys' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.ie' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.ie_len' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.bssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.ssid' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.default_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.default_mgmt_key' not described in 'wireless_dev'
   include/net/cfg80211.h:4687: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
>> include/net/cfg80211.h:2035: warning: Function parameter or member 'transmitted_bss' not described in 'cfg80211_bss'
>> include/net/cfg80211.h:2035: warning: Function parameter or member 'nontrans_list' not described in 'cfg80211_bss'
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2848: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:2390: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2390: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1001: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:477: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '

vim +2035 include/net/cfg80211.h

9caf0364 Johannes Berg    2012-11-29  1983  
9caf0364 Johannes Berg    2012-11-29  1984  /**
2a519311 Johannes Berg    2009-02-10  1985   * struct cfg80211_bss - BSS description
2a519311 Johannes Berg    2009-02-10  1986   *
2a519311 Johannes Berg    2009-02-10  1987   * This structure describes a BSS (which may also be a mesh network)
2a519311 Johannes Berg    2009-02-10  1988   * for use in scan results and similar.
2a519311 Johannes Berg    2009-02-10  1989   *
abe37c4b Johannes Berg    2010-06-07  1990   * @channel: channel this BSS is on
dcd6eac1 Simon Wunderlich 2013-07-08  1991   * @scan_width: width of the control channel
2a519311 Johannes Berg    2009-02-10  1992   * @bssid: BSSID of the BSS
2a519311 Johannes Berg    2009-02-10  1993   * @beacon_interval: the beacon interval as from the frame
2a519311 Johannes Berg    2009-02-10  1994   * @capability: the capability field in host byte order
83c7aa1a Johannes Berg    2013-02-05  1995   * @ies: the information elements (Note that there is no guarantee that these
83c7aa1a Johannes Berg    2013-02-05  1996   *	are well-formed!); this is a pointer to either the beacon_ies or
83c7aa1a Johannes Berg    2013-02-05  1997   *	proberesp_ies depending on whether Probe Response frame has been
83c7aa1a Johannes Berg    2013-02-05  1998   *	received. It is always non-%NULL.
34a6eddb Jouni Malinen    2010-01-06  1999   * @beacon_ies: the information elements from the last Beacon frame
776b3580 Johannes Berg    2013-02-01  2000   *	(implementation note: if @hidden_beacon_bss is set this struct doesn't
776b3580 Johannes Berg    2013-02-01  2001   *	own the beacon_ies, but they're just pointers to the ones from the
776b3580 Johannes Berg    2013-02-01  2002   *	@hidden_beacon_bss struct)
34a6eddb Jouni Malinen    2010-01-06  2003   * @proberesp_ies: the information elements from the last Probe Response frame
776b3580 Johannes Berg    2013-02-01  2004   * @hidden_beacon_bss: in case this BSS struct represents a probe response from
776b3580 Johannes Berg    2013-02-01  2005   *	a BSS that hides the SSID in its beacon, this points to the BSS struct
776b3580 Johannes Berg    2013-02-01  2006   *	that holds the beacon data. @beacon_ies is still valid, of course, and
776b3580 Johannes Berg    2013-02-01  2007   *	points to the same data as hidden_beacon_bss->beacon_ies in that case.
77965c97 Johannes Berg    2009-02-18  2008   * @signal: signal strength value (type depends on the wiphy's signal_type)
983dafaa Sunil Dutt       2017-12-13  2009   * @chains: bitmask for filled values in @chain_signal.
983dafaa Sunil Dutt       2017-12-13  2010   * @chain_signal: per-chain signal strength of last received BSS in dBm.
2a519311 Johannes Berg    2009-02-10  2011   * @priv: private area for driver use, has at least wiphy->bss_priv_size bytes
2a519311 Johannes Berg    2009-02-10  2012   */
2a519311 Johannes Berg    2009-02-10  2013  struct cfg80211_bss {
2a519311 Johannes Berg    2009-02-10  2014  	struct ieee80211_channel *channel;
dcd6eac1 Simon Wunderlich 2013-07-08  2015  	enum nl80211_bss_scan_width scan_width;
2a519311 Johannes Berg    2009-02-10  2016  
9caf0364 Johannes Berg    2012-11-29  2017  	const struct cfg80211_bss_ies __rcu *ies;
9caf0364 Johannes Berg    2012-11-29  2018  	const struct cfg80211_bss_ies __rcu *beacon_ies;
9caf0364 Johannes Berg    2012-11-29  2019  	const struct cfg80211_bss_ies __rcu *proberesp_ies;
9caf0364 Johannes Berg    2012-11-29  2020  
776b3580 Johannes Berg    2013-02-01  2021  	struct cfg80211_bss *hidden_beacon_bss;
6ff7973a Sara Sharon      2018-12-07  2022  	struct cfg80211_bss *transmitted_bss;
6ff7973a Sara Sharon      2018-12-07  2023  	struct list_head nontrans_list;
9caf0364 Johannes Berg    2012-11-29  2024  
9caf0364 Johannes Berg    2012-11-29  2025  	s32 signal;
9caf0364 Johannes Berg    2012-11-29  2026  
2a519311 Johannes Berg    2009-02-10  2027  	u16 beacon_interval;
2a519311 Johannes Berg    2009-02-10  2028  	u16 capability;
2a519311 Johannes Berg    2009-02-10  2029  
9caf0364 Johannes Berg    2012-11-29  2030  	u8 bssid[ETH_ALEN];
983dafaa Sunil Dutt       2017-12-13  2031  	u8 chains;
983dafaa Sunil Dutt       2017-12-13  2032  	s8 chain_signal[IEEE80211_MAX_CHAINS];
2a519311 Johannes Berg    2009-02-10  2033  
1c06ef98 Johannes Berg    2012-12-28  2034  	u8 priv[0] __aligned(sizeof(void *));
2a519311 Johannes Berg    2009-02-10 @2035  };
2a519311 Johannes Berg    2009-02-10  2036  

:::::: The code at line 2035 was first introduced by commit
:::::: 2a5193119269062608582418deba7af82844159a cfg80211/nl80211: scanning (and mac80211 update to use it)

:::::: TO: Johannes Berg <johannes@sipsolutions.net>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--8t9RHnE3ZwKMSgU+
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/zlrjCmoWwAA

--8t9RHnE3ZwKMSgU+--
