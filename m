Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E8F4EE874
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788535419; cv=none; b=U3fEoJ/7/UwPseLiiaDsKJWS+bAKb1qLC00GEBmhd00uJWHgRdm7ajW2VMiJJFfwFcf1xP+x1a+auS1shLRFnozrtiN3lTlBceskA0B+Ic37nDNnRpgYLbx0lcK95Hasifkuz6athk9nS6gMQXCUHrErvIpDP1hQeuCLvsrC2AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788535419; c=relaxed/simple;
	bh=dQgbyI4eHyTaFz6wZGf9vucF/9U+2DGssLrA4TgvnMk=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=CsdLNKLcRBLDilcC7Q50Yk8rkPwImqjNvp9jLCgjm+2xupXITlRyTP/SHzQddQvoCrG2ZzjSVgxueSVQYSp+WGWrcFOgB+hYMxj7WCLWM8c50k/eGShfToDLSmVfwMQUX/lwTj7c4cKfHYOQDyuMci7/Fibly0AIDzv99jtTuj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EjHEpqol; arc=none smtp.client-ip=91.218.175.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EjHEpqol"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=dQgbyI4eHyTaFz6wZGf9vucF/9U+2DGssLrA4TgvnMk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788535414; v=1; x=1789140214;
 b=EjHEpqolu5c2XIB7AKG0MY35/xHIcTEf3CSGX6iypofODxFORVSg8ilNg7uKesgQSlK9oDHo
 Zcc0rMtKbkua7twqIvpv6UN+hG08XQkPE3Kb36+oldN54UqMYGCxIYHID1ZR4fvs1k3fG52cRZm
 mPZgEbUeoYY3rZlhhZ0uk/PI=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bb8fef85ef12ef97;
	Fri, 04 Sep 2026 15:23:34 +0000
X-Mizu-Trace-ID: bb8fef85ef12ef97
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 04 Sep 2026 15:23:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <7982b4a7e64f74e2068790ec389ca680a081f730@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: cw1200: fix TX padding OOB read leaking heap data to
 device
To: linux-wireless@vger.kernel.org
Cc: bvanassche@acm.org

From: Tianchu Chen <flynnnchen@tencent.com>

The TX path rounds the transfer size up to the bus alignment
(align_size(), up to 511 bytes for SDIO, 1 byte for SPI) but sends
the padded length straight from the frame buffer, which has no room
reserved for the padding.  cw1200_data_write() therefore reads past
the end of the frame and the bus transfer carries those bytes to the
device.  A bogus device can collect up to 511 bytes of kernel heap
data per TX frame.

The RX path does not have this problem: it allocates the skb with
the aligned length (alloc_len) before reading.

Compute the exact padding with the bus align_size() callback, make
sure queued TX frames have tailroom for it, and zero the padding
bytes before the transfer so nothing past the frame is exposed.

This is not expected to change driver behavior on most cases: frame
contents and transfer sizes are unchanged, only the content of the
padding bytes (previously undefined stale memory, now zero), which
the device never reads since the WSM header carries the real frame
length.  The skb expansion can only fail under memory exhaustion,
in which case the frame is dropped like on the existing error paths
of cw1200_tx().

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLA=
N chipsets")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/st/cw1200/bh.c   |  8 +++++++-
 drivers/net/wireless/st/cw1200/txrx.c | 14 ++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/bh.c b/drivers/net/wireless/s=
t/cw1200/bh.c
index b034bab4b4897..9367a981f1dee 100644
--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -344,6 +344,7 @@ static int cw1200_bh_tx_helper(struct cw1200_common *=
priv,
 			       int *tx_burst)
 {
 	size_t tx_len;
+	size_t aligned_len;
 	u8 *data;
 	int ret;
 	struct wsm_hdr *wsm;
@@ -376,9 +377,14 @@ static int cw1200_bh_tx_helper(struct cw1200_common =
*priv,
=20
=20	atomic_inc(&priv->bh_tx);
=20
-=09tx_len =3D priv->hwbus_ops->align_size(
+	aligned_len =3D priv->hwbus_ops->align_size(
 		priv->hwbus_priv, tx_len);
=20
+=09/* Zero the bus alignment padding so no stale data is sent. */
+	if (aligned_len > tx_len)
+		memset(data + tx_len, 0, aligned_len - tx_len);
+	tx_len =3D aligned_len;
+
 	/* Check if not exceeding CW1200 capabilities */
 	if (WARN_ON_ONCE(tx_len > EFFECTIVE_BUF_SIZE))
 		pr_debug("Write aligned len: %zu\n", tx_len);
diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless=
/st/cw1200/txrx.c
index 084d52b11f5b0..e13695667a00b 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -14,6 +14,7 @@
 #include "wsm.h"
 #include "bh.h"
 #include "sta.h"
+#include "hwbus.h"
 #include "debug.h"
=20
=20#define CW1200_INVALID_RATE_ID (0xFF)
@@ -716,6 +717,7 @@ void cw1200_tx(struct ieee80211_hw *dev,
 	struct ieee80211_sta *sta;
 	struct wsm_tx *wsm;
 	bool tid_update =3D false;
+	size_t pad_len;
 	u8 flags =3D 0;
 	int ret;
=20
@@=20-764,6 +766,18 @@ void cw1200_tx(struct ieee80211_hw *dev,
=20
=20	sta =3D t.sta;
=20
+=09/*
+	 * The bus transfer is padded up to the bus alignment and the
+	 * padding is transferred from the frame buffer.  Make sure the
+	 * buffer has room for the padding so the device never receives
+	 * data past the end of the frame.
+	 */
+	pad_len =3D priv->hwbus_ops->align_size(priv->hwbus_priv, skb->len) -
+		skb->len;
+	if (skb_tailroom(skb) < pad_len &&
+	    pskb_expand_head(skb, 0, pad_len, GFP_ATOMIC))
+		goto drop;
+
 	spin_lock_bh(&priv->ps_state_lock);
 	{
 		tid_update =3D cw1200_tx_h_pm_state(priv, &t);
--=20
2.51.0
