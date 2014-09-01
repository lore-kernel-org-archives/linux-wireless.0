Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5646 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751078AbaIAHem convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 03:34:42 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id s817YflK026330
	for <linux-wireless@vger.kernel.org>; Mon, 1 Sep 2014 00:34:41 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1p3keemn3g-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 01 Sep 2014 00:34:41 -0700
From: Avinash Patil <patila@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 1 Sep 2014 00:33:36 -0700
Subject: RE: mwifiex: parse TDLS action frames during RX
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147CC8@SC-VEXCH2.marvell.com> (sfid-20140901_093446_071247_A509EF0C)
References: <20140828132352.GD24477@mwanda>
In-Reply-To: <20140828132352.GD24477@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for reporting static checker warning.
Patch has been submitted which ensures we do not copy beyond end.

Thanks,
Avinash.
________________________________________
From: Dan Carpenter [dan.carpenter@oracle.com]
Sent: Thursday, August 28, 2014 6:53 PM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: parse TDLS action frames during RX

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
