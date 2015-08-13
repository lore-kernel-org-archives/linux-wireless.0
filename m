Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:37984 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbbHMElg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 00:41:36 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>
Subject: [PATCH 0/5] staging: wilc1000: 64bit build patch
Date: Thu, 13 Aug 2015 13:41:18 +0900
Message-ID: <1439440883-16061-1-git-send-email-tony.cho@atmel.com> (sfid-20150813_064153_794413_0CBABF86)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patch includes new design for 64 bits. The driver uses the
redundant typecasting to communicate with the chipset, which causes several
compile warnings.

However, this patch uses the real data type and removes unnecessary typecasting.
Also, the driver allocates the ID value to the pointer address representing
the handlers and adds it into the data frames instead of the pointer address.
In results, the driver sends and gets the data frame to/from the chipset
together with ID value instead of pointer address as a handler. This series of
patch removes the warnings which 64 bit issues cause as well.

change log

- v2
 This version 2 updated only "use id value as argument" patch
 : Add return error code in newly added function.
 : Add error handling as the return error code
 : Remove ++ operrator

Johnny Kim (5):
  staging: wilc1000: replace WILC_WFIDrvHandle by tstrWILC_WFIDrv
  staging: wilc1000: change void pointer type to real type
  staging: wilc1000: clarify the argument type
  staging: wilc1000: use the real data type
  staging: wilc1000: use id value as argument

 drivers/staging/wilc1000/host_interface.c         | 471 ++++++++++++++--------
 drivers/staging/wilc1000/host_interface.h         | 109 ++---
 drivers/staging/wilc1000/linux_wlan.c             |  16 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  22 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |   5 +-
 5 files changed, 372 insertions(+), 251 deletions(-)

-- 
1.9.1

