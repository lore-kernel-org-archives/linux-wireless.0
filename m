Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38677 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbESFrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 01:47:21 -0400
Received: by wichy4 with SMTP id hy4so7980766wic.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2015 22:47:19 -0700 (PDT)
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Haggai Eran <haggai.eran@gmail.com>
Subject: [PATCH] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
Date: Tue, 19 May 2015 08:47:24 +0300
Message-Id: <1432014444-29039-1-git-send-email-haggai.eran@gmail.com> (sfid-20150519_074733_526627_7608FC99)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With an RTL8191SU USB adaptor, sometimes the hints for a fragmented
packet are set, but the packet length is too large. Truncate the packet
to prevent memory corruption.

Signed-off-by: Haggai Eran <haggai.eran@gmail.com>
---

Hi,

I think this solves the issue for me. I'll test it more thoroughly later. I
still don't know why a fragmented packet has such a large pkt_len value though. 

Thanks,
Haggai

 drivers/staging/rtl8712/rtl8712_recv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index cd8b444..d7ea9c1 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -1055,8 +1055,12 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		pkt_offset = (u16)round_up(tmp_len, 128);
 		/* for first fragment packet, driver need allocate 1536 +
 		 * drvinfo_sz + RXDESC_SIZE to defrag packet. */
-		if ((mf == 1) && (frag == 0))
+		if ((mf == 1) && (frag == 0)) {
 			alloc_sz = 1658;/*1658+6=1664, 1664 is 128 alignment.*/
+            if (tmp_len > alloc_sz) {
+                tmp_len = alloc_sz;
+            }
+        }
 		else
 			alloc_sz = tmp_len;
 		/* 2 is for IP header 4 bytes alignment in QoS packet case.
-- 
1.9.1

