Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:54158 "EHLO
        mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751059AbcL1RmI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 12:42:08 -0500
From: Andrey Rusalin <arusalin@dev.rtsoft.ru>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, michael.thalmeier@hale.at,
        linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Cc: Andrey Rusalin <arusalin@dev.rtsoft.ru>
Subject: [PATCH 0/3] NFC: pn533: fixes for i2c driver
Date: Wed, 28 Dec 2016 20:10:56 +0300
Message-Id: <1482945059-12249-1-git-send-email-arusalin@dev.rtsoft.ru> (sfid-20161228_184212_559480_0CE60248)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each of these patches fix some oops that I met during  
tests of the driver with itead pn532 nfc module.

First and third patches related to order of initialization driver,
where interrupt handler was registered before work queues
were ready to handle it.
Also iqr was freed already after work queues were deinitialized.

Second patch originally sent by Michael Thalmeier.
I reworked a little bit to make it more readable.

Andrey Rusalin (3):
  NFC: pn533: change order of free_irq and dev unregistration
  NFC: pn533: improve cmd queue handling
  NFC: pn533: change order operations in dev registation

 drivers/nfc/pn533/i2c.c   | 32 +++++++++++-------
 drivers/nfc/pn533/pn533.c | 82 ++++++++++++++++++++++++++++++-----------------
 drivers/nfc/pn533/pn533.h |  1 +
 drivers/nfc/pn533/usb.c   |  4 +++
 4 files changed, 77 insertions(+), 42 deletions(-)

-- 
2.7.4
