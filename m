Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35545 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbcFWO5i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 10:57:38 -0400
Received: by mail-wm0-f66.google.com with SMTP id a66so11659010wme.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 07:57:37 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name
Subject: ath9k: extend and improve handling of ath9k_platform_data
Date: Thu, 23 Jun 2016 16:57:08 +0200
Message-Id: <20160623145714.20576-1-martin.blumenstingl@googlemail.com> (sfid-20160623_165741_522744_EF98A711)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series improves handling of ath9k_platform_data inside ath9k. A
quick summary of the changes is:
- led_active_high can now be configured via ath9k_platform_data:
  This change is based on a patch originally written by Vittorio
  Gambaletta which is part of OpenWrt's ath9k patches.
- small code cleanups which include removal of unused variables,
  return values duplicate code (no functional changes)
- ath9k_hw_init_macaddr will not change common->macaddr anymore
  to make it independent of whether it's called before or after
  ath9k_platform_data initialization in init.c
- initialization based on ath9k_platform_data in init.c is now
  easier to understand (no functional changes)

Patch 6 from this series supersedes the following patch by Eduardo
Abinader: "ath9k: return false when reading wrong eeprom offset" [0]


[0] https://patchwork.kernel.org/patch/9181371/


