Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B495013A7
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569678; cv=none; b=cFKBWAxpHgEo1GBVUis1ViPMRiQRB0O3YMQtYheKX0FN7homfp+EjrCMsSkSgGUVMSGTFSQPz3GkQkQaFI2rtDiLMCV+4lQk1bLejVekKbvFfTNVKV4JntDAlkFUuM2NHP/twBPSssZrcfB/3fZzrjKDAfAwnQ72ICRNwEpqXNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569678; c=relaxed/simple;
	bh=PlOJNJGJ21/zM9BXf8ozPjYX+ZnZ+flZ9CXRUzpgRW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+GScdz3KRrq/sNuie7oQ2XfDbGW5zHrGawLCMQq42ixZwr9BZBeL+LkjsOApStgUtsXUX0NystL9Fpu7KWwUSlPWo6rr/OOGTbOMhCF12eBM7XSS547aPJRnCalAEtaPBFXXBEUrNap+NIvlXl5LNb7dXi7ICMbuqgDdhDc43E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=CiBt5c00; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="CiBt5c00"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=V6K4hQ4TvdSscJDE/DLhCZ7kwFl7+qvKsSt9PSuLjOU=;
	t=1791569676; x=1792779276; b=CiBt5c00FZ0geE1reKH2oX8WDBs5K+Bt69knUK8i8/clq9A
	dePKkUettDgotqkUnCeoE5ZXK3P6s36b7PE+Mp/7wgpVLvs7xq5KUe2q1SqbJGO2vtRe5ECI0AJzH
	05NF5S4qcYXdTm2IgBMpVOqRCldQjz4ns9EX5jeFecYKqTKwIcs0lHvJDl91Yi747AA2pKQYBEsPP
	N87YSOP3fqnbmLoxidtFnH6DROWFt53u4mw1NlkvqCxYk2X1JPd0UKYtGWwOYffyl0nv51+Hjqldn
	MnkLdAOkiQy45kw0AHlAxAw6xYZtb6PbtL64fPNRokQOAUBct1K0Dm5kdRaMjhHw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF74-0000000AtGH-0YTV;
	Fri, 09 Oct 2026 20:14:34 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 14/17] wifi: nl80211: transmit control port frames without wiphy mutex
Date: Fri,  9 Oct 2026 20:10:13 +0200
Message-ID: <20261009201417.d89a3bc2b1ec.I30d12968a0d4ab7a4ac8d0995a9ab7583b0ce2ef@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009181416.335754-19-johannes@sipsolutions.net>
References: <20261009181416.335754-19-johannes@sipsolutions.net>
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
index 32b458c9a7ee..3fa310b30139 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5271,6 +5271,7 @@ struct mgmt_frame_regs {
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted. A @cookie
  *	value of 0 means the caller does not want TX status reporting.
+ *	Called without the wiphy mutex.
  *
  * @get_ftm_responder_stats: Retrieve FTM responder statistics, if available.
  *	Statistics should be cumulative, currently no way to reset is provided.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b4ff8c811dc1..4044ea7d344a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -21070,7 +21070,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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
2.56.0

