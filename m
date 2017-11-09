Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:50374 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754802AbdKIXiq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 18:38:46 -0500
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
Subject: [PATCH v2 0/6] wl1251: Fix MAC address for Nokia N900
Date: Fri, 10 Nov 2017 00:38:22 +0100
Message-Id: <1510270708-14377-1-git-send-email-pali.rohar@gmail.com> (sfid-20171110_004144_456461_95337939)
In-Reply-To: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series fix processing MAC address for wl1251 chip found in Nokia N900.

Changes since v1:
* Added Acked-by for Pavel Machek
* Fixed grammar
* Magic numbers for NVS offsets are replaced by defines
* Check for validity of mac address NVS data is moved into function
* Changed order of patches as Pavel requested

Pali Rohár (6):
  wl1251: Update wl->nvs_len after wl->nvs is valid
  wl1251: Generate random MAC address only if driver does not have
    valid
  wl1251: Parse and use MAC address from supplied NVS data
  wl1251: Set generated MAC address back to NVS data
  firmware: Add request_firmware_prefer_user() function
  wl1251: Use request_firmware_prefer_user() for loading NVS
    calibration data

 drivers/base/firmware_class.c          |   45 +++++++++++++-
 drivers/net/wireless/ti/wl1251/Kconfig |    1 +
 drivers/net/wireless/ti/wl1251/main.c  |  104 ++++++++++++++++++++++++++------
 include/linux/firmware.h               |    9 +++
 4 files changed, 138 insertions(+), 21 deletions(-)

-- 
1.7.9.5
