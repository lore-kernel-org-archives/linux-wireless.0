Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A753BCD14
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708782; cv=none; b=ObFyD7mNWQD62M/TDxuj7dbscUtaNd0Y4SILYg9MV++m0G9JsQALNAR5LkX+bHOW0L6IImdvY9pH1DD4wLg9SYMqmDa28As0VuyX7SbtLVqd/XTPqw2I1BGEyvmqt+tQXKRkaRVJm6NpC6+cr50vypZ+gsuVetWdKUD2PWiWfdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708782; c=relaxed/simple;
	bh=duaIhzIxi+hVoTlGpnym8/t0BOBT0OGZZhkgQpSGQwM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP3+RBQBp9BX3Htq7ylDgs3zreJdfVxsUvNzQk5QcHW1VvJWru0+OKg+Kw228NKATHOiM+Ab6GSNP+ll3/Nvl8wu7QxN0hLRNq0QOpQwliZq833yuFOBmx/MVNHFfVkug7TQIh+a3QumcoFhcJTTVXnm/U4vJZxm5mdvyKMSYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=t3CY/+aA; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="t3CY/+aA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=neITg8s8IAqWfZHlnBXR6depQPCegF0mmeNB6TXge9U=; b=t3CY/+aAfuC6rFjB0b/N3Wez51
	ALRMvZCAxm+r7WfIFXsMpSSro7vNZRun8VbPSEpIvPPjmSlYnSNtpakCr+QyBK5sSQcDhz1wTt39Q
	02F2HrkIF+cZGkinzZeqHkDIKM+iWQOM07sxQrILfFqwfRwdJCgB6scA4Cn8OPb45fdE=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHQ-005AHx-17
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:16 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 09/18] wifi: mt76: mt7915: avoid nss underflow in mt7915_mcu_get_sta_nss
Date: Wed, 22 Jul 2026 08:26:01 +0000
Message-ID: <20260722082610.2699628-9-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a peer's VHT/HE MCS map has no supported spatial stream (all fields
0x3), the loop exits with nss == 0 and the function returned (u8)-1 (255),
which was then written into the firmware sta_rec_bf beamforming fields.
Clamp the result to 0.

Fixes: 89029a85482c ("mt76: mt7915: add Tx beamformer support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 9730209cdd8f..d1d8846b9f6e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -51,7 +51,7 @@ mt7915_mcu_get_sta_nss(u16 mcs_map)
 			break;
 	}
 
-	return nss - 1;
+	return nss ? nss - 1 : 0;
 }
 
 static void
-- 
2.53.0

