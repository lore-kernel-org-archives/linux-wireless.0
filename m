Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB6D4301D4
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548484; cv=none; b=Zh1k8Nie/dlZ0gPLlE9a7NIPfARV8B6olSiCsJ0sKnclUseaLcD3OsA88VXyKkkTOg85kEpu7lbV56bGpkkZaN1t1t7XaQogtiARisFATRcZIFxgHM2569jE4vYyLHuJOyPnycM53kl/eK3KTahFavAM84pwi+rDUpj3SlXAFwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548484; c=relaxed/simple;
	bh=DJ5f2erKiOxy/li/GYuvI3WaFcPwbPU61zJNk1ONVlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TF2E7I5juQtyImPJIHs2mBKwodgRv0aYyhKJtqlQ8QcwRHj4ckT32FT4T6ZGaCHGkVzkHi+FfCsioRQfhxHacuiBlNihLzAjk6b7CGgDPdfGNy6LqXVCfY1LjhVffF03zzBRsUvuS9LPukOeYCUmgfVLKRqquV3wQfLJfoLDNew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=dAIDusg0; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="dAIDusg0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=T82aOlXVkHUhWyrvNADuxMa1eI1vdwjZkbI+/j/hW24=;
	t=1772548483; x=1773758083; b=dAIDusg0qgpes8F+NA2pJt7RnaRWpsbCpb7wfF1goe5zDPu
	VDgpbDsTUCdoABC3gbSx/Lbd8uIHk6YJ0s218Q6hFN8K4mljoo0npjWOutgDu3+Tn+0q2J92bB08j
	jCHGsMVgr5Uv4JUbAMLmeNVZ90Jj6W+6E6W9TwsyFLAjB8ynQVTmAni7Kw3NF89Z7/LXu5PygNTzZ
	XfjlRzO4MQVQ/Wr1v0dQVlXfV+9bD5uoPsE9CljSPyEWyVOA4tYq5fIlXsLNxaV27L7+J+MWKKOnK
	uN0CuLiq8DuvIJ0lfK9mVTizrMVTHS5oZCvSeqNWEqGh8Ebh1M7ELHFWfzfZgWuA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxQpc-00000007A1T-2FYw;
	Tue, 03 Mar 2026 15:34:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC wireless-next 4/8] wifi: mac80211: remove NPCA during chandef downgrade
Date: Tue,  3 Mar 2026 15:26:59 +0100
Message-ID: <20260303153435.1a9133d41872.Ic39badb6782ef2242942424538f57e4a83391a06@changeid>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303143434.273141-10-johannes@sipsolutions.net>
References: <20260303143434.273141-10-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

We can't use NPCA any more if the chandef was downgraded,
for obvious reasons. Clear NPCA during any downgrade.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b2e6c8b98381..373d0f853dbc 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3752,6 +3752,10 @@ void ieee80211_chandef_downgrade(struct cfg80211_chan_def *c,
 		c->width = new_primary_width;
 	}
 
+	/* whatever we do, downgrading removes NPCA */
+	c->npca_chan = NULL;
+	c->npca_punctured = 0;
+
 	/*
 	 * With an 80 MHz channel, we might have the puncturing in the primary
 	 * 40 Mhz channel, but that's not valid when downgraded to 40 MHz width.
-- 
2.53.0

