Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF7329992A
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 04:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785731727; cv=none; b=P97l1egv7yTGBzY1ZblYwho7Y7BzfjGehLXAHW19dqrXyBBxVNVpKbpA+/FoLk91CrnbYRbjfNAgy+X1frmgvAI3mfbccQjhiDcsPWVbKkbiGENUnh3szt3bNBEFDCTd+jgB7m6g5qdjfZUG4F8nO2BhVCXPE8wKzovCbOzXoGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785731727; c=relaxed/simple;
	bh=HFNnyf3hOA1G/TRRfOJHyvEFk0S0OkvWbInQ+oSmMgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hN1cMJbiwf7XOZtkFdyZtUtvtOygblqprj5IaMb54eKV1JdfZYnpxIhhcRvvYOLrX7Rc7MizFmAFBKV85wFS3qjFC6ScyHZcsC46JkJ2HJhIHdshRw87tEjn8xvyYFig19LDgQQhhcY5NncYKV3p9HynUb//pkBslvXjouz12/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=EoSRsiCR; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="EoSRsiCR"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8486ac3f347so3702123b3a.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 21:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785731725; x=1786336525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FlMawpKdCrPEbx9UBuD7FOWeld0YoyXHPw6amxfGzXg=;
        b=EoSRsiCR+Uk89DriCASU4dpRFpF3hS7oUO0nh9qKGAZIIM7YeUyaHwq/MY+myCnTaV
         ZximG8QoBT+BtqjldVevSQqxM0vMsb/CRzk8HtGNICjVlY7psUTmBhA58XqvGcrX/9uU
         14agS4Paztvy3F7JGR7Ve/uL3LCbsJBj+d5c21ag8NOPss7tHUbC0V9cY1hBUUc3a/tB
         qnIX97b2l5M1BbmcLvneUtj6nmfATUraYWwQHgHuJhhsO+N3W1OfXxs3jvRYcrVhTpyq
         D6zmbpn54wHfCwDx8tCWD5jB5Et71mk9uONaWgGkiN5Km5IRifY7JoymplJnkULIGsam
         ueug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785731725; x=1786336525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FlMawpKdCrPEbx9UBuD7FOWeld0YoyXHPw6amxfGzXg=;
        b=byILFerBIJhK+CqJ+OIQurgVlRP9lTeYTJjmh4TJuxj3/PSwy/bHGg03O59zYb71to
         CeNt0gRyBXBO9q07Omy/0TZNXDBSbQ10KNG8UCC2iAei3p+Zs6RDtM8Ojo4a7BgF1R+S
         ivGvkQ4GfLbF3OBAAaQ1XIsKyjbaXMBLZyhGtovGZhO+zO5IfZNGWekve8FuhwraQFGM
         FDKvj/ZcRtjuxVGOmTgHniY/s631FI/LoIAAD6D8HxXKnOqXKtof7/QIKVkdExLmO/4P
         vb+siMGDiKvjC12qhONNyC6jYpafRy0Bm2UD7l+EgRX4gImbks7IWceo5q/DAbbmAY90
         F1aQ==
X-Gm-Message-State: AOJu0Yz+Qg30aqmJ/gawN3darfI1487DBqKA4yvr6pc2G3pCwGnBZqKy
	qQrCxUNI1RHvlnYuQKGNChEv9iwbOf3vKwVKl698ro2dYIr+VOzOIG0NuaFU9i9b88yVnc4yf/+
	hZmk5C92desRZtA==
X-Gm-Gg: AR+sD13+6UXHrBJxKPRuVhGy6xTGJ7AiqKR7EAvM10zG7w6qeKLGfIYrlq0DaQILUGN
	5SHGikqhGq1x7PcLfQQY4x1TUv63m/OqVIaV9Che4TFdDidx34sR5z4TpG54IOP4oQsEmY3MXSt
	qmDIDm+qPx9CpVXI/ibSyOPslGZXgEYnqQFRZnj23GIdXP3ETAN2j3UbRMqf7xz68b+jqfUeN0l
	DpT2EmgsSi5gzxbM/AvgXgmY0+za6r8F6hVcne2ZD9MjwkOFpGqiC9lQSKrc5c8oNs3sJxh2weT
	j6KuoRqBkMbKciG0KcDqiTUrhdZxQHmr7ACLJdtMNO/tcg1clZRfNg/btXh+WXubDo7BnLCIeJS
	c+ahvqgfIlZqfAI0E8ZBomIQfMtO5mZsB2WgoiaIeAAfpQ9hZ1z5161yLq2HrL8KA3JCikUL84q
	3leE46d+hhYCQgyek6o9JqjCAzxPXW+GMbJKKQIkHeZmPOUQ3CMYda4E1+6DJc+7GsS1xqpL9Ow
	rDvkvVNZhk+
X-Received: by 2002:a05:6a00:428d:b0:846:5d1f:56d4 with SMTP id d2e1a72fcca58-84ee4862564mr7229581b3a.14.1785731725443;
        Sun, 02 Aug 2026 21:35:25 -0700 (PDT)
Received: from Roxy.localdomain ([202.8.9.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc41ca4dsm3075215b3a.52.2026.08.02.21.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 21:35:24 -0700 (PDT)
From: Zhiling Zou <zhilinz@nebusec.ai>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	michal.kazior@tieto.com,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH wireless 1/1] wifi: mac80211: keep paired old chanctx alive
Date: Mon,  3 Aug 2026 12:35:10 +0800
Message-ID: <b9b582b0db3814f641648b8886bb50f9d68f93ac.1785730815.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1785730815.git.zhilinz@nebusec.ai>
References: <cover.1785730815.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An in-place replacement keeps reciprocal replace_ctx pointers between
the old WILL_BE_REPLACED chanctx and the new REPLACES_OTHER chanctx.
However, the early free paths only consider assigned and reserved link
users when deciding whether to free the old chanctx.

That lets the old chanctx be freed too early while the replacement
partner still points back to it, either when the last assigned link is
released or when that link successfully reassigns to another existing
context. Later unreserve and switch-finalization paths can then follow a
stale replace_ctx pointer.

Keep a paired old chanctx alive until the replacement pair has been torn
down. Apply the same check to both __ieee80211_link_release_channel()
and ieee80211_link_use_reserved_reassign(). If the replacement is later
abandoned, ieee80211_link_unreserve_chanctx() already tears down the
pairing before freeing the old chanctx once no users remain.

Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/mac80211/chan.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5152b84a33577..d3789cf8d4179 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -231,6 +231,13 @@ int ieee80211_chanctx_refcount(struct ieee80211_local *local,
 	return num;
 }
 
+static bool
+ieee80211_chanctx_has_replace_partner(struct ieee80211_chanctx *ctx)
+{
+	return ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	       ctx->replace_ctx;
+}
+
 static int ieee80211_num_chanctx(struct ieee80211_local *local, int radio_idx)
 {
 	struct ieee80211_chanctx *ctx;
@@ -1403,6 +1410,7 @@ void ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *ctx = link->reserved_chanctx;
+	struct ieee80211_chanctx *old_ctx = NULL;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -1416,6 +1424,7 @@ void ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 			if (WARN_ON(!ctx->replace_ctx))
 				return;
 
+			old_ctx = ctx->replace_ctx;
 			WARN_ON(ctx->replace_ctx->replace_state !=
 			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
 			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
@@ -1426,6 +1435,11 @@ void ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 
 			list_del_rcu(&ctx->list);
 			kfree_rcu(ctx, rcu_head);
+
+			if (ieee80211_chanctx_refcount(sdata->local,
+						       old_ctx) == 0)
+				ieee80211_free_chanctx(sdata->local, old_ctx,
+						       false);
 		} else {
 			ieee80211_free_chanctx(sdata->local, ctx, false);
 		}
@@ -1705,7 +1719,8 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 
 	ieee80211_check_fast_xmit_iface(sdata);
 
-	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0 &&
+	    !ieee80211_chanctx_has_replace_partner(old_ctx))
 		ieee80211_free_chanctx(local, old_ctx, false);
 
 	ieee80211_recalc_chanctx_min_def(local, new_ctx);
@@ -2174,7 +2189,8 @@ void __ieee80211_link_release_channel(struct ieee80211_link_data *link,
 	}
 
 	ieee80211_assign_link_chanctx(link, NULL, false);
-	if (ieee80211_chanctx_refcount(local, ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, ctx) == 0 &&
+	    !ieee80211_chanctx_has_replace_partner(ctx))
 		ieee80211_free_chanctx(local, ctx, skip_idle_recalc);
 
 	link->radar_required = false;
-- 
2.43.0

