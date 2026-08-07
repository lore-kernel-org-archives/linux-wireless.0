Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563C612B94;
	Fri,  7 Aug 2026 02:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786071400; cv=none; b=PeSm6RrhLhA5TyrFAEMrRXkicm4H5+6DJmuSMFfu4ytAohQAfxeK+Eq1YjoqTEIGQRP5lvfDF7nPJOwYKf33J8V7YNFQPhPvOrZmdi31IcVMsUh3bYsatFVNE6cWAP9qhp92MvwYwrfysY0GTWH+UaMqTGtFVJ0NlnWbZoWdtnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786071400; c=relaxed/simple;
	bh=sMjo+vMZ3HtHucfyWe9JW8Ip/ZGVz+rgSm+BHT0zqf4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S9XSQ7NnsA5yDRjMJOZk5KzpezssQPcR/WEe0m82SOyQsz6/orcPqDZfdNC+SD5pfSn/m+RbS7Gah2TaUufd8sChU8vwfV6lln5lSlOV/f6pXHRV5v+HtKGr76QVZQfqAOCrLyW/VBi32bqrNpbueZ/zM6ltReNIkIORE/ycwJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 97dedbf4920b11f1aa26b74ffac11d73-20260807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:75a0e0ad-b6bd-44ee-8edb-59f1de35a4e6,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:dc1a74f3a12583116f8656b6593050f9,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|83|102|850|865|898,TC:nil,Content:
	0|15|50,EDM:5,IP:nil,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:
	0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 97dedbf4920b11f1aa26b74ffac11d73-20260807
X-User: gonglinkai@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <gonglinkai@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 481017638; Fri, 07 Aug 2026 10:56:31 +0800
From: Linkai Gong <gonglinkai@kylinos.cn>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath12k: fix channel list double-free on error paths
Date: Fri,  7 Aug 2026 10:56:28 +0800
Message-Id: <20260807025628.1893831-1-gonglinkai@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <6a9196e8-2e2f-43f8-9665-6ebb82b95951@oss.qualcomm.com>
References: <6a9196e8-2e2f-43f8-9665-6ebb82b95951@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Aug 06, 2026 at 18:47:38 -0700, Jeff Johnson wrote:
> https://wireless.docs.kernel.org/en/latest/en/users/drivers/ath12k/submittingpatches.html#tested-on-tag
> Tested-on: tag missing. How was this tested?

Thanks for the review.

This issue was found by code review of the error paths in
ath12k_mac_setup_channels_rates(). I do not have QCN9274/WCN7850
hardware, so I could not provide a Tested-on tag or reproduce the
ENOMEM double-free on a device.

The bug is: after kfree() of sbands[].channels on failure, the
pointer is left non-NULL (or the wrong band is cleared), and
ath12k_mac_cleanup_unregister() frees it again.

I understand Tested-on is required for ath12k. I will follow up
with a v2 including Tested-on once I can test on QCN9274/WCN7850
hardware. Meanwhile, any Tested-by from someone with the hardware
would be appreciated.

Thanks,
Linkai
