Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:36406 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbaHYK3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 06:29:10 -0400
Received: by mail-lb0-f175.google.com with SMTP id 10so11794165lbg.20
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2014 03:29:09 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/3] ath10k: ce fixes 2014-08-08
Date: Mon, 25 Aug 2014 12:19:20 +0200
Message-Id: <1408961963-3682-1-git-send-email-michal.kazior@tieto.com> (sfid-20140825_122915_007923_4B2C7227)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This removes implicit endianess in some places.
I'd love to get rid of it from
ath10k_pci_diag_access* as well but let's fix
ath10k_pci_diag_mem_* first.

Note: This is based on my logging patch and fw
crash dump fix.

v2:
 * rebased
 * some fixes in patch [3/3] (see notes there)


Michal Kazior (3):
  ath10k: move pci init structures
  ath10k: dont duplicate service-pipe mapping
  ath10k: make target endianess more explicit

 drivers/net/wireless/ath/ath10k/pci.c | 408 +++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h |  18 +-
 2 files changed, 209 insertions(+), 217 deletions(-)

-- 
1.8.5.3

