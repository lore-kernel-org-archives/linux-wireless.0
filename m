Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:56597 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbIOCxl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 22:53:41 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 0/7] remove wilc_errorsupport.h from the wilc driver
Date: Tue, 15 Sep 2015 11:53:34 +0900
Message-ID: <1442285621-29457-1-git-send-email-tony.cho@atmel.com> (sfid-20150915_045344_663902_7497B37D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch aims to remove the wilc_errorsupport.h which is unnecessary in the
wilc driver. This patch replaces the error types defined by wilc driver with
kernel generic error types and removes macros which handles the errors.

Leo Kim (7):
  staging: wilc1000: remove definition WILC_IS_ERR
  staging: wilc1000: remove definition WILC_NULLCHECK
  staging: wilc1000: remove definition WILC_ERRORCHECK
  staging: wilc1000: remove definition WILC_ERRORREPORT
  staging: wilc1000: remove definitions unused
  staging: wilc1000: replace wilc error types with kernel generic error
    type.
  staging: wilc1000: remove wilc_errorsupport

 drivers/staging/wilc1000/coreconfigurator.c       |   30 +-
 drivers/staging/wilc1000/host_interface.c         | 1166 +++++++++------------
 drivers/staging/wilc1000/linux_mon.c              |   14 +-
 drivers/staging/wilc1000/linux_wlan.c             |    2 +-
 drivers/staging/wilc1000/wilc_errorsupport.h      |   65 --
 drivers/staging/wilc1000/wilc_msgqueue.c          |  112 +-
 drivers/staging/wilc1000/wilc_msgqueue.h          |    1 -
 drivers/staging/wilc1000/wilc_oswrapper.h         |    3 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  133 ++-
 9 files changed, 643 insertions(+), 883 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_errorsupport.h

-- 
1.9.1

