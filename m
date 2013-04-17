Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4305 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966709Ab3DQT0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 15:26:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: change return type for
 brcmf_rollback_toq() to void
Date: Wed, 17 Apr 2013 21:25:57 +0200
Message-ID: <1366226758-20641-10-git-send-email-arend@broadcom.com> (sfid-20130417_212622_165007_74B0E347)
In-Reply-To: <1366226758-20641-1-git-send-email-arend@broadcom.com>
References: <1366226758-20641-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function brcmf_rollback_toq() is already called in error path
and its result should not override the initial error value. As the
function releases the sk_buff there is no need to return anything
so change return type to void.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 13518ec..25eaa13 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1574,7 +1574,7 @@ static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 	return rc;
 }
 
-static int
+static void
 brcmf_fws_rollback_toq(struct brcmf_fws_info *fws, struct sk_buff *skb)
 {
 	/*
@@ -1654,7 +1654,6 @@ fail:
 		fws->stats.rollback_failed++;
 	} else
 		fws->stats.rollback_success++;
-	return rc;
 }
 
 static int brcmf_fws_consume_credit(struct brcmf_fws_info *fws, int fifo,
@@ -1733,7 +1732,7 @@ static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
 	return rc;
 
 rollback:
-	rc = brcmf_fws_rollback_toq(fws, skb);
+	brcmf_fws_rollback_toq(fws, skb);
 	return rc;
 }
 
-- 
1.7.10.4


