Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:24792 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbbCFRkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 12:40:49 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/5] brcmfmac: Fix race condition in msgbuf ioctl processing.
Date: Fri, 6 Mar 2015 18:40:41 +0100
Message-ID: <1425663642-19725-5-git-send-email-arend@broadcom.com> (sfid-20150306_184057_478916_C8710D2E)
In-Reply-To: <1425663642-19725-1-git-send-email-arend@broadcom.com>
References: <1425663642-19725-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Msgbuf is using a wait_event_timeout to wait for the response on
an ioctl. The wakeup routine uses waitqueue_active to see if
wait_event_timeout has been called. There is a chance that the
response arrives before wait_event_timeout is called, this
will result in situation that wait_event_timeout never gets
woken again and assumed result will be a timeout. This patch
removes that errornous situation by always setting the
ctl_completed var before checking for queue active.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
index 6262612..4ec9811 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c
@@ -481,10 +481,9 @@ static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
 
 static void brcmf_msgbuf_ioctl_resp_wake(struct brcmf_msgbuf *msgbuf)
 {
-	if (waitqueue_active(&msgbuf->ioctl_resp_wait)) {
-		msgbuf->ctl_completed = true;
+	msgbuf->ctl_completed = true;
+	if (waitqueue_active(&msgbuf->ioctl_resp_wait))
 		wake_up(&msgbuf->ioctl_resp_wait);
-	}
 }
 
 
-- 
1.9.1

