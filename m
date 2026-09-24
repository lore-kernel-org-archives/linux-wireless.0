Received: from mta0.migadu.com (out-241.mta0.migadu.com [91.218.175.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C702D4052D4
	for <linux-wireless@vger.kernel.org>; Thu, 24 Sep 2026 09:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790240618; cv=none; b=SxBNmM4gxQMLm787AmrW8x4jAvAulFbK5uQWylw0SQ/byWlNR0MVU4zF+EC+joMXOfMFAxdf0vPvnh/gcfqh6L8c00D7f8NIrlaJQW8Lcdqc1zmKnLFiPIDsS3V8NL7iEx0n/mYTqX4Pohz0dqGjxNR3s9qijFjG3e6rCGRX2cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790240618; c=relaxed/simple;
	bh=4zWi4SS9GGmWv54W/CgvN7ukLy9avKj8s60KReUEOoU=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc; b=hfkeq0smnvKuiz5nUca+2h/nKDwHYtPFCXNvJwtu0cMeA4Xr2qsm09lcQgOdAx+KK5NkNpbxL+9Qx24pl5FgIdJ6rHJ4l2WrfbQWBu4PEkbqL7n1VuDBvadSssABliByzTCCSuZV9OI3+Hey0cuJZ+KNo0+YJ8NkUrWx3MqgmqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aF0oN3Bd; arc=none smtp.client-ip=91.218.175.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aF0oN3Bd"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4zWi4SS9GGmWv54W/CgvN7ukLy9avKj8s60KReUEOoU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790240612; v=1; x=1790845412;
 b=aF0oN3BdKNRXDZ6GnFdXp3D5OYJY4HB5DDtfsxzvGV/7n+qFa/GmGlKYATkp4hC3vOcsubDV
 4VojAfCyHjWq8WELuzFWK29v/A5hLMOcwywPSQfx+HyBWfpBrO5Yt6ln4IoGnTT4fGp3lOSC/DQ
 tdu1ijmlGhVJGellI8x/wrjM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ada7dab963a9372c;
	Thu, 24 Sep 2026 09:03:32 +0000
X-Mizu-Trace-ID: ada7dab963a9372c
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 09:03:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Tianchu Chen" <tianchu.chen@linux.dev>
Message-ID: <969ee752d023e7431481605c320fa0636cc6f20c@linux.dev>
TLS-Required: No
Subject: [PATCH] wifi: cw1200: fix link_id_db OOB access via
 device-controlled link ID
To: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org

From: Tianchu Chen <flynnnchen@tencent.com>

cw1200_rx_cb() stores the link ID from the device-supplied WSM
header (a 4-bit field, range 0-15) into priv->action_linkid for P2P
public action frames without an upper bound check.  The work handler
cw1200_link_id_reset() then uses it to index link_id_db[], which has
only CW1200_MAX_STA_IN_AP_MODE (5) entries, so a device reporting a
link ID of 6-15 makes the driver read and write cw1200_common fields
past the array (a status copy and a constant store onto adjacent
work/lock/timer fields), corrupting driver state.

The first link ID check in the same function (used for timestamp
tracking) already validates against CW1200_MAX_STA_IN_AP_MODE and
degrades out-of-range IDs to untracked handling, so out-of-range
link IDs on the RX path are anticipated; the P2P remap branch was
missed.

Add the same bound to the remap branch.  This is expected to keep
driver behavior unchanged in most cases: the driver itself only
assigns link IDs 1..5, and a P2P public action frame carrying any
other ID now degrades to the same untracked handling the first
branch already applies, instead of corrupting memory.

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLA=
N chipsets")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
---
 drivers/net/wireless/st/cw1200/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/st/cw1200/txrx.c b/drivers/net/wireless=
/st/cw1200/txrx.c
index e13695667a00b..33b02e562b79e 100644
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -1050,7 +1050,7 @@ void cw1200_rx_cb(struct cw1200_common *priv,
 		schedule_work(&priv->linkid_reset_work);
 	}
=20
-=09if (link_id && p2p &&
+	if (link_id && link_id <=3D CW1200_MAX_STA_IN_AP_MODE && p2p &&
 	    ieee80211_is_action(frame->frame_control) &&
 	    (mgmt->u.action.category =3D=3D WLAN_CATEGORY_PUBLIC)) {
 		/* Link ID already exists for the ACTION frame.
--=20
2.51.0
