Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51686 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2EPW2d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 18:28:33 -0400
Date: Wed, 16 May 2012 17:28:25 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: stable@vger.kernel.org
Cc: Touko Korpela <touko.korpela@iki.fi>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 3.2.y, 3.3.y] brcm80211: smac: fix endless retry of A-MPDU
 transmissions
Message-ID: <20120516222824.GA11009@burratino> (sfid-20120517_002838_126715_3C215A20)
References: <1330018703-2472-1-git-send-email-arend@broadcom.com>
 <1330018703-2472-2-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330018703-2472-2-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>
Date: Thu, 9 Feb 2012 21:08:58 +0100

commit 5e379203c7788b7af01150bfadbc74d2797a2ef4 upstream.

The A-MPDU code checked against a retry limit, but it was using
the wrong variable to do so. This patch fixes this to assure
proper retry mechanism.

This problem had a side-effect causing the mac80211 flush callback
to remain waiting forever as well. That side effect has been fixed
by commit by Stanislaw Gruszka:

commit f96b08a7e6f69c0f0a576554df3df5b1b519c479
Date:   Tue Jan 17 12:38:50 2012 +0100

    brcmsmac: fix tx queue flush infinite loop

    Reference:
    https://bugzilla.kernel.org/show_bug.cgi?id=42576

Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
Hi Ben and Greg,

Please consider

  5e379203c778 brcm80211: smac: fix endless retry of A-MPDU
               transmissions

for application to the 3.2.y and 3.3.y stable trees.  It is the real
fix to the bug worked around by f96b08a7e6f6 (brcmsmac: fix tx queue
flush infinite loop, 2012-01-17).  The remaining symptom after that
workaround was an assertion failure (WARNING at
drivers/net/wireless/brcm80211/brcmsmac/main.c:8241).

Touko Korpela (cc-ed) tested the patch against 3.2.17 + "brcm80211:
smac: pass missing argument to 'brcms_b_mute'" and found it to
work[1]:

> Patch works, warning is gone after couple of hours of use. I let you
> know if situation changes.

Thanks,
Jonathan

[1] http://bugs.debian.org/672891

 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 7f27dbdb6b60..051586275f14 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1053,17 +1053,13 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		}
 		/* either retransmit or send bar if ack not recd */
 		if (!ack_recd) {
-			struct ieee80211_tx_rate *txrate =
-			    tx_info->status.rates;
-			if (retry && (txrate[0].count < (int)retry_limit)) {
+			if (retry && (ini->txretry[index] < (int)retry_limit)) {
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
 				/*
 				 * Use high prededence for retransmit to
 				 * give some punch
 				 */
-				/* brcms_c_txq_enq(wlc, scb, p,
-				 * BRCMS_PRIO_TO_PREC(tid)); */
 				brcms_c_txq_enq(wlc, scb, p,
 						BRCMS_PRIO_TO_HI_PREC(tid));
 			} else {
-- 
1.7.10.2

