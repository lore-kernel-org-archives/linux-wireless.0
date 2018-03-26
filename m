Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:14434 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbeCZLqK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Mar 2018 07:46:10 -0400
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@Microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH v2 0/9] staging: wilc1000: fix memory leaks and checkpatch reported issues
Date: Mon, 26 Mar 2018 17:15:54 +0530
Message-ID: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com> (sfid-20180326_134614_374365_E1EB65FD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series contains changes to fix memory leaks, avoid NULL pointer
exceptions and checkpatch reported issue fixes.

V2:
 Modified patch #4, #6, #7 as per review comments.
 Added 'Reviewed-by' tags in commit description.


Ajay Singh (9):
  staging: wilc1000: remove unused global variables related to p2p
  staging: wilc1000: avoid 'NULL' pointer access in
    wilc_network_info_received()
  staging: wilc1000: free allocated memory in edit and add station
    functions
  staging: wilc1000: free memory allocated in add wep key functions
  staging: wilc1000: free allocated memory after processing
    wilc_send_config_pkt()
  staging: wilc1000: fix to free allocated memory in wilc_add_ptk()
  staging: wilc1000: free allocated memory in wilc_add_rx_gtk()
  staging: wilc1000: split handle_rcvd_gnrl_async_info() to avoid
    leading tabs
  staging: wilc1000: free memory allocated for general info message from
    firmware

 drivers/staging/wilc1000/host_interface.c | 448 +++++++++++++++---------------
 1 file changed, 217 insertions(+), 231 deletions(-)

-- 
2.7.4
