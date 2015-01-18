Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55266 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbbARFKo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 00:10:44 -0500
Subject: [PATCH 0/7] net: wireless: wcn36xx: add basic wcn3620 support
From: Andy Green <andy.green@linaro.org>
To: Kalle Valo <kvalo@codeaurora.org>,
	Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Date: Sun, 18 Jan 2015 13:10:35 +0800
Message-ID: <20150118050741.31866.36490.stgit@114-36-241-182.dynamic.hinet.net> (sfid-20150118_061049_851097_98BE40F3)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series adds some basic wcn3620 support to the
mainline wcn36xx driver.

 - modify the chip detection to be told which chip from
   platform ops, which can get it from Device Tree... the
   existing detection is just assume it's a wcn3680 if it
   has AC mode which is not enough

 - Adapt the DXE register selection to use 3680 mode for
   3620 as well

 - Add a couple of async "indication" messages which can
   appear down smd on 3620, just accept and ignore

 - Accept a modified form of trigger_ba response that is
   sent by the wcn3620 firmware, if device is a 3620

 - Disable powersaving mode if 3620

With these the 3620 can associate and work for a while
before needing to be forcibly reassociated again.

It's tested on an msm8916-QRD "phone" dev platform that
includes wcn3620.

---

Andy Green (7):
      net: wireless: wcn36xx: add wcn3620 chip type definition
      net: wireless: wcn36xx: get chip type from platform ops
      net: wireless: wcn36xx: use 3680 dxe regs for 3620
      net: wireless: wcn36xx: introduce WCN36XX_HAL_AVOID_FREQ_RANGE_IND
      net: wireless: wcn36xx: swallow two wcn3620 IND messages
      net: wireless: wcn36xx: remove powersaving for wcn3620
      net: wireless: wcn36xx: handle new trigger_ba format


 drivers/net/wireless/ath/wcn36xx/dxe.c     |    2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h     |    2 ++
 drivers/net/wireless/ath/wcn36xx/main.c    |   22 +++++++-----------
 drivers/net/wireless/ath/wcn36xx/smd.c     |   34 ++++++++++++++++++++++++++--
 drivers/net/wireless/ath/wcn36xx/smd.h     |    9 +++++++
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |   13 +++++++----
 6 files changed, 62 insertions(+), 20 deletions(-)

--
