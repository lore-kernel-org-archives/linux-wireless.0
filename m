Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1KRIUy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:20:54 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8KsYa032152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:20:54 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 02/77] iwlegacy: rename iwl to il
Date: Fri, 18 Nov 2011 09:21:24 +0100
Message-Id: <1321604559-10707-2-git-send-email-sgruszka@redhat.com> (sfid-20111118_092057_390748_EBC6EA9F)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_legacy prefix result in long function names, what cause that we
have frequent line split and not readable code. Also iwl_foo symbols
are duplicated in iwlwifi driver, what is annoying when editing
kernel tree with cscope.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.c |   32 +-
 drivers/net/wireless/iwlegacy/iwl-3945-debugfs.h |   12 +-
 drivers/net/wireless/iwlegacy/iwl-3945-fh.h      |   12 +-
 drivers/net/wireless/iwlegacy/iwl-3945-hw.h      |   46 +-
 drivers/net/wireless/iwlegacy/iwl-3945-led.c     |   14 +-
 drivers/net/wireless/iwlegacy/iwl-3945-led.h     |    8 +-
 drivers/net/wireless/iwlegacy/iwl-3945-rs.c      |  468 +++---
 drivers/net/wireless/iwlegacy/iwl-3945.c         | 1200 ++++++++--------
 drivers/net/wireless/iwlegacy/iwl-3945.h         |  186 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-calib.c   |  210 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-calib.h   |   16 +-
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.c |   32 +-
 drivers/net/wireless/iwlegacy/iwl-4965-debugfs.h |   12 +-
 drivers/net/wireless/iwlegacy/iwl-4965-eeprom.c  |   26 +-
 drivers/net/wireless/iwlegacy/iwl-4965-hw.h      |   82 +-
 drivers/net/wireless/iwlegacy/iwl-4965-led.c     |   20 +-
 drivers/net/wireless/iwlegacy/iwl-4965-led.h     |   10 +-
 drivers/net/wireless/iwlegacy/iwl-4965-lib.c     |  380 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-rs.c      | 1112 ++++++++--------
 drivers/net/wireless/iwlegacy/iwl-4965-rx.c      |   52 +-
 drivers/net/wireless/iwlegacy/iwl-4965-sta.c     |  258 ++--
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c      |  442 +++---
 drivers/net/wireless/iwlegacy/iwl-4965-ucode.c   |   50 +-
 drivers/net/wireless/iwlegacy/iwl-4965.c         |  846 ++++++------
 drivers/net/wireless/iwlegacy/iwl-4965.h         |  202 ++--
 drivers/net/wireless/iwlegacy/iwl-commands.h     |  506 ++++----
 drivers/net/wireless/iwlegacy/iwl-core.c         |  994 +++++++-------
 drivers/net/wireless/iwlegacy/iwl-core.h         |  434 +++---
 drivers/net/wireless/iwlegacy/iwl-csr.h          |   16 +-
 drivers/net/wireless/iwlegacy/iwl-debug.h        |  194 ++--
 drivers/net/wireless/iwlegacy/iwl-debugfs.c      |  284 ++--
 drivers/net/wireless/iwlegacy/iwl-dev.h          |  440 +++---
 drivers/net/wireless/iwlegacy/iwl-eeprom.c       |  156 +-
 drivers/net/wireless/iwlegacy/iwl-eeprom.h       |   60 +-
 drivers/net/wireless/iwlegacy/iwl-fh.h           |   38 +-
 drivers/net/wireless/iwlegacy/iwl-hcmd.c         |  186 ++--
 drivers/net/wireless/iwlegacy/iwl-helpers.h      |   66 +-
 drivers/net/wireless/iwlegacy/iwl-io.h           |  326 +++---
 drivers/net/wireless/iwlegacy/iwl-led.c          |   60 +-
 drivers/net/wireless/iwlegacy/iwl-led.h          |   34 +-
 drivers/net/wireless/iwlegacy/iwl-legacy-rs.h    |  404 +++---
 drivers/net/wireless/iwlegacy/iwl-power.c        |   64 +-
 drivers/net/wireless/iwlegacy/iwl-power.h        |   32 +-
 drivers/net/wireless/iwlegacy/iwl-prph.h         |   18 +-
 drivers/net/wireless/iwlegacy/iwl-rx.c           |   72 +-
 drivers/net/wireless/iwlegacy/iwl-scan.c         |  258 ++--
 drivers/net/wireless/iwlegacy/iwl-spectrum.h     |    4 +-
 drivers/net/wireless/iwlegacy/iwl-sta.c          |  376 +++---
 drivers/net/wireless/iwlegacy/iwl-sta.h          |   78 +-
 drivers/net/wireless/iwlegacy/iwl-tx.c           |  200 ++--
 drivers/net/wireless/iwlegacy/iwl3945-base.c     | 1664 +++++++++++-----------
 drivers/net/wireless/iwlegacy/iwl4965-base.c     | 1382 +++++++++---------
 52 files changed, 7037 insertions(+), 7037 deletions(-)

1.2M patch can be downloaded from:
http://people.redhat.com/sgruszka/iwlegacy-2011-11-16/0002-iwlegacy-rename-iwl-to-il.patch
