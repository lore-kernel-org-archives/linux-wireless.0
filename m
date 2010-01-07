Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab0AGWY7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:24:59 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 0/4] cfg80211: few country IE parse fixes
Date: Thu,  7 Jan 2010 17:24:53 -0500
Message-Id: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, this series has a few country IE fixes some of which
Benoit reported. The fix I made goes in with an enhancement
which reduces the number of rules created if the AP is stupid
and sends congigious channels, never making use of the number
of channels in the triplets.

I've tested this against an AP issuing these country IE
triplets below:

[1]
[2]
[36]
[40]

[1]
[2-4]
[5-12]
[36]
[40-44]

[1-4]
[5-7]
[36-44]
[48-64]

[36-36]
[40-40]
[44-44]
[48-48]
[52-52]
[56-56]
[60-60]
[64-64]
[100-100]
[104-104]
[108-108]
[112-112]
[116-116]
[120-120]
[124-124]
[128-128]
[132-132]
[136-136]
[140-140]

All these country IEs now only produce two triplets on regulatory rules.

I generated these with hostapd using a debug patch for country IEs:

http://bombadil.infradead.org/~mcgrof/patches/hostapd/enable-11d-debugging.patch

Luis R. Rodriguez (4):
  cfg80211: add debug print when we drop a bogus country IE
  cfg80211: fix 2 GHz subband calculation for country IEs
  cfg80211: process the max power on a country IE
  cfg80211: Fix country IE parsing for single channel triplets

 net/wireless/reg.c |  235 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 227 insertions(+), 8 deletions(-)

