Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:40187 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3JUROz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:14:55 -0400
Received: by mail-wg0-f51.google.com with SMTP id l18so6925842wgh.30
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:14:54 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 0/5] ath: simplify radar / beaconing flag settings
Date: Mon, 21 Oct 2013 19:14:46 +0200
Message-Id: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_191458_053225_D6364D29)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, Johannes,

these patches start cleaning up the flag usage through the reg-notifier
but the main motiviation here as to help clarify the case in which
DFS is supported and we don't need to apply some paranoid flags. I've
determined its best to clean this up on cfg80211 (unifying flags)
and deal with the DFS case in cfg80211 as well (I add the documentation,
but expect Januz to send a respective change later for DFS).

Given that the later patches cfg80211 / other drivers I'll let you
guys decide what tree these bubble up through.

This series simplifies the flag application setup. Just a heads up I
noticed that broadcom and rtl drivers share a lot of this code so
eventually we may want to just export these and share them somehow.

Luis R. Rodriguez (5):
  ath: fix logic on ath_reg_apply_active_scan_flags()
  ath: clean up ath_reg_apply_active_scan_flags()
  ath: rename ath_reg_apply_active_scan_flags() to
    ath_reg_apply_ir_flags()
  ath: simplify ath_reg_apply_beaconing_flags()
  ath: move the channel for ath_reg_apply_beaconing_flags() into helper

 drivers/net/wireless/ath/regd.c | 174 ++++++++++++++++++++++------------------
 1 file changed, 94 insertions(+), 80 deletions(-)

-- 
1.8.4.rc3

