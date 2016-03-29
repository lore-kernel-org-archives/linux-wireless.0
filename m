Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35939 "EHLO
	mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbcC2GGg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 02:06:36 -0400
Received: by mail-pf0-f175.google.com with SMTP id u190so6572236pfb.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2016 23:06:36 -0700 (PDT)
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] Misc wcn36xx fixes
Date: Mon, 28 Mar 2016 23:06:17 -0700
Message-Id: <1459231593-360-1-git-send-email-bjorn.andersson@linaro.org> (sfid-20160329_081255_809708_5D2401CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I was debugging some issues with the wcn36xx driver I found a series of
patches that exists in Eugene's github tree but not in mainline.

Noteworthy is the long requested feature of having working ARP support.

Please apply these rebased and relocated patches.

Jason Mobarak (1):
  wcn36xx: don't pad beacons for mesh

Pontus Fuchs (15):
  wcn36xx: Clean up wcn36xx_smd_send_beacon
  wcn36xx: Pad TIM PVM if needed
  wcn36xx: Add helper macros to cast vif to private vif and vice versa
  wcn36xx: Use consistent name for private vif
  wcn36xx: Use define for invalid index and fix typo
  wcn36xx: Fetch private sta data from sta entry instead of from vif
  wcn36xx: Add helper macros to cast sta to priv
  wcn36xx: Remove sta pointer in private vif struct
  wcn36xx: Parse trigger_ba response properly
  wcn36xx: Copy all members in config_sta v1 conversion
  wcn36xx: Use allocated self sta index instead of hard coded
  wcn36xx: Clear encrypt_type when deleting bss key
  wcn36xx: Track association state
  wcn36xx: Implement multicast filtering
  wcn36xx: Use correct command struct for EXIT_BMPS_REQ

 drivers/net/wireless/ath/wcn36xx/debug.c   |  12 +-
 drivers/net/wireless/ath/wcn36xx/hal.h     |  18 ++-
 drivers/net/wireless/ath/wcn36xx/main.c    |  91 +++++++++----
 drivers/net/wireless/ath/wcn36xx/pmc.c     |   4 +-
 drivers/net/wireless/ath/wcn36xx/smd.c     | 205 +++++++++++++++++++++--------
 drivers/net/wireless/ath/wcn36xx/smd.h     |   3 +
 drivers/net/wireless/ath/wcn36xx/txrx.c    |   8 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  20 ++-
 8 files changed, 257 insertions(+), 104 deletions(-)

-- 
2.5.0

