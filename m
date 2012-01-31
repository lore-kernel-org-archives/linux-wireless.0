Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46747 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2AaOkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:40:43 -0500
Received: by werb13 with SMTP id b13so66758wer.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 06:40:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 0/7] wl12xx: add some psm/suspend features
Date: Tue, 31 Jan 2012 16:44:01 +0200
Message-Id: <1328021048-8944-1-git-send-email-eliad@wizery.com> (sfid-20120131_154049_513763_FE9342D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add some psm / suspend features:
* Add the ability to force psm (by default, the fw uses dynamic ps)
* Use differnet wake up conditions on suspend
* Add pattern support to wowlan triggers

(depends on the "wl12xx: update fw api" patchset)

v2: the rx filters patches were squashed and rewritten (thanks Eyal!)

Eyal Shapira (7):
  wl12xx: Set different wake up conditions in case of suspend
  wl12xx: add suspend_listen_interval debugfs file
  wl12xx: add forced_ps mode
  wl12xx: add forced_ps debugfs file
  wl12xx: add RX data filter ACX commands
  wl12xx: add RX data filters management functions
  wl12xx: support wowlan wakeup patterns

 drivers/net/wireless/wl12xx/acx.c     |  115 +++++++++++++-
 drivers/net/wireless/wl12xx/acx.h     |   34 ++++-
 drivers/net/wireless/wl12xx/conf.h    |   19 +++
 drivers/net/wireless/wl12xx/debugfs.c |  131 ++++++++++++++++-
 drivers/net/wireless/wl12xx/main.c    |  272 +++++++++++++++++++++++++++++++--
 drivers/net/wireless/wl12xx/ps.c      |   12 +-
 drivers/net/wireless/wl12xx/rx.c      |   61 ++++++++
 drivers/net/wireless/wl12xx/rx.h      |    8 +-
 drivers/net/wireless/wl12xx/wl12xx.h  |   38 +++++-
 9 files changed, 662 insertions(+), 28 deletions(-)

-- 
1.7.6.401.g6a319

