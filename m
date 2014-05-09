Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64286 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaEIMmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:42:52 -0400
Received: by mail-ee0-f46.google.com with SMTP id t10so2604067eei.33
        for <linux-wireless@vger.kernel.org>; Fri, 09 May 2014 05:42:51 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] ath10k: recovery improvements 2014-05-09
Date: Fri,  9 May 2014 14:35:50 +0200
Message-Id: <1399638957-20449-1-git-send-email-michal.kazior@tieto.com> (sfid-20140509_144255_713431_61C6B753)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This depends on my `ath10k: recovery fixes
2014-05-09`.

Hopefully the split makes it a little saner to
review.

Please note: `ath10k: make wmi timeout trigger hw
restart` effectively hides the mgmt tx / htc
credit starvation issue that was discussed
recently. My intention is to make the driver more
robust and as a side effect it makes the
starvation issue less painful. If desired so
the patch can be easily ignored in the series as
nothing depends on it.


Michal Kazior (7):
  ath10k: move restart_work call
  ath10k: introduce core restart symbol
  ath10k: drain wmi quickly upon hw restart
  ath10k: wake up everything on core restart
  ath10k: reduce timeout values
  ath10k: make wmi timeout trigger hw restart
  ath10k: remove old unused defines

 drivers/net/wireless/ath/ath10k/core.c | 27 +++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/core.h |  7 +++++--
 drivers/net/wireless/ath/ath10k/htt.c  |  2 +-
 drivers/net/wireless/ath/ath10k/mac.c  |  8 +++-----
 drivers/net/wireless/ath/ath10k/pci.c  |  3 +--
 drivers/net/wireless/ath/ath10k/txrx.c |  2 +-
 drivers/net/wireless/ath/ath10k/wmi.c  | 17 ++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h  |  4 ++--
 8 files changed, 54 insertions(+), 16 deletions(-)

-- 
1.8.5.3

