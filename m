Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:56207 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860Ab3GPHz5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 03:55:57 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/3] ath10k: hardware recovery
Date: Tue, 16 Jul 2013 09:54:34 +0200
Message-ID: <1373961277-14784-1-git-send-email-michal.kazior@tieto.com> (sfid-20130716_095600_463156_E8FF4C6E)
In-Reply-To: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
References: <1372148011-28234-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Respin of hw recovery. This implements recovery
from a firmware crash.

Note: this is based on my
      "ath10k: device setup refactor" patchset.

v3:
 * rename RESTARTING_ON/OFF to RESTARTING/RESTARTED
 * update commit message for 'create debufs..'

Michal Kazior (3):
  ath10k: implement device recovery
  ath10k: implement fw crash simulation command
  ath10k: create debugfs interface to trigger fw crash

 drivers/net/wireless/ath/ath10k/core.c  |   30 +++++++++
 drivers/net/wireless/ath/ath10k/core.h  |   19 ++++++
 drivers/net/wireless/ath/ath10k/debug.c |   54 +++++++++++++++++
 drivers/net/wireless/ath/ath10k/htc.c   |    3 +
 drivers/net/wireless/ath/ath10k/mac.c   |  101 +++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/mac.h   |    1 +
 drivers/net/wireless/ath/ath10k/pci.c   |    2 +
 drivers/net/wireless/ath/ath10k/wmi.c   |   26 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.h   |   19 ++++++
 9 files changed, 236 insertions(+), 19 deletions(-)

-- 
1.7.9.5

