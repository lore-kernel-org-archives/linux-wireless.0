Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF424282F06;
	Thu, 20 Aug 2026 08:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787213808; cv=none; b=e93xQiF9ZHsSoXdT9o7mrdvKDRzRYlc+k8CkrWdKWHpASDp0eZoDHM/6k8BfC4oW4kai3VYfH58pzL59vhafemgSRraN5IuVQ63Jy8lETI2UmyIx5XXnIqTKZ2IhUqwGpNqo7sUTHFDGYYoOLwM8aIwi+HCHZAzh9Fb7iGMhYoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787213808; c=relaxed/simple;
	bh=I7Leg6UhCygJlx6mUKjHFGNtpOZvBLd5qQ5Kig7ZBt0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IprkwRG/gNxBq9Qg9zbemlhjme57Mi/PWyiqZULh5eoKVN7ppIcCQDNiVTXlz5HNSZ/uOqJoDBKziDlRFBw3Nrs81pmYFsCyEQv77g18JEGcHrkuN9W77tMmO9t09fBg4MD901aMCY2lMc1YairS6bHXDgBMr+TWBlOCOD6sL9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 77df15f89c6f11f19a56ed5b684f684d-20260820
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:de78ca73-c2f6-40e4-81ae-f4ea902cbe33,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:4087f9d0d051b94e765b50c2e9c155a8,BulkI
	D:nil,BulkQuantity:0,SF:102|136|850|865|898,TC:nil,Content:0|15|50,EDM:5|-
	100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 77df15f89c6f11f19a56ed5b684f684d-20260820
X-User: lilinmao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1618554250; Thu, 20 Aug 2026 16:16:39 +0800
From: Linmao Li <lilinmao@kylinos.cn>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Linmao Li <lilinmao@kylinos.cn>
Subject: [PATCH 0/2] wifi: nxpwifi: fix the host-MLME authentication frame path
Date: Thu, 20 Aug 2026 16:16:32 +0800
Message-Id: <20260820081634.4043666-1-lilinmao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two fixes to nxpwifi_cfg80211_authenticate(), found by reading the code
rather than by hitting them on hardware.

Patch 1 is the one that matters.  The frame length is kept in a single u16
that conflates two different lengths and gets both wrong.  req->ie_len and
req->auth_data_len are both size_t; the IE policy caps req->ie_len at
IEEE80211_MAX_DATA_LEN, but NL80211_ATTR_AUTH_DATA has only a four-byte
minimum, and nla_len is a u16, so one auth data attribute can carry 65531
bytes - enough for the sum to wrap when it is assigned to the u16.  With
auth_data_len == 65510 and no IEs the length becomes 6, kzalloc(6)
succeeds, and the copy below writes 65506 user-provided bytes past a
6-byte heap object.  Separately, NXPWIFI_MGMT_HEADER_LEN already
accounts for the address4 that nxpwifi_form_mgmt_frame() splices in, so
that helper is asked to append ETH_ALEN to a length that already included
it and overruns the skb tailroom by six bytes; SKB_DATA_ALIGN() slack
normally hides it.

The patch keeps the 3-address length the driver builds separate from the
longer frame the firmware sees, and rejects lengths that cannot be
represented once address4 is added.  The value handed to the firmware does
not change for frames that were already valid.

Patch 2 is the small one: the same function never checks that kzalloc(),
and leaks the buffer when dev_alloc_skb() fails.

Reaching patch 1's overflow needs CAP_NET_ADMIN in the netns user namespace
(NL80211_CMD_AUTHENTICATE is GENL_UNS_ADMIN_PERM), an up netdev, and a
suitable STA/BSS/SAE state.  I have not written a reproducer or looked at
exploitability, so I would describe it as user-influenced heap corruption
and leave it there.

mwifiex has the same length handling in mwifiex_cfg80211_authenticate() -
it is where this code came from - and it is in mainline since v6.12.  That
needs its own fix against the fixes tree rather than being folded in here;
I did not want to mix a wireless-next driver with a stable-bound one.

Compile-tested only (allmodconfig, W=1, drivers/net/wireless/nxp/ clean).
I do not have IW61x hardware.

Linmao Li (2):
  wifi: nxpwifi: fix the authentication frame length handling
  wifi: nxpwifi: handle authentication frame allocation failures

 drivers/net/wireless/nxp/nxpwifi/cfg80211.c | 24 ++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)


base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.25.1

