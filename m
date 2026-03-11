Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F64B3A3830
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270471; cv=none; b=VcaLieh76yLgm3yHecsCTiCmNb1Ad2mdmR/GdD4TIA4p9aWhkQUhDUuI4PdzipJ0syO3ZHKLezy6haDzHDaXf8xKBMviUxBKhtHhP5wcknIFDlNA+q3GO3hVI/WF6qdZdQqMpY3mJejtvt3/Mv0FZVqGDSrHPJuiFw/9LtXcBbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270471; c=relaxed/simple;
	bh=+wrEprzSFJFqEQjhkx3IQoVj0ZQZ8PRhZRy8yzxbsJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoCVT8UqUpJsfqW+FfbSa/bc2kJX6if6Miim6sIHKu2EEzDTDsEY0hmBAbFAJvqyd4NfnYmwPliv+ZKoO5R1gBv2nwfYPL8VTHcp+Fgb5pfCcu+S1clZiwo4kbEFf2QqdswLU525GDRU02wKlT2QlbnP5D0DJDAaAVUfZ4dhpxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=iPDMBiUr; arc=none smtp.client-ip=67.231.154.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="iPDMBiUr"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6193B440067
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2026 23:07:45 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 0224E13C2B4;
	Wed, 11 Mar 2026 16:07:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0224E13C2B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1773270463;
	bh=+wrEprzSFJFqEQjhkx3IQoVj0ZQZ8PRhZRy8yzxbsJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPDMBiUrwoRuG/+AsXjxuWeOHl+5MoKpa7yjCYa1SuR3pSbJSnflQSR5bVBHvohkv
	 j+RUb0uCFSSxEIIeayJW/nqxr7fWvJqhPHL8X4h+8vsZhwRndk3agd2SuROdQr9/Wa
	 SKY0UPzRe0aNkDp/Fgny9Ep+OIG7AecF1O3X3oN4=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH wireless-next 28/28] wifi: mac80211: Decrease WARN spam.
Date: Wed, 11 Mar 2026 16:07:30 -0700
Message-ID: <20260311230730.163348-29-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260311230730.163348-1-greearb@candelatech.com>
References: <20260311230730.163348-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1773270466-B_Ap7pw3-j2W
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1773270466;B_Ap7pw3-j2W;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

Comment one of them out, and make another WARN_ONCE.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 net/mac80211/link.c | 1 -
 net/mac80211/util.c | 3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index 6125e79f67c9..e3a825ea3a04 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -544,7 +544,6 @@ static int _ieee80211_set_active_links(struct ieee80211_sub_if_data *sdata,
 		ret = drv_change_sta_links(local, sdata, &sta->sta,
 					   old_active | active_links,
 					   active_links);
-		WARN_ON_ONCE(ret);
 
 		/*
 		 * Do it again, just in case - the driver might very
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ec11ee6b8752..df156f8b5211 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1879,7 +1879,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		if (suspended)
 			WARN(1, "Hardware became unavailable upon resume. This could be a software issue prior to suspend or a hardware issue.\n");
 		else
-			WARN(1, "Hardware became unavailable during restart.\n");
+			WARN_ONCE(1, "Hardware became unavailable during restart: %d\n", res);
+
 		ieee80211_wake_queues_by_reason(hw, IEEE80211_MAX_QUEUE_MAP,
 						IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 						false);
-- 
2.42.0

