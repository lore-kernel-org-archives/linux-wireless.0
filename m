Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174E94D2ED0
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533860; cv=none; b=eC6Sj7WKnQAGrVC2VeBircMROmp6g23BAuWGtbNdmEfgAm1vxhEiTbYTZVNqcKt13HPEQ/vdmRijF0k5sbS6vh/8R328Y6mvVNIyXkdisbqRTljJ5/7kVdzIoBmIti3dgPX4oF7bbxSwO53YIZ6sJMWsaPegLugZNsuONwT2bdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533860; c=relaxed/simple;
	bh=+qgRHIvUNUwbUCTKhQMjD7pYpQCdA80WzFN2/TeuzQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCOrjmJArHgdBx5Cq5XeJVjbCfg6bzzzKVWmkKyPuxGJyQSs4lHS5dRqbPuTon2yOdHLxA4yif9kI2p7Qc8vkjytBB3b8q72DeWLfSVbKolKEqkJ8Xl93ad1CBnaDr4tIKH+0AIDNmhhaETpJpHopiuJq6RprDwEDRBatalEZGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=b36Yk93A; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="b36Yk93A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=z9WuVS3Cu5NU00zuNL9WRhVlFtOBivAOrjZCqek3srk=;
	t=1788533858; x=1789743458; b=b36Yk93A5geuxeS7aVexzIMY9yiQhGBpTY5alHTrvo7kX40
	1akQemInCf9EzAMVNT+agqZKQYh7T+GFW0NwE9+IbXh18PYSBFnAP3kg5Iutj+kRO8X7Hf1QK5ZGz
	dSlVafuwIbRP/C2tPa6kRVQlSB815x60zptHL78uHSURQQ2sBikOkKAbud0VOk4O37tRbIr/q7d5A
	seRfjc2MXSX9vXvB+fu/wazUWo6g/lG4TK9On+CIYPxnchbADMauMbQclPtU/OZNIWiVR3vVAtE8s
	tKCqhi/jJ7LWOa3nVTVCMFUIiIvES7DdginS/kpNBzN3QSC4Zr5c7vu6BJOGGA6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VMD-00000001SWk-0s3m;
	Fri, 04 Sep 2026 16:57:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+81cd9dc1596563141d19@syzkaller.appspotmail.com
Subject: [PATCH wireless 07/10] wifi: mac80211: abort chanswitch when leaving a mesh
Date: Fri,  4 Sep 2026 16:57:11 +0200
Message-ID: <20260904165722.d0b87eee08aa.I80550d6127e0bb26efb49a5fbe95be1aef1cd0cb@changeid>
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

The code in ieee80211_stop_mesh() leaves CSA active, but leaving
the mesh released the channel context, so the CSA finalize work
crashes:

  Oops: general protection fault, probably for non-canonical address
        0xdffffc0000000003
  KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
  RIP: 0010:ieee80211_put_srates_elem+0x42/0x640 net/mac80211/util.c:3272
  Call Trace:
   ieee80211_mesh_build_beacon+0xa83/0x1b50 net/mac80211/mesh.c:1093
   ieee80211_mesh_rebuild_beacon+0xc7/0x170 net/mac80211/mesh.c:1147
   ieee80211_mesh_finish_csa+0x131/0x210 net/mac80211/mesh.c:1542
   ieee80211_set_after_csa_beacon net/mac80211/cfg.c:4085 [inline]
   __ieee80211_csa_finalize net/mac80211/cfg.c:4133 [inline]
   ieee80211_csa_finalize+0x633/0x1150 net/mac80211/cfg.c:4155
   cfg80211_wiphy_work+0x2ab/0x450 net/wireless/core.c:438

Abort the channel switch properly.

Assisted-by: LLM
Fixes: b8456a14e9d2 ("{nl,cfg,mac}80211: implement mesh channel switch userspace API")
Reported-by: syzbot+81cd9dc1596563141d19@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=81cd9dc1596563141d19
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d4507e4e6ec1..bed7ac838250 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1204,6 +1204,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 
 	netif_carrier_off(sdata->dev);
 
+	/* abort any running channel switch */
+	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_vif_unblock_queues_csa(sdata);
+
 	/* flush STAs and mpaths on this iface */
 	sta_info_flush(sdata, -1);
 	ieee80211_free_keys(sdata, true);
-- 
2.55.0

