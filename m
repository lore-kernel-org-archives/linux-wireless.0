Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0A296BAF
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785545007; cv=none; b=L5zQIVzXTbVZlMUMZesMnJ7LUIMRXfVLx81nuyIXdmgSNnjaUxwzEid+JGizl36/qDt6ErvHFwfdbhQD6ONuseFDJJX3m2ocCufibmjPlNNJzBQjSqST6UQI5gMtFWphThmrIla5QLjiFjvj9G4l/akC8YfPCEf32XUFn5mDRB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785545007; c=relaxed/simple;
	bh=F0ysE6YH41uWO/d+JZW29/5KWxWGXTbrIC/DYo4N+q8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rmPe0cM1cDxwTrSzA258Xe5t8n2jgAKCwK2y8oAi7c6nAkPihIfSk8ZU8gHvLflTpf/0dHBA31P47YYkvU1emDMjSJCTdfjrdR+pcsy3KBdjQPcolfaj0hQ82nBcBKxxPC+7N3B/gpcIOGf56jUJwnT517d8iWni24iCHkf/IrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvaHKnMi; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvaHKnMi"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b0117dda13so1470960e87.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 17:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785545004; x=1786149804; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F+mu3lYgplfrwjY2DJL/ygTm4SmYdcK4n2UmUXCZpKc=;
        b=lvaHKnMi4W7S4GUSkuxQu5iBvV8zxkAevCBdpyjMh7TAzbPlTMls0aLdDapGQnzIzy
         VY7B8RIIpbiL/qjBGaaEMo5RFP0GSeWlwNX8Fo1IKXg4hGW6rw7Y3uxbBoqua7DejT9x
         gX1Yt5ZnAWbBSa7uhRpggz2WXa+5XBwM6eYI+qGe8bOLN9ogjDG/2V70EdvOU2zxeb1H
         uT9dpZ0tDkjF4uFQTlEn64iwca9eWFnEGuElhfOqkr/PKNSsTPDGSdicvfoZoQQMTB+y
         NVxftFnGKNqosTF8xWskp0vjK5MgdnIxZJ/u+Vj+scf3SBXoQoK1XDnAtG1IonB+1hDD
         Geuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785545004; x=1786149804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F+mu3lYgplfrwjY2DJL/ygTm4SmYdcK4n2UmUXCZpKc=;
        b=G//b+fuaWUgTjCOfGoRAxOTADTvXz4Puhobj8P1yu2DozzpsprYEWPrhu272hWa5wG
         a2Uk1L71EFBSZ3ihfngeExRvcTRQsQDnNehxFoOsfq3f3TnAFRjnjNlTfOIcHT/OybXw
         DCrWXW113lpaMSf3D0bMDFWNR0ZTMSWa6Mi8TCY6Gqo93tlgriffvy0Zt4Mft30g1Cr9
         4+AoSALNBI2YawQQik2otTj4EEgHH5VM469T6rMqnEMMEmtgMdElGr/DAUJWug2C0Aqw
         lWeg82CzSbfLqfkIm0xStHPLes+g7CKwMqXTr8JkIcgUXADCd+DNW/hBr5hDsTJrh4yv
         yPdA==
X-Gm-Message-State: AOJu0YyoxzSbhtAHf8ngb0eROQ4ylQPPQuNlTcft4A7AsvM5fHSSPEnR
	U1lrmlWsQsYxbQX/ObLWk814g517+aoa9SstPdcHrkTL7ucZL8QpSvjvfM4FHrMK
X-Gm-Gg: AR+sD10xqUa5D1thTqqWGu2G61CgoqRZ0Fa0TIaiuIlnoE4KC1iEUTYi22TskML3AaT
	W+uF2vAWd4I1G5Qnl31fUr0AcPNh60NH5Fy5G/s2urblU/Fwbe7E8NQsyu6BJHhSzuxqUONZlEj
	3v3gFzLgYlCYIRGxFo1euPUMVN7wnz9jAvRpLolV7fWwxeUea2WyVtGqGgeSL6j/QA508SaznYs
	ulWkugiIYbSjqxYhuQCMKzM+huy8iNxU1VvTrDEp/TIozDE+Infhhn9Uik0zG9XyM44JlrpQyi6
	9u/hoI3W8McK10R4SsfklyUnyVdmNRVqcgAUk2S4F7MMNaMzR+4KaI9JI0AzeukNrKgSKoeAiI+
	PBUNJFmw6YGF4snMFkhQ8AZjqWZ/6n0O2d/ZAt52p2ZapZlRjaugYzyNLzUFxrL9mG9rtNZc8IA
	iexAVuQpgbuZZOt3x/IGFIistRC9ZIb70jUeOJzmCHMLVXMeDKk2kTSX6VFCMSFK0pngu6xasmb
	pFsVx0uR5R/vRV0ayoK+4+V
X-Received: by 2002:ac2:4a6a:0:b0:5b0:f9d:f7d9 with SMTP id 2adb3069b0e04-5b2e4f83e1dmr200946e87.45.1785545003821;
        Fri, 31 Jul 2026 17:43:23 -0700 (PDT)
Received: from zbok.dom.cz (89-79-165-104.dynamic.play.pl. [89.79.165.104])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23d23d7sm598582e87.37.2026.07.31.17.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 17:43:22 -0700 (PDT)
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	Kamil Bienkiewicz <perceivalpercy@gmail.com>
Subject: [PATCH v2] wifi: ath12k: advertise AP_VLAN interface mode for IPQ5332
Date: Sat,  1 Aug 2026 02:42:43 +0200
Message-ID: <20260801004243.489010-1-perceivalpercy@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Only the two QCN9274 hw_params advertise NL80211_IFTYPE_AP_VLAN; the
IPQ5332 entry does not. As ath12k sets SW_CRYPTO_CONTROL, mac80211 does
not add the mode on the driver's behalf, so AP/VLAN is absent from the
wiphy and hostapd cannot create WDS station interfaces:

  nl80211: Failed to create interface <name>: -95 (Operation not supported)

The 4-address datapath itself (sta_set_4addr, per-station TCL metadata,
WMI_PEER_USE_4ADDR/WMI_VDEV_PARAM_WDS, 4-address frame and NULL/EAPOL
handling) is shared Wi-Fi 7 code with no per-chip or per-bus gating, so
IPQ5332 can already deliver it. AP_VLAN is a software interface type, so
no interface combination changes are needed.

On a mixed-bus single-wiphy group the effect is wider still, since
ath12k_mac_get_ifmodes() intersects interface_modes across all radios:
one IPQ5332 masks AP_VLAN for the QCN9274 radios too.

Advertise AP_VLAN on IPQ5332 as QCN9274 does. Tested with 4-address WDS
stations on IPQ5332 + 2x QCN9274; RADIUS dynamic VLAN was not tested.

Tested-on: IPQ5332 hw1.0 AHB WLAN.WBE.1.6-01270-QCAHKSWPL_SILICONZ-1
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Kamil Bienkiewicz <perceivalpercy@gmail.com>
---
v2: rebased onto ath/main (8150c22bc). No functional change; v1 was
generated against a backports tree and its trailing context no longer
matched after .supports_cong_ctrl_max_msdus was added to the IPQ5332
hw_params entry.

IPQ5424 (line ~845, and possibly QCC2072/WCN7850) appears to need the
same change, but I have no such hardware, so I have limited this to
IPQ5332 which I could test.
 drivers/net/wireless/ath/ath12k/wifi7/hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/hw.c b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
index 7b86f324b..a20c21807 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/hw.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/hw.c
@@ -664,7 +664,8 @@ static const struct ath12k_hw_params ath12k_wifi7_hw_params[] = {
 
 		.interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				   BIT(NL80211_IFTYPE_AP) |
-				   BIT(NL80211_IFTYPE_MESH_POINT),
+				   BIT(NL80211_IFTYPE_MESH_POINT) |
+				   BIT(NL80211_IFTYPE_AP_VLAN),
 		.supports_monitor = true,
 		.supports_cong_ctrl_max_msdus = true,
 
-- 
2.55.0

