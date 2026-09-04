Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6304E8DFB
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534080; cv=none; b=THgPxEmsaAzpMWEwMmihOo6S0m8bvpB77sER5v1AU1PMp7nVgS3DqZIy+4raSmVnoGX6lORcctW057IM0gm10Wx766ceTXT2ALdItdOtMgqlTuWXVMRY4kq9cow7h0ecR0Fon432qTKakgPyM3FkHACJqaP0wdBAI8lXmOhfoUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534080; c=relaxed/simple;
	bh=FfvU4VsN7W4zyd1YxVoDimNe94nUWikAh42RS0qe+vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddsapcmt6Op2CWxaOhM4M5ohHubO2KvQJol1Td+Z5bLixwyRCEGoFSms9l8zE+x9Ic3Aooz/ZTGgRFE2sY4gUC3cUZ5QV2b+3ATBARHpmyrANJQAYgjJ1k9FA+xT25rfieW3v2fGp0U3fA1VhGfX6b5VB69NuM1oW0aV66UYp04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bb8iGh8B; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bb8iGh8B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=3j0zDH0GhxYYkHjjYauxkvPsdrIi+n+Fuh+JNl2KUhw=;
	t=1788534078; x=1789743678; b=bb8iGh8Bqg5kVeSoA/VVtwz/d5jIU6Fuv4nWz/b6UCH6fyc
	9GXm2Qno5i+HFGrXWSHX199xpS4YVnzFXzTgz4XSTeeqvSkBzketWGR3L8HMyR190s9kzbQRhE03v
	jOxT8edT6sUIxAck8nnRgPunRo8bsyMeOnz5y3YyKkA0G6TV8Ts9dhRLUs/dENAWSw9GJhmlPPXbE
	1ah6H04NLELSmcEA2ykm7qVk5LRamM/DzXlWxQyiFiJQVPN0uJvSWVxbpLdgjQKdpyrllw1u6eJye
	fJ732+g/ZTiP41eOlXCzClHgQV/ON2Jqr6t8XaeHZspAo8f5D3mSMj3yhEgBU3PA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPm-00000001SeL-06ee;
	Fri, 04 Sep 2026 17:01:14 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com
Subject: [PATCH wireless 04/10] wifi: mac80211: don't allow link changes when iface is down
Date: Fri,  4 Sep 2026 16:58:03 +0200
Message-ID: <20260904170057.56ab694fe989.I6d85e530bc2db6e48bfd13ccee0b71155e32b85b@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150057.424369-12-johannes@sipsolutions.net>
References: <20260904150057.424369-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_set_active_links() only checks that the interface is running in
the inner __ieee80211_set_active_links(), after drv_can_activate_links()
was already called, so using active_links on an interface that's down
triggers the check-sdata-in-driver warning.

Add the missing check in the debugfs file.

Assisted-by: LLM
Fixes: 3d9011029227 ("wifi: mac80211: implement link switching")
Reported-by: syzbot+582469b3a9ef5f13606b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=582469b3a9ef5f13606b
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index f3c6a41e4911..8346d3eb1143 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -729,6 +729,9 @@ static ssize_t ieee80211_if_parse_active_links(struct ieee80211_sub_if_data *sda
 	if (kstrtou16(buf, 0, &active_links) || !active_links)
 		return -EINVAL;
 
+	if (!ieee80211_sdata_running(sdata))
+		return -ENETDOWN;
+
 	return ieee80211_set_active_links(&sdata->vif, active_links) ?: buflen;
 }
 IEEE80211_IF_FILE_RW(active_links);
-- 
2.55.0

