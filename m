Return-Path: <SRS0=ku3N=ZJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92AE6C432C3
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Nov 2019 03:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ACE72084E
	for <linux-wireless@archiver.kernel.org>; Sun, 17 Nov 2019 03:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfKQDoa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Nov 2019 22:44:30 -0500
Received: from mga17.intel.com ([192.55.52.151]:61640 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfKQDoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Nov 2019 22:44:30 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Nov 2019 19:44:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,314,1569308400"; 
   d="scan'208";a="288922262"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 16 Nov 2019 19:44:28 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iWBUB-000HQY-HH; Sun, 17 Nov 2019 11:44:27 +0800
Date:   Sun, 17 Nov 2019 11:44:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     kbuild-all@lists.01.org, nbd@nbd.name,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [RFC PATCH] mt76: mt76x02: mt76x2u_channel_switch_beacon() can be
 static
Message-ID: <20191117034412.axocckshf3mkabdk@4978f4969bb8>
References: <20191116111709.4686-5-markus.theil@tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116111709.4686-5-markus.theil@tu-ilmenau.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


Fixes: 919c09d543ec ("mt76: mt76x02: add channel switch support for usb interfaces")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 usb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 2f2c39a6a9e6c..ee88ec1f488b0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -100,7 +100,7 @@ mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
 	return err;
 }
 
-void mt76x2u_channel_switch_beacon(struct ieee80211_hw *hw,
+static void mt76x2u_channel_switch_beacon(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif,
 				   struct cfg80211_chan_def *chandef) {}
 
