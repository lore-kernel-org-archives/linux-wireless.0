Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BAD357D07
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 03:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785727720; cv=none; b=ebAQcw/1Y89bgUwfbmHv6Mup70Fx1Hq+zZnXx4yEuDl8FMfy2C+btXFZOEtLCWvVZbmdbWadHlDhjk/d8nGJ2L83ujgRukbCDUXLyCGz+YzQAQE7aQNtqNWtmUTXeTIQU6LfQoFcxrMcBqjThOVqnq7G6mT0kzCsAGnJtmiS1XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785727720; c=relaxed/simple;
	bh=eygo4DwzJUOOLJpviBnIAfWGE86Gwqn/3gxmyv4j/ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ciBkxElEnBWkbBpIuDgJVDO6xqaH0gC0GX3JVSJ43T68qTclLD6gRdnXPm9DQeHgTOdrJ3prGVVCjxMJzAagqtFC26KaMHi2daGHwAkdwsyCO+DbR3r5FCAy6tFe6kaMBkcuMX/mR4VGA0CvQLdxMd04F3ik/KsECnTRGQvbWV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=M1KIqMD5; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="M1KIqMD5"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e3617ba36so2911755a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 20:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785727718; x=1786332518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gVW0UFRMezJS/UNCtoa3QulCvsdWoJcSJLcRPrBe8Mo=;
        b=M1KIqMD5S8TWypEz1QjKfW3dSUfW9EUa5gF+IBvuvTJQVrtzjDcL982D6/N2/Uruao
         muno2PaVOKQaq5Yj1lqloQquR8/axuAMifzyCWlE56HPnWyaaHd1hJReHjkgCqDKMCfh
         NoNx5Wxjj+8kLTEIRVATyY6MpoihSh5kbUtKqXs1Pf0AxE/4E92SVDJsxngSynqK85MF
         OFuxR2PVBrB7W/oiUJFqLTJoeCTe3sZrL3cRTFuvxNMXR2/CmgqM3mMuaHuZrFxxjlw7
         KC7V8NXYfiMLO9Rd0+51UKVLc2UmonnkJ+r85LMJG+CZEwbnMWR4HRmLvRr3fShs405K
         DH/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785727718; x=1786332518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gVW0UFRMezJS/UNCtoa3QulCvsdWoJcSJLcRPrBe8Mo=;
        b=LvecMCPnc+TF+ZVc3kMg320VO3a6EPpwCkTdwNm2FXkpTILwXTmVQr64MxeSVAvPBv
         ODaNCOir2RMPRyYiAZriGBP1mNiJBo4SNwqFiZjnkrXirCZ/jXyNXyXe1dMJRKrBnTZD
         0w8cOrGGC0SGH18eZ9xF/I+AndYOo/kgdpTYC3kUAFU7MWkoKLj1ut5bNo4Ct0uv2NVA
         Xh5YXIGGz9Npn0Jj0xp9AJ7DY5ttS+nKKoIKnyf7jJe289mAeH0lzLFI03KGLPdG4yZD
         YVRyi4ZjdpobXR619VjBCk66YWzCtSZ82AE8D8xNXfqXuIg7+cNcZL5f8OopNf05H0cH
         InBw==
X-Gm-Message-State: AOJu0Ywv6paeZ/zn27noxedOED1Bq1Jyr+4byKPrBgEv3xUxtdfPiMtY
	NFnatL3Rmm6ETe1tzWbYO8mh8D6K5tvHioQS7lhNjxVXVfWSrCPZ5wTTQDwhVBZMhnRqhcbBpqR
	ILkXysdJpq2exVA==
X-Gm-Gg: AR+sD107bYC1x1NgE12oHnBt0E01vUnjuQQeYJtUX2CqHG/2ulaJMeP5lRv8oSPaLeB
	mchF8J01vKcQWijUCwsjqrwIdXIcgLujwlhWUkg9pd7xE8nephKfdZ99SaWyN2wj3nVRlIEYzyP
	Vh3XWO7eD/mrFbSCabqtU5lTlsOywdyQMZqFUPg/cwUY/X9b4uZ4hWkeq8vtuteJ2OvmDMEqe32
	1FtMdTVcXacVdeniV80rcCNDwe/tf3Abdxh+vYEGgLPVVjsIgqqA3fJOK7lOB6j+rR2Oe0+ysz9
	qDVb6+0KvVhfAUwG+T7y4RtAqJ5t/ldJnFjdQEVFJespBpb5iM6vfxFi4mTvJt7TASV+Y9F2mWs
	qPGq3SNlVLN37vjUeIu43f9XjKHvdlR+hVBWStmHYUYHZXP0zSgVQlbHnQD5v/Gt9m8mk3atPQy
	cPdrAMeL4IbnY10Zi+uajpgqT+/kk9tMbAk/GvazCwy+qr6d5SbJyntu8z54YdxmlXKMBTFipim
	w==
X-Received: by 2002:a17:90b:4b8f:b0:38e:2524:7272 with SMTP id 98e67ed59e1d1-38fbc56c8d6mr7358369a91.39.1785727718525;
        Sun, 02 Aug 2026 20:28:38 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb2d19f7fsm3280982a91.17.2026.08.02.20.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 20:28:37 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	michal.kazior@tieto.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 1/1] wifi: mac80211: count only matching reservations in reserved switch
Date: Mon,  3 Aug 2026 11:28:22 +0800
Message-ID: <4b6c4b8648ab1920c38a40be32c0b1a2797b4ac6.1785726007.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785726007.git.zhilinz@nebusec.ai>
References: <cover.1785726007.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ieee80211_vif_use_reserved_switch() validates a replacement by counting
assigned links on ctx->replace_ctx and treating reservations too
broadly. A link can still be assigned to the old channel context while
holding a reservation that belongs to a different replacement
operation.

That can make the current replacement appear complete too early. If
another link finalizes first, the function can free the
WILL_BE_REPLACED chanctx while the unmatched link and driver still use
it, leading to a use-after-free in later beacon generation.

Require an in-place reservation to point at the current replacement
context, and require the reserved and assigned contexts to be the
matching replacement pair, before counting or moving the link.

Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/mac80211/chan.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5152b84a33577..79057e1ad105c 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1770,7 +1770,8 @@ ieee80211_link_use_reserved_assign(struct ieee80211_link_data *link)
 }
 
 static bool
-ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
+ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link,
+					struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *old_ctx, *new_ctx;
@@ -1780,6 +1781,9 @@ ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
 	new_ctx = link->reserved_chanctx;
 	old_ctx = ieee80211_link_get_chanctx(link);
 
+	if (new_ctx != ctx)
+		return false;
+
 	if (!old_ctx)
 		return false;
 
@@ -1792,6 +1796,12 @@ ieee80211_link_has_in_place_reservation(struct ieee80211_link_data *link)
 	if (new_ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
 		return false;
 
+	if (new_ctx->replace_ctx != old_ctx)
+		return false;
+
+	if (old_ctx->replace_ctx != new_ctx)
+		return false;
+
 	return true;
 }
 
@@ -1821,7 +1831,8 @@ static int ieee80211_chsw_switch_vifs(struct ieee80211_local *local,
 		}
 
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
-			if (!ieee80211_link_has_in_place_reservation(iter.link))
+			if (!ieee80211_link_has_in_place_reservation(iter.link,
+								     ctx))
 				continue;
 
 			old_ctx = ieee80211_link_get_chanctx(iter.link);
@@ -1923,7 +1934,9 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 
 		for_each_chanctx_user_assigned(local, ctx->replace_ctx, &iter) {
 			n_assigned++;
-			if (iter.link && iter.link->reserved_chanctx) {
+			if (iter.link &&
+			    ieee80211_link_has_in_place_reservation(iter.link,
+								    ctx)) {
 				n_reserved++;
 				if (iter.link->reserved_ready)
 					n_ready++;
@@ -1948,7 +1961,8 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 use_reserved:
 		ctx->conf.radar_enabled = false;
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
-			if (ieee80211_link_has_in_place_reservation(iter.link) &&
+			if (ieee80211_link_has_in_place_reservation(iter.link,
+								    ctx) &&
 			    !iter.link->reserved_ready)
 				return -EAGAIN;
 
@@ -1989,7 +2003,8 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		}
 
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
-			if (!ieee80211_link_has_in_place_reservation(iter.link))
+			if (!ieee80211_link_has_in_place_reservation(iter.link,
+								     ctx))
 				continue;
 
 			ieee80211_chan_bw_change(local,
@@ -2038,7 +2053,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 			struct ieee80211_bss_conf *link_conf = link->conf;
 			u64 changed = 0;
 
-			if (!ieee80211_link_has_in_place_reservation(link))
+			if (!ieee80211_link_has_in_place_reservation(link, ctx))
 				continue;
 
 			rcu_assign_pointer(link_conf->chanctx_conf,
@@ -2089,7 +2104,8 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		for_each_chanctx_user_reserved(local, ctx, &iter) {
 			struct ieee80211_link_data *link = iter.link;
 
-			if (WARN_ON(ieee80211_link_has_in_place_reservation(link)))
+			if (WARN_ON(ieee80211_link_has_in_place_reservation(link,
+									    ctx)))
 				continue;
 
 			if (!link->reserved_ready)
-- 
2.43.0

