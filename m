Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36422 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaBNJC4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 04:02:56 -0500
Date: Fri, 14 Feb 2014 12:02:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: patila@marvell.com
Cc: linux-wireless@vger.kernel.org, Bing Zhao <bzhao@marvell.com>
Subject: re: mwifiex: parse TDLS action frames during RX
Message-ID: <20140214090244.GA13684@elgon.mountain> (sfid-20140214_100331_655666_8B148305)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Avinash Patil,

The patch 5f2caaf32bc6: "mwifiex: parse TDLS action frames during RX"
from Feb 7, 2014, leads to the following static checker warning:

	drivers/net/wireless/mwifiex/tdls.c:820 mwifiex_process_tdls_action_frame()
	error: memcpy() '&sta_ptr->tdls_cap.rsn_ie' too small (256 vs 257)

drivers/net/wireless/mwifiex/tdls.c
   814                  case WLAN_EID_EXT_CAPABILITY:
   815                          memcpy((u8 *)&sta_ptr->tdls_cap.extcap, pos,
   816                                 sizeof(struct ieee_types_header) +
   817                                 min_t(u8, pos[1], 8));
   818                          break;
   819                  case WLAN_EID_RSN:
   820                          memcpy((u8 *)&sta_ptr->tdls_cap.rsn_ie, pos,
   821                                 sizeof(struct ieee_types_header) + pos[1]);

Smatch thinks pos[] is untrusted data because it comes from skb->data
in mwifiex_process_rx_packet().

sta_ptr->tdls_cap.rsn_ie is defined like:

struct ieee_types_generic {
        struct ieee_types_header ieee_hdr;
        u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_header)];
} __packed;

So it is IEEE_MAX_IE_SIZE (256) bytes long.  Meanwhile the memcpy()
limit is 2 + 0xff, so it's 257 and we are corrupting a byte past the end
of the struct.

   822                          break;
   823                  case WLAN_EID_QOS_CAPA:
   824                          sta_ptr->tdls_cap.qos_info = pos[2];
   825                          break;

regards,
dan carpenter
