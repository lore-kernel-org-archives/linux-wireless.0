Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6514151121D
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 18:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791569676; cv=none; b=VBtGgmWtryx0lKLM9/k0DhXHhjhjTI03NrRBo1OlkjEc+7Ensv8/7J2YftMyXMeaZoSTf+6DAE1OyqEqJ/YmEkGQ1al1UQIwcUZ59eUB8QUgnVGRyAwavKICiYeuOfxGE8i6yjwSiXrLBcR9f2dupotMh/Pot7Tdum2ULfJ8fWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791569676; c=relaxed/simple;
	bh=t4HvKefrwftKV9MeA0K78ww6JF6tn+PmQkQTE76OLoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5+DCxuXnCCYc6UnNRx71/lp9tRhRKnrFZ7FkqrWsyIw0x0YH7JifJJO8CmBQPpLanUYOEYzrjlVeamQo5F47dzqKRm8h9oBUEQIxPJFFoBZfooDnWuq3TmU41hHIIB2n2t4Wec2kydlwEBEk/cgaofUPzEn4AmvtJ8ygGdMDRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cBfw/M7f; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cBfw/M7f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=znaLvgf6kvDRwf/irWfAxnjxGBXVpbnWtt6yiTwBDvs=;
	t=1791569675; x=1792779275; b=cBfw/M7fuhxUcJ5nzWkd17lX1qs0n9GZe2iIGWf1ugZkrio
	P8CadzgR8fOzbBdnOfYE+WVykA3YSYVW6i20LJi13wwEva4fbWpB6KcSeFJ19nrFdoouQCOkkmq+t
	4NDF0tYe/NSWuip+kyA2lSgU5cLzqnucljfEbloT2sqaPDJ87kkUEZk5js4iJ2tYu8nOOZOOPtdlV
	PKr3juBh0HBgpT4YjgdGPyck5hUwQLjCe6hv1+5MWMO60YPbMF+zKRYYWzocmv4tbs594m9av8jp8
	sYLMP3yYD+PfzdyQhwZYeRqO7+DVU5ltYAVqZSvzYOoDpuoJN8nHRddQ+OP69a/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFF72-0000000AtGH-3U3S;
	Fri, 09 Oct 2026 20:14:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 12/17] wifi: nl80211: probe peers without wiphy mutex
Date: Fri,  9 Oct 2026 20:10:11 +0200
Message-ID: <20261009201417.75233ff945c8.I2f462bfffa96feb8dcc4386bc35ebc25d877a92f@changeid>
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

None of the drivers implementing probe_peer (mac80211,
wil6210, nxpwifi) need the wiphy mutex for it, so we
can just not take it. Document that as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 5 ++++-
 net/wireless/nl80211.c | 3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0eee48bdc937..32b458c9a7ee 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5149,7 +5149,10 @@ struct mgmt_frame_regs {
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
index 7cb3bb9438d7..b4ff8c811dc1 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -20835,7 +20835,8 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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
2.56.0

