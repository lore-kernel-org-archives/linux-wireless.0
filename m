Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48052 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1KWP1a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:27:30 -0500
Received: by vbbfc26 with SMTP id fc26so552637vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 07:27:29 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [RFC 0/5] wireless: fix set tx power..
Date: Wed, 23 Nov 2011 10:27:19 -0500
Message-Id: <1322062044-14831-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111123_162733_268518_5673BF18)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While reviewing setting tx power I noticed some drivers had this busted
by assuming we passed dBm while we actually pass the value in mBm from
cfg80211. Would it be better to simply define a typedef here to avoid
other bogus uses later?

Luis R. Rodriguez (5):
  cfg80211: clarify set tx power mBm documentation
  ath6kl: fix ath6kl's set tx power
  brcm80211: fix usage of set tx power
  brcm80211: avoid code duplication on set tx power
  mwifiex: fix usage of set tx power

 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    3 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    9 ++-------
 drivers/net/wireless/mwifiex/cfg80211.c            |    3 ++-
 include/net/cfg80211.h                             |    3 ++-
 4 files changed, 8 insertions(+), 10 deletions(-)

-- 
1.7.4.15.g7811d

