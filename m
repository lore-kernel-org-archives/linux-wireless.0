Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D1C38AC75;
	Sun,  4 Oct 2026 11:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112630; cv=none; b=e8EE1cFb6ou6WH8Dz7xpZ5WKdSJKFbImt0CqIlwakF73upKR1FaGpcu8OpJBaDK/rExQjvh1m9F1IeY0WaAnsaaflZzvqEw6SzSvm0GLhQeIkdkTxQWa6kU8DMewaj87ISZ2L8KiIn+2qvKNpeeZI6UBq4qfZbvnHCiAsAnlzz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112630; c=relaxed/simple;
	bh=596JaCT6Mp1AbJhS7IYhR4+cm7Ylya50lKXNzDbv124=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/O0Ygcvmh8hOthVvn545KtSw2CRtcyehFdFeIsHgrykvsjmiY8rvYrPploPrh82w1yWlv20mibqmzetD+LvRsbMa4LdlncFmsubCK87SAIFLfC10TpHqQ8EkUs/d90JofzBErhYTRN23IPpNsGUraKYTt0ANP5Hk3BLcE7CiHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=IdeMgywM; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="IdeMgywM"
Received: from MAILGW-HP.hp.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 56F6A1BA68;
	Sun, 04 Oct 2026 14:17:07 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=EVdHbBvroDmI1dupR9CV
	wLwG1vstFP2aGg4Ap+XLLLs=; b=IdeMgywM4XBcsTaZ4w4A8tN65zlt8wf7SuO5
	bDWqN8SbIbgF4/MYzKk/5T6GidTkSdQvkiVTDUYL5mqfVWChlK2XFxHZRo1ksIKt
	MSqaEaOSJzYbmyfVCmAT4RDf1XIHDp7Mck7lvfLwwTNYIBe0eAtOiDlrlqWECNVl
	qGbF/Gt07nL7mTFjH5tkaAQriOt+SNTAHCvBcFN3hofbID6ttBLO04BJDAFUe9Nk
	mtd8TrWHpE4Y83AINyqrR60W4mgkCu4S0ktiFN4u1OWVkroqOxIhgeZDoHH8cdx4
	wLb430b+XFOy9Xz/T6wkKEjWvdVNaotcEcd1sAxdc6KWGSHn+Q==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 917BE1BA67;
	Sun, 04 Oct 2026 14:17:06 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:17:06 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>, Felix
 Fietkau <nbd@nbd.name>
Subject: [PATCH wireless-next 2/2] wifi: mac80211: keep the BSS color while a color change is pending
Date: Sun, 4 Oct 2026 14:14:50 +0300
Message-ID: <e696e399eee2f42c2907c45c85aa894705bee1bf.1791111135.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.1.git.me@andrei-z.com>
References: <cover.1791111135.1.git.me@andrei-z.com>
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

When a BSS color change starts, mac80211 tells the driver that the BSS
color is disabled, as the Beacon frames say during the countdown, but it
also sets the color to 0. While the BSS Color Disabled subfield is 1, an
HE STA shall keep using its nonzero color, the one it used before, in the
BSS_COLOR of the HE PPDUs it transmits (IEEE Std 802.11-2024, 26.11.4),
and a driver can only do so if it still knows the color.

Keep the current color and only clear enabled.

Assisted-by: LLM
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 net/mac80211/cfg.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 28f99a8f8a..e68edf833f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5807,8 +5807,13 @@ ieee80211_color_change(struct wiphy *wiphy, struct net_device *dev,
 
 	cfg80211_color_change_started_notify(sdata->dev, params->count, link_id);
 
+	/* While the color is disabled, the BSS keeps using its current color
+	 * (IEEE Std 802.11-2024, 26.11.4)
+	 */
 	if (changed)
-		ieee80211_color_change_bss_config_notify(link, 0, 0, changed);
+		ieee80211_color_change_bss_config_notify(link,
+							 link_conf->he_bss_color.color,
+							 0, changed);
 	else
 		/* if the beacon didn't change, we can finalize immediately */
 		ieee80211_color_change_finalize(link);
-- 
2.47.3


