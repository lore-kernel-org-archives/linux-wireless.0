Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AF33939CE
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785766401; cv=none; b=J0hcvg7IBQ7oqd2ghXEDKW7Az7vMMmfyYi1hrWtBGeHkNMXN/1k1SfqNYBo3a+GTwDoc9Gek5ZznDiRt4AtgBSJAaFMpzGdzskjCjpz7FRE9BfxLyet6LDW9oAl2dXI1cSPk+rNs4NxBSIHgDviklUDGFCS8vYcr5Rs1Bq6Se+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785766401; c=relaxed/simple;
	bh=+C1/trH/vqi2/Z7ZEEoViX4d61YyqpiUJUEDwOhFMZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uffWL1EbU3j8yPzLGBM7yln5E/GMSKDHKtBRxM3y39MKbH1CCfXiqgAVNcPq3q2rs7bNrtG0hGfCFUDpJUmZiAy0dRkK716YZKLebXJaPrQboIV4XD/fwt3Tkwsrv1ZIwtVcB4uWhMk01xXeSlF95H7c7Huy/bBmJAKAqQ9vUQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=q+0C35ye; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="q+0C35ye"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=6Qq0/374IgV/BvVJkzkK42K1Z6knTkqCC9ABVsBv6m4=;
	t=1785766399; x=1786975999; b=q+0C35ye9uWpLjl6zpam+etKewmsepctJS4aVig5+xd97j4
	9Q4OS03mmAdfFVpsVXtmvz7A9FRmKWkh+D0fGGbaJlNbsIgtapMsQYPyldTIApUBRlQqknqHaKRiY
	dPWFRux3w05c3mX7m4fAxStq4A4Umu0jYQcPtr1j1aBv6PdNODlbtYIXpnRimPG5zHNbtV810yPNh
	v0/PDxalHr7j+t58oB00aEkkRI3WuQJZHrrsGiFw8M0QbGrG0qWhf4rGZ3QIIsUm7OOp0Tp9MZIaM
	oNYQtf6SWvrVDfNLJispN3oh6TAGnXCPzGlLKpPUjwjLYG7JHxfn3bMj5PIDGmMw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqtPp-0000000G4Ws-0XHD;
	Mon, 03 Aug 2026 16:13:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/7] wifi: mac80211: unshare the skb before building the header
Date: Mon,  3 Aug 2026 16:08:40 +0200
Message-ID: <20260803141309.292711-13-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803141309.292711-9-johannes@sipsolutions.net>
References: <20260803141309.292711-9-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_build_hdr() unshares the skb halfway through, after it
has already looked at it but before it writes anything. That's not
a problem, but complicates the callers and requires passing the
flags to the function, etc.

Move the unsharing to the only caller that matters, the new one
from the previous patch has a fresh SKB and doesn't need it and
the TDLS callers via ieee80211_tdls_build_mgmt_packet_data() are
also fresh SKBs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 28c60ae442c0..1d139c2506bb 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2637,9 +2637,8 @@ static void ieee80211_remove_ack_skb(struct ieee80211_local *local, u16 info_id)
  * the appropriate IEEE 802.11 header based on which interface the packet is
  * being transmitted on.
  *
- * Note that this function also takes care of the TX status request and
- * potential unsharing of the SKB - this needs to be interleaved with the
- * header building.
+ * Note that this function also takes care of the TX status request. The skb
+ * must not be shared.
  *
  * The function requires the read-side RCU lock held
  *
@@ -2949,15 +2948,6 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
 
-	/*
-	 * If the skb is shared we need to obtain our own copy.
-	 */
-	skb = skb_share_check(skb, GFP_ATOMIC);
-	if (unlikely(!skb)) {
-		ret = -ENOMEM;
-		goto free;
-	}
-
 	hdr.frame_control = fc;
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;
@@ -4424,6 +4414,12 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 		if (skb->protocol == sdata->control_port_protocol)
 			ctrl_flags |= IEEE80211_TX_CTRL_SKIP_MPATH_LOOKUP;
 
+		skb = skb_share_check(skb, GFP_ATOMIC);
+		if (unlikely(!skb)) {
+			kfree_skb_list(next);
+			goto out;
+		}
+
 		skb = ieee80211_build_hdr(sdata, skb, info_flags,
 					  sta, ctrl_flags, 0);
 		if (IS_ERR(skb)) {
-- 
2.55.0

