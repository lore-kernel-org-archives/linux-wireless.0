Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54032 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab1K1Viy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 16:38:54 -0500
Received: by qadc14 with SMTP id c14so1617565qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 13:38:54 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: [PATCH 0/5] wireless: fix set tx power
Date: Mon, 28 Nov 2011 16:38:45 -0500
Message-Id: <1322516330-4007-1-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_223857_672819_A93DC0F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver maintainers have approved of these now except for brcm80211.
I should note that Kalle indicated he was going to queue up the ath6kl
patch though so not sure if you want to wait for his patch or just suck
mine in. I think it makes sense to roll these in together as a series,
the rebase that Kalle would do shouldn't be impacted by this I think.

What we can do later is just add a data structure as suggested by hpa
to avoid these sort of issues.

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

