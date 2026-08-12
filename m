Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C727603F;
	Wed, 12 Aug 2026 06:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786514882; cv=none; b=r/YFTAZzBCEqUDUTd/D1mzZkuDPEg/e+Obbcvt084pDs5+neEhUHAT52u+KfIuh7AhBcw2rrLP/A6myJLPb1b/ctHc5KVs4ebJG0TbvfKf+75TsSD8CAY/ij0Xos3wg78ZAqQ704Y9bY8WRWAw1rkikWttd1V+tJTgku722Wvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786514882; c=relaxed/simple;
	bh=GAFhDzmrPMDkyEZPKhuSsI/fLaHEacrb5eI7J6xM6oI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZIvPRv679+5PYvRToKdfsEoHxA75rXWrvrl1YscIALFJd+eqAnOCqNo3G1uFGAUOsTcFtf5cZG3r/L2s+bztuA8Gqz1EYKl02MDSAErKgK7nl4zPzO7faxSUIF/RMJ4CCu490ScbRjq/nWtSSqFkBHbY1YmJ7NTnbsfmlb+i/TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 268249ac961411f1aa26b74ffac11d73-20260812
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c4fa71bb-19a8-48a4-9a21-631a65a85a0b,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:fee35ebd6b918f7a4a1938d7b8555ca8,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 268249ac961411f1aa26b74ffac11d73-20260812
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1976893132; Wed, 12 Aug 2026 14:07:51 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>,
	Arien Judge <arien.judge@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 0/4] wifi: mm81x: firmware and host table parsing fixes
Date: Wed, 12 Aug 2026 14:07:36 +0800
Message-Id: <20260812060740.1275280-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Four fixes to the firmware paths of the mm81x driver, found by reading
fw.c.  I have no MM81x hardware, so all of them were established from
the code and none was tested on a device.

Patches 1 and 2 are error handling: a scratch buffer that is only freed
on the success path, and a failed segment download whose -EIO is
overwritten by the boot address write that follows it, so an
incompletely downloaded image is reported as loaded.

Patches 3 and 4 bound two TLV walks that currently only require a TLV
header to start inside the region being walked, and that read structures
larger than the header without checking the declared length.  Patch 4 is
the one that does not need a corrupt file: firmware reporting a TLV
shorter than the structure the driver casts it to is enough to read past
the allocation.

Patch 2 depends on the out_free label added by patch 1.

Linmao Li (4):
  wifi: mm81x: free the firmware scratch buffer on parse failures
  wifi: mm81x: do not discard a failed firmware segment write
  wifi: mm81x: bound the .fw_info TLV walk
  wifi: mm81x: bound the extended host table walk

 drivers/net/wireless/morsemicro/mm81x/fw.c | 80 +++++++++++++++-------
 1 file changed, 54 insertions(+), 26 deletions(-)

-- 
2.25.1

