Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47297 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754780AbdBPQY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 11:24:58 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [RFC V2 0/3] Pre-CAC and sharing DFS state across multiple radios
Date: Thu, 16 Feb 2017 21:54:32 +0530
Message-ID: <1487262275-14654-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20170216_172550_013400_36C7481C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently irrespective of dfs domain and radar detection activity
pre-CAC results for a wiphy are retained till the wiphy is detroyed.
This may not be preferred in non-ETSI dfs domain where pre-CAC is not
explicitly mentioned in the respective DFS requirement spec. This patch
set modifies the current behaviour of pre-CAC for non-ETSI domain by
giving 2 seconds grace period for dfs master interface to start operating
on the CAC completed channel.

This patch set also adds support to share dfs channel state across
multiple radios of the same regulatory configuration.

Vasanthakumar Thiagarajan (3):
  cfg80211: Make pre-CAC results valid only for ETSI domain
  cfg80211: Disallow moving out of operating DFS channel in non-ETSI
  cfg80211: Share Channel DFS state across wiphys of same DFS domain

 include/uapi/linux/nl80211.h |   5 ++
 net/wireless/ap.c            |   5 ++
 net/wireless/chan.c          | 117 ++++++++++++++++++++++++++++++++++
 net/wireless/core.c          |  37 +++++++++++
 net/wireless/core.h          |  16 +++++
 net/wireless/ibss.c          |   1 +
 net/wireless/mesh.c          |   1 +
 net/wireless/mlme.c          |  50 ++++++++++++---
 net/wireless/nl80211.c       |  52 ++++++++++++++++
 net/wireless/reg.c           | 145 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h           |  36 +++++++++++
 11 files changed, 456 insertions(+), 9 deletions(-)

-- 
1.9.1
