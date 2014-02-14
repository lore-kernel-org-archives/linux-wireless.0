Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:31466 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbaBNJ5a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Feb 2014 04:57:30 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id s1E9vTO9025589
	for <linux-wireless@vger.kernel.org>; Fri, 14 Feb 2014 01:57:29 -0800
Received: from sc-owa03.marvell.com ([199.233.58.149])
	by mx0b-0016f401.pphosted.com with ESMTP id 1j16gptah7-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 14 Feb 2014 01:57:29 -0800
From: Avinash Patil <patila@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bing Zhao <bzhao@marvell.com>
Date: Fri, 14 Feb 2014 01:57:25 -0800
Subject: RE: mwifiex: parse TDLS action frames during RX
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC22D1A79260@SC-VEXCH2.marvell.com> (sfid-20140214_105742_456385_8057640B)
References: <20140214090244.GA13684@elgon.mountain>
In-Reply-To: <20140214090244.GA13684@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for reporting the issue.

I will submit a patch to fix this warning.

Thanks and Regards,
Avinash Patil

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Friday, February 14, 2014 2:33 PM
To: Avinash Patil
Cc: linux-wireless@vger.kernel.org; Bing Zhao
Subject: re: mwifiex: parse TDLS action frames during RX

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
