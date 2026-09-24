Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE0046D544
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 10:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790245190; cv=none; b=KU1mUYGbCp2OiqwW1nVsTwJNqAKSJgihkJ577ue/EftXJeHlMpPXqnulbkIDpD82H+/m/DgHdgC9WfQIOfuJU7M98udEHZMsk6iWljuHJdjG/anZTfWHlwse8JSQlH24a2mAx61AtnfXOoEU4sStn9qtMclWeL93CoS3hYh9IxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790245190; c=relaxed/simple;
	bh=EpHWCgWmTnrhmIymFIN51SaFEVqwZyVOfqIMKGWcfCI=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=AraHHtt7POEudirsX4/Hrp/D3/1COb2Gdd68T04sLa3HhLTggSrsxXX4sUjEAnpKwi62cWshhpjeyudmDyG4ee8a99I2ca9MwkVvtvtOrMI6pDpsH17E++nfVXzT9KfTlbXIpEYeMXHknL8iQBWmN36OURHnF48IuMvzPhY69/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rTDv4dHT; arc=none smtp.client-ip=91.218.175.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rTDv4dHT"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EpHWCgWmTnrhmIymFIN51SaFEVqwZyVOfqIMKGWcfCI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790245184; v=1; x=1790849984;
 b=rTDv4dHTiP/JPsh5aLekQWolR+sRboyMOxl8cp1MRTtbfBdXxaQw3NIvXk0JkP5wZcUQEzoM
 qnJ8INbgsTCaBfRFnlhUx2B4PgCNB+gMrduFkORZGoiFixTFoYXje07axmLDFiNfY2KR/LpguG2
 mZrxzXnM7R1vDEHCM7ikk0Ek=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d49de8040e9185b6;
	Thu, 24 Sep 2026 10:19:43 +0000
X-Mizu-Trace-ID: d49de8040e9185b6
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 10:19:43 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <f22d4f23e5e54b1debd6038b3b75119f97920a73@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: libertas: fix RX OOB access from device-controlled
 pkt_ptr
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org

From: Tianchu Chen <flynnnchen@tencent.com>

lbs_process_rxed_packet() computes the packet header pointer as
skb->data + rxpd->pkt_ptr, where pkt_ptr is a 32-bit value supplied
by the device, and never checks it against the packet length. The
only validation (skb->len < ETH_HLEN + 8 + sizeof(struct rxpd))
bounds the total length, not pkt_ptr.

A bogus device can report an arbitrary pkt_ptr:

- the memcmp() against the RFC1042 header reads 6 bytes at
  pkt_ptr + 14, potentially past the skb buffer
- if the compared bytes happen to match, the EthernetII header
  reconstruction writes 12 bytes at pkt_ptr + 8;
- hdrchop derived from pkt_ptr is later passed to skb_pull().

Validate pkt_ptr before using it: it must leave room for a full
struct rxpackethdr within the received frame. It is not expected
to affect the driver behavior in most cases, only invalid pkt_ptr
packets being dropped.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: e45d8e534b67 ("libertas: add support for Marvell SD8688 chip")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/marvell/libertas/rx.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/rx.c b/drivers/net/wir=
eless/marvell/libertas/rx.c
index c34d30f7cbe03..a9d1320d90b15 100644
--- a/drivers/net/wireless/marvell/libertas/rx.c
+++ b/drivers/net/wireless/marvell/libertas/rx.c
@@ -89,6 +89,15 @@ int lbs_process_rxed_packet(struct lbs_private *priv, =
struct sk_buff *skb)
 		goto done;
 	}
=20
+=09if (le32_to_cpu(p_rx_pd->pkt_ptr) >
+	    skb->len - sizeof(struct rxpackethdr)) {
+		lbs_deb_rx("rx err: pkt_ptr beyond packet\n");
+		dev->stats.rx_length_errors++;
+		ret =3D -EINVAL;
+		dev_kfree_skb(skb);
+		goto done;
+	}
+
 	lbs_deb_rx("rx data: skb->len - pkt_ptr =3D %d-%zd =3D %zd\n",
 		skb->len, (size_t)le32_to_cpu(p_rx_pd->pkt_ptr),
 		skb->len - (size_t)le32_to_cpu(p_rx_pd->pkt_ptr));
--=20
2.51.0
