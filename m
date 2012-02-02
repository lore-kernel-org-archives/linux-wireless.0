Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65011 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2BBKAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 05:00:10 -0500
Received: by wics10 with SMTP id s10so1599679wic.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 02:00:09 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 0/4] wl12xx: add some psm/suspend features
Date: Thu,  2 Feb 2012 12:03:38 +0200
Message-Id: <1328177022-26646-1-git-send-email-eliad@wizery.com> (sfid-20120202_110015_582535_F9989962)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some psm / suspend features:
* Add the ability to force psm (by default, the fw uses dynamic ps)
* Use differnet wake up conditions on suspend

(depends on the "wl12xx: update fw api" patchset)

v3: remove the rx-filters patches

Eyal Shapira (4):
  wl12xx: Set different wake up conditions in case of suspend
  wl12xx: add suspend_listen_interval debugfs file
  wl12xx: add forced_ps mode
  wl12xx: add forced_ps debugfs file

 drivers/net/wireless/wl12xx/acx.c     |   10 ++-
 drivers/net/wireless/wl12xx/acx.h     |    3 +-
 drivers/net/wireless/wl12xx/conf.h    |   19 +++++
 drivers/net/wireless/wl12xx/debugfs.c |  131 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/main.c    |   76 +++++++++++++++++--
 drivers/net/wireless/wl12xx/ps.c      |   12 ++-
 drivers/net/wireless/wl12xx/wl12xx.h  |    2 +-
 7 files changed, 232 insertions(+), 21 deletions(-)

-- 
1.7.6.401.g6a319

