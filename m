Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:59573 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754607AbeBPPMb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:12:31 -0500
From: Ajay Singh <ajay.kathat@microchip.com>
To: <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <claudiu.beznea@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 10/12] staging: wilc1000: fix line over 80 characters in tcp_process()
Date: Fri, 16 Feb 2018 20:41:47 +0530
Message-ID: <1518793909-15573-11-git-send-email-ajay.kathat@microchip.com> (sfid-20180216_161236_113086_CC5163B9)
In-Reply-To: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
References: <1518793909-15573-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix "line over 80 characters" issue found by checkpatch.pl script.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index aedf84d..391ecd5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -232,8 +232,10 @@ static inline void tcp_process(struct net_device *dev, struct txq_entry_t *tqe)
 					 (u32)tcp_hdr_ptr[11];
 
 				for (i = 0; i < tcp_session; i++) {
+					u32 j = ack_session_info[i].seq_num;
+
 					if (i < 2 * MAX_TCP_SESSION &&
-					    ack_session_info[i].seq_num == seq_no) {
+					    j == seq_no) {
 						update_tcp_session(i, ack_no);
 						break;
 					}
-- 
2.7.4
