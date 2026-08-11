Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7375B2D73B6;
	Tue, 11 Aug 2026 02:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786413984; cv=none; b=az8XvQiUwI0iU3kQYDqE3ziuhNavotJh/Q4zV2DBqn7ktCER+7gx2ud0yZa33Yi45cHC/lxHMvBSh3XdeDh1K4ePagkXF4+3JAWtBHkPNYG60m4V6us9W/stUciHd1vQlzGmOIQpezeIN4xrEU04GQPD/OGWTRKE6BoMTtXXcho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786413984; c=relaxed/simple;
	bh=aFm8Aj9OZytwFyAPsBqRjPMF5tcPLmJJrU05ezkPDR0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ix+IreJ0PHxeuSOVKqFEIWhLdQwMBESJj8oIuZp7FdEpXe5TPhFbI/LrERLg/qVje5RPhCHsBFcN+VqGloVwYBu00yB5H/6RoDeLRBR7hlcOcEei3ZWxX6ZclJDDzs8eg123kiDdCEWV9E/KHG1CfJSjdPIap3dcve6ny/s6ha0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3ac63d92952911f1aa26b74ffac11d73-20260811
X-CID-CACHE: Type:Local,Time:202608111005+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:cc768920-1958-4739-954b-4253221ddfc3,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:91971f77f26c422c5bb862d4c2fe6f0c,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:80|81|82|83|102|850|865|898,TC:nil,Conte
	nt:0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL
	:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3ac63d92952911f1aa26b74ffac11d73-20260811
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1098198722; Tue, 11 Aug 2026 10:06:13 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: rameshkumar.sundaram@oss.qualcomm.com
Cc: jjohnson@kernel.org,
	baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath12k: fix channel list double-free on error paths
Date: Tue, 11 Aug 2026 10:06:10 +0800
Message-Id: <20260811020610.399158-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <59d20ace-66cc-4a0c-a09a-e669becd2657@oss.qualcomm.com>
References: <59d20ace-66cc-4a0c-a09a-e669becd2657@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 10, 2026 at 03:44:54PM +0530, Rameshkumar Sundaram wrote:
> So this probably should either be split into two fixes, or the commit
> message/Fixes tag should be adjusted.
>
> But unless there is another reachable path where these stale pointers
> are later freed or dereferenced, do we really need a Fixes tag here?

Thanks. Agree on both points , the first two hunks predate
acc152f9be20 , and with Baochen's clarification there is no reachable
second free, so a Fixes tag does not make sense.

v2 will drop Fixes and keep this as one small hardening patch.

Thanks,
Linkai
