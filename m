Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06B539099A;
	Mon,  3 Aug 2026 07:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785741235; cv=none; b=e4j1PYjqNciHPG/VEgJJ86XOV2iaTIPu0PeC7x0baECIfkpkA9MzO3GJfYHLQk0qMZZOQwUBmciYtEosMxzjmMM/YvGqgFcIKeJETtgdzjsoDN7AKvzYMtHbiq60tGYHKdq6soagQmKAIbOPGbjipmomBNBw8XBqsiSky9mqsxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785741235; c=relaxed/simple;
	bh=GMvoBJqSqBDS3OI85GH7YYZlqpMXUk9WJ1PrbSS70os=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UIXKKVD2ulEimM54uSJYfO54Srr3mDBtOT2syYzEKS5nm8ktmbso6W8YgEOoY34y0K6/Wtx4UkK6JwOO6oD8QY7slYIa4FeK2//XORCNGNR9tujtVjgR5eOIRuwZVQIaJruBNfRAQ3WfRVxQGbEThJKKxflxkgT7x8KbEYbQZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: d9fb4a768f0a11f1aa26b74ffac11d73-20260803
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9d863a68-8113-4d21-a89b-b63b8168ddc1,IP:15,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:9d863a68-8113-4d21-a89b-b63b8168ddc1,IP:15,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:b013618833d60fa7d56155eb1700c120,BulkI
	D:26080315134327ISSXXP,BulkQuantity:0,Recheck:0,SF:10|66|78|102|127|865|89
	8,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS
	:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:1,BRE:0,A
	RC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d9fb4a768f0a11f1aa26b74ffac11d73-20260803
X-User: pengcan@kylinos.cn
Received: from lenovo [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <pengcan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1729089582; Mon, 03 Aug 2026 15:13:39 +0800
From: Can Peng <pengcan@kylinos.cn>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Can Peng <pengcan@kylinos.cn>
Subject: [PATCH v2 0/2] wifi: brcmfmac: validate msgbuf flowring IDs
Date: Mon,  3 Aug 2026 15:12:57 +0800
Message-ID: <20260803071259.546631-1-pengcan@kylinos.cn>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clean up the excess blank lines in msgbuf.c first, then validate
firmware supplied msgbuf flowring IDs before converting them to internal
flow IDs and using them as bit and array indexes.

Changes in v2:
- Add a preparatory cleanup to use a single blank line between functions
  and declarations in msgbuf.c.
- Rebase the flowring ID validation change on top of the cleanup.
- Link to v1:
  https://lore.kernel.org/all/20260723055618.550834-1-pengcan@kylinos.cn/

Can Peng (2):
  wifi: brcmfmac: remove extra blank lines in msgbuf.c
  wifi: brcmfmac: validate msgbuf flowring IDs before use

 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 84 +++++++++----------
 1 file changed, 39 insertions(+), 45 deletions(-)

-- 
2.53.0
