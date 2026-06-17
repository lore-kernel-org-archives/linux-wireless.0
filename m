Received: from smtpcmd14162.aruba.it (smtpcmd14162.aruba.it [62.149.156.162])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B8837DEAB
	for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2026 21:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.162
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781732765; cv=none; b=m4Wcl9ZAcMbnC++jiodmB8O7b2zn1lBALnlqb2UOESI83iZaFFTORj+FkRBclI4QPjoQmpGWe+rsEiICYn0RE9tlPgIzDGfVvikPnT+yFRRIldPBJCXnxrSMSC0XDforjBlMcj/Y2G6nrB1AIpYsaGt1P7CmYUU2jd4flhLr/1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781732765; c=relaxed/simple;
	bh=hjXlednnPAavbfrdO2yxouzQ52Ff1GGT1R6xtl+uF48=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RV/39iFuZamszWTBO4DRjh0BaI2zPaLCgXKuZ77qFjqiEIyv5BXXJkCGKE1MDwqxkn3QG7SBPyeybkEbUyPXLrvhhp7fcRaOGBsZgF0A4d9U1XW6Xa5lH6KDf9kmhOxXcTad5Na0QgoAbc06RXM6SQQlaxMrCr65YYOE1sM9Yn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=c4t6wd+h; arc=none smtp.client-ip=62.149.156.162
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="c4t6wd+h"
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id Zy28wJnjp4OeoZy28w469S; Wed, 17 Jun 2026 23:42:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1781732573; bh=hjXlednnPAavbfrdO2yxouzQ52Ff1GGT1R6xtl+uF48=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=c4t6wd+hWnsU/IGOQ0N4aOQ4baitKYwsqm2leoT/5RCJdVe/IiLPHRg7ol2ZidE82
	 EUpxq/iH8z/h5iT6X2zKIRSlYGtnecCcLP8JYp17euWmrCXB7WWAv5OmoPX4rcLVs4
	 /W5dQi8hbNbBmfPTNpuHckMUyV59G80ppIcBzfp2jd+SHYOpy2e73+d+PDTxwVly05
	 rXI0ZAb6e56mUYUBINe+cxUaib1MVOfewYbXr46lyZ0Kdkb3tDs1hKwnkwd/H+XqtQ
	 EOsUdwXuKsqWunY+IFLaLdpC1xtXKWLTyQIocJEvmrIo67z4SjmUg2KVVuPTAY5+Hb
	 EeliDjzZU500A==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 17 Jun 2026 23:42:09 +0200
Subject: [PATCH 2/4] bcma: pmu: program max resource mask on
 BCM4352/BCM4360
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260617-b43-add-4352-wip-v1-2-c81323496720@gmail.com>
References: <20260617-b43-add-4352-wip-v1-0-c81323496720@gmail.com>
In-Reply-To: <20260617-b43-add-4352-wip-v1-0-c81323496720@gmail.com>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 b43-dev@lists.infradead.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 Alessio Ferri <alessio.ferri.3012@gmail.com>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfPga/+jcvE7OuVVkZZs2F7agCubGjDhtcpV1hH4MibJtEXcWFUoXf4T1Rcg46b/cSooFJI1uB+/CcAr/9DA2GnTTvr//ENtbOm4ZlZw14Hbjw+y03/8N
 i44DKnR74un2GonNyUEQSXpwwq/KsP0PseoIwO0fk9zgo2Y9wNj5nojY1FVIJ9Ib6fRVKLYs9RwK8D3eYFjibOy5IqEA6ec+2lisEMwSiQwiwWjH2/zN87eW
 pJYLaqmC4TX4aKJKhW2DnSD9+Qx5bCTexrywcCV81yUW0vva/8k/WRabCymJEErXpUPCB4SGuhMH9JhqKLdoZThVJi5iGOAeYeNaj5ar55WytF6pCt6C9vOf
 IFxNgFy2C4Vhx+LQbfeqHKI7f/Due0rsxajeRDiqdC4loLp7fhhxNHhS8H/OrJgZGypV1R8i

From: Alessio Ferri <alessio.ferri.3012@gmail.com>

bcma_pmu_resources_init() has no case for the BCM4352/BCM4360 family.
The vendor instead set the max mask for chip rev > 2 with CS bit 5 clear.
Match the vendor behaviour.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/driver_chipcommon_pmu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 263ef6fa1d0f..cdd5f7d668ba 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -188,6 +188,14 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 			  BCMA_RES_4314_WL_CORE_READY;
 		max_msk = 0x3FFFFFFF;
 		break;
+	case BCMA_CHIP_ID_BCM4352:
+	case BCMA_CHIP_ID_BCM4360:
+		/*
+		 * Vendor programs the max mask here for chip rev > 2 with ChipStatus bit 5 clear
+		 */
+		if (bus->chipinfo.rev > 2 && !(cc->status & BIT(5)))
+			max_msk = 0x1ff;
+		break;
 	default:
 		bcma_debug(bus, "PMU resource config unknown or not needed for device 0x%04X\n",
 			   bus->chipinfo.id);

-- 
2.54.0

