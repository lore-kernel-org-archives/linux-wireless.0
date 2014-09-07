Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:65262 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaIGRcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 13:32:25 -0400
Received: by mail-we0-f178.google.com with SMTP id q58so2149431wes.37
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2014 10:32:24 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv3 0/2] add auto parameter to set distance command
Date: Sun,  7 Sep 2014 19:32:18 +0200
Message-Id: <1410111140-4340-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140907_193235_591509_E97E3CB3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add auto parameter to set distance command in order to enable ACK timeout
estimation algorithm (dynack). Currently dynack is supported just by ath9k

This patch is based on "configure dynack through mac80211/cfg80211 stack"
patchset sent on linux-wireless

Changes since v2:
- define NL80211_FEATURE_ACKTO_ESTIMATION to report driver dynack capability
- rebase on top of mac80211-next tree

Changes since v1:
- add dynack info to info command

Lorenzo Bianconi (2):
  iw: update nl80211.h
  iw: add auto parameter to set distance command

 info.c    |  2 ++
 nl80211.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 phy.c     | 43 +++++++++++++++++++++++++------------------
 3 files changed, 71 insertions(+), 18 deletions(-)

-- 
1.9.1

