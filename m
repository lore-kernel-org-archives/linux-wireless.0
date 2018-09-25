Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE529C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:23:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9245A21480
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9245A21480
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbeIYM3z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:29:55 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:12155 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeIYM3y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:29:54 -0400
X-IronPort-AV: E=Sophos;i="5.54,301,1534834800"; 
   d="scan'208";a="20543148"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 24 Sep 2018 23:23:55 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 chn-sv-exch03.mchp-main.com (10.10.76.49) with Microsoft SMTP Server id
 14.3.352.0; Mon, 24 Sep 2018 23:23:54 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v3 00/29] staging: wilc1000: avoid static variables and cleanup changes
Date:   Tue, 25 Sep 2018 11:53:15 +0530
Message-ID: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series contains changes to avoid the use of static variables.
Cleanup changes to fix some checkpatch issues and return void for
function if their return value is not used.
Also deleted 'wilc_debugfs.c' file as it's not used.

Changes since v2:
   Included Joe's suggestion for patch#28
    - replaced previous patch with an improved version(refactor code)

Changes since v1:
   Address Dan's comment for patch#29
    - return the correct error for failure in the second iteration

Ajay Singh (29):
  staging: wilc1000: change return type to 'void' for
    wilc_frame_register()
  staging: wilc1000: change return type to 'void' for
    wilc_wlan_set_bssid()
  staging: wilc1000: change return type to 'void' for lock init & deinit
    functions
  staging: wilc1000: change return type to 'void' for
    wilc_deinit_host_int()
  staging: wilc1000: change return type to 'void' for
    wilc_wfi_deinit_mon_interface()
  staging: wilc1000: use 'void' return type for
    host_int_get_assoc_res_info()
  staging: wilc1000: use 'void' return for wilc_wlan_txq_add_to_head()
  staging: wilc1000: change return type to 'void' tcp ack filter
    functions
  staging: wilc1000: use 'void' return for
    wilc_wlan_txq_filter_dup_tcp_ack()
  staging: wilc1000: change return type to 'void' for
    wilc_wlan_cfg_indicate_rx()
  staging: wilc1000: refactor wilc_wlan_parse_info_frame() function
  staging: wilc1000: set default value of cfg response type in
    wilc_wlan_cfg_indicate_rx()
  staging: wilc1000: changes 'val' type to u8 in wilc_cfg_byte struct
  staging: wilc1000: remove unused wid type values
  staging: wilc1000: remove unused wid from cfg struct
  staging: wilc1000: refactor code to remove 'mac_status' from
    'wilc_mac_cfg' struct
  staging: wilc1000: refactor code to avoid static variables for config
    parameters
  staging: wilc1000: rename 'wilc_mac_cfg' struct to 'wilc_cfg_str_vals'
  staging: wilc1000: avoid the use of 'hif_driver_comp' completion
    variable
  staging: wilc1000: remove use of unnecessary 'wilc_connected_ssid'
    variable
  staging: wilc1000: avoid use of 'g_sdio' static variable
  staging: wilc1000: avoid use of 'g_spi' static variable
  staging: wilc1000: remove unnecessary memset in sdio_init() &
    wilc_spi_init()
  staging: wilc1000: remove p2p related static variables to wilc_vif
    struct
  staging: wilc1000: remove wilc_debugfs.c file as its not used
  staging: wilc1000: remove unnecessary option used with ccflags-y in
    Makefile
  staging: wilc1000: use usleep_range() in place of udelay()
  staging: wilc1000: refactor wilc_set_multicast_list() function
  staging: wilc1000: return exact error of register_netdev() from
    wilc_netdev_init()

 drivers/staging/wilc1000/Makefile                 |   5 +-
 drivers/staging/wilc1000/host_interface.c         |  64 ++---
 drivers/staging/wilc1000/host_interface.h         |   6 +-
 drivers/staging/wilc1000/linux_mon.c              |   3 +-
 drivers/staging/wilc1000/linux_wlan.c             |  64 +++--
 drivers/staging/wilc1000/wilc_debugfs.c           | 115 ---------
 drivers/staging/wilc1000/wilc_sdio.c              |  56 +++--
 drivers/staging/wilc1000/wilc_spi.c               |  57 +++--
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  90 +++----
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.h |   4 +-
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  14 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  44 ++--
 drivers/staging/wilc1000/wilc_wlan.h              |   3 +-
 drivers/staging/wilc1000/wilc_wlan_cfg.c          | 294 +++++++++-------------
 drivers/staging/wilc1000/wilc_wlan_cfg.h          |  26 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   4 -
 16 files changed, 340 insertions(+), 509 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_debugfs.c

-- 
2.7.4

