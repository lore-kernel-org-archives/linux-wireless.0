Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D074CC29B
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 14:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788533860; cv=none; b=DyyQveEizmg+JCOrBJNnfhtLIK1IYVuL4a71vyaf8tT+k2JESAV67ikqgSNLM9FH4NxW9DKNfP0AZ7Lh6zWy8bmNqCCFkAn2oH//52fp6OJ4Rvu9WW2bI86zKeEvkMKaHoTi3FGLGL1f6233AxCEz/RUJI6GbbsxtRLt+1ktMgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788533860; c=relaxed/simple;
	bh=Pw8XESA+wi6bk9pHmBWuUIKfACmZCIJI89bvdyK2Z7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjCihwV5BCB5XPO1ajMP/kTPCCb5AN7F91cw3NrPug8Tg8G1aqxwW/TQg+CTzOBl3Txdy3ht5QqHbLsJ58+A8amBOxR3PDKy4BYxZFrHVp16jV+8DfsRSBwE1ROjGVkOORSoxYnNDyQpL5c6f4rIyDeyluja7Qh2FTpaUJFT4NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ElFrBr8e; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ElFrBr8e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=E1xZSqTYN/5UliJ6QOx2lbxzvcBuket1IdQwwF6btUQ=;
	t=1788533858; x=1789743458; b=ElFrBr8eokNCfJ97IQEdB0lLznirmVSaB4SsiMkv/rWZJ6W
	O4OTmEqOF2NjxecRAVKv9efo9ZP58ZUSKYlkk488/UhcSWhAFlou0K0xKzOC5KWZsx148cZNPYxTx
	qOWjV6A841gUrCkhzHO96AuWE8zVcX5jiMjyuUbYVHYCKQXBc8gaUlY4rmlJKKLhNFF/3CfGLjXfq
	Brqjzukl9ClCYmwMKZyuzbGmRIAFZl7f6YutYvDF7bP/V/ZPo8A0PpBuleuQd8D6a/p1EK2d8kArE
	hVKPm2CiCK0qAVptREcViBtLf7+4xwtYPqY5Xp2bCcJqPAlTbCzGTidwv077vrlQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VMF-00000001SWk-3Wgp;
	Fri, 04 Sep 2026 16:57:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+e84ecca6d1fa09a9b3d9@syzkaller.appspotmail.com
Subject: [PATCH wireless 09/10] wifi: mac80211: reset the LED state when ifup fails
Date: Fri,  4 Sep 2026 16:57:13 +0200
Message-ID: <20260904165722.044aa432f873.I601a67a2cd558b8ef8416a07554ae7efe896e9d8@changeid>
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

When the first interface comes up, the radio LED is turned on. This can
start the TPT trigger timer, which continues running.

But if bringing up the interface fails then the timer keeps running and
won't be stopped by anything, eventually it can be freed:

  ODEBUG: free active (active state 0) object: ffff888127e12130 object type: timer_list hint: tpt_trig_timer+0x0/0x300 net/mac80211/led.c:145
  WARNING: CPU: 0 PID: 5923 at lib/debugobjects.c:612 debug_print_object+0x1a2/0x2b0
   debug_check_no_obj_freed+0x4b7/0x600 lib/debugobjects.c:1129
   kfree+0x436/0x670 mm/slub.c:6818
   ieee80211_led_exit+0x162/0x1c0 net/mac80211/led.c:210
   ieee80211_unregister_hw+0x27e/0x3a0 net/mac80211/main.c:1706
   rt2x00lib_remove_dev+0x55b/0x670

Undo the LED state in the error path.

Assisted-by: LLM
Fixes: 67408c8c7b9d ("mac80211: selective throughput LED trigger active")
Reported-by: syzbot+e84ecca6d1fa09a9b3d9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e84ecca6d1fa09a9b3d9
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 8c300e045fdf..4c34c3287eb4 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1606,8 +1606,12 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
  err_del_interface:
 	drv_remove_interface(local, sdata);
  err_stop:
-	if (!local->open_count)
+	if (!local->open_count) {
+		ieee80211_led_radio(local, false);
+		ieee80211_mod_tpt_led_trig(local, 0,
+					   IEEE80211_TPT_LEDTRIG_FL_RADIO);
 		drv_stop(local, false);
+	}
 	if (sdata->vif.type == NL80211_IFTYPE_NAN_DATA)
 		RCU_INIT_POINTER(sdata->u.nan_data.nmi, NULL);
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
-- 
2.55.0

