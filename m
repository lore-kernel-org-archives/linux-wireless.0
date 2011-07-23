Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38846 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1GWIb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 04:31:28 -0400
Received: by fxd18 with SMTP id 18so6327489fxd.11
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 01:31:27 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 0/2] ssb: start cleaning boardflags
Date: Sat, 23 Jul 2011 11:10:10 +0200
Message-Id: <1311412213-3825-1-git-send-email-zajec5@gmail.com> (sfid-20110723_103132_055870_44AF89C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Boardflags are board (SPROM to say exactly) specific, so should be
defined in ssb code. It does not make sense to redefine them over
and over in every driver.

This is the real fix for:
linux-next-20110722/drivers/bcma/driver_pci.c:175: error: 'SSB_PCICORE_BFL_NOPCI' undeclared (first use in this function)

Ideally that patches should replace
[PATCH] bcma: fix 'SSB_PCICORE_BFL_NOPCI' undeclared build breakage

Rafał Miłecki (2):
  ssb: define boardflags
  bcma: use boardflags define from ssb code

 drivers/bcma/driver_pci.c    |    2 +-
 include/linux/ssb/ssb_regs.h |   40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 1 deletions(-)

-- 
1.7.3.4

