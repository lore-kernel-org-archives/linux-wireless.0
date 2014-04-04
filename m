Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:57804 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaDDLe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2014 07:34:58 -0400
Received: by mail-we0-f171.google.com with SMTP id t61so3239280wes.2
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2014 04:34:57 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/2] ath10k: fix radar/cac
Date: Fri,  4 Apr 2014 13:28:44 +0200
Message-Id: <1396610926-5787-1-git-send-email-michal.kazior@tieto.com> (sfid-20140404_133547_247120_731F1A30)
In-Reply-To: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This loosely depends on `ath10k: refactor monitor
code`. Without it patch this patchset introduces
some (harmless) runtime warnings.

This v2 introduces a non-functional patch to avoid
forward declaration. The [1/2] has a little
conflict with `ath10k: refactor monitor code`
which renames ath10k_monitor_stop() to
ath10k_monitor_vdev_stop().

Part of the original CAC problem is also addressed
in `mac80211: fix radar_enabled propagation`.


Michal Kazior (2):
  ath10k: reorder functions
  ath10k: refactor radar detection code

 drivers/net/wireless/ath/ath10k/core.h |   4 +
 drivers/net/wireless/ath/ath10k/mac.c  | 224 +++++++++++++++------------------
 2 files changed, 106 insertions(+), 122 deletions(-)

-- 
1.8.5.3

