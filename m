Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41931 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab2HKT4j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 15:56:39 -0400
Received: by ghrr11 with SMTP id r11so2297134ghr.19
        for <linux-wireless@vger.kernel.org>; Sat, 11 Aug 2012 12:56:38 -0700 (PDT)
Date: Sat, 11 Aug 2012 14:56:32 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: [RFC v2 0/2] bcma: expose cc sprom for read/write in sysfs
Message-ID: <cover.1344713431.git.saul.stjohn@gmail.com> (sfid-20120811_215643_421363_7954DE7A)
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

