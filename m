Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8B21E260C
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 10:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791281227; cv=none; b=PTnX8ktXeNsyh0DfDukCtaIXLbTiV41bIE7JHZOpe1PWlBwsUKuTdlONGgQr4xIqq3yh8TJN+fGKxycKKdq8c8791PjJefAup0OTzxs4WbLE2Mtvys+RKoqbtnwhw/aMYoxwOkopkl4ITiCwqcc53MNqq++2zHDJ/WRPHLJ1KOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791281227; c=relaxed/simple;
	bh=nghGUG5rRLyJud5j2Cl3GSau9IA/V07ttlyw8JIt7kA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IVz9sVnYhp+1a6iq/PijEZTlrp7C2hoOcAuVQjy9lThTt8mLP0Y2JfTVWXMZBCdDeFCbB5N8WCB7HqdtNZ0TKtcfz+tNNoFl4+H/ysPtn/UZMwH5ofpP5m7uyk9ZPmVEPCYz/Alj4p3Fg8x1rkO+Vnu1XQ9kqbD/mNHSlaWFdYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=WGiZYBDa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="WGiZYBDa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=M844cFnvUdlA6zQnfs48INuvN5BlQ3Je9WquK04lT0I=; t=1791281225; x=1792490825; 
	b=WGiZYBDaxg3/kV6odaAPEn2Z8MsFR8K3Ec7+z1E+PGMdKhhI94jcmrdYMtVJ1Xz2sT3J70IqQ/G
	p+lvXnILp1z2IxsSA6D1tCBzPdXuXjPkBzCBn2tx94gc0lYU7MLR1FIEDxBGAGt9u0+QM9fydYTSN
	xYmtpneThypJ1Cc+lpl5/8j86uX0bU9baax8DYj3PI4TNU2GsR7PERSmqCCmIdcMOz9PnA5bMmsGj
	KTOIZCgUnkzOn2H5I9Avx5zQAu17qpFmFCuf/K1xv+FVdCN9OeVYBVi7wrNDukf/otszkP+9HzXwr
	iqxyfaUjMiZ4CSY2jpxjUUkIqByzQTRUDRNQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xE24b-00000006XqW-2KfM
	for linux-wireless@vger.kernel.org;
	Tue, 06 Oct 2026 12:07:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-net v3 00/19] wifi: further RTNL redux
Date: Tue,  6 Oct 2026 12:03:58 +0200
Message-ID: <20261006100655.2687533-21-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1: https://lore.kernel.org/linux-wireless/20261004190122.1559001-20-johannes@sipsolutions.net/

v2: https://lore.kernel.org/linux-wireless/20261005100525.1991059-20-johannes@sipsolutions.net/
 - patch 3: fix netns check/crash, fix race in tests

v3:
 - new patch 1 to fix regdb accesses
 - use wiphy mutex for reg notifier
   (to clear things up for Jeff's LLM ;-) )
 - more testing than before - survived our internal CI


No new notes, so as before:

We've been discussing some issues around lock contention for a
while now, and syzbot keeps reporting RTNL hangs against wifi.
Inspired by both I looked at further reducing RTNL in the wifi
stack, addressing the two biggest concerns:

 1) After this, we no longer hold RTNL on (mostly) nl80211
    command paths, unless of course it's required for the
    specific command.

 2) Regulatory is disentangled and no longer requires RTNL.

johannes



