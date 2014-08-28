Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45552 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbaH1NZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 09:25:21 -0400
Date: Thu, 28 Aug 2014 16:23:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: patila@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: parse TDLS action frames during RX
Message-ID: <20140828132352.GD24477@mwanda> (sfid-20140828_152525_090311_79A452B3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash Patil,

The patch 5f2caaf32bc6: "mwifiex: parse TDLS action frames during RX"
from Feb 7, 2014, leads to the following static checker warning:

	drivers/net/wireless/mwifiex/tdls.c:873 mwifiex_process_tdls_action_frame()
	error: '2 + pos[1]' from user is not capped properly

drivers/net/wireless/mwifiex/tdls.c
   868                          memcpy((u8 *)&sta_ptr->tdls_cap.extcap, pos,
   869                                 sizeof(struct ieee_types_header) +
   870                                 min_t(u8, pos[1], 8));
   871                          break;
   872                  case WLAN_EID_RSN:
   873                          memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
   874                                 sizeof(struct ieee_types_header) + pos[1]);

The ->rsn_ie buffer is 256 bytes large.
sizeof(struct ieee_types_header) is 2.
pos[1] is a number between 0-255.
This can write 1 byte beyond the end.

   875                          break;
   876                  case WLAN_EID_QOS_CAPA:
   877                          sta_ptr->tdls_cap.qos_info = pos[2];
   878                          break;

regards,
dan carpenter
