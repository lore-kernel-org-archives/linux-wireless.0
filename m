Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:47729 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbZFRBoP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 21:44:15 -0400
Received: by pxi27 with SMTP id 27so730623pxi.33
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2009 18:44:17 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH V2] libertas: copy WPA keys to priv when associating
Date: Wed, 17 Jun 2009 18:45:34 -0700
Message-Id: <1245289534-21888-1-git-send-email-andrey@cozybit.com>
In-Reply-To: <1245186407.28992.59.camel@130.81.190.10.in-addr.arpa>
References: <1245186407.28992.59.camel@130.81.190.10.in-addr.arpa>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Libertas currently maintains a copy of the WPA unicast and group keys
when using WPA or WPA2.  This copy is checked when deciding whether or
not to return to sleep in IEEE PS mode but the actual copying back to
priv was omitted, which breaks IEEE PS mode with WPA/WPA2 when one
issues commands that require temporarily keeping the device awake.

This patch introduces the omitted copy-back of the keys so that IEEE PS
functions correctly in WPA/WPA2 mode.  Thanks to Dan Williams for
clearing up the issue.

V2: fix typo.  Also, this has been tested on GSPI and SDIO with V9 firmware.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/assoc.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index b9b3741..b7c7cb0 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1368,11 +1368,17 @@ static int assoc_helper_wpa_keys(struct lbs_private *priv,
 	if (ret)
 		goto out;
 
+	memcpy(&priv->wpa_unicast_key, &assoc_req->wpa_unicast_key,
+			sizeof(struct enc_key));
+
 	if (test_bit(ASSOC_FLAG_WPA_MCAST_KEY, &assoc_req->flags)) {
 		clear_bit(ASSOC_FLAG_WPA_UCAST_KEY, &assoc_req->flags);
 
 		ret = lbs_cmd_802_11_key_material(priv, CMD_ACT_SET, assoc_req);
 		assoc_req->flags = flags;
+
+		memcpy(&priv->wpa_mcast_key, &assoc_req->wpa_mcast_key,
+				sizeof(struct enc_key));
 	}
 
 out:
-- 
1.5.6.3

