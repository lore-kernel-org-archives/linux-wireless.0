Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:39505 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3LCReD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 12:34:03 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so14076765wes.12
        for <linux-wireless@vger.kernel.org>; Tue, 03 Dec 2013 09:34:01 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: c_manoha@qca.qualcomm.com, linville@tuxdriver.com,
	johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [RFT 0/2] wireless: address REGULATORY_CUSTOM_REG usage with regulatory_hint()
Date: Tue,  3 Dec 2013 18:33:52 +0100
Message-Id: <1386092034-13442-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131203_183413_089211_8028D8EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith spotted a warning on the ath module when it doesn't set the
REGULATORY_CUSTOM_REG flag but still uses the wiphy_apply_custom_regulatory().
The issue is that the cards that it is warning on are not world roaming
but the ath module preference is to be conservative and to apply a custom
world roaming regulatory domain *prior* to applying the one seen mandated
by the alpha2 on the card with regulatory_hint().

Fix this first in the shared ath module for the Atheros drivers and then
later merge a generic solution so that others drivers don't have to do
this, and remove the temporary flag removal within the ath module then.

The split of the patches should let John take in the ath module fix while
Johannes can take in the generic solution for cfg80211 separately. Once
Johannes sends a pull request to Linville I suspect there will be no
conflicts.

Sujith please test each one separately if you can.

Luis R. Rodriguez (2):
  ath: fix warning on usage of REGULATORY_CUSTOM_REG
  cfg80211: make regulatory_hint() remove REGULATORY_CUSTOM_REG

 drivers/net/wireless/ath/regd.c | 7 ++++---
 include/net/regulatory.h        | 4 ++++
 net/wireless/reg.c              | 2 ++
 3 files changed, 10 insertions(+), 3 deletions(-)

-- 
1.8.4.3

