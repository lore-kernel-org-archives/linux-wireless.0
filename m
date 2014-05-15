Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64133 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaEOItJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 04:49:09 -0400
Received: by mail-ee0-f52.google.com with SMTP id e53so402956eek.11
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 01:49:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/5] ath10k: recovery fixes 2014-05-09
Date: Thu, 15 May 2014 10:41:59 +0200
Message-Id: <1400143324-14911-1-git-send-email-michal.kazior@tieto.com> (sfid-20140515_104921_346138_51998D72)
In-Reply-To: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's is a bunch of fixes for recovery/hw
restart. This notably fixes a bug Ben has hit some
time ago.

I also have some improvements for recovery code as
well in a follow up patchset that I'll be sending
separately.

v2:
 * minor code style adjustments
 * extra comment
 * sanity check in wep key worker


Michal Kazior (5):
  ath10k: clean up start() callback
  ath10k: perform hw restart lazily
  ath10k: drain tx before restarting hw
  ath10k: protect wep tx key setup
  ath10k: dont configure bssid for ap mode

 drivers/net/wireless/ath/ath10k/core.c |   5 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 117 ++++++++++++++++++++++-----------
 2 files changed, 83 insertions(+), 39 deletions(-)

-- 
1.8.5.3

