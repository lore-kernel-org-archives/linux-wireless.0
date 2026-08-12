Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CA633D4FD;
	Wed, 12 Aug 2026 06:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514890; cv=none; b=kj4qR5LA9H6jbL8D0UiP5H5o7SeFVve5Q44kL2olxoNCHHRt366mEBwCXP8PsHvCNCssqXPLtCdGwQviXRf/POx1ECUqHsx4fdCXAKJPC1VivRyqbDJ9oahVIKWN7p8GRS3sfMGaffUS7jTgC1Jpek/z2vUf4DaVBXuIuRY0Tpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514890; c=relaxed/simple;
	bh=YmzKRhhX/lB/xv+JxthT8pLmBgVHp0dH6MwVhDfiqng=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jFaea/cJnr6BhFr0icu9+DMSpKnyYkaUiQf9QdTY9wKwSnuWf1NM/67Q7ggRXfYLpjDH1A5dWRzSt4sX5t+tHFSJ/rsbLr1ICjXvooRj/nhd0AUP9Caj6IzPXQKdEi4YMrwZpRsPqRJWDWgGy5VLVhpNAcSsq77BTbd8NC1GtbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2a816c86961411f1aa26b74ffac11d73-20260812
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:d70cf44e-4b7a-47e8-ab28-b4557b563245,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:53d3b6b9f4122bd44a4513ecb6b5f556,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|136|850|865|898,TC:nil,Content
	:0|15|50,EDM:5|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2a816c86961411f1aa26b74ffac11d73-20260812
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 581914761; Wed, 12 Aug 2026 14:07:58 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 2/4] wifi: mm81x: do not discard a failed firmware segment write
Date: Wed, 12 Aug 2026 14:07:38 +0800
Message-Id: <20260812060740.1275280-3-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260812060740.1275280-1-lilinmao@kylinos.cn>
References: <20260812060740.1275280-1-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mm81x_dm_write() fails while downloading a PT_LOAD segment,
mm81x_fw_load_fw() sets ret to -EIO and breaks out of the loop.  The
boot address write at the end of the function then overwrites ret, so a
partially downloaded image is reported as loaded and the chip is
triggered on it instead of the load being retried.

Leave the function as soon as a segment fails.

Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
---
 drivers/net/wireless/morsemicro/mm81x/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/morsemicro/mm81x/fw.c b/drivers/net/wireless/morsemicro/mm81x/fw.c
index d407b57f4c9cb..a2cb97cefc4e9 100644
--- a/drivers/net/wireless/morsemicro/mm81x/fw.c
+++ b/drivers/net/wireless/morsemicro/mm81x/fw.c
@@ -162,7 +162,7 @@ static int mm81x_fw_load_fw(struct mm81x *mors, const struct firmware *fw)
 			mm81x_release_bus(mors);
 			if (status) {
 				ret = -EIO;
-				break;
+				goto out_free;
 			}
 		}
 	}
-- 
2.25.1

