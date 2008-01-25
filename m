Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4816 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbYAYVdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 16:33:41 -0500
Date: Fri, 25 Jan 2008 16:18:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michael Buesch <mb@bu3sch.de>, Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
Message-ID: <20080125211815.GF14687@tuxdriver.com> (sfid-20080125_213347_250275_5598AFD2)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <alpine.LFD.1.00.0801250934030.14161@hp.linux-foundation.org> <alpine.LFD.1.00.0801251011590.14161@hp.linux-foundation.org> <200801251930.27022.mb@bu3sch.de> <alpine.LFD.1.00.0801251045430.2979@hp.linux-foundation.org> <20080125194807.GD14687@tuxdriver.com> <20080125195037.GE14687@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080125195037.GE14687@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2008 at 02:50:37PM -0500, John W. Linville wrote:
> On Fri, Jan 25, 2008 at 02:48:07PM -0500, John W. Linville wrote:
> 
> > http://kerneltrap.org/mailarchive/linux-netdev/2007/11/24/442496
> > 
> > Quoth Herbert Xu:
> > 
> > "OK.  Let me clarify this a bit more.  We require at least one
> > of the following rules to be met:
> > 
> > * the IPv4/IPv6 header is aligned by 8 bytes on reception;
> > * or the platform provides unaligned exception handlers.
> 
> > (Hmmm..."aligned by 8 bytes", so our warning and my iwlwifi patch
> > may still not be right...)
> 
> http://kerneltrap.org/mailarchive/linux-netdev/2007/11/25/443558
> 
> More from Herbert:
> 
> "Sorry I was wrong about the 8 bytes requirement.  Although the
> IPv6 protocol does try to maintain an 8-byte alignment the Linux
> stack never does anything that requires that.
> 
> So 4 bytes is enough."
> 
> Phew!

Alright, here is my whack at it...  The iwl_handle_data_packet_monitor
bits are untested, as I appear to be too daft to figure-out how to
exercise those paths.

Anyway, this is mostly just so we can scope the driver change required
in absence of a firmware change.  Persumably the changes required if
we were to put such code in mac80211 would be similar.

John

-----

From: John W. Linville <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: move data at CPU to ensure 4-byte alignment for payload

Ugly, but if the firmware won't cooperate...

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   13 ++++++++++---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   10 +++++++++-
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   10 +++++++++-
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 3a45fe9..06cd28e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -252,6 +252,7 @@ static void iwl3945_handle_data_packet(struct iwl_priv *priv, int is_data,
 	struct iwl_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
 	struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
 	short len = le16_to_cpu(rx_hdr->len);
+	int hdrlen, align;
 
 	/* We received data from the HW, so stop the watchdog */
 	if (unlikely((len + IWL_RX_FRAME_SIZE) > skb_tailroom(rxb->skb))) {
@@ -275,11 +276,17 @@ static void iwl3945_handle_data_packet(struct iwl_priv *priv, int is_data,
 		return;
 	}
 
-	skb_reserve(rxb->skb, (void *)rx_hdr->payload - (void *)pkt);
+	hdr = (void *)rx_hdr->payload;
+	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+	align = hdrlen & 3;
+
+	skb_reserve(rxb->skb, (void *)rx_hdr->payload - (void *)pkt - align);
 	/* Set the size of the skb to the size of the frame */
-	skb_put(rxb->skb, le16_to_cpu(rx_hdr->len));
+	skb_put(rxb->skb, len);
 
-	hdr = (void *)rxb->skb->data;
+        /* align payload on 4-byte boundary if necessary */
+	if (align)
+		memmove((void *)hdr - align, hdr, len);
 
 	if (iwl_param_hwcrypto)
 		iwl_set_decrypted_flag(priv, rxb->skb,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 891f90d..11eb75b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -3496,6 +3496,7 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	__le32 *rx_end;
 	unsigned int skblen;
 	u32 ampdu_status;
+	int hdrlen, align;
 
 	if (!include_phy && priv->last_phy_res[0])
 		rx_start = (struct iwl4965_rx_phy_res *)&priv->last_phy_res[1];
@@ -3533,10 +3534,17 @@ static void iwl4965_handle_data_packet(struct iwl_priv *priv, int is_data,
 	ampdu_status = le32_to_cpu(*rx_end);
 	skblen = ((u8 *) rx_end - (u8 *) & pkt->u.raw[0]) + sizeof(u32);
 
+	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+	align = hdrlen & 3;
+
 	/* start from MAC */
-	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt);
+	skb_reserve(rxb->skb, (void *)hdr - (void *)pkt - align);
 	skb_put(rxb->skb, len);	/* end where data ends */
 
+	/* align payload on 4-byte boundary if necessary */
+	if (align)
+		memmove(rxb->skb->data, hdr, len);
+
 	/* We only process data packets if the interface is open */
 	if (unlikely(!priv->is_open)) {
 		IWL_DEBUG_DROP_LIMIT
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 1a6b0e0..d6018bd 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3056,7 +3056,9 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 				    struct ieee80211_rx_status *stats,
 				    u16 phy_flags)
 {
+	struct ieee80211_hdr *hdr;
 	struct iwl_rt_rx_hdr *iwl_rt;
+	int hdrlen, align;
 
 	/* First cache any information we need before we overwrite
 	 * the information provided in the skb from the hardware */
@@ -3072,8 +3074,14 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 		return;
 	}
 
+	/* determine payload alignment adjustment */
+	hdr = data;
+	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control))
+		+ sizeof(*iwl_rt);
+	align = 4 - (hdrlen & 3); /* invert align since already at skb head */
+
 	/* copy the frame data to write after where the radiotap header goes */
-	iwl_rt = (void *)rxb->skb->data;
+	iwl_rt = (void *)rxb->skb->data + align;
 	memmove(iwl_rt->payload, data, len);
 
 	iwl_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 6cd57c2..9ef9d14 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3144,7 +3144,9 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 				    struct ieee80211_rx_status *stats,
 				    u16 phy_flags)
 {
+	struct ieee80211_hdr *hdr;
 	struct iwl_rt_rx_hdr *iwl_rt;
+	int hdrlen, align;
 
 	/* First cache any information we need before we overwrite
 	 * the information provided in the skb from the hardware */
@@ -3160,8 +3162,14 @@ void iwl_handle_data_packet_monitor(struct iwl_priv *priv,
 		return;
 	}
 
+	/* determine payload alignment adjustment */
+	hdr = data;
+	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control))
+		+ sizeof(*iwl_rt);
+	align = 4 - (hdrlen & 3); /* invert align since already at skb head */
+
 	/* copy the frame data to write after where the radiotap header goes */
-	iwl_rt = (void *)rxb->skb->data;
+	iwl_rt = (void *)rxb->skb->data + align;
 	memmove(iwl_rt->payload, data, len);
 
 	iwl_rt->rt_hdr.it_version = PKTHDR_RADIOTAP_VERSION;
-- 
1.5.3.3

-- 
John W. Linville
linville@tuxdriver.com
