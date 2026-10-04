Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A57C3B9DAD;
	Sun,  4 Oct 2026 11:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112500; cv=none; b=SvJX0j0zNSU+0Luf/L2a8yj5DYz87Tj9fkFMWFTiLDKwMfsLYF8l+lNUnFbWKqV3624BLw7wL87nKYkjopfEzSNUJ4cqzG2UZdFFJyHkN8iYRqzykthPCMiPLsg+64esZogIiXeMvbgbWCqioyhbw1Z5tOX+s7nINJ8CtuIRFXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112500; c=relaxed/simple;
	bh=/+oRZ3f7uP3eXIrZITjsb878GJwuVUBJu56S/r/0pVE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BjxaT3xNVb4YiDqPd/DgpfOc0kHlWnLQZSC8LNtf9VsokSIHvq1vBQgNHDBLu2Ob54OpUmnkH7I+v4x6Rn16RyVCmi1bOuXD2sVCq9gcNle/xsGFoBv0EklHDbVnZmDywnS0g5diVhhHI6MJ50ZEz58wF4swjJwPmdzT+oGWf7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=KwmgdDHU; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="KwmgdDHU"
Received: from MAILGW-DELL.dell.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 4148A13BCB;
	Sun, 04 Oct 2026 14:14:57 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:message-id:mime-version:reply-to:subject:subject:to
	:to; s=sig1; bh=oPPgHQlTrnBHfbNta8PNjL/e8w+pnhWu2Gm5pE5Hink=; b=
	KwmgdDHU2qDICdiwX8JZXNWbfuo31nB1bK87EGxaZR1lidFc/8sKjsqsc6aCpL4h
	spfJa9Ps9qRip8mOK3QiwvFsbyHztH+3fG8PLUmVR6/utX9ZtWR+i9A3l5gqPHkh
	8gaxMFHpZiEPcoQf0HomEh0qeQc3TBRKiY21y3NSbAsSjKvFDF8NCqrH9dIKiO9F
	/nrCm9TcK1j5HGTJxc8wVoQJd3LMfCFM+jErvashnFp10KD4hkQtk6CSqU/4opul
	rdYyhHmFZ7LYSkooQZ/IlR0ioyPB+0x3Me5bQMKvNBIQEf/17UgZnrgen5rROyLF
	g642xjUVdSNT+LtYpzHHeA==
Received: from VTJ-MX.corp.irix.systems (unknown [IPv6:2a02:2f04:1:9c24::6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 1CC0D13D20;
	Sun, 04 Oct 2026 14:14:56 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:14:55 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>, Felix
 Fietkau <nbd@nbd.name>
Subject: [PATCH wireless-next 0/2] wifi: mac80211: airtime weight op, BSS color during a color change
Date: Sun, 4 Oct 2026 14:14:48 +0300
Message-ID: <cover.1791111135.1.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

Two mac80211 changes an ath11k AP needs; the ath11k patches that use
them follow in "[PATCH ath-next 0/2] wifi: ath11k: firmware airtime
fairness, BSS color while disabled"
(<cover.1791111135.3.git.me@andrei-z.com>).

1. Felix Fietkau's sta_set_airtime_weight driver op, carried in OpenWrt,
   so a driver can program a station's airtime weight into firmware.
   v2 posted it inside an ath11k series, which is now split by tree.
2. When a BSS color change starts, mac80211 cleared the color along with
   the enabled flag, so a driver could no longer keep transmitting the
   color the BSS still uses (IEEE Std 802.11-2024, 26.11.4).

Both run, with the ath11k patches, on the QCN9074 and IPQ5018 radios of
two U6 Enterprise access points.

Changes to patch 1 since v2: Felix's Signed-off-by is back in the
trailer block.

The patches by me were written with an AI coding assistant (Claude
Code), which also drafted the changelogs; the testing described was done
on the hardware.

v2 of patch 1: https://lore.kernel.org/all/20261003155542.96363-4-me@andrei-z.com/

Andrei-Alexandru Bleortu (1):
  wifi: mac80211: keep the BSS color while a color change is pending

Felix Fietkau (1):
  wifi: mac80211: notify driver on airtime weight changes

 include/net/mac80211.h    |  5 +++++
 net/mac80211/cfg.c        | 13 +++++++++++--
 net/mac80211/driver-ops.c |  4 ++++
 net/mac80211/driver-ops.h | 19 +++++++++++++++++++
 net/mac80211/sta_info.c   |  7 ++++++-
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 6 files changed, 72 insertions(+), 3 deletions(-)


base-commit: f49defea7668d8c68ec19fa085ef3da6075561c7
-- 
2.47.3


