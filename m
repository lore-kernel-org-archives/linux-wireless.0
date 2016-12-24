Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33274 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752418AbcLXQ5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Dec 2016 11:57:19 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 0/6] wl1251: Fix MAC address for Nokia N900
Date: Sat, 24 Dec 2016 17:52:55 +0100
Message-Id: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com> (sfid-20161224_175739_468925_0446FDAA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fix processing MAC address for wl1251 chip found in Nokia N900.

Pali Rohár (6):
  firmware: Add request_firmware_prefer_user() function
  wl1251: Use request_firmware_prefer_user() for loading NVS
    calibration data
  wl1251: Update wl->nvs_len after wl->nvs is valid
  wl1251: Generate random MAC address only if driver does not have
    valid
  wl1251: Parse and use MAC address from supplied NVS data
  wl1251: Set generated MAC address back to NVS data

 drivers/base/firmware_class.c          |   45 +++++++++++++++-
 drivers/net/wireless/ti/wl1251/Kconfig |    1 +
 drivers/net/wireless/ti/wl1251/main.c  |   91 +++++++++++++++++++++++++-------
 include/linux/firmware.h               |    9 ++++
 4 files changed, 125 insertions(+), 21 deletions(-)

-- 
1.7.9.5
