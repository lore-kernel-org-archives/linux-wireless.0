Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:55293 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3J2Seh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 14:34:37 -0400
Received: by mail-wg0-f41.google.com with SMTP id b13so5139052wgh.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 11:34:35 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/3] wireless: fix usage of freq_reg_info()
Date: Tue, 29 Oct 2013 19:34:23 +0100
Message-Id: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_193440_744996_33F93FCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mihir reported freq_reg_info() was being used incorrectly on
ath/regd.c, I spotted this was true for years, and given that
a few vendors copied the same behaviour it meant other drivers
also had this broken. This fixes this issue accross 3 drivers.

These patches depend on the no-ir patches, and depending
on what tree that goes in this may be desirable to be merged
there.

The fix is represented with the Coccinelle SmPL grammar:

@@
struct ieee80211_channel *ch;
struct wiphy *wiphy;
const struct ieee80211_reg_rule *rule;
@@

-rule = freq_reg_info(wiphy, ch->center_freq);
+rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));

Luis R. Rodriguez (3):
  ath: fix usage of freq_reg_info()
  brcm80211: fix usage of freq_reg_info()
  rtlwifi: fix usage of freq_reg_info()

 drivers/net/wireless/ath/regd.c                   | 2 +-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c | 3 ++-
 drivers/net/wireless/rtlwifi/regd.c               | 7 ++++---
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
1.8.4.rc3

