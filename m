Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:37947 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3FEOYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:24:37 -0400
Received: by mail-ie0-f169.google.com with SMTP id 10so3876126ied.28
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 07:24:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370371064-6903-1-git-send-email-linux@rempel-privat.de>
References: <51ADBC01.6090202@blackshift.org>
	<1370371064-6903-1-git-send-email-linux@rempel-privat.de>
Date: Wed, 5 Jun 2013 16:24:36 +0200
Message-ID: <CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com> (sfid-20130605_162440_434495_A74916A6)
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, Marc Kleine-Budde <mkl@blackshift.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 4, 2013 at 8:37 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> This error seems to be really rare, and we do not know real couse of it.
> But, in any case, we should check size of head before reducing it.

Mind to try the (completely untested) patch against wireless-testing instead?
Helmut

---
Subject: [PATCH] ath9k_htc: Restore skb headroom when returning skb to mac80211

ath9k_htc adds padding between the 802.11 header and the payload during
TX by moving the header. When handing the frame back to mac80211 for TX
status handling the header is not moved back into its original position.
This can result in a too small skb headroom when entering ath9k_htc
again (due to a soft retransmission for example) causing an
skb_under_panic oops.

Fix this by moving the 802.11 header back into its original position
before returning the frame to mac80211 as other drivers like rt2x00
or ath5k do.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index e602c95..666cfb6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -448,6 +448,8 @@ static void ath9k_htc_tx_process(struct
ath9k_htc_priv *priv,
     struct ieee80211_conf *cur_conf = &priv->hw->conf;
     bool txok;
     int slot;
+    struct ieee80211_hdr *hdr;
+    int padpos, padsize;

     slot = strip_drv_header(priv, skb);
     if (slot < 0) {
@@ -504,6 +506,15 @@ send_mac80211:

     ath9k_htc_tx_clear_slot(priv, slot);

+    /* Remove padding before handing frame back to mac80211 */
+    hdr = (struct ieee80211_hdr *) skb->data;
+    padpos = ieee80211_hdrlen(hdr->frame_control);
+    padsize = padpos & 3;
+    if (padsize && skb->len > padpos + padsize) {
+        memmove(skb->data + padsize, skb->data, padpos);
+        skb_pull(skb, padsize);
+    }
+
     /* Send status to mac80211 */
     ieee80211_tx_status(priv->hw, skb);
 }
--
1.7.10.4
