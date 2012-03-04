Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58905 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab2CDIzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 03:55:46 -0500
Received: by wejx9 with SMTP id x9so1794100wej.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 00:55:45 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 00/11] wl12xx: various patches
Date: Sun,  4 Mar 2012 10:55:44 +0200
Message-Id: <1330851355-24459-1-git-send-email-eliad@wizery.com> (sfid-20120304_095619_684571_31B301C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some various patches pending in my queue. Mostly
address issues related to multi-vif and the
auth/assoc redesign.

Eliad Peller (11):
  wl12xx: don't start dev role on ibss vifs
  wl12xx: consider bss_conf->idle instead of hw->conf.flags
  wl12xx: implement sta_state callback
  wl12xx: set authorized AP on sta_state notification
  wl12xx: increment session_counter for device role as well
  wl12xx: set correct vif type in change_interface callback
  wl12xx: don't handle change_channel while associated
  wl12xx: don't allow scanning while device is in ROC
  wl12xx: configure the correct beacon_interval
  wl12xx: avoid bug_on_recovery during fw switch
  wl12xx: print the tx packet len

 drivers/net/wireless/wl12xx/cmd.c    |    2 +-
 drivers/net/wireless/wl12xx/main.c   |  321 ++++++++++++++--------------------
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +-
 3 files changed, 134 insertions(+), 193 deletions(-)

-- 
1.7.6.401.g6a319

