Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18682 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751740AbdB0Lgj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 06:36:39 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: [PATCH V2 0/3] Pre-CAC and sharing DFS state across multiple radios
Date: Mon, 27 Feb 2017 17:04:32 +0530
Message-ID: <1488195275-29371-1-git-send-email-vthiagar@qti.qualcomm.com> (sfid-20170227_123657_349678_AD7978C3)
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
 net/wireless/nl80211.c       |  52 +++++++++++++++
 net/wireless/reg.c           | 148 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.h           |  36 +++++++++++
 11 files changed, 459 insertions(+), 9 deletions(-)

-- 
1.9.1
