Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:58889 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758178AbaDIKNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 06:13:21 -0400
Received: by mail-ee0-f44.google.com with SMTP id e49so1670983eek.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 03:13:20 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: improve recovery speed
Date: Wed,  9 Apr 2014 12:07:05 +0200
Message-Id: <1397038028-7665-1-git-send-email-michal.kazior@tieto.com> (sfid-20140409_121325_165231_B93D56C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Patch 1/3 is just a cleanup I wanted to keep
separate from 2/3 which actually improves recovery
speed.

With this I'm able to recover from a `hard`
simualtion crash in ~3 seconds instead of ~10.

This should decrease the chance of CQM kicking in
on connected clients (due to beacon loss) when
ath10k is acting as AP.


Michal Kazior (3):
  ath10k: differentiate between target init failures
  ath10k: don't wait for device init if it crashed
  ath10k: skip suspending when recovering

 drivers/net/wireless/ath/ath10k/core.c |  6 ++++--
 drivers/net/wireless/ath/ath10k/pci.c  | 17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 3 deletions(-)

-- 
1.8.5.3

