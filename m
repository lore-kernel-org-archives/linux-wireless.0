Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34378 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443AbbDJNam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 09:30:42 -0400
Received: by lbcga7 with SMTP id ga7so13738392lbc.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 06:30:41 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/4] ath10k: ibss crypto fixes
Date: Fri, 10 Apr 2015 13:23:19 +0000
Message-Id: <1428672203-8604-1-git-send-email-michal.kazior@tieto.com> (sfid-20150410_153101_751190_14F71CBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've mainly tested this on kvalo/pending branch.
Currently master branch contains 0f611d28fc2e
("mac80211: count interfaces correctly for
combination checks") which breaks IBSS in
wpa_supplicant due to P2P Device and interface
combinations. This has been pointed out in the
following thread:

 [1]: http://thread.gmane.org/gmane.linux.kernel.wireless.general/135570/focus=136643

If someone's interested in running ath10k IBSS
make sure to use kernel prior to 4.0, revert the
mentioned mac80211 patch or apply wpa_supplicant
workaround patch from [1].


Janusz Dziedzic (1):
  ath10k: enable ibss-rsn

Michal Kazior (3):
  ath10k: don't use reassoc flag
  ath10k: fix multiple key static wep with ibss
  ath10k: set def key idx for ibss

 drivers/net/wireless/ath/ath10k/mac.c | 44 +++++++++++++++++++++++++++++------
 1 file changed, 37 insertions(+), 7 deletions(-)

-- 
2.1.4

