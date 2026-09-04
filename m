Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0CA4D2ED6
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533859; cv=none; b=jSuafHTHF6c2pbmrpv3gegVrQ0fUv9fwn+MpuZR8zNWd4l13rcOr3LCZQicvlneXwri/oAeD4MvKCT+U2Gt84mR7qk0kxxI/DJZ6GU8vvvSMnbHpN6kNlWSe600wToWOZCRJe+qK2OrGZCcCmg06SvH7x/EuKx+YyFGKvquvNl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533859; c=relaxed/simple;
	bh=cSztQNu18ZRRSqZV5gL8HJirf3S1sIudS5uc7t+g1g4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lGml+iwZncjfA+urXJhtStOm22TzvcOI/wHtJlKD5fjN9t+ghiccwlsdad2I1ctx9Z5YvMuabEaosTz81Evc37umFsdQutotJzbS0kfF6ovp9bZV1tSFsFTuZPGGGOHFdzhnS+Z4Nb9sORejxpdPEqE9gPQr0tSmb0qlT8kla+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gUoVFhWJ; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gUoVFhWJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=93UVgh/4jBtbVYMTZqkpB0frZU1cnGk5F2gA/n7Ax5M=;
	t=1788533857; x=1789743457; b=gUoVFhWJ8n5kHx3mChGl0DmusPI6xFkD1o1XJVjFutlAhGT
	K9/6b3zcHasZl+Byzi+bNuUyhd7DRUIZ2fA59/x4ZzRALNIHvIqqEGXWmjFtO63HtmWjl0GSNlwKX
	sRL/8gHGmDKo1AImwK74MWeRQxGV23c1P/iukHhvzJgbnyVRlQeW+PnmFFsqwhkOEflMhpE4JHrfA
	QPB9gXsy8gm1KstCkSmkK8i5T9i0vJKjQ+s42QTQyqT0+AX6k3ZgTbBxvET4WJN5H3dhfmPHvoWDQ
	+9Czdc3KthFj3xoJuL7O6RqSBMVsylhzz1Y56HPmR7NGycPPISBeEjSuB/IBZU1A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VME-00000001SWk-29rD;
	Fri, 04 Sep 2026 16:57:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+ca7a2759caaa6cd4e3db@syzkaller.appspotmail.com,
	syzbot+c4686c3eb8b64032618f@syzkaller.appspotmail.com
Subject: [PATCH wireless 08/10] wifi: mac80211: reset state when starting AP fails
Date: Fri,  4 Sep 2026 16:57:12 +0200
Message-ID: <20260904165722.9629429a5221.I7f599412bfe12a09d41ea4901be9ad165d07d133@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145722.424159-12-johannes@sipsolutions.net>
References: <20260904145722.424159-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_start_ap() can set enable_beacon (and beacon_int) and fail
later, leaving it set forever. Scanning can then attempt to restore
beaconing on such an interface, leading to:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:mac80211_hwsim_link_info_changed+0xca7/0xf00
  Call Trace:
   drv_link_info_changed+0x413/0x860 net/mac80211/driver-ops.c:495
   ieee80211_link_info_change_notify+0x24b/0x3c0 net/mac80211/main.c:427
   ieee80211_offchannel_return+0x381/0x580 net/mac80211/offchannel.c:160
   __ieee80211_scan_completed+0x993/0xe30 net/mac80211/scan.c:519
   ieee80211_scan_work+0x472/0x2010 net/mac80211/scan.c:1193
   cfg80211_wiphy_work+0x2b7/0x550 net/wireless/core.c:538

in hwsim. Also, cfg80211 then allows changing the interface type,
and the off-channel path getgs confused about beaconing as well,
leading to another warning:

  WARNING: net/mac80211/driver-ops.c:468 at drv_link_info_changed+0x583/0x880
   ieee80211_link_info_change_notify+0x24b/0x3c0 net/mac80211/main.c:427
   ieee80211_offchannel_stop_vifs+0x328/0x5c0 net/mac80211/offchannel.c:122
   ieee80211_start_sw_scan net/mac80211/scan.c:583 [inline]
   __ieee80211_start_scan+0xfb6/0x1af0 net/mac80211/scan.c:882

Reset the state on failures to always have it correct.

Assisted-by: LLM
Fixes: d6a83228823f ("mac80211: track enable_beacon explicitly")
Reported-by: syzbot+ca7a2759caaa6cd4e3db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ca7a2759caaa6cd4e3db
Reported-by: syzbot+c4686c3eb8b64032618f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c4686c3eb8b64032618f
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2b13c057312e..2d5a0abe35db 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1929,6 +1929,9 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 
 error:
+	link_conf->enable_beacon = false;
+	link_conf->beacon_int = prev_beacon_int;
+	sdata->vif.cfg.ssid_len = 0;
 	ieee80211_link_release_channel(link);
 
 	return err;
-- 
2.55.0

