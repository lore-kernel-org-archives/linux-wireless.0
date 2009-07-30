Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65468 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbZG3Aqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 20:46:33 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 17:46:35 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/2] wireless: fix 11d lockdep warning
Date: Wed, 29 Jul 2009 17:46:30 -0700
Message-ID: <1248914792-6010-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the lockdep warning for me. We take a much simpler
approach than that mess I was doing before. cfg80211 stuff will
go later.

Luis R. Rodriguez (2):
  cfg80211: use goto out on 11d reg hint failure
  cfg80211: decouple regulatory variables from cfg80211_mutex

 net/wireless/core.c |    4 +---
 net/wireless/reg.c  |   32 +++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 12 deletions(-)

