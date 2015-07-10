Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:44279 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbbGJF4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2015 01:56:18 -0400
From: Johnny Kim <johnny.kim@atmel.com>
To: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<linux-wireless@vger.kernel.org>, <chris.park@atmel.com>
CC: <johnny.kim@atmel.com>, <rachel.kim@atmel.com>,
	<tony.cho@atmel.com>, <Nicolas.FERRE@atmel.com>,
	<dean.lee@atmel.com>, <austin.shin@atmel.com>
Subject: [PATCH 0/3] staging: wilc1000: rework integer value for x64
Date: Fri, 10 Jul 2015 14:55:54 +0900
Message-ID: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com> (sfid-20150710_075622_163648_5EFD7671)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Greg.

This driver convert pointer address to integer value and use it
as function argument. because the value has a limited 32bit size,
current driver happen many issues on x64 machine.

I have split it up enough sensibliy to allow review. If this patches
are accepted, I will update more patches related with this patch.

Best regards.
Johnny.

Johnny Kim (3):
  staging: wilc1000: wilc_wlan_cfg_commit(): replace integer with
    pointer
  staging: wilc1000: wilc_wlan_cfg_get(): replace integer with void
    pointer
  staging: wilc1000: wilc_wlan_cfg_set(): replace integer with void
    pointer

 drivers/staging/wilc1000/coreconfigurator.c |  4 ++--
 drivers/staging/wilc1000/linux_wlan.c       |  2 +-
 drivers/staging/wilc1000/wilc_wlan.c        | 12 ++++++------
 drivers/staging/wilc1000/wilc_wlan_if.h     |  4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

-- 
1.9.1

