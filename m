Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:33899 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755088AbaIRNcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 09:32:09 -0400
Received: by mail-we0-f182.google.com with SMTP id q59so463778wes.41
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2014 06:32:07 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/9] ath10k: mostly cleanups
Date: Thu, 18 Sep 2014 15:21:18 +0200
Message-Id: <1411046487-19544-1-git-send-email-michal.kazior@tieto.com> (sfid-20140918_153213_410561_D3445623)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's a bunch of clean up patches for WMI and a
single fix. I'm including the fix in this patchset
because one of the clean up patches depends on it.


Michal Kazior (9):
  ath10k: fix tx/rx chainmask init
  ath10k: remove unused pdev_set_channel command
  ath10k: deduplicate wmi_channel code
  ath10k: deduplicate host mem chunk code
  ath10k: relocate wmi attach/deatch functions
  ath10k: deduplicate wmi service ready logic
  ath10k: clean up phyerr code
  ath10k: unify wmi event function names
  ath10k: re-work scan start command building

 drivers/net/wireless/ath/ath10k/core.h     |   4 +-
 drivers/net/wireless/ath/ath10k/debug.c    |   2 +-
 drivers/net/wireless/ath/ath10k/debug.h    |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c      |  10 +-
 drivers/net/wireless/ath/ath10k/spectral.c |  34 +-
 drivers/net/wireless/ath/ath10k/spectral.h |   8 +-
 drivers/net/wireless/ath/ath10k/wmi.c      | 823 +++++++++++++----------------
 drivers/net/wireless/ath/ath10k/wmi.h      | 244 ++-------
 8 files changed, 445 insertions(+), 684 deletions(-)

-- 
1.8.5.3

