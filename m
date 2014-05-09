Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59087 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIMXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:23:42 -0400
Received: by mail-ee0-f47.google.com with SMTP id c13so2622163eek.6
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:23:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/5] ath10k: recovery fixes 2014-05-09
Date: Fri,  9 May 2014 14:15:44 +0200
Message-Id: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com> (sfid-20140509_142346_059687_F7A36237)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's is a bunch of fixes for recovery/hw
restart. This notably fixes a bug Ben has hit some
time ago.

I also have some improvements for recovery code as
well in a follow up patchset that I'll be sending
separately.


Michal Kazior (5):
  ath10k: clean up start() callback
  ath10k: perform hw restart lazily
  ath10k: drain tx before restarting hw
  ath10k: protect wep tx key setup
  ath10k: dont configure bssid for ap mode

 drivers/net/wireless/ath/ath10k/core.c |   5 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 103 +++++++++++++++++++++------------
 2 files changed, 70 insertions(+), 38 deletions(-)

-- 
1.8.5.3

