Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:35402 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2A3OzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 09:55:23 -0500
Received: by wics10 with SMTP id s10so3498005wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 06:55:22 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/7] wl12xx: add some psm/suspend features
Date: Mon, 30 Jan 2012 16:58:38 +0200
Message-Id: <1327935525-24361-1-git-send-email-eliad@wizery.com> (sfid-20120130_155530_255059_447A2EAB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some psm / suspend features:
* Add the ability to force psm (by default, the fw uses dynamic ps)
* Use differnet wake up conditions on suspend
* Add pattern support to wowlan triggers

Eyal Shapira (4):
  wl12xx: Set different wake up conditions in case of suspend
  wl12xx: add suspend_listen_interval debugfs file
  wl12xx: add forced_ps mode
  wl12xx: add forced_ps debugfs file

Pontus Fuchs (3):
  wl12xx: Add rx data filter commands
  wl12xx: Add functions for managing rx data filters
  wl12xx: Add support for WoWLAN packet pattern trigger

 drivers/net/wireless/wl12xx/acx.c     |  100 ++++++++++++++++++-
 drivers/net/wireless/wl12xx/acx.h     |   45 ++++++++-
 drivers/net/wireless/wl12xx/conf.h    |   19 ++++
 drivers/net/wireless/wl12xx/debugfs.c |  131 ++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/main.c    |  178 ++++++++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/ps.c      |   12 ++-
 drivers/net/wireless/wl12xx/rx.c      |  105 +++++++++++++++++++
 drivers/net/wireless/wl12xx/rx.h      |   14 +++-
 drivers/net/wireless/wl12xx/wl12xx.h  |   38 +++++++-
 9 files changed, 616 insertions(+), 26 deletions(-)

-- 
1.7.6.401.g6a319

