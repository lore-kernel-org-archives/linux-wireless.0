Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE0814A4CC;
	Fri, 16 Oct 2026 00:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792109876; cv=none; b=Cuwdd/3A7pJspOluWRRCZHivQTP8o2pXegMwTtyxNcLK95TektvZSVuJ3sGZ4VfzsysAY5Bm0EIShgyyI7AJTmrW/lWO9JeGFmzgVvhaW6jWc+YfjAmGdefrb5bu2T/olH2Ea/u1qm3l0Hh7QDxMvzFLey9Qip4QYmnZgjCPUws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792109876; c=relaxed/simple;
	bh=+cl9qymxEtviJwTkXH9r4C6uoUeq8a2WZVC+87PscCw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=CT0+MycDvs4dVB2/dbyazsj93a8Uu62lDNYozNyFkM8YYDKITr3ovG4XNhDx+VV86r09j2lPTr/Xm35TjPE2FJ2x3BZ4Ct/WL+ILzP0tyoUXjvmCD5bgNKfo6G8liDGqAYQXsQDxhJT7dAZA46DmEC+RJ2Bthvj9saIPGPXkb28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0uHUKDh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0uHUKDh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1DCAC2BCC7;
	Fri, 16 Oct 2026 00:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792109875;
	bh=+cl9qymxEtviJwTkXH9r4C6uoUeq8a2WZVC+87PscCw=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=g0uHUKDh0mAOCw3Q4kEGxxZ0fiBh+wNsXB89BXUSsGfvVosKrr9ZLbRtQGANeCflV
	 PX2Ha3Z+FXWIZQzyOE7uvgT0EZ8aSurxCDjvM9ncozB7AhhD7Jfdg0yfal16BAh1+K
	 jgA4VrFUA5JP0+HgwqJntENpXHDt/tpJsfUCpgxbkp4w8nZywX3KvTHJ6cqE0ItPve
	 oX9T3q8LNeltmu28JNIbgDvEsRr/DloaSqG8a4SCxDhL5Z3pKvDXXJHkc2l9rqmXtN
	 Mq+hcwB91NIG7GB8atYIbu9wdg03PvOZ7oBThFCmBkQjrInhm6y5bfAbuTEIjMUVNj
	 GFkuB4ZOeePoQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED11CCA463;
	Fri, 16 Oct 2026 00:17:55 +0000 (UTC)
From: Shunsuke Nagashima via B4 Relay <devnull+shunsuke.nagashi.ma@kernel.org>
Subject: [PATCH ath-next 0/3] wifi: ath10k: WCN3990 station fixes for PMF
 and failed connections
Date: Fri, 16 Oct 2026 09:17:53 +0900
Message-Id: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QrCMBAEf6Xsswe5VFL1V8SH2pz2FKIksRRK/
 93Tvu2wzCwoklUKTs2CLJMWfSUD3jUYxj7dhTQawzsf2HGgvo7snrRpNLGtFKnrAvvj/tC2McL
 cd5abzv/uGaZQkrnisj3lc33IUH9ZrOsXthzue4MAAAA=
X-Change-ID: 20261016-ath10k-series-v1-send-7761294833dd
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, David Heidelberg <david@ixit.cz>, 
 Fabricio Akio <fabricioakio@gmail.com>, 
 Shunsuke Nagashima <shunsuke@nagashi.ma>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792109874; l=3103;
 i=shunsuke@nagashi.ma; s=20260927; h=from:subject:message-id;
 bh=+cl9qymxEtviJwTkXH9r4C6uoUeq8a2WZVC+87PscCw=;
 b=hROuBCtTNem1gMX+HZrA5R8YewpERBu9qFuTiZZvgRXiSRrFdQVGtXI0LxxDlB3qgJEaixK/7
 ci2u9HmKAe7CY9tKlUI35G3wCFsoatUFz/8yvMl0BgTPYUuP+tGtK4m
X-Developer-Key: i=shunsuke@nagashi.ma; a=ed25519;
 pk=5WP8Bzifiy3DFoCeQ1lLy2osPmlNAkq71Un7ly9lbpk=
X-Endpoint-Received: by B4 Relay for shunsuke@nagashi.ma/20260927 with
 auth_id=1069
X-Original-From: Shunsuke Nagashima <shunsuke@nagashi.ma>
Reply-To: shunsuke@nagashi.ma

These three patches fix two problems I hit on a comma four (SDM845,
WCN3990 hw1.0 SNOC, firmware WLAN.HL.2.0.c10-00459) in station mode.

Patch 1 sets the PMF peer flag on WCN3990. Without it, the firmware
sends ADDBA Request frames unprotected on PMF connections, no Block Ack
agreement is set up, and throughput on a 5 GHz WPA3 AP was about a
tenth of WPA2 on the same AP. On 5 GHz the protected Deauth also
carried PN 0, which one AP dropped, so the next association got
status 30.

Patches 2 and 3 are about the station vdev after a connection attempt
that failed before the vdev came up. ath10k stops the vdev but does not
bring it down, and this firmware then holds the Auth frames of the
next attempt for about 20 s. Patch 3 sends the down after the stop.
Patch 2 makes ath10k_bss_disassoc() skip its down for a vdev that is
not up, so that the down is not sent while the peer still exists.

Patch 1 does not depend on patches 2 and 3.

All results are from my own device runs on WCN3990 only. The test
kernel is v7.2-based and also carries three out-of-tree ath10k patches
(MAC address, in-order rx A-MSDU, SET_KEY wait).

Patch 3's notes also describe a rare data stall right after an
association. It also happened on a build without patches 2 and 3 and
on builds without patch 1, so no single patch of this series is needed
for it to happen; its cause is not known.

Related patches on the list:

 - David Heidelberg's RFC "wifi: ath10k: skip completion wait for
   pairwise key removal" (patchwork 14827446) adds a hw_params field at
   the same place as patch 1 (the end of the WCN3990 entry and of
   struct ath10k_hw_params). Whichever goes in second needs a small
   rebase in core.c and hw.h (keep both new fields).
 - Fabricio Akio's "wifi: ath10k: don't reset TxBF on disassociation"
   (patchwork 14880772) changes ath10k_bss_disassoc() next to patch 2.
   The two do not depend on each other; either applies on top of the
   other with git am -3.

AI-assistance disclosure:

I worked on this with Claude (mainly claude-opus-5-5 and
claude-fable-5-1) and Codex (gpt-6-astra). They helped go through the
logs and sniffer captures, draft the code changes and the debug builds,
and write the English of the commit messages and this letter. I
reviewed the code. All device tests ran on my own comma four, and the
results come from those runs.

---
Shunsuke Nagashima (3):
      wifi: ath10k: set the PMF peer flag on WCN3990
      wifi: ath10k: skip disassociation down for a station vdev that is not up
      wifi: ath10k: bring down a station vdev that never came up

 drivers/net/wireless/ath/ath10k/core.c |  1 +
 drivers/net/wireless/ath/ath10k/core.h |  2 ++
 drivers/net/wireless/ath/ath10k/hw.h   |  6 +++++
 drivers/net/wireless/ath/ath10k/mac.c  | 45 +++++++++++++++++++++++++++++-----
 4 files changed, 48 insertions(+), 6 deletions(-)
---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261016-ath10k-series-v1-send-7761294833dd

Best regards,
--  
Shunsuke Nagashima <shunsuke@nagashi.ma>


