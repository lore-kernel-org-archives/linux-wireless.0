Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52847 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbbFDE4E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 00:56:04 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t544svsB010945
	for <linux-wireless@vger.kernel.org>; Wed, 3 Jun 2015 21:56:01 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 1usqkvkjkx-1
	(version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2015 21:56:01 -0700
From: David Lin <dlin@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Pete Hsieh <peteh@marvell.com>, Chor Teck Law <ctlaw@marvell.com>
Subject: [PATCH] mwlwifi: Initial submission of wireless driver to mainline
Date: Thu, 4 Jun 2015 04:55:59 +0000
Message-ID: <141c66f2950e4832a2bd99064db75970@SC-EXCH02.marvell.com> (sfid-20150604_065613_821632_75C8A27E)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

	Herewith, I am submitting the Linux driver for WRT1900AC. The work
was initially developed as part of openwrt effort and maintained on
https://github.com/kaloz/mwlwifi, thanks to the host where it is
nurtured.

	Recently, I have also patched it to pass checkpatch.pl so that it
can be qualified for mainline.

	This is still work in progress, with 8864 chipset more mature and
tested, while 8897 for the similar use case is added recently. We
will continue to maintain and enhance it.

We hope the community will welcome this initial submission!

Regards,

David Lin (1):
  Add new mac80211 driver mwlwifi.

 drivers/net/wireless/Kconfig                |    1 +
 drivers/net/wireless/Makefile               |    2 +
 drivers/net/wireless/mwlwifi/Kconfig        |   17 +
 drivers/net/wireless/mwlwifi/Makefile       |    9 +
 drivers/net/wireless/mwlwifi/mwl_debug.c    |  207 ++
 drivers/net/wireless/mwlwifi/mwl_debug.h    |  118 +
 drivers/net/wireless/mwlwifi/mwl_dev.h      |  465 ++++
 drivers/net/wireless/mwlwifi/mwl_fwcmd.c    | 3615 +++++++++++++++++++++++++++
 drivers/net/wireless/mwlwifi/mwl_fwcmd.h    |  184 ++
 drivers/net/wireless/mwlwifi/mwl_fwdl.c     |  218 ++
 drivers/net/wireless/mwlwifi/mwl_fwdl.h     |   29 +
 drivers/net/wireless/mwlwifi/mwl_mac80211.c |  877 +++++++
 drivers/net/wireless/mwlwifi/mwl_mac80211.h |   32 +
 drivers/net/wireless/mwlwifi/mwl_main.c     | 1095 ++++++++
 drivers/net/wireless/mwlwifi/mwl_rx.c       |  589 +++++
 drivers/net/wireless/mwlwifi/mwl_rx.h       |   30 +
 drivers/net/wireless/mwlwifi/mwl_sysadpt.h  |   64 +
 drivers/net/wireless/mwlwifi/mwl_tx.c       |  892 +++++++
 drivers/net/wireless/mwlwifi/mwl_tx.h       |   34 +
 19 files changed, 8478 insertions(+)
 create mode 100644 drivers/net/wireless/mwlwifi/Kconfig
 create mode 100644 drivers/net/wireless/mwlwifi/Makefile
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_debug.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_debug.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_dev.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwcmd.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwcmd.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwdl.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_fwdl.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_mac80211.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_mac80211.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_main.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_rx.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_rx.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_sysadpt.h
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_tx.c
 create mode 100644 drivers/net/wireless/mwlwifi/mwl_tx.h

-- 
1.9.1

