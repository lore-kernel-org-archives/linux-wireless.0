Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8772E975E
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195076; cv=none; b=tD0sYDoGT8PDG8JlHoNGe898PB5jBns0r2f6dtArZQohSgPXIOTQOymIQv09qoyGC97wrMa+bNO6QzEDwYXXEE4wOxLHRg1NJA6vGw64AYQ8vs0o04fsULy9eFiTNCdwsxar3lb7hUi0Yr2MYNGGGfsklBQ7SPTNgzIBeL0UY3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195076; c=relaxed/simple;
	bh=vw1d4+FrNE3Jr+L89xbAa3t12QN3HcDLyBQAE2g9ogk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j93Xq8H8C1WK5Sn5WyLC/9JvF3IIs2+3z96zPpXm4an3IhIL5Htp6mM2RaC58CyT1uGc6eyxBMWoumUOiqRITxTSeMqPoS9B4nY5XJVsQDGhLvPSWbyoESTp06Rn+PsY+H5beBao3DQaHr3y7oTo/1y8n32P0Kcehq5WfjGEMqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=rYvZEMkB; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="rYvZEMkB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=sMohHznHLlbb//ZtTUfK6+vkkOhidjod+a6hBQmVDQc=;
	t=1791195074; x=1792404674; b=rYvZEMkB3rmNsorzlNMZXsptW0PTlHyaQZRO5x48lRtTQ5m
	uCtq8URSLdD039J8cfWQz6QHqExM232hnhdjk872vrVJxvBZwxPF63nkFM5h8fzzwPXvFWomG8cfV
	iC+XMQ+5ej1dq43FKfYg7XCAWOJMuCyhJCbXPuSIZYSRd3YQxnuWT3CcckI6pbMHrjcSwvs1aQ7iw
	On22KjmyUo2r31gTDlXmqq91ceVDRzx0LsC5RutGRoMg+rmu4++M/2N5GW9IsisbvFHgqhCM+Hm/N
	lE7Yk/Q3bkheLAtlGM5g2b4WO01kThXso3yZ0LSU1oXZuL0Vp8BTkKES8cRVaX6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff5-00000005CGx-3Yy6;
	Mon, 05 Oct 2026 12:11:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 11/13] wifi: nl80211: probe peers without wiphy mutex
Date: Mon,  5 Oct 2026 12:06:27 +0200
Message-ID: <20261005121058.6319fb734db6.I2f462bfffa96feb8dcc4386bc35ebc25d877a92f@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005101057.1992330-15-johannes@sipsolutions.net>
References: <20261005101057.1992330-15-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

None of the drivers implementing probe_peer (mac80211,
wil6210, nxpwifi) need the wiphy mutex for it, so we
can just not take it. Document that as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 5 ++++-
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 73d9e86493ff..1c5130e5f5f3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5143,7 +5143,10 @@ struct mgmt_frame_regs {
  *
  * @probe_peer: probe a connected peer (AP: STA MAC required; STA: no MAC),
  *	must use the @cookie as provided which is later passed to
- *	cfg80211_probe_status().
+ *	cfg80211_probe_status(). Called without the wiphy mutex, so the
+ *	interface type may have changed/be changing and the MAC may be
+ *	%NULL even in AP mode (if runtime type changes are supported),
+ *	drivers must check for that.
  *
  * @set_noack_map: Set the NoAck Map for the TIDs.
  *
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b9d0aaa6fc6c..51f2d7de8638 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20798,7 +20798,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_probe_peer,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
 	{
 		.cmd = NL80211_CMD_REGISTER_BEACONS,
-- 
2.55.0

