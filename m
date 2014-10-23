Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:48654 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJWGhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 02:37:35 -0400
Received: by mail-wi0-f180.google.com with SMTP id em10so1061527wid.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 23:37:33 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 0/5] wiphy-specific regulatory management
Date: Thu, 23 Oct 2014 09:37:32 +0300
Message-Id: <1414046257-22184-1-git-send-email-arik@wizery.com> (sfid-20141023_083738_545313_A73073CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series includes two patches sent previously - allowing more channel
flags to propagate from regdom info and introducing a regulatory enforcement
mechanism for interfaces inhibiting a forbidden channel after a regulatory
update.

Introduce wiphy-specific regulatory management. This allows devices to manage
regdomain changes exclusively for their own wiphy. These devices do not update
the cfg80211 regdomain and are unaffected by hints external to the device/FW.
Introduce a new API to allow these devices to set their own regdomain.

Arik Nemtsov (2):
  cfg80211: introduce regulatory flags controlling bw
  cfg80211: leave invalid channels on regdomain change

Jonathan Doron (3):
  cfg80211: update missing fields in custom regulatory path
  cfg80211: allow wiphy specific regdomain management
  cfg80211: Allow usermode to query wiphy specific regd info

 include/net/cfg80211.h       |  14 +++
 include/net/regulatory.h     |   9 ++
 include/uapi/linux/nl80211.h |  23 +++++
 net/wireless/core.c          |   7 ++
 net/wireless/nl80211.c       | 132 ++++++++++++++++++++++------
 net/wireless/nl80211.h       |   1 +
 net/wireless/reg.c           | 201 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/reg.h           |   1 +
 8 files changed, 356 insertions(+), 32 deletions(-)

-- 
1.9.1

