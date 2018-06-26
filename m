Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:18401 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750919AbeFZGHM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 02:07:12 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 00/12] staging: wilc1000: address TODO item to remove host_if_work()
Date: Tue, 26 Jun 2018 11:37:02 +0530
Message-ID: <1529993234-27294-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180626_080716_306748_AFEDE44C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current patch series contains changes to address TODO item [1].

[1]. Move handling for each individual members of 'union message_body' out
into a separate 'struct work_struct' and completely remove the multiplexer
that is currently part of host_if_work(), allowing movement of the
implementation of each message handler into the callsite of the function
that currently queues the 'host_if_msg'.


Ajay Singh (12):
  staging: wilc1000: remove host_if_work() to handle TODO list issue
  staging: wilc1000: remove unused marco related to HIF commands
  staging: wilc1000: move the allocation of cmd out of
    wilc_enqueue_cmd()
  staging: wilc1000: added 'work_comp' completion as part of host_if_msg
  staging: wilc1000: remove 'hif_thread_comp' completions
  staging: wilc1000: rename wilc_enqueue_cmd() to wilc_enqueue_work()
  staging: wilc1000: handle freeing of key data in wep add key
  staging: wilc1000: handle freeing of key data in wilc_add_ptk()
  staging: wilc1000: handle freeing of 'key' & 'seq' data in
    wilc_add_rx_gtk()
  staging: wilc1000: avoid use of static variable 'inactive_time'
  staging: wilc1000: avoid use of static variable 'rssi'
  staging: wilc1000: updated TODO file

 drivers/staging/wilc1000/TODO                     |    5 -
 drivers/staging/wilc1000/host_interface.c         | 1548 +++++++++++----------
 drivers/staging/wilc1000/host_interface.h         |    7 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |    2 +-
 4 files changed, 799 insertions(+), 763 deletions(-)

-- 
2.7.4
