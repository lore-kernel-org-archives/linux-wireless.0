Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41994C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 08:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029332081D
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 08:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 029332081D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbeKGSPb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 13:15:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:30232 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbeKGSPb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 13:15:31 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Nov 2018 00:46:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,475,1534834800"; 
   d="scan'208";a="83969509"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 07 Nov 2018 00:46:07 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gKJTT-000APW-6C; Wed, 07 Nov 2018 16:46:07 +0800
Date:   Wed, 7 Nov 2018 16:46:03 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Adham.Abozaeid@microchip.com
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        johannes@sipsolutions.net, Aditya.Shankar@microchip.com,
        Ganesh.Krishna@microchip.com
Subject: Re: [PATCH v3 2/4] staging: wilc1000: validate cfg parameters before
 scheduling the work
Message-ID: <201811071647.HHGwbZKi%fengguang.wu@intel.com>
References: <20181106000109.6178-3-adham.abozaeid@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106000109.6178-3-adham.abozaeid@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Adham,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on staging/staging-testing]
[also build test WARNING on v4.20-rc1 next-20181106]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Adham-Abozaeid-microchip-com/staging-wilc1000-validate-input-to-set_wiphy_param-and-return-proper-errors/20181106-120308

smatch warnings:
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:1152 set_wiphy_params() warn: always true condition '(wiphy->retry_short < 256) => (0-255 < 256)'
drivers/staging/wilc1000/wilc_wfi_cfgoperations.c:1164 set_wiphy_params() warn: always true condition '(wiphy->retry_long < 256) => (0-255 < 256)'

vim +1152 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c

  1141	
  1142	static int set_wiphy_params(struct wiphy *wiphy, u32 changed)
  1143	{
  1144		int ret;
  1145		struct cfg_param_attr cfg_param_val;
  1146		struct wilc_priv *priv = wiphy_priv(wiphy);
  1147		struct wilc_vif *vif = netdev_priv(priv->dev);
  1148	
  1149		cfg_param_val.flag = 0;
  1150	
  1151		if (changed & WIPHY_PARAM_RETRY_SHORT) {
> 1152			if (wiphy->retry_short > 0 && wiphy->retry_short < 256) {
  1153				netdev_dbg(vif->ndev,
  1154					   "Setting WIPHY_PARAM_RETRY_SHORT %d\n",
  1155					   wiphy->retry_short);
  1156				cfg_param_val.flag  |= RETRY_SHORT;
  1157				cfg_param_val.short_retry_limit = wiphy->retry_short;
  1158			} else {
  1159				netdev_err(vif->ndev, "Short retry limit out of range\n");
  1160				return -EINVAL;
  1161			}
  1162		}
  1163		if (changed & WIPHY_PARAM_RETRY_LONG) {
> 1164			if (wiphy->retry_long > 0 && wiphy->retry_long < 256) {
  1165				netdev_dbg(vif->ndev,
  1166					   "Setting WIPHY_PARAM_RETRY_LONG %d\n",
  1167					   wiphy->retry_long);
  1168				cfg_param_val.flag |= RETRY_LONG;
  1169				cfg_param_val.long_retry_limit = wiphy->retry_long;
  1170			} else {
  1171				netdev_err(vif->ndev, "Long retry limit out of range\n");
  1172				return -EINVAL;
  1173			}
  1174		}
  1175		if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
  1176			if (wiphy->frag_threshold > 255 &&
  1177			    wiphy->frag_threshold < 7937) {
  1178				netdev_dbg(vif->ndev,
  1179					   "Setting WIPHY_PARAM_FRAG_THRESHOLD %d\n",
  1180					   wiphy->frag_threshold);
  1181				cfg_param_val.flag |= FRAG_THRESHOLD;
  1182				cfg_param_val.frag_threshold = wiphy->frag_threshold;
  1183			} else {
  1184				netdev_err(vif->ndev,
  1185					   "Fragmentation threshold out of range\n");
  1186				return -EINVAL;
  1187			}
  1188		}
  1189	
  1190		if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
  1191			if (wiphy->rts_threshold > 255) {
  1192				netdev_dbg(vif->ndev,
  1193					   "Setting WIPHY_PARAM_RTS_THRESHOLD %d\n",
  1194					   wiphy->rts_threshold);
  1195				cfg_param_val.flag |= RTS_THRESHOLD;
  1196				cfg_param_val.rts_threshold = wiphy->rts_threshold;
  1197			} else {
  1198				netdev_err(vif->ndev, "RTS threshold out of range\n");
  1199				return -EINVAL;
  1200			}
  1201		}
  1202	
  1203		ret = wilc_hif_set_cfg(vif, &cfg_param_val);
  1204		if (ret)
  1205			netdev_err(priv->dev, "Error in setting WIPHY PARAMS\n");
  1206	
  1207		return ret;
  1208	}
  1209	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
