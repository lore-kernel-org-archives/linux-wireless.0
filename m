Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35510 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbbHQQIt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 12:08:49 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 0/5] staging: wilc1000: code improvements
Date: Mon, 17 Aug 2015 12:08:32 -0400
Message-Id: <cover.1439827537.git.raphael.beamonte@gmail.com> (sfid-20150817_181112_533559_C064F87E)
In-Reply-To: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com>
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The first 3 patches of the following 5 are aimed to simplify the
wilc_exported_buf.c macros as well as correct a potential memory
leak from the use of the MALLOC_WILC_BUFFER one.

The next 2 patches are correcting two kind of checkpatch warning
reports in different files of the wilc1000 driver.

Raphaël


Raphaël Beamonte (5):
  staging: wilc1000: remove DECLARE_WILC_BUFFER()
  staging: wilc1000: remove FREE_WILC_BUFFER()
  staging: wilc1000: replace MALLOC_WILC_BUFFER() macro to avoid
    possible memory leak
  staging: wilc1000: use pr_* instead of printk
  staging: wilc1000: remove void function return statements that are not
    useful

 drivers/staging/wilc1000/coreconfigurator.c  |  4 +-
 drivers/staging/wilc1000/host_interface.c    |  4 --
 drivers/staging/wilc1000/linux_wlan.c        |  9 ++--
 drivers/staging/wilc1000/linux_wlan_common.h | 32 ++++++-------
 drivers/staging/wilc1000/linux_wlan_sdio.c   |  2 +-
 drivers/staging/wilc1000/linux_wlan_spi.c    |  2 +-
 drivers/staging/wilc1000/wilc_debugfs.c      | 16 +++----
 drivers/staging/wilc1000/wilc_exported_buf.c | 69 +++++++++++++++++-----------
 drivers/staging/wilc1000/wilc_wlan.c         |  3 --
 drivers/staging/wilc1000/wilc_wlan_cfg.c     |  2 -
 10 files changed, 75 insertions(+), 68 deletions(-)

-- 
2.1.4

