Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F187147728E
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 10:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791195078; cv=none; b=ZsJBhKQPXIuLxtf4xKViZBuQPrAqSgg+I1RL1NAihF3Iy52TACbbevRSCELDvyY9wzfE7JXHuSDqzt0k8FJ7w4pTHhtD2LZ0jdzHwj4fh+fDKfsXkcr+86J1RCzW+wCoY5ZdMtxDQiojd8nDL6vZcxObIkgLigA1vq+UoC88qDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791195078; c=relaxed/simple;
	bh=AIfudOnyQII/Hm8byu+1F7dIK6v3uVWRrB3FSqNjcM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwCGJ4tnkGC1ONN5pdL6bgSBXqI1oR1PyVQETHDnzbTC5QvmyOgWWIdr+5e+j89aYneuQE9TyMLff5wMb8R2GdNHdPxKFwykqlUTqt+l5T4RP6Rvb2dtgkNPJTvplOMH+MqEm9kmNFp3ANj9Y/hqTq4dP1IE+wxJG7FY+nrOBUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=loZYSo1o; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="loZYSo1o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=GXKq+vyNgRXeEdfQfaj+N9aRCfHk9NVziiNYa/7MEOk=;
	t=1791195077; x=1792404677; b=loZYSo1oxCVgn+MhY30W3iLeZFGNjug+9XUXHfJxVF7vpSk
	SRNUxqHC3sZy32aBmb8OC6hllF4VTpuuSilWEivv+9O/ih9Rk3SvujMya7SbrzTM6aDBQHgi3x6Rh
	Kqq6oEjZKyei1zF0EcgtwT5SxJT5IXLiUb66fZ7ma7Ir8VsjGrtgJLkiuSkYhmWiFzEzBrzhvxSMC
	1hWHC0FU5vsY3hrCXGOtMX3IhbUsRUaqeLpZMkALXlA4/Gm80+/mZL0hirg8xIMA0m+IjFJXPvi8Q
	I9LCmMSg4lIvxl82Nbs2zS9ggXaDWZDnOGr2k1c/38BqhQU3NMpvete5Kk8rhsjg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDff7-00000005CGx-10J3;
	Mon, 05 Oct 2026 12:11:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH v2 13/13] wifi: nl80211: transmit control port frames without wiphy mutex
Date: Mon,  5 Oct 2026 12:06:29 +0200
Message-ID: <20261005121058.df85b18d4d6a.I30d12968a0d4ab7a4ac8d0995a9ab7583b0ce2ef@changeid>
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

Only mac80211 currently implements tx_control_port, and it
no longer needs the wiphy mutex, so don't take it here.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 1 +
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1c5130e5f5f3..49c6600c024b 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5265,6 +5265,7 @@ struct mgmt_frame_regs {
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted. A @cookie
  *	value of 0 means the caller does not want TX status reporting.
+ *	Called without the wiphy mutex.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 51f2d7de8638..4e956f12c390 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21033,7 +21033,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_tx_control_port,
 		.flags = GENL_UNS_ADMIN_PERM,
-		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP |
+					 NL80211_FLAG_NO_WIPHY_MTX),
 	},
 	{
 		.cmd = NL80211_CMD_GET_FTM_RESPONDER_STATS,
-- 
2.55.0

