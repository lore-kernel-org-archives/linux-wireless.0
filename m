Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DATE_IN_PAST_03_06,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20CEC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 03:08:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD72223DD
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 03:08:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BD72223DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbeKMNEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 08:04:38 -0500
Received: from mga12.intel.com ([192.55.52.136]:12795 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbeKMNEi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 08:04:38 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2018 19:08:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,497,1534834800"; 
   d="gz'50?scan'50,208,50";a="90645251"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2018 19:08:31 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gMP42-0002u5-OQ; Tue, 13 Nov 2018 11:08:30 +0800
Date:   Tue, 13 Nov 2018 07:20:35 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH v2 3/6] mac80211: Add airtime accounting and scheduling
 to TXQs
Message-ID: <201811130758.obetW5Hg%fengguang.wu@intel.com>
References: <1541805421-27309-4-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1541805421-27309-4-git-send-email-rmanohar@qti.qualcomm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Toke,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211/master]
[also build test WARNING on v4.20-rc1]
[cannot apply to next-20181112]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Rajkumar-Manoharan/Move-TXQ-scheduling-and-airtime-fairness-into-mac80211/20181111-072032
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
   drivers/mtd/nand/raw/nand_base.c:603: warning: Excess function parameter 'mtd' description in 'panic_nand_wait'
   drivers/mtd/nand/raw/nand_base.c:603: warning: Excess function parameter 'mtd' description in 'panic_nand_wait'
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
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:554: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:554: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:554: warning: Function parameter or member 'start' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:554: warning: Function parameter or member 'end' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:554: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_leaf'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:602: warning: Function parameter or member 'adev' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:602: warning: Function parameter or member 'vm' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:602: warning: Function parameter or member 'cursor' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:602: warning: Function parameter or member 'entry' not described in 'for_each_amdgpu_vm_pt_dfs_safe'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:847: warning: Function parameter or member 'level' not described in 'amdgpu_vm_bo_param'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1355: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_func'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'params' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'bo' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'level' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'pe' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'addr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'count' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'incr' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:1522: warning: Function parameter or member 'flags' not described in 'amdgpu_vm_update_huge'
   drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c:3095: warning: Function parameter or member 'pasid' not described in 'amdgpu_vm_make_compute'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_pin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_unpin' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_res_obj' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_get_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_import_sg_table' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_vunmap' not described in 'drm_driver'
   include/drm/drm_drv.h:609: warning: Function parameter or member 'gem_prime_mmap' not described in 'drm_driver'
   include/drm/drm_mode_config.h:869: warning: Function parameter or member 'quirk_addfb_prefer_xbgr_30bpp' not described in 'drm_mode_config'
   drivers/gpu/drm/drm_fourcc.c:112: warning: Function parameter or member 'dev' not described in 'drm_driver_legacy_fb_format'
   drivers/gpu/drm/drm_fourcc.c:112: warning: Excess function parameter 'native' description in 'drm_driver_legacy_fb_format'
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
30e0c99838 Toke Høiland-Jørgensen 2018-11-09  2360   *
30e0c99838 Toke Høiland-Jørgensen 2018-11-09  2361   * @weight_multipler: Driver specific airtime weight multiplier used while
30e0c99838 Toke Høiland-Jørgensen 2018-11-09  2362   *	refilling deficit of each TXQ.
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
30e0c99838 Toke Høiland-Jørgensen 2018-11-09  2399  	u8 weight_multiplier;
f0706e828e Jiri Benc              2007-05-05 @2400  };
f0706e828e Jiri Benc              2007-05-05  2401  

:::::: The code at line 2400 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--7JfCtLOvnd9MIVvH
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICBkG6lsAAy5jb25maWcAjFxZc+O2ln7Pr2AlVVPddas73tpxZsoPEAiKiEiCTYBa/MJS
ZLqjurbkkeSk+9/POSApbge+k0rSbRwAxHKW7yzwLz/94rG30/5lfdpu1s/PP7xv5a48rE/l
o/e0fS7/x/OVlyjjCV+az9A52u7evv+6vb679W4+X/7++cKblYdd+ezx/e5p++0Nhm73u59+
+Qn+/QUaX15hlsN/e982m0+/eR/88s/teuf99vn688Wny4/VX6ArV0kgpwXnhdTFlPP7H00T
/FDMRaalSu5/u7i+uDj3jVgyPZPOzTL7WixUNmtnmOQy8o2MRSGWhk0iUWiVmZZuwkwwv5BJ
oOB/hWEaB9v1T+1hPHvH8vT22i5zkqmZSAqVFDpO24lkIk0hknnBsmkRyVia++srPIV6wSpO
JXzdCG287dHb7U84cTM6UpxFzXZ+/rkd1yUULDeKGGz3WGgWGRxaN4ZsLoqZyBIRFdMH2Vlp
lzIByhVNih5iRlOWD64RykW4aQn9NZ032l1Qd4/DDris9+jLh/dHq/fJN8T5+iJgeWSKUGmT
sFjc//xht9+VHzvXpFd6LlNOzs0zpXURi1hlq4IZw3hI9su1iOSE+L49SpbxEBgAJBG+BTwR
NWwKPO8d3/48/jieypeWTaciEZnkViTSTE1ER6o6JB2qBU3JhBbZnBlkvFj5nfFIDVTGhV+L
j0ymLVWnLNMCO7VtHNh4plUOY4oFMzz0VWeE3Vq3i88Me4eMokbPPWeRhMGiiJg2BV/xiNi2
1Qbz9hQHZDufmIvE6HeJRQz6gvl/5NoQ/WKlizzFtTT3ZLYv5eFIXVX4UKQwSvmSdyUiUUiR
fiRIdrFkkhLKaYjXZ3eaaYKj0kyIODUwRyK6n2za5yrKE8OyFTl/3atLqxR+mv9q1sd/eyfY
qrfePXrH0/p09Nabzf5td9ruvrV7NpLPChhQMM4VfKtiofMnkMXsPbVkeilajpaR8dzT41OG
OVYF0LqfgR/BLsDhUzpZV527w/VgvJxVf3EJbZ7o2ujwEKTFcs+AsRcsMcUEZQI65EnM0sJE
kyKIch12P8WnmcpTTWuYUPBZqiTMBNduVEZzTLUINCJ2LrJPJiJG3/okmoEmnFvpy3xix2Cr
VQqXJh8EqgfkafgjZgnv8diwm4a/ELMx4E34FigePTAqufQvbzv6BgTZRHCNXKRWWZmMcTEY
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
AA==

--7JfCtLOvnd9MIVvH--
