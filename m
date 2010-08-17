Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61807 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0HQTrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 15:47:20 -0400
Received: by eyg5 with SMTP id 5so2243590eyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 12:47:18 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: [PATCH 0/4] wl1271 -> wl1251 port patches
Date: Tue, 17 Aug 2010 22:46:51 +0300
Message-Id: <1282074415-6168-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been looking at wl1271 changelog and found several patches that
seem to be also applicable to wl1251. I'm not that sure about patches
2 and 4, but 1 and 3 should be correct (I've verified 3 with TI driver).
I've been running these on pandora for several days now without problems.

It's a shame wl12xx drivers were completely split, it would look like
they could share fair bit of code. Now wl1251 does not benefit from more
actively developed wl1271 fixes.

There are even more wl1271 patches that could be applicable to wl1251.
Kalle, could you take a look at the list below? I could try porting if
you think any of those make sense.


Adding disconnect command, it seems to be also used by TI driver:
25a7dc6d22adda590be4932ebc772ea35914880c
c7f43e451ba40e66a89d51e63bc21a57824592f2

powersave fail handling:
19ad0715d8d9acc259ef02f83df767df2cf1eafe

not masking interrupts while processing:
4aa05917051b01da037a80c3207b48aee252eed2

connection monitoring control:
6ccbb92ead9379d7de2cc25cd950d15a8d22e0c9
a9af092b524614dd3fc7b52bde7c87f8b82cd2a6

broken ps-poll handling:
90494a90bea010af47547880634e0f1c52824a7d

improved queue stopping:
06f7bc7db79fabe6b2ec16eff0f59e4acc21eb72

probably more..


Grazvydas Ignotas (4):
  wl1251: add missing __packed modifier for some structs
  wl1251: fix event handling mechanism
  wl1251: fix beacon filter table structure
  wl1251: wait for join command complete event

 drivers/net/wireless/wl12xx/wl1251_acx.h   |    8 +++---
 drivers/net/wireless/wl12xx/wl1251_boot.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1251_cmd.h   |    6 ++--
 drivers/net/wireless/wl12xx/wl1251_event.c |   29 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_event.h |    1 +
 drivers/net/wireless/wl12xx/wl1251_main.c  |   24 ++++++++++------------
 6 files changed, 49 insertions(+), 21 deletions(-)

