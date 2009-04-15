Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3422 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZDOL6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 07:58:38 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 0/5] misc ath5k fixes
Date: Wed, 15 Apr 2009 07:57:31 -0400
Message-Id: <1239796656-20646-1-git-send-email-me@bobcopeland.com> (sfid-20090415_135846_413120_8E354871)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are various fixes for ath5k.  Patch 1 is the result of a script to
compare our initval tables against the ones in the open source HALs.
Patches 2 and 3 are self-explanatory.  Patches 4 and 5 may help make a
use-after-free bug more rare (though it isn't fully solved - both need
some testing so are 2.6.31 material).

Bob Copeland (5):
  ath5k: fix initvals errors
  ath5k: use tasklet_hi_schedule for beacon queue
  ath5k: use bool for modparams
  ath5k: use rx hw descriptor pointer for self-linked check
  ath5k: manipulate rxlink and descriptor address under rxbuf lock

 drivers/net/wireless/ath/ath5k/base.c     |   35 +++++++---------------------
 drivers/net/wireless/ath/ath5k/base.h     |    1 -
 drivers/net/wireless/ath/ath5k/dma.c      |    2 -
 drivers/net/wireless/ath/ath5k/initvals.c |    8 ++----
 4 files changed, 12 insertions(+), 34 deletions(-)


