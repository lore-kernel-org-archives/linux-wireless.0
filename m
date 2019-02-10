Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D78D1C282C2
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 01:53:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E0F320811
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 01:53:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="gu4mGamc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfBKBxA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 20:53:00 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:46378 "EHLO
        4.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfBKBw7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 20:52:59 -0500
X-Greylist: delayed 8398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 20:52:59 EST
Received: from player755.ha.ovh.net (unknown [10.109.160.232])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id EF0EC1836D4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:47 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player755.ha.ovh.net (Postfix) with ESMTPSA id B0D8D2A708C2;
        Sun, 10 Feb 2019 21:06:46 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832805;
        bh=KY6TJSyWNHTUFJpACrDg8lSGQh1b9Z4/kNsjsgZEJh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=gu4mGamcptSvMvWcMIODsmnX9QPoibSyQyukEGBqzYfWlXVFs7gI68HfHkUB8U+bA
         kwuGTdliPs5iczc0lAVyF+IYBSYLp813saueOvNzX1wIMDXQus3CZRNaeMu2h46XxY
         eG6fhhNeWE892Khu2DkdlEctN/NX+I1EWV71qoNk=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 12/12] ath9k: EXT_KEY_ID A-MPDU API update
Date:   Sun, 10 Feb 2019 22:06:20 +0100
Message-Id: <20190210210620.31181-13-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190210210620.31181-1-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10549400653003824327
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrleeggdeiiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When using Extended Key ID mac80211 drops @IEEE80211_TX_CTL_AMPDU for
the last packet which can be added to a A-MPDU in preparation.

Finalize A-MPDU immediately and start a new aggregation.

Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
---

This is the (b)leading edge of my current attempt to figure out a
solution to the "must not aggregate keyid 0 and 1 frames together"
problem.

I've not even tested that patch properly, yet..
So it only shows how I think ath9k driver can use the A-MPDU border
signal to send out the A-MPDU frame currently under construction.

May be useful to figure out if we want to implement A-MPDU border signal
in mac80211, through.

 drivers/net/wireless/ath/ath9k/xmit.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index a24265018cb2..84bbce6f212f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -990,10 +990,8 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 		 * from a previous session or a failed attempt in the queue.
 		 * Send them out as normal data frames
 		 */
-		if (!tid->active)
+		if (!tid->active) {
 			tx_info->flags &= ~IEEE80211_TX_CTL_AMPDU;
-
-		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			bf->bf_state.bf_type = 0;
 			return bf;
 		}
@@ -1017,12 +1015,18 @@ ath_tx_get_tid_subframe(struct ath_softc *sc, struct ath_txq *txq,
 			break;
 		}
 
-		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno)) {
+		if (tid->bar_index > ATH_BA_INDEX(tid->seq_start, seqno) ||
+		    !(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) {
 			struct ath_tx_status ts = {};
 			struct list_head bf_head;
 
 			INIT_LIST_HEAD(&bf_head);
-			list_add(&bf->list, &bf_head);
+			if (tx_info->flags & IEEE80211_TX_CTL_AMPDU &&
+			    tid->bar_index <= ATH_BA_INDEX(tid->seq_start, seqno))
+				list_add(&bf->list, &bf_head);
+			else
+				ath_tx_addto_baw(sc, tid, bf);
+
 			ath_tx_update_baw(sc, tid, bf);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, NULL, &ts, 0);
 			continue;
-- 
2.20.1

