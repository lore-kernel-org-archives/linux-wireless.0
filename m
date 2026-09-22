Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC185326CD
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072339; cv=none; b=QLTIwKVhK9QBY1lZi/Fbd73/MEPbUzr7h176Pe4r4Zv8GPwH5TmytCWZvbd3J5oN29UceZofUk5CxKAHE3fwGbofRlvbUgdrnjxRrYoRjEgWRFHpqg6aLAS9Y/Wh8MYT1H/f93mLVH4jj11ZcuD5MoL5jhSmsYAryHfjEa7nids=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072339; c=relaxed/simple;
	bh=4JmfR16fxqCgF430fg6bY4TzUGn64Wwi+KTamtBjlpI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SuK2V9avvm2Y6F7aWNKquQbw3EpEpk4+qk8cMkW1r31jNtuT8cypOfQSw7cPIGRQRrbo2PWkxJjN00rY+Bf4Y5DzBwXIfM85w0RiLsdOqxEbF/X2LINnduwrQK4yzH3QBanyKwhTB4tGI3WtT40KlTZ93+temesamq2Hd6wxi6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=WPblCQ/5; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="WPblCQ/5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J6UJ6J4Ur4B6k6q7V9tF04au/WLrJAhFqj3EyzsOVyc=; b=WPblCQ/5vViyMk6URSNNbU60OP
	jyVTbHRaE8DkAST4j7v6P5aDhgs2/QxgpejLzVoOPWGmtv8PStOcPTyKc4XaGjelv7oPoFSBC4gnG
	9Ui1ROe8EJ/nzoBmHLr0WQbFChR8iGqmyZxYk2xDTq/vw7PRfIgidJXltP03JoADZhdQ=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xaM-0080aD-2Q;
	Tue, 22 Sep 2026 12:18:50 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH 0/5] wifi: SCS and MSCS for offloaded flows
Date: Tue, 22 Sep 2026 12:18:43 +0200
Message-ID: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Frames that the hardware forwards on behalf of the driver never reach
ieee80211_select_queue(), so the SCS and MSCS rules of a station are not
applied to them. On an access point this covers most of the downlink
traffic. This series lets the offload layer query the user priority of a
flow, and mt7996 stores the answer in the flow entry.

It applies on top of the series "wifi: SCS and MSCS".

Patch 1 adds an undecided flag to the SCS verdict, for a caller that
evaluates a flow instead of a frame. Patch 2 adds
ieee80211_sta_flow_prio(), which applies the same rules in the same
order as the software path, on a parsed flow description instead of a
frame. It fails when a rule refers to a field that the description does
not carry, and the caller then leaves the flow to the software path.

Patch 3 adds a driver op that mac80211 calls after a rule change, so
that the driver can drop the stale entries of that station.

Patch 4 adds the query to mtk_eth_soc. It runs in __mtk_ppe_check_skb()
as an entry binds, which is the only place where the flow is known for
both rule based entries and the learned subflows of a bridge entry. The
flow description only carries the fields that the entry matches on, so
that one answer holds for every packet that hits it. This excludes the
DSCP and the ports of 3-tuple entries. The flush unbinds the entries of
the station, and the next packet binds them again with a fresh query.
The patch touches drivers/net/ethernet/mediatek,
include/linux/soc/mediatek and, for the flush op,
drivers/net/wireless/mediatek/mt76/mt7996.

Patch 5 answers the query in mt76 by mapping the station index back to
the station and passing it on to mac80211.

Not covered: an entry that outlives its station keeps the station index,
which is freed and reused. This is not specific to SCS and needs a per
peer flush of the flow table.

Felix Fietkau (5):
  wifi: cfg80211: report an undecided SCS evaluation
  wifi: mac80211: add a flow priority query
  wifi: mac80211: add the flow offload flush op
  net: ethernet: mtk_eth_soc: query the wireless driver for the flow TID
  wifi: mt76: answer the flow priority query

 drivers/net/ethernet/mediatek/mtk_eth_soc.h      |   1 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c          | 198 +++++++++++++---
 drivers/net/ethernet/mediatek/mtk_ppe.h          |   4 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c  |  34 ++-
 drivers/net/ethernet/mediatek/mtk_wed.c          |  33 +++-
 drivers/net/ethernet/mediatek/mtk_wed.h          |   9 +-
 drivers/net/wireless/mediatek/mt76/mt76.h        |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c |  39 ++-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c |   1 +-
 drivers/net/wireless/mediatek/mt76/wed.c         |  17 +-
 include/linux/soc/mediatek/mtk_wed.h             |   8 +-
 include/net/cfg80211.h                           |   4 +-
 include/net/mac80211.h                           |  32 +++-
 net/mac80211/driver-ops.h                        |  19 ++-
 net/mac80211/scs.c                               |  93 +++++---
 net/mac80211/trace.h                             |   7 +-
 net/wireless/scs.c                               |  28 +-
 net/wireless/tests/scs.c                         |  74 ++++++-
 18 files changed, 535 insertions(+), 68 deletions(-)

base-commit: 3788e2e605155c0753afbee78f17e0aaa8b13155
-- 
git-series 0.9.1
