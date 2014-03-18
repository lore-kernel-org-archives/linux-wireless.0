Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:45139 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757838AbaCRT0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 15:26:31 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so6234709wgh.28
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 12:26:30 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/14] staging: vt6656: s_uGetDataDuration use __le16.
Date: Tue, 18 Mar 2014 19:25:06 +0000
Message-Id: <1395170708-2990-12-git-send-email-tvboxspy@gmail.com> (sfid-20140318_202649_911846_FFFAA4BD)
In-Reply-To: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
References: <1395170708-2990-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

s_uGetDataDuration always returns to __le16 type

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/rxtx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index 850d1b9..d30e699 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -129,7 +129,7 @@ static u16 s_vFillRTSHead(struct vnt_private *pDevice, u8 byPktType,
 	union vnt_tx_data_head *head, u32 cbFrameLength, int bNeedAck,
 	struct ethhdr *psEthHeader, u16 wCurrentRate, u8 byFBOption);
 
-static u16 s_uGetDataDuration(struct vnt_private *pDevice,
+static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 	u8 byPktType, int bNeedAck);
 
 static __le16 s_uGetRTSCTSDuration(struct vnt_private *pDevice,
@@ -411,7 +411,7 @@ static u16 s_uGetRTSCTSRsvTime(struct vnt_private *priv,
 }
 
 //byFreqType 0: 5GHz, 1:2.4Ghz
-static u16 s_uGetDataDuration(struct vnt_private *pDevice,
+static __le16 s_uGetDataDuration(struct vnt_private *pDevice,
 					u8 byPktType, int bNeedAck)
 {
 	u32 uAckTime = 0;
-- 
1.9.0

