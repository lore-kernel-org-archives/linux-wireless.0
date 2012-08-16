Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53242 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab2HPTEf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 15:04:35 -0400
Received: by ialo24 with SMTP id o24so489044ial.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 12:04:35 -0700 (PDT)
Date: Thu, 16 Aug 2012 13:59:05 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Saul St. John" <saul.stjohn@gmail.com>
Subject: [PATCH 0/2] bcma: expose cc sprom for read/write in sysfs
Message-ID: <20120816185905.GA6726@eris.garyseven.net> (sfid-20120816_210440_517664_67816F0F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ssb driver exposes the device SPROM to sysfs, which allows users to
modify various device settings using ssb-sprom from the b43-tools package.

These patches implement similar functionality in bcma, so that ssb-sprom
can be used with newer Broadcom devices.

Saul St. John (2):
  bcma: register cc core driver, device
  bcma: expose cc sprom to sysfs

 drivers/bcma/bcma_private.h                 |    5 +
 drivers/bcma/driver_chipcommon.c            |  212 ++++++++++++++++++++++++---
 drivers/bcma/main.c                         |   79 +++++-----
 drivers/bcma/sprom.c                        |   47 +++++-
 include/linux/bcma/bcma_driver_chipcommon.h |    4 +-
 5 files changed, 287 insertions(+), 60 deletions(-)

-- 
1.7.10.4

