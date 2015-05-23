Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:36768 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbbEWUOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2015 16:14:18 -0400
From: Haggai Eran <haggai.eran@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Haggai Eran <haggai.eran@gmail.com>,
	Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless@vger.kernel.org, <stable@vger.kernel.org>
Subject: [PATCH v1] staging: rtl8712: prevent buffer overrun in recvbuf2recvframe
Date: Sat, 23 May 2015 23:13:51 +0300
Message-Id: <1432412031-12871-1-git-send-email-haggai.eran@gmail.com> (sfid-20150523_221422_451141_263C519A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With an RTL8191SU USB adaptor, sometimes the hints for a fragmented
packet are set, but the packet length is too large. Allocate enough
space to prevent memory corruption and a resulting kernel panic [1].

[1] http://www.spinics.net/lists/linux-wireless/msg136546.html

Cc: <stable@vger.kernel.org>
Signed-off-by: Haggai Eran <haggai.eran@gmail.com>
---
Hi Larry,

I've updated the patch to avoid truncating the packets. I'm keeping the minimal
buffer of 1658 bytes in case some other device does rely on this
defragmentation feature.

Regards,
Haggai

 drivers/staging/rtl8712/rtl8712_recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index cd8b444..5542243 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -1056,7 +1056,8 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		/* for first fragment packet, driver need allocate 1536 +
 		 * drvinfo_sz + RXDESC_SIZE to defrag packet. */
 		if ((mf == 1) && (frag == 0))
-			alloc_sz = 1658;/*1658+6=1664, 1664 is 128 alignment.*/
+			/*1658+6=1664, 1664 is 128 alignment.*/
+			alloc_sz = max_t(u16, tmp_len, 1658);
 		else
 			alloc_sz = tmp_len;
 		/* 2 is for IP header 4 bytes alignment in QoS packet case.
-- 
1.9.1

