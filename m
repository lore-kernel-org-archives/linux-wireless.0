Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6847C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 15:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE4720643
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 15:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730218AbeLSP36 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 10:29:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:44816 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728764AbeLSP34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 10:29:56 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 07:29:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,373,1539673200"; 
   d="gz'50?scan'50,208,50";a="102893835"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 19 Dec 2018 07:29:50 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gZdnC-000Aq1-4i; Wed, 19 Dec 2018 23:29:50 +0800
Date:   Wed, 19 Dec 2018 23:29:10 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Louie Lu <git@louie.lu>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH v5 3/6] mac80211: Add airtime accounting and scheduling
 to TXQs
Message-ID: <201812192356.uCqnbW8W%fengguang.wu@intel.com>
References: <1545181331-5288-4-git-send-email-rmanohar@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1545181331-5288-4-git-send-email-rmanohar@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Toke,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mac80211/master]
[also build test WARNING on v4.20-rc7]
[cannot apply to next-20181219]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rajkumar-Manoharan/Move-TXQ-scheduling-and-airtime-fairness-into-mac80211/20181219-132034
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git master
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/cfg80211.h:4447: warning: Function parameter or member 'wext.prev_bssid_valid' not described in 'wireless_dev'
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/cfg80211.h:2846: warning: cannot understand function prototype: 'struct cfg80211_ftm_responder_stats '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:2400: warning: Function parameter or member 'radiotap_timestamp.units_pos' not described in 'ieee80211_hw'
   include/net/mac80211.h:2400: warning: Function parameter or member 'radiotap_timestamp.accuracy' not described in 'ieee80211_hw'
>> include/net/mac80211.h:2400: warning: Function parameter or member 'weight_multiplier' not described in 'ieee80211_hw'
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.rts_cts_rate_idx' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.use_rts' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.use_cts_prot' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.short_preamble' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.skip_table' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.jiffies' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.vif' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.hw_key' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.flags' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'control.enqueue_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'ack' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'ack.cookie' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.ampdu_ack_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.ampdu_len' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.antenna' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.tx_time' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.is_valid_ack_signal' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'status.status_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'driver_rates' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'pad' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:1007: warning: Function parameter or member 'rate_driver_data' not described in 'ieee80211_tx_info'
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   include/net/mac80211.h:483: warning: cannot understand function prototype: 'struct ieee80211_ftm_responder_params '
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'rx_stats_avg' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'rx_stats_avg.signal' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'rx_stats_avg.chain_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.filtered' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.retry_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.retry_count' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.lost_packets' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.last_tdls_pkt_time' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.msdu_retries' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.msdu_failed' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.last_ack' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.last_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.ack_signal_filled' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'status_stats.avg_ack_signal' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'tx_stats.packets' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'tx_stats.bytes' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'tx_stats.last_rate' not described in 'sta_info'
   net/mac80211/sta_info.h:601: warning: Function parameter or member 'tx_stats.msdu' not described in 'sta_info'
>> net/mac80211/sta_info.h:601: warning: Function parameter or member 'airtime' not described in 'sta_info'
>> net/mac80211/sta_info.h:601: warning: Function parameter or member 'airtime_weight' not described in 'sta_info'
   kernel/rcu/tree.c:685: warning: Excess function parameter 'irq' description in 'rcu_nmi_exit'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_excl.active' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.cb' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.poll' not described in 'dma_buf'
   include/linux/dma-buf.h:304: warning: Function parameter or member 'cb_shared.active' not described in 'dma_buf'
   include/linux/dma-fence-array.h:54: warning: Function parameter or member 'work' not described in 'dma_fence_array'
   include/linux/gpio/driver.h:375: warning: Function parameter or member 'init_valid_mask' not described in 'gpio_chip'
   include/linux/iio/hw-consumer.h:1: warning: no structured comments found
   include/linux/input/sparse-keymap.h:46: warning: Function parameter or member 'sw' not described in 'key_entry'
   include/linux/regulator/driver.h:227: warning: Function parameter or member 'resume' not described in 'regulator_ops'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw0' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw1' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw2' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.esw3' not described in 'irb'
   arch/s390/include/asm/cio.h:245: warning: Function parameter or member 'esw.eadm' not described in 'irb'
   drivers/slimbus/stream.c:1: warning: no structured comments found
   include/linux/spi/spi.h:177: warning: Function parameter or member 'driver_override' not described in 'spi_device'
   drivers/target/target_core_device.c:1: warning: no structured comments found
   drivers/usb/typec/bus.c:1: warning: no structured comments found
   drivers/usb/typec/class.c:1: warning: no structured comments found
   include/linux/w1.h:281: warning: Function parameter or member 'of_match_table' not described in 'w1_family'
   fs/direct-io.c:257: warning: Excess function parameter 'offset' description in 'dio_complete'
   fs/file_table.c:1: warning: no structured comments found
   fs/libfs.c:477: warning: Excess function parameter 'available' description in 'simple_write_end'
   fs/posix_acl.c:646: warning: Function parameter or member 'inode' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'mode_p' not described in 'posix_acl_update_mode'
   fs/posix_acl.c:646: warning: Function parameter or member 'acl' not described in 'posix_acl_update_mode'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:183: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_read_lock'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:254: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_gfx'
   drivers/gpu/drm/amd/amdgpu/amdgpu_mn.c:302: warning: Function parameter or member 'blockable' not described in 'amdgpu_mn_invalidate_range_start_hsa'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:382: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:383: warning: cannot understand function prototype: 'struct amdgpu_vm_pt_cursor '
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'end' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:555: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:603: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:848: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1356: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1523: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3100: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_mode_config.h:869: warning: Function parameter or member 'quirk_addfb_prefer_xbgr_30bpp' not described in 'drm_mode_config'
   drivers/gpu/drm/i915/i915_vma.h:49: warning: cannot understand function prototype: 'struct i915_vma '
   drivers/gpu/drm/i915/i915_vma.h:1: warning: no structured comments found
   drivers/gpu/drm/i915/intel_guc_fwif.h:554: warning: cannot understand function prototype: 'struct guc_log_buffer_state '
   drivers/gpu/drm/i915/i915_trace.h:1: warning: no structured comments found
   include/linux/skbuff.h:862: warning: Function parameter or member 'dev_scratch' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'list' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'ip_defrag_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'skb_mstamp_ns' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member '__cloned_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'head_frag' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member '__pkt_type_offset' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'encapsulation' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'encap_hdr_csum' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_valid' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_complete_sw' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'csum_level' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'inner_protocol_type' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'remcsum_offload' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'offload_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'offload_mr_fwd_mark' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'sender_cpu' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'reserved_tailroom' not described in 'sk_buff'
   include/linux/skbuff.h:862: warning: Function parameter or member 'inner_ipproto' not described in 'sk_buff'
   include/net/sock.h:238: warning: Function parameter or member 'skc_addrpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_portpair' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_ipv6only' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_net_refcnt' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_daddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_v6_rcv_saddr' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_cookie' not described in 'sock_common'
   include/net/sock.h:238: warning: Function parameter or member 'skc_listener' not described in 'sock_common'

vim +2400 include/net/mac80211.h

1bc0826c8f Johannes Berg          2007-09-18  2242  
7ac1bd6aec Johannes Berg          2007-09-14  2243  /**
7ac1bd6aec Johannes Berg          2007-09-14  2244   * struct ieee80211_hw - hardware information and state
75a5f0ccfd Johannes Berg          2007-09-18  2245   *
75a5f0ccfd Johannes Berg          2007-09-18  2246   * This structure contains the configuration and hardware
75a5f0ccfd Johannes Berg          2007-09-18  2247   * information for an 802.11 PHY.
75a5f0ccfd Johannes Berg          2007-09-18  2248   *
75a5f0ccfd Johannes Berg          2007-09-18  2249   * @wiphy: This points to the &struct wiphy allocated for this
75a5f0ccfd Johannes Berg          2007-09-18  2250   *	802.11 PHY. You must fill in the @perm_addr and @dev
75a5f0ccfd Johannes Berg          2007-09-18  2251   *	members of this structure using SET_IEEE80211_DEV()
8318d78a44 Johannes Berg          2008-01-24  2252   *	and SET_IEEE80211_PERM_ADDR(). Additionally, all supported
8318d78a44 Johannes Berg          2008-01-24  2253   *	bands (with channels, bitrates) are registered here.
75a5f0ccfd Johannes Berg          2007-09-18  2254   *
75a5f0ccfd Johannes Berg          2007-09-18  2255   * @conf: &struct ieee80211_conf, device configuration, don't use.
75a5f0ccfd Johannes Berg          2007-09-18  2256   *
75a5f0ccfd Johannes Berg          2007-09-18  2257   * @priv: pointer to private area that was allocated for driver use
75a5f0ccfd Johannes Berg          2007-09-18  2258   *	along with this structure.
75a5f0ccfd Johannes Berg          2007-09-18  2259   *
75a5f0ccfd Johannes Berg          2007-09-18  2260   * @flags: hardware flags, see &enum ieee80211_hw_flags.
75a5f0ccfd Johannes Berg          2007-09-18  2261   *
75a5f0ccfd Johannes Berg          2007-09-18  2262   * @extra_tx_headroom: headroom to reserve in each transmit skb
75a5f0ccfd Johannes Berg          2007-09-18  2263   *	for use by the driver (e.g. for transmit headers.)
75a5f0ccfd Johannes Berg          2007-09-18  2264   *
70dabeb74e Felix Fietkau          2013-12-14  2265   * @extra_beacon_tailroom: tailroom to reserve in each beacon tx skb.
70dabeb74e Felix Fietkau          2013-12-14  2266   *	Can be used by drivers to add extra IEs.
75a5f0ccfd Johannes Berg          2007-09-18  2267   *
566bfe5a8b Bruno Randolf          2008-05-08  2268   * @max_signal: Maximum value for signal (rssi) in RX information, used
566bfe5a8b Bruno Randolf          2008-05-08  2269   *	only when @IEEE80211_HW_SIGNAL_UNSPEC or @IEEE80211_HW_SIGNAL_DB
75a5f0ccfd Johannes Berg          2007-09-18  2270   *
ea95bba41e Tomas Winkler          2008-07-18  2271   * @max_listen_interval: max listen interval in units of beacon interval
ea95bba41e Tomas Winkler          2008-07-18  2272   *	that HW supports
ea95bba41e Tomas Winkler          2008-07-18  2273   *
75a5f0ccfd Johannes Berg          2007-09-18  2274   * @queues: number of available hardware transmit queues for
e100bb64bf Johannes Berg          2008-04-30  2275   *	data packets. WMM/QoS requires at least four, these
e100bb64bf Johannes Berg          2008-04-30  2276   *	queues need to have configurable access parameters.
e100bb64bf Johannes Berg          2008-04-30  2277   *
830f903866 Johannes Berg          2007-10-28  2278   * @rate_control_algorithm: rate control algorithm for this hardware.
830f903866 Johannes Berg          2007-10-28  2279   *	If unset (NULL), the default algorithm will be used. Must be
830f903866 Johannes Berg          2007-10-28  2280   *	set before calling ieee80211_register_hw().
32bfd35d4b Johannes Berg          2007-12-19  2281   *
32bfd35d4b Johannes Berg          2007-12-19  2282   * @vif_data_size: size (in bytes) of the drv_priv data area
32bfd35d4b Johannes Berg          2007-12-19  2283   *	within &struct ieee80211_vif.
17741cdc26 Johannes Berg          2008-09-11  2284   * @sta_data_size: size (in bytes) of the drv_priv data area
17741cdc26 Johannes Berg          2008-09-11  2285   *	within &struct ieee80211_sta.
d01a1e6586 Michal Kazior          2012-06-26  2286   * @chanctx_data_size: size (in bytes) of the drv_priv data area
d01a1e6586 Michal Kazior          2012-06-26  2287   *	within &struct ieee80211_chanctx_conf.
ba8c3d6f16 Felix Fietkau          2015-03-27  2288   * @txq_data_size: size (in bytes) of the drv_priv data area
ba8c3d6f16 Felix Fietkau          2015-03-27  2289   *	within @struct ieee80211_txq.
870abdf671 Felix Fietkau          2008-10-05  2290   *
78be49ec2a Helmut Schaa           2010-10-02  2291   * @max_rates: maximum number of alternate rate retry stages the hw
78be49ec2a Helmut Schaa           2010-10-02  2292   *	can handle.
78be49ec2a Helmut Schaa           2010-10-02  2293   * @max_report_rates: maximum number of alternate rate retry stages
78be49ec2a Helmut Schaa           2010-10-02  2294   *	the hw can report back.
e6a9854b05 Johannes Berg          2008-10-21  2295   * @max_rate_tries: maximum number of tries for each stage
4e6cbfd09c John W. Linville       2010-07-29  2296   *
df6ba5d80d Luciano Coelho         2011-01-12  2297   * @max_rx_aggregation_subframes: maximum buffer size (number of
df6ba5d80d Luciano Coelho         2011-01-12  2298   *	sub-frames) to be used for A-MPDU block ack receiver
df6ba5d80d Luciano Coelho         2011-01-12  2299   *	aggregation.
df6ba5d80d Luciano Coelho         2011-01-12  2300   *	This is only relevant if the device has restrictions on the
df6ba5d80d Luciano Coelho         2011-01-12  2301   *	number of subframes, if it relies on mac80211 to do reordering
df6ba5d80d Luciano Coelho         2011-01-12  2302   *	it shouldn't be set.
5dd36bc933 Johannes Berg          2011-01-18  2303   *
5dd36bc933 Johannes Berg          2011-01-18  2304   * @max_tx_aggregation_subframes: maximum number of subframes in an
41cbb0f5a2 Luca Coelho            2018-06-09  2305   *	aggregate an HT/HE device will transmit. In HT AddBA we'll
41cbb0f5a2 Luca Coelho            2018-06-09  2306   *	advertise a constant value of 64 as some older APs crash if
41cbb0f5a2 Luca Coelho            2018-06-09  2307   *	the window size is smaller (an example is LinkSys WRT120N
41cbb0f5a2 Luca Coelho            2018-06-09  2308   *	with FW v1.0.07 build 002 Jun 18 2012).
41cbb0f5a2 Luca Coelho            2018-06-09  2309   *	For AddBA to HE capable peers this value will be used.
3a25a8c8b7 Johannes Berg          2012-04-03  2310   *
6e0456b545 Felix Fietkau          2016-03-03  2311   * @max_tx_fragments: maximum number of tx buffers per (A)-MSDU, sum
6e0456b545 Felix Fietkau          2016-03-03  2312   *	of 1 + skb_shinfo(skb)->nr_frags for each skb in the frag_list.
6e0456b545 Felix Fietkau          2016-03-03  2313   *
3a25a8c8b7 Johannes Berg          2012-04-03  2314   * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
3a25a8c8b7 Johannes Berg          2012-04-03  2315   *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
ac55d2fe05 Johannes Berg          2012-05-10  2316   *
ac55d2fe05 Johannes Berg          2012-05-10  2317   * @radiotap_mcs_details: lists which MCS information can the HW
ac55d2fe05 Johannes Berg          2012-05-10  2318   *	reports, by default it is set to _MCS, _GI and _BW but doesn't
b4f7f4ad42 Jani Nikula            2016-10-21  2319   *	include _FMT. Use %IEEE80211_RADIOTAP_MCS_HAVE_\* values, only
ac55d2fe05 Johannes Berg          2012-05-10  2320   *	adding _BW is supported today.
72d7872852 Arik Nemtsov           2012-05-10  2321   *
5164892184 Johannes Berg          2012-11-22  2322   * @radiotap_vht_details: lists which VHT MCS information the HW reports,
5164892184 Johannes Berg          2012-11-22  2323   *	the default is _GI | _BANDWIDTH.
b4f7f4ad42 Jani Nikula            2016-10-21  2324   *	Use the %IEEE80211_RADIOTAP_VHT_KNOWN_\* values.
5164892184 Johannes Berg          2012-11-22  2325   *
41cbb0f5a2 Luca Coelho            2018-06-09  2326   * @radiotap_he: HE radiotap validity flags
41cbb0f5a2 Luca Coelho            2018-06-09  2327   *
99ee7cae3b Johannes Berg          2016-08-29  2328   * @radiotap_timestamp: Information for the radiotap timestamp field; if the
99ee7cae3b Johannes Berg          2016-08-29  2329   *	'units_pos' member is set to a non-negative value it must be set to
99ee7cae3b Johannes Berg          2016-08-29  2330   *	a combination of a IEEE80211_RADIOTAP_TIMESTAMP_UNIT_* and a
99ee7cae3b Johannes Berg          2016-08-29  2331   *	IEEE80211_RADIOTAP_TIMESTAMP_SPOS_* value, and then the timestamp
99ee7cae3b Johannes Berg          2016-08-29  2332   *	field will be added and populated from the &struct ieee80211_rx_status
99ee7cae3b Johannes Berg          2016-08-29  2333   *	device_timestamp. If the 'accuracy' member is non-negative, it's put
99ee7cae3b Johannes Berg          2016-08-29  2334   *	into the accuracy radiotap field and the accuracy known flag is set.
99ee7cae3b Johannes Berg          2016-08-29  2335   *
72d7872852 Arik Nemtsov           2012-05-10  2336   * @netdev_features: netdev features to be set in each netdev created
680a0daba7 Johannes Berg          2015-04-13  2337   *	from this HW. Note that not all features are usable with mac80211,
680a0daba7 Johannes Berg          2015-04-13  2338   *	other features will be rejected during HW registration.
219c38674c Alexander Bondar       2013-01-22  2339   *
219c38674c Alexander Bondar       2013-01-22  2340   * @uapsd_queues: This bitmap is included in (re)association frame to indicate
219c38674c Alexander Bondar       2013-01-22  2341   *	for each access category if it is uAPSD trigger-enabled and delivery-
219c38674c Alexander Bondar       2013-01-22  2342   *	enabled. Use IEEE80211_WMM_IE_STA_QOSINFO_AC_* to set this bitmap.
219c38674c Alexander Bondar       2013-01-22  2343   *	Each bit corresponds to different AC. Value '1' in specific bit means
219c38674c Alexander Bondar       2013-01-22  2344   *	that corresponding AC is both trigger- and delivery-enabled. '0' means
219c38674c Alexander Bondar       2013-01-22  2345   *	neither enabled.
219c38674c Alexander Bondar       2013-01-22  2346   *
219c38674c Alexander Bondar       2013-01-22  2347   * @uapsd_max_sp_len: maximum number of total buffered frames the WMM AP may
219c38674c Alexander Bondar       2013-01-22  2348   *	deliver to a WMM STA during any Service Period triggered by the WMM STA.
219c38674c Alexander Bondar       2013-01-22  2349   *	Use IEEE80211_WMM_IE_STA_QOSINFO_SP_* for correct values.
2475b1cc0d Max Stepanov           2013-03-24  2350   *
2475b1cc0d Max Stepanov           2013-03-24  2351   * @n_cipher_schemes: a size of an array of cipher schemes definitions.
2475b1cc0d Max Stepanov           2013-03-24  2352   * @cipher_schemes: a pointer to an array of cipher scheme definitions
2475b1cc0d Max Stepanov           2013-03-24  2353   *	supported by HW.
167e33f4f6 Ayala Beker            2016-09-20  2354   * @max_nan_de_entries: maximum number of NAN DE functions supported by the
167e33f4f6 Ayala Beker            2016-09-20  2355   *	device.
70e53669c4 Wen Gong               2018-08-08  2356   *
70e53669c4 Wen Gong               2018-08-08  2357   * @tx_sk_pacing_shift: Pacing shift to set on TCP sockets when frames from
70e53669c4 Wen Gong               2018-08-08  2358   *	them are encountered. The default should typically not be changed,
70e53669c4 Wen Gong               2018-08-08  2359   *	unless the driver has good reasons for needing more buffers.
1053390d02 Toke Høiland-Jørgensen 2018-12-18  2360   *
1053390d02 Toke Høiland-Jørgensen 2018-12-18  2361   * @weight_multipler: Driver specific airtime weight multiplier used while
1053390d02 Toke Høiland-Jørgensen 2018-12-18  2362   *	refilling deficit of each TXQ.
7ac1bd6aec Johannes Berg          2007-09-14  2363   */
f0706e828e Jiri Benc              2007-05-05  2364  struct ieee80211_hw {
f0706e828e Jiri Benc              2007-05-05  2365  	struct ieee80211_conf conf;
75a5f0ccfd Johannes Berg          2007-09-18  2366  	struct wiphy *wiphy;
830f903866 Johannes Berg          2007-10-28  2367  	const char *rate_control_algorithm;
f0706e828e Jiri Benc              2007-05-05  2368  	void *priv;
30686bf7f5 Johannes Berg          2015-06-02  2369  	unsigned long flags[BITS_TO_LONGS(NUM_IEEE80211_HW_FLAGS)];
f0706e828e Jiri Benc              2007-05-05  2370  	unsigned int extra_tx_headroom;
70dabeb74e Felix Fietkau          2013-12-14  2371  	unsigned int extra_beacon_tailroom;
32bfd35d4b Johannes Berg          2007-12-19  2372  	int vif_data_size;
17741cdc26 Johannes Berg          2008-09-11  2373  	int sta_data_size;
d01a1e6586 Michal Kazior          2012-06-26  2374  	int chanctx_data_size;
ba8c3d6f16 Felix Fietkau          2015-03-27  2375  	int txq_data_size;
ea95bba41e Tomas Winkler          2008-07-18  2376  	u16 queues;
ea95bba41e Tomas Winkler          2008-07-18  2377  	u16 max_listen_interval;
f0706e828e Jiri Benc              2007-05-05  2378  	s8 max_signal;
e6a9854b05 Johannes Berg          2008-10-21  2379  	u8 max_rates;
78be49ec2a Helmut Schaa           2010-10-02  2380  	u8 max_report_rates;
e6a9854b05 Johannes Berg          2008-10-21  2381  	u8 max_rate_tries;
41cbb0f5a2 Luca Coelho            2018-06-09  2382  	u16 max_rx_aggregation_subframes;
41cbb0f5a2 Luca Coelho            2018-06-09  2383  	u16 max_tx_aggregation_subframes;
6e0456b545 Felix Fietkau          2016-03-03  2384  	u8 max_tx_fragments;
3a25a8c8b7 Johannes Berg          2012-04-03  2385  	u8 offchannel_tx_hw_queue;
ac55d2fe05 Johannes Berg          2012-05-10  2386  	u8 radiotap_mcs_details;
5164892184 Johannes Berg          2012-11-22  2387  	u16 radiotap_vht_details;
99ee7cae3b Johannes Berg          2016-08-29  2388  	struct {
99ee7cae3b Johannes Berg          2016-08-29  2389  		int units_pos;
99ee7cae3b Johannes Berg          2016-08-29  2390  		s16 accuracy;
99ee7cae3b Johannes Berg          2016-08-29  2391  	} radiotap_timestamp;
72d7872852 Arik Nemtsov           2012-05-10  2392  	netdev_features_t netdev_features;
219c38674c Alexander Bondar       2013-01-22  2393  	u8 uapsd_queues;
219c38674c Alexander Bondar       2013-01-22  2394  	u8 uapsd_max_sp_len;
2475b1cc0d Max Stepanov           2013-03-24  2395  	u8 n_cipher_schemes;
2475b1cc0d Max Stepanov           2013-03-24  2396  	const struct ieee80211_cipher_scheme *cipher_schemes;
167e33f4f6 Ayala Beker            2016-09-20  2397  	u8 max_nan_de_entries;
70e53669c4 Wen Gong               2018-08-08  2398  	u8 tx_sk_pacing_shift;
1053390d02 Toke Høiland-Jørgensen 2018-12-18  2399  	u8 weight_multiplier;
f0706e828e Jiri Benc              2007-05-05 @2400  };
f0706e828e Jiri Benc              2007-05-05  2401  

:::::: The code at line 2400 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--VbJkn9YxBvnuCH5J
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
/xGVx9CoWwAA

--VbJkn9YxBvnuCH5J--
