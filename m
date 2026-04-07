Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8097E35DA67;
	Tue,  7 Apr 2026 15:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775574695; cv=none; b=R71zVJ3mxxq+g1lyynvofdCxmEBFat2uN95kcWgCLpqOe6VkbReyd4ZGiVDTWBmDw6ue//tskNYLx/3dQfIsLSUcTSD6UsOPDZWh7nKgd03BH29V2rfa6Zb/mYkuySxpv0uhpo0RF8t0DF+osKzdkhzP39aC6zqjL6JgJVidb5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775574695; c=relaxed/simple;
	bh=du9Hh4E2pPm0a3BhcAvyXy9zMrIAlKjJzHQCMlxwU1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAVJRceSZmtQdgIPw1lxhAXbOWoJcYkA0hi/KJ825CrgQYQ9JR8wl836qU1yLD0k75KH6B3N4eP5wRPMXGJcaAQlikdKRvv34PrK68vZMukgzOwUAZNrr0GMKNt72nyktlkOBBn97ALlWdEtlrVNGPsK262j6VWsb64jpkzr2hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eef7/eyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eef7/eyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A48CC116C6;
	Tue,  7 Apr 2026 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775574695;
	bh=du9Hh4E2pPm0a3BhcAvyXy9zMrIAlKjJzHQCMlxwU1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eef7/eyB5Y7wIM08VLdCwL0vyXJ6NDAkAhDyo4R6TkSS5zf7FwS0QVZVoB8Noz+75
	 V+2UBY3bON6RFkr6D0qtcTL9W28iyxRCgnTnBalpa87iZbuMG8j9i58KUzmo+4Lo5b
	 45U3wYOXHhNgYVKvCIbWDZvOiYC4508ZN4lfXrwlcVYNtNMyaUe3wG7KXjZb+OqWiP
	 1zLPafdVdGrFeUQncoZD3G5d4gVchsLeU8qomYazyeSktwMETT36aILA4iD5pzG3c5
	 TDTh/LNMe3GNG+HNNHEcCeEgZUVIoxVkt5iHQIlRFExbbjOkWYMCCpyqWAaL+amm90
	 dN/UBhEMaMWFw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1wA85V-0000000DNJ3-0T2f;
	Tue, 07 Apr 2026 17:11:33 +0200
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH v2 1/3] wifi: at76c50x: refactor endpoint lookup
Date: Tue,  7 Apr 2026 17:11:09 +0200
Message-ID: <20260407151111.3187826-2-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260407151111.3187826-1-johan@kernel.org>
References: <20260407151111.3187826-1-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the common USB helper for looking up bulk and interrupt endpoints
instead of open coding.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index 44b04ea3cc8b..32e3e09e7680 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -2226,34 +2226,20 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 static int at76_alloc_urbs(struct at76_priv *priv,
 			   struct usb_interface *interface)
 {
-	struct usb_endpoint_descriptor *endpoint, *ep_in, *ep_out;
-	int i;
+	struct usb_endpoint_descriptor *ep_in, *ep_out;
 	int buffer_size;
 	struct usb_host_interface *iface_desc;
+	int ret;
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: ENTER", __func__);
 
 	at76_dbg(DBG_URB, "%s: NumEndpoints %d ", __func__,
 		 interface->cur_altsetting->desc.bNumEndpoints);
 
-	ep_in = NULL;
-	ep_out = NULL;
 	iface_desc = interface->cur_altsetting;
-	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
-		endpoint = &iface_desc->endpoint[i].desc;
-
-		at76_dbg(DBG_URB, "%s: %d. endpoint: addr 0x%x attr 0x%x",
-			 __func__, i, endpoint->bEndpointAddress,
-			 endpoint->bmAttributes);
-
-		if (!ep_in && usb_endpoint_is_bulk_in(endpoint))
-			ep_in = endpoint;
 
-		if (!ep_out && usb_endpoint_is_bulk_out(endpoint))
-			ep_out = endpoint;
-	}
-
-	if (!ep_in || !ep_out) {
+	ret = usb_find_common_endpoints(iface_desc, &ep_in, &ep_out, NULL, NULL);
+	if (ret) {
 		dev_err(&interface->dev, "bulk endpoints missing\n");
 		return -ENXIO;
 	}
-- 
2.52.0

