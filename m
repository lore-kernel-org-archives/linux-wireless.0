Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43602 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731580AbeGSOJw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 10:09:52 -0400
From: Balaji Pothunoori <bpothuno@codeaurora.org>
To: johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Balaji Pothunoori <bpothuno@codeaurora.org>
Subject: [PATCH v2 0/3] cfg80211/mac80211/ath10k: Extend avg ack rssi support for mgmt frames
Date: Thu, 19 Jul 2018 18:56:26 +0530
Message-Id: <1532006789-32454-1-git-send-email-bpothuno@codeaurora.org> (sfid-20180719_152645_207189_85424FA8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding ack signal support in station dump if the driver supports; also made changes to update 
"last ack signal" and "avg ack signal" for both data and management tx ack packet.

Balaji Pothunoori (3):
  cfg80211: Extend avg ack rssi support for mgmt frames
  mac80211: Extend avg ack rssi support for mgmt frames
  ath10k: management tx ack rssi capability check

 drivers/net/wireless/ath/ath10k/mac.c |  5 +++--
 include/uapi/linux/nl80211.h          |  7 +++++++
 net/mac80211/sta_info.c               | 26 +++++++++++++-------------
 net/wireless/nl80211.c                |  7 ++++---
 4 files changed, 27 insertions(+), 18 deletions(-)

--
v2 : Addressed Johannes comments 
     Modified subject and commit log 
2.7.4
