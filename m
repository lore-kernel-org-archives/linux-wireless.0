Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBC146D2A3;
	Fri, 14 Aug 2026 12:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786710513; cv=none; b=TIVF98ZyeoGm/twzPMMDatCW8d8lSNe3pUwgQGaBram6i1WCX/M9W2QzyYbr0LeFTl/hBstl01k4RfRcW71FnpnUlHnoz7/xvE0NIy4CiIMi+jOV1bMqVT3kTQMZxqbv8AE7ZWwfZQ6X/AzQB6qkQyIOTQ8YO+/kfst6aHL5e0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786710513; c=relaxed/simple;
	bh=B/8nEI3SmiQ1pi08MAmCaBlVZm+8qxKzsozhKrTsI8I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jSjgQNsMUHs5QmS7Ughn4gt8Ny7OvN7fRxJusilLm3SEaioKp2Oeag84jX75ZjURKdffYnEf+KVJlFJxDfbyM7Pr10gCRE1rXWMzHW5B7z5GGCkgOj4ORidaTWiouzfAV0RU+a8plgjTG/e/S6yh2lY7TvAAGDeLhZKpu293t/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: a1ff58c297db11f1aa26b74ffac11d73-20260814
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:0e5453ea-b9ab-4482-ae39-0765930bae6e,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:3cbf55c59a5fe0538462ea6efaacdcd8,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|850|865|898,TC:nil,Content:0|1
	5|50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a1ff58c297db11f1aa26b74ffac11d73-20260814
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 356174463; Fri, 14 Aug 2026 20:28:19 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 3/3] wifi: nxpwifi: release the firmware when the VDLL image does not fit
Date: Fri, 14 Aug 2026 20:28:10 +0800
Message-Id: <20260814122810.2999536-4-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260814122810.2999536-1-lilinmao@kylinos.cn>
References: <20260814122810.2999536-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_get_vdll_image() requests the firmware file when the driver no
longer holds it and drops that reference once the image has been
copied.  The error path taken when the requested VDLL length is not
smaller than the firmware returns without dropping it, and nothing else
releases adapter->firmware after the initial download completes, so the
whole firmware image stays pinned for the lifetime of the adapter.

Release it on that path too.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/nxp/nxpwifi/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/util.c b/drivers/net/wireless/nxp/nxpwifi/util.c
index 97811ee25f392..1d664967ca854 100644
--- a/drivers/net/wireless/nxp/nxpwifi/util.c
+++ b/drivers/net/wireless/nxp/nxpwifi/util.c
@@ -1206,6 +1206,10 @@ static int nxpwifi_get_vdll_image(struct nxpwifi_adapter *adapter, u32 vdll_len)
 			nxpwifi_dbg(adapter, ERROR,
 				    "Invalid VDLL length = %d, fw_len=%d\n",
 				    vdll_len, (int)adapter->firmware->size);
+			if (req_fw) {
+				release_firmware(adapter->firmware);
+				adapter->firmware = NULL;
+			}
 			return -EINVAL;
 		}
 		if (req_fw) {
-- 
2.25.1

