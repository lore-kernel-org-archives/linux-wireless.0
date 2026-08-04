Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB3B3E835E
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831984; cv=none; b=YIND3X0/6yOWeTDOHXP4LKRpwmJf8WnbX7+rKwYNTZfIN2ttTZsuZtsjy4Rm/E7vKSOZbq9fwiPUaWdw83RVvLIaM8KwrNX/v0Jq4psNdjHSxb8EDzNwFKMM9ITNLJpyU7mnMcpNtALz1ymnA1m5TyVrs4gNCZFJrgodKSOrXnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831984; c=relaxed/simple;
	bh=fOeSr+kmu9MCOQh1UzXLy3x77o7c5722eWAAn/KXuZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n94uH/xBLiLB8ipJ4H0QsW994u/ID0nYkOMKQkXwwrSGOoWcPNgwiqBQ9nuCmdhwscUMh6R3NR9t3RaWlKWbXQKtQZkJb6nbAhH3ruRPabv+2VRjPGK+QVGMSMjWp1UnHLZ5xw1tmsv+ZC/bmmncwiEo4OHk9iNb5u+hAZ59bEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=oLAMeUnD; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="oLAMeUnD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fxmp46FK42kCNpguexDckTrchDrVmQOV5upAxM+OKH8=; b=oLAMeUnDqJ8ytOmEh0zu5uvdwc
	cRIGIC1DWg5xDU7MOWWGuSE5x/f1iqjZ/gCXE3YbVs2Zze32RyF9stUrRQNA+t2ai3RxVndhhgYYs
	JddlGgU7Xxld+JqSs2PMcweRMVCVtXX7vyNVzGiVuxLO57EQ59X5qyg8h10g8LL3soX8=;
Received: from p200300cadf14d100000000000000085c.dip0.t-ipconnect.de ([2003:ca:df14:d100::85c] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wrATT-00AxSO-0C;
	Tue, 04 Aug 2026 10:26:11 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next] wifi: mac80211: skip default WMM setup for AP_VLAN links
Date: Tue,  4 Aug 2026 08:26:08 +0000
Message-ID: <20260804082608.2011433-1-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

AP_VLAN interfaces are never passed to the driver, so setting default WMM
parameters on their links trips the check-sdata-in-driver warning in
drv_conf_tx(), as well as in the BSS_CHANGED_QOS link info notification.
Skip it, matching the existing AP_VLAN handling in this function.

Fixes: 2259d14499d1 ("wifi: mac80211: set default WMM parameters on all links")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/link.c b/net/mac80211/link.c
index dc68144dc363..931950a10508 100644
--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -360,7 +360,8 @@ static int ieee80211_vif_update_links(struct ieee80211_sub_if_data *sdata,
 		link = links[link_id];
 		ieee80211_link_init(sdata, link_id, &link->data, &link->conf);
 		ieee80211_link_setup(&link->data);
-		ieee80211_set_wmm_default(&link->data, true, non_sta);
+		if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+			ieee80211_set_wmm_default(&link->data, true, non_sta);
 	}
 
 	if (new_links == 0)
-- 
2.53.0

