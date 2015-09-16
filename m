Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26790 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbbIPJgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 05:36:05 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH v2 0/6] removing wilc_errorsupport.h file
Date: Wed, 16 Sep 2015 18:35:58 +0900
Message-ID: <1442396164-18728-1-git-send-email-tony.cho@atmel.com> (sfid-20150916_113614_820071_2E636CE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patch is resent in total 6 patches as version 2. This version
fixes the warnings reported by checkpatch.pl not to make additional warnings.
The concern for the memory leak issue is checked again in this version.

The error types provided by wilc driver are being replaced by the ones provided
by Linux kernel and the macros which checking errors are being deleted in these
patches becasue they are not helpful to code readability.

Leo Kim (6):
  staging: wilc1000: remove a macro WILC_NULLCHECK
  staging: wilc1000: remove the macro WILC_ERRORCHECK
  staging: wilc1000: remove the macro WILC_ERRORREPORT
  staging: wilc1000: remove definitions unused
  staging: wilc1000: replace wilc error types with the generic error
    types
  staging: wilc1000: remove wilc_errorsupport.h

 drivers/staging/wilc1000/coreconfigurator.c       |   28 +-
 drivers/staging/wilc1000/host_interface.c         | 1115 +++++++++------------
 drivers/staging/wilc1000/linux_mon.c              |   14 +-
 drivers/staging/wilc1000/linux_wlan.c             |    2 +-
 drivers/staging/wilc1000/wilc_errorsupport.h      |   64 --
 drivers/staging/wilc1000/wilc_msgqueue.c          |  113 ++-
 drivers/staging/wilc1000/wilc_msgqueue.h          |    1 -
 drivers/staging/wilc1000/wilc_oswrapper.h         |    3 -
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  133 ++-
 9 files changed, 616 insertions(+), 857 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_errorsupport.h

-- 
1.9.1

