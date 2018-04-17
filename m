Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:37054 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753099AbeDQNX4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 09:23:56 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH v2 0/5] wcn36xx: scan related patches
Date: Tue, 17 Apr 2018 15:23:32 +0200
Message-Id: <20180417132337.31720-1-daniel@zonque.org> (sfid-20180417_152413_304545_AC46C767)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's another series of 5 patches for wcn36xx that address some issues
with scanning. The first one is the most important one.

Daniel


v1 → v2:

* Moved one hunk from 5/5 to 4/5 so the series becomes bisectable
* Add more commit log context to 5/5

Daniel Mack (5):
  wcn36xx: abort scan request when 'dequeued' indicator is sent
  wcn36xx: cancel pending scan request when interface goes down
  wcn36xx: handle scan cancellation when firmware support is missing
  wcn36xx: send bss_type in scan requests
  wcn36xx: pass information elements in scan requests

 drivers/net/wireless/ath/wcn36xx/hal.h     |  8 +++++++-
 drivers/net/wireless/ath/wcn36xx/main.c    | 29 +++++++++++++++++++++++++----
 drivers/net/wireless/ath/wcn36xx/smd.c     | 20 +++++++++++++++++---
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h |  7 +------
 4 files changed, 50 insertions(+), 14 deletions(-)

-- 
2.14.3
