Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345EC538D6C
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 12:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788870527; cv=none; b=o0587NhhdYLdg1Dyq2X4mw0qZIT3Q71j2iEj6Uky3+MvH4L/iB0iyak1SdwUeisdXNW/W1Bn9wHIco42lwYiwX4O7VOvwmA0By7BYv7GASKzPTkoYIoAmeSL2bNB/lFBVcubyVE3aXrniyCVE60iPS4J8lT+b3gFTHanI9DY+FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788870527; c=relaxed/simple;
	bh=8iIkBQtLFFOBvJZOYFnw9oUKw/ulZPtOFKAF36mrMzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FE6Fa+tANgTAxWzLdTHhXJmoMKfivnIcvaTcX6qoJMAnretivUgNEQ07Kk0ydUeS+aluMTtGy46wKIDKwaQTotZ4aiOVEccXaW2B5ziSD1T7sNUxpsjB5ZjXlPe4hqz9YoZD1Nx0ppYWoG8Hxx7eLcaKgbFKg/yi02tBmAebgAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=cE7iSDYb; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="cE7iSDYb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=j4U9Fvsi4S+Z/XYKEyvTGEpC4Yg5n/wZoFGnDS27WJk=;
	t=1788870526; x=1790080126; b=cE7iSDYbsT4b03wWnaZGvo0K0ywQd7VavqeUbo+rmrDWEeg
	IYbxRVjawEQoouZhqhNoYZAZsK+XwM1IPkbI71WQDsY4vix6WofkxlTVNNVZBp7L80F33SDCZ9My/
	ztHWkzs8kkfNkF3jusTyLhceRIjjWxaJRSyuO20NrixTUJPE07+it+mt/GIc0oB7DKdA/seajeXVc
	hJ49GbpqHL+wfLV6zttUlezy8xtmMr38IausgR4zwDlLmBDD3MpC7PU+ht/uKZafSYfFsRK9hj+qb
	JUB30MhjqcxciDHi68n/hlpfokca+0iQ8GS9TGZX8yZ6ce6o7FXWVJhh7U3C1xig==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x3uwM-0000000670J-40WB;
	Tue, 08 Sep 2026 14:28:43 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com
Subject: [PATCH RESEND wireless 02/10] wifi: mac80211: reset the AP_VLAN tailroom counter on ifdown
Date: Tue,  8 Sep 2026 14:28:13 +0200
Message-ID: <20260908122838.201719-14-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908122838.201719-12-johannes@sipsolutions.net>
References: <20260908122838.201719-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

On ifup, AP_VLAN interfaces get crypto_tx_tailroom_needed_cnt from
the AP interface, but it's never decremented again unless the AP is
also brought down. Thus, bringing the same AP_VLAN up again will
increment the counter again and eventually hit the sanity check:

  WARN_ON_ONCE(sdata->crypto_tx_tailroom_needed_cnt !=
               master->crypto_tx_tailroom_needed_cnt);

Reset it on ifdown to avoid that.

Assisted-by: LLM
Fixes: f9dca80b98ca ("mac80211: fix AP_VLAN crypto tailroom calculation")
Reported-by: syzbot+de3ee5362db09487ea37@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3ee5362db09487ea37
Link: https://patch.msgid.link/20260904170057.1f4fc05e5663.Ic863c2fea0352a9282006378bc9c9dedbe27c037@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ca66eb493ac7..889c32fd8de1 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -616,6 +616,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 		RCU_INIT_POINTER(sdata->vif.bss_conf.chanctx_conf, NULL);
 		/* see comment in the default case below */
 		ieee80211_free_keys(sdata, true);
+		/* increased by AP value on ifup, so reset on ifdown */
+		sdata->crypto_tx_tailroom_needed_cnt = 0;
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
2.55.0

