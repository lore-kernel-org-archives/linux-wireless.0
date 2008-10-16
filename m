Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:41324 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbYJPPqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 11:46:18 -0400
Message-ID: <48F761CA.5040102@lwfinger.net> (sfid-20081016_174647_664575_D3BECAD6)
Date: Thu, 16 Oct 2008 08:46:18 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH 6/6] p54: integrate parts of lmac_longbow.h and other
 parts of stlc45xx
References: <200810150408.44363.chunkeey@web.de>
In-Reply-To: <200810150408.44363.chunkeey@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> This patch removes most/all? of the "magic" numbers and unknown structure 
> variables inside the code and replaces them with meaningful prototypes.
> 
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---

The following change of ack_rssi from __le16 to u8 generates the sparse warning
"drivers/net/wireless/p54/p54common.c:660:5: warning: cast to restricted __le16":

> +struct p54_frame_sent {
>  	u8 status;
> -	u8 retries;
> -	__le16 ack_rssi;
> +	u8 tries;
> +	u8 ack_rssi;
> +	u8 quality;

The statement in question is:

info->status.ack_signal = p54_rssi_to_dbm(dev,
                le16_to_cpu(payload->ack_rssi));

The following patch fixes the warning:

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -657,7 +657,7 @@ static void p54_rx_frame_sent(struct iee
                if (payload->status & 0x02)
                        info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
                info->status.ack_signal = p54_rssi_to_dbm(dev,
-                               le16_to_cpu(payload->ack_rssi));
+                               (int)payload->ack_rssi);
                skb_pull(entry, sizeof(*hdr) + pad + sizeof(*entry_data));
                ieee80211_tx_status_irqsafe(dev, entry);
                goto out;

Larry


