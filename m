Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793651920;
	b=pBlte2e6vJVdSpR9tWmLbnKJhL3Bc+hE1AQ5sjT1ZYD2V2Z4k9nYgn17GlzWrDvSrjIP
	 kWWPCSmy0wRbk70AfE83+AVaWMJ2NR18vrElpJCvYprYzkMT0SHooJtAu2HmOJrfc+1/6
	 S0RWaw+1Z+rxqPDQJugfn14cq6mVsbwjlHJelygqESnlzYksAQhS2syiD9dz7apqaD/lM
	 XKM4Z67MdxrNr/ZHVRgOdlUBLTCqGUFmkSeW3/12GnPBlCKHwyCpJ2TA/4z0LLHhhR6Aq
	 ujMW33OA5W3Y+uj3ws0iioAxYbEoduDtx+3AxVneNnHoBD2c/klAzpfQK2NoxZ+DOuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793651920;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Gt1/vdnR3EkHfEBcZLTqy9ywXqmbtJE/UO6eEWER7nE=;
	b=WdR4EE5ZLjq71sNcN4PXaCnT6Q6fY8CwQGio2Fx3ftHqJYnCnCr+LMd00ZGubkI59P+s
	 5G4ZtAX+kEi1xFuAsfDhAIHsZcgnBK3rF5OzvXWMdJZWA6cv6yU7opiTBPL7hWJivgTWx
	 QiiO4GDjAN03VbU4Gx/rbOQTuJ24a6/VJFBNyJp2y3ULo4vDrzYi1FRuwfx3BiWMhYE6r
	 JExnYn4UcFmhaD0oxwdXTbxWNc7TBpNWfnxRbGQh4XKAamjKYBcRDlBVH/mzhRV0+i5Lh
	 y9azxnA1gfvRSit9kzYDhA7TxSSHgCuS7fy95Bpjx/gg2U0vQW43WHjwFyTsIKLi9TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=nwWwSCNm;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD77606A334
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=nwWwSCNm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Gt1/vdnR3EkHfEBcZLTqy9ywXqmbtJE/UO6eEWER7nE=;
	t=1793651919; x=1794861519; b=nwWwSCNmhbNnl11TXsA++JVdyi3gjzpHV7zdQvR9YV+WYqK
	eIpfMYr5fSMJVrCQM8XFuc1cVUNvikGc2KH3SvCvzmwW+HglmTw0TcZhFMBZV7hHK8oS3SllabZeq
	xdHjzk3Wh8p28fIjFD6j2pZGgyP3KaFcfF1f5+foPt7TtlWsUxjafjKkCFi7ujE5rgPZAEwoTKGid
	BO/zcOfxeGn6pIr7OzFIT8fWGkDYpbLGAtZ3PS+GEsXYGimi2S6VFUh2n+o6mQTc9bABNN4dzWe26
	DxzGaa2hGd2d5ewaLU6i7ye/CThbR1MwtgKlrPngC3c1b4OxJSijA+qSPYCayG1A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xNync-00000001vzr-3SKg;
	Mon, 02 Nov 2026 21:38:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/30] wifi: mac80211: disable BHs when waking TXQs on PS wakeup
Date: Mon,  2 Nov 2026 21:22:52 +0100
Message-ID: <20261102203831.1058362-34-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102203831.1058362-32-johannes@sipsolutions.net>
References: <20261102203831.1058362-32-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_sta_ps_deliver_wakeup() can be called in process
context, e.g. for mesh when the peer link is changed via
nl80211, but drivers can dequeue frames from TXQs when
wake_tx_queue() is called, requiring soft IRQs disabled.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 23166fc39729..80341173ae45 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1865,12 +1865,15 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
+	/* this can be called in process context, e.g. for mesh */
+	local_bh_disable();
 	for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
 		if (!sta->sta.txq[i] || !txq_has_queue(sta->sta.txq[i]))
 			continue;
 
 		schedule_and_wake_txq(local, to_txq_info(sta->sta.txq[i]));
 	}
+	local_bh_enable();
 
 	skb_queue_head_init(&pending);
 
-- 
2.56.0

