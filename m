Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4019 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075Ab1CUUQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 16:16:52 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: george@znau.edu.ua
cc: zajec5@gmail.com, mb@bu3sch.de, linville@tuxdriver.com,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: [RFC] drivers: brcmaxi: AMBA AXI functionality library module
Date: Mon, 21 Mar 2011 21:16:25 +0100
Message-ID: <1300738586-7157-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To feed the active discussion some more I offer this patch to be
reviewed by those interested. I do not expect this to be all peachy
but would like to get a more concrete discussion going here.

Refer to thread 'new utility kernel module for detecting cores in newer
chipsets'. George used the term 'backplane agents'. This module could
be considered such an agent. It exposes cores to the 'core driver' by
calling driver provided callbacks. Currently it also exposes register
space (wrapper) which only concerns 'backplane agents' and not so much
to 'core drivers'. Currently, this module does not provide any code
for the 'core drivers'.

Arend van Spriel (1):
  drivers: brcmaxi: provide amba axi functionality in separate module

 drivers/Kconfig          |    2 +
 drivers/Makefile         |    1 +
 drivers/brcmaxi/Makefile |   23 ++
 drivers/brcmaxi/axi.c    |  859 ++++++++++++++++++++++++++++++++++++++++++++++
 include/brcmaxi/axi.h    |  340 ++++++++++++++++++
 5 files changed, 1225 insertions(+), 0 deletions(-)
 create mode 100644 drivers/brcmaxi/Makefile
 create mode 100644 drivers/brcmaxi/axi.c
 create mode 100644 include/brcmaxi/axi.h


