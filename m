Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EC846C4A0;
	Fri, 14 Aug 2026 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786710505; cv=none; b=NxTl/nPnepd6MeeKDjTHrIGG9IWjPtGBiAU8taTwEX02UwOQNVTdnZqA0Z1nP8XMr0nJj+P0tufY4R2G3SJjFi6dEzgh1j4QUBksBKXSk62L3trKyQ+c1qv6Z1OM1iOC7yUi/Nw4nzxToCW7t8Nq0BKuaUc+IOVoPnnTfgzrX+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786710505; c=relaxed/simple;
	bh=UjpvmLPgfC7jTbrZzeXGwPqwdm9bhuQq0mkcj6QGHD0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CIxXyKCtfSNYqm1gNMcvrgF008gdKvTp+336NWoTCanb0Dj+VVouU3nxvxchYLsvhB6W9dCSCvSNkvzFch0BGbwAnJFNuJqoD4itJ8k64/nsIUhTqKWY6T8gQ72j+BFqXMnpiaQJeAcLX+M1WnMyPF1sXRuWVK2mkYHyQM2F2Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9f8a5bc897db11f1aa26b74ffac11d73-20260814
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:366488d5-00e9-4b81-9380-1a0b9d6d0158,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:e7bac3a,CLOUDID:9c698a8d391ef44591f5d181bd7fdafc,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9f8a5bc897db11f1aa26b74ffac11d73-20260814
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 977070634; Fri, 14 Aug 2026 20:28:15 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH wireless-next 0/3] wifi: nxpwifi: harden the VDLL download path
Date: Fri, 14 Aug 2026 20:28:07 +0800
Message-Id: <20260814122810.2999536-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The VDLL download path acts on an event the firmware sends, and on the
lengths that event carries, without checking either.  Reading through it
turned up three problems:

  - the ten-byte event header is dereferenced without checking that the
    event is long enough to hold it;

  - the block length the event carries is clamped only against the size
    of the VDLL image, not against the 2048-byte command buffer the
    block is copied into;

  - the error path taken for an oversized VDLL image keeps the firmware
    file pinned for the lifetime of the adapter.

Patch 2 is the one that matters most.  msg_len is a u16, so a block
length near 65535 wraps it to a small value: the skb is grown by a few
bytes and the memcpy() that follows still writes block_len bytes past
the end of the command buffer.

The three are independent, but they all touch util.c and apply in
order.

Found by inspection; there is no IW61x hardware here to test on.

Linmao Li (3):
  wifi: nxpwifi: validate the length of the VDLL indication event
  wifi: nxpwifi: reject VDLL blocks that do not fit the command buffer
  wifi: nxpwifi: release the firmware when the VDLL image does not fit

 drivers/net/wireless/nxp/nxpwifi/util.c | 31 ++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 6 deletions(-)

-- 
2.25.1

