Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:45134 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750731AbeFDF3P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Jun 2018 01:29:15 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 0/4] staging: wilc1000: modification to use list_head data structure
Date: Mon, 4 Jun 2018 10:59:06 +0530
Message-ID: <1528090150-5397-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180604_073032_760381_C0443A7C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of having own linked list implementation to maintain buffer queue change
to use list_head. Also removed the few elements from 'wilc' struct as it's not
required to be part of 'wilc' struct.

Ajay Singh (4):
  staging: wilc1000: use list_head to maintain 'txq_entry_t' elements of
    tx queue
  staging: wilc1000: use list_head to maintain 'rxq_entry_t elements in
    rx queue
  staging: wilc1000: remove 'rxq_entries' from 'wilc' struct
  staging: wilc1000: move 'txq_spinlock_flags' from 'wilc' structure to
    local variable

 drivers/staging/wilc1000/linux_wlan.c         |   2 +
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   9 +--
 drivers/staging/wilc1000/wilc_wlan.c          | 101 ++++++++------------------
 drivers/staging/wilc1000/wilc_wlan.h          |   5 +-
 4 files changed, 37 insertions(+), 80 deletions(-)

-- 
2.7.4
