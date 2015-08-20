Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:18432 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbbHTHdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 03:33:23 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <jude.lee@atmel.com>, <robin.hwang@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 0/5] staging: wilc1000: support 64bit machine and remove warnings
Date: Thu, 20 Aug 2015 16:32:49 +0900
Message-ID: <1440055974-9998-1-git-send-email-tony.cho@atmel.com> (sfid-20150820_093330_883204_C09EB767)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This includes the remaining patches for 64bits. The driver uses the redundant
typecasting to communicate with the chipset, which causes several compile
warnings.

However, this patch uses the real data type and removes unnecessary typecasting.
Also, the driver allocates the ID value to the pointer address representing
the handlers and adds it into the data frames instead of the pointer address.
In results, the driver sends and gets the data frame to/from the chipset
together with ID value instead of pointer address as a handler. The ID value is
vaild from 0 to NUM_CONCURRENT_IFC. Only 0 value is the reserved value to
terminate a handler and to inform it to chipset.

This series of patch removes the warnings which 64 bit issue and the redundant
typecasting cause as well.

Johnny Kim (5):
  staging: wilc1000: use the real data type
  staging: wilc1000: add an argument for Handle_SetWfiDrvHandler
  staging: wilc1000: use id value as argument
  staging: wilc1000: change address to fixed value
  staging: wilc1000: define undefined operation mode

 drivers/staging/wilc1000/host_interface.c     | 271 ++++++++++++++++++--------
 drivers/staging/wilc1000/host_interface.h     |   2 +
 drivers/staging/wilc1000/linux_wlan.c         |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h |   1 -
 4 files changed, 195 insertions(+), 83 deletions(-)

-- 
1.9.1

