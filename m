Return-Path: <SRS0=bI0Y=RS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EE4C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BBE8205C9
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Mar 2019 15:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbfCOPjQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Mar 2019 11:39:16 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44082 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727451AbfCOPjQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Mar 2019 11:39:16 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1h4ovQ-0004n1-Pn; Fri, 15 Mar 2019 17:39:13 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 15 Mar 2019 17:38:56 +0200
Message-Id: <20190315153907.16192-1-luca@coelho.fi>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/11] cfg80211/mac80211 patches from our internal tree 2019-03-15
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Some patches with mac80211 and cfg80211 changes from our internal
tree.

Please review, though you have already reviewed most if not all of
them ;)

Cheers,
Luca.


Andrei Otcheretianski (1):
  mac80211: Increase MAX_MSG_LEN

Avraham Stern (1):
  mac80211_hwsim: set p2p device interface support indication

Ilan Peer (1):
  cfg80211: Handle WMM rules in regulatory domain intersection

Liad Kaufman (1):
  ieee80211: update HE IEs to D4.0 spec

Luca Coelho (1):
  nl80211: copy the length of dst of src in
    nl80211_notify_radar_detection()

Sara Sharon (5):
  cfg80211: don't skip multi-bssid index element
  cfg80211: support non-inheritance element
  mac80211: support non-inheritance element
  cfg80211: support profile split between elements
  mac80211: support profile split between elements

Shaul Triebitz (1):
  nl80211: increase NL80211_MAX_SUPP_REG_RULES

 drivers/net/wireless/mac80211_hwsim.c |   2 +
 include/linux/ieee80211.h             |  14 ++-
 include/net/cfg80211.h                |  22 ++++
 include/uapi/linux/nl80211.h          |   4 +-
 net/mac80211/ieee80211_i.h            |   1 -
 net/mac80211/trace_msg.h              |   7 +-
 net/mac80211/util.c                   | 162 +++++++++++++++---------
 net/wireless/nl80211.c                |   2 +-
 net/wireless/reg.c                    |  39 ++++++
 net/wireless/scan.c                   | 173 ++++++++++++++++++++++++--
 10 files changed, 345 insertions(+), 81 deletions(-)

-- 
2.20.1

