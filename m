Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D982D73B6;
	Tue, 11 Aug 2026 02:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786413958; cv=none; b=ieIRkCAYLRUkS6pDHprvohmGJuu5EjA3xIR2cw5NWEFM5ABpnZMvujhW+GG7SdqObcssavE1Oc3jKvbF1Irqy1rZNUwZWbg0LDMOMioF0NLcCICePVKPHZFtcq5EdKHy6QhBAgHtqaDdC7todOd1OLwqwD71HQ6hKHxtdDhFfys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786413958; c=relaxed/simple;
	bh=p8qMkQur3Y8Ns6FT0sD489XqC4EZZ5ibiYUQjNEcYws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VsOynnb1UWa7Cjb4WxnYuxgt3ITATNf+jyw4sJ1/PvPCjolXD/GTYT7ZtoWOvBke5BVIPxr8gfwFTvZ8nXJDF92G0giLtY6HhP38y+qTq3PNIEUrs+gmpXvJ/6hxzQahYLutpf/xOEwDDhzP+9pZohGybB4DJPuU9hdC8xDJWqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2dc95dc2952911f1aa26b74ffac11d73-20260811
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:42b7a489-1240-48a9-87e1-e7153d45e6ea,IP:0,U
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
X-UUID: 2dc95dc2952911f1aa26b74ffac11d73-20260811
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 923249976; Tue, 11 Aug 2026 10:05:51 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: baochen.qiang@oss.qualcomm.com
Cc: jjohnson@kernel.org,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath12k: fix channel list double-free on error paths
Date: Tue, 11 Aug 2026 10:05:49 +0800
Message-Id: <20260811020549.391881-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <bd5db1a2-90f3-4cc9-8cd8-c18499c56a2b@oss.qualcomm.com>
References: <bd5db1a2-90f3-4cc9-8cd8-c18499c56a2b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Mon, Aug 10, 2026 at 03:07:25PM +0530, Baochen Qiang wrote:
> So this is actually a dangling pointer
> issue, not a reachable double-free — nothing frees the failing radio's pointers a second
> time. Please reword the message to something like "error paths leave dangling pointers + a
> copy-paste typo; harden by consistently nulling after kfree()."

Thanks. You are right, I misread the cleanup loop.

Will reword the commit message in v2. Code change stays the same.

Thanks,
Linkai
