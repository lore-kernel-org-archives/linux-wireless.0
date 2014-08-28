Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40063 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936487AbaH1LId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 07:08:33 -0400
Received: by mail-lb0-f170.google.com with SMTP id w7so692614lbi.29
        for <linux-wireless@vger.kernel.org>; Thu, 28 Aug 2014 04:08:32 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: monitor fixes
Date: Thu, 28 Aug 2014 12:58:15 +0200
Message-Id: <1409223497-19946-1-git-send-email-michal.kazior@tieto.com> (sfid-20140828_130837_702089_099E82D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This cleans up the monitor code a bit and
introduces a workaround for a fw bug (leading to a
fw crash) when station interface associates while
a monitor vdev is running.

People have been complaining about the fw crash
for some time now. I guess we have no choice but
to make a workaround in ath10k. The most common
usecase that will benefit from this fix is
probably 4addr sta briding.


Michal Kazior (2):
  ath10k: fix monitor start/stop sequences
  ath10k: stop monitor vdev for sta assoc

 drivers/net/wireless/ath/ath10k/core.h |   1 -
 drivers/net/wireless/ath/ath10k/mac.c  | 131 +++++++++++++++------------------
 2 files changed, 58 insertions(+), 74 deletions(-)

-- 
1.8.5.3

