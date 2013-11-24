Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42480 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3KXQ44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 11:56:56 -0500
Received: by mail-ea0-f169.google.com with SMTP id l9so1901734eaj.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 08:56:55 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	sujith@msujith.org, johannes@sipsolutions.net,
	rmanohar@qca.qualcomm.com
Subject: [PATCH 0/3] ath9k: tx99 initialization fixes
Date: Sun, 24 Nov 2013 17:56:48 +0100
Message-Id: <1385312211-3119-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131124_175700_538895_C64DAEDE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset fix two issues in ath9k tx99 code. In particular:
*[PATCH 1/3]: add ieee80211_get_vif_by_addr to get a reference to
vif data structure for a given mac address
*[PATCH 2/3]: initialize tx99_vif pointer in ath9k_tx99_init() since
ath9k_add_interface() is not run for monitor interfaces
*[PATCH 3/3]: initialize first chain attempt counter to 1 in
ath9k_build_tx99_skb()

This patchset has been applied on top of latest Sujith's tx99 patches

Lorenzo Bianconi (3):
  mac80211: implement ieee80211_get_vif_by_addr
  ath9k: get tx99_vif pointer in ath9k_tx99_init
  ath9k: fix mrr initialization in tx99 code

 drivers/net/wireless/ath/ath9k/main.c |  9 ---------
 drivers/net/wireless/ath/ath9k/tx99.c |  7 +++++++
 include/net/mac80211.h                |  9 +++++++++
 net/mac80211/util.c                   | 26 ++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 9 deletions(-)

-- 
1.8.3.2

