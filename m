Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657796;
	b=qyoaxObt8iHbCI5/UEextz9lXu4dLX7lrEFHXhFvNoTrso6hwXgDFCzMFLnBTaCFc3GM
	 c+UriVOKmIlrKJmTSJJDnMcMB26krRM9fd0C2GWWI30jP2Ba3HJdezj4NFzv90viUL6QB
	 fzTIfRYguPYV4VBsXeMqA63tR/lnNo4ZByDnoZLZHdqriWK454IUlZ24rzuGvczoOpube
	 OonK0bemIRUzmX3ityzI9WdqYisohL/1MLV5bM5j4RT5A1D1VQEoQQOSNKJoFhRaMUYGP
	 rKvpBFISBc9yBY0bOBr9Qc4GC5kl9jS3VrjwTyEPpHMWjyT/Tk6QXrQ4F4k5R9vFP2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657796;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RbsrJbC+78XvE/Jv08a1o71KMq3rArHAmE6ml/65NA=;
	b=wP2Bvfie/w1Ges5xhsae4oE4eSjl72WPRmpXMldjKbUMnoJ/T0gDr7RYaJS8k1Ylu3ut
	 rhmbbLkTLSuI5lezYl81SpfrvCpHoYvgvxcT/8jDPSgTTpK5VLixTCKCkkFlsUkVO8p6Q
	 S2j1bEyPsjgu3j4wz6nY2tGbvrH6CX3WaDT0CbKPjcsCHGl7cHkVuJHcsBSNeDJe0+6Fs
	 QVSjfhWLV2lJ7L+PgjYF7Rk2dKPfheJUO0ONfJjEECU4sPd6ngBgrS/6WvAN3bRRzxDva
	 t8lhIX6bKFmhVl75FwWpF9wCNTfv8CnW8a+oKruvJUJgwtYXwIO3fz3jN8RAojdnz9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I5Cs8nr7;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526D4606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 526D4606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I5Cs8nr7
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c5358fc28so2834789f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 14:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793657795; x=1794262595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7RbsrJbC+78XvE/Jv08a1o71KMq3rArHAmE6ml/65NA=;
        b=I5Cs8nr7qtS5Gn4X5tF2GZWTgK0D00M6Sny6nh1ntLNXKZaQ9j4gG38aI7jVPk9l6A
         TT37nNYREAzpwOTqf2xgcB8w9slpGhfDQNhQzWFHt7CwNqMBsAkttf7wrcJIcs+nB4Fz
         MapwBIupvOlJ4atQBMYC/BrGDfpHVVjKmjJt9q2Qabz6dUC9JLvtvcDhC57+0BSVfsNL
         i4ifp14dOU98shscDtw9/LL0Hpalhx0FN0itaBQUalqYeAobdy39dRSBJRpTUp5Pl6R8
         W4SSU6Ua/ciYxrEd8WNp90hxChsEH3Qb2ytlchYf8m4bqohNdjGabk87E1cW02DS6qcD
         e7Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793657795; x=1794262595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RbsrJbC+78XvE/Jv08a1o71KMq3rArHAmE6ml/65NA=;
        b=ITZqVhQLH86xJsgTYrUyixplg6OwOLEZK4OlBQecKGfMTsQu8iRaWwahpmEvN9OI8x
         mmB8RtxKF/HsFrgoyzCVbrZ4G0AdFybwhg6hJtTfnzafUNthx8mdsB9ly0OrqhV4wrix
         +Y+VMBRP4Gy1ubFZBKtiA4yM+PpznsSpjnhDmYZSdWBDQMzlJwtghO5n3g5NA83yyb1v
         QgkZEJk0gAEQdMq3tGgbQBMgVjqvesXJsNozvFOu4dNfEz9rD5lJNb1yUNRKN8uDuFFL
         ICgHPJROjjmI2si5uX2mWtJ9VVHpD3xkqwI05lexBqy+Ii0lPkvdyBqBS2lCfm9d/x2q
         cLJw==
X-Gm-Message-State: APuU4Z8z0FIAahzOYS1EXWys+OuY9L3OKRmqKDpdi17doe2oSkxFKPpA
	AE0Zw/P93seZ8jv3v9wCCIrU50c6NFEKRJPT4ons/jFyulVYmcrmTpeFPBQO
X-Gm-Gg: AYBFou2LGVno2u6tOIIEwCjTqdt+8aeXMQb5+p+8dHdGlz1I3hxw6JAgz/7URGJtlfA
	ix9CqS7ayZ3V2c/DYpIbcv+MFty3dsuDnw/GU6NrwPV7VEv2p8AtYwsJRIhJEsNAF8fLtNA/R5f
	rBI/xl6fasoQgFadGHaflcMWtMaelwRKA4+756sQwJL6U8Z0B5MHG0/wng+OW4vEYF0r3NWLu4r
	XA7P8M0ENr/yEd3x0IHaMPyJTwcxr2zHjLg/oTz5hjjvxXf9WqT23K0SxpvRPV+1Qf2WxsRGo97
	V8xQ/6gpq1HWPdF9io8Fc6I7b4kND/h/+ZTVp40dLV25sZf+BqkFZsUTe1FRJw4npEqrrQ2+eud
	Gmwq764uB13EQ5zB8W/I+A5HoDaLPmjODIj6w43wLt3DE5Zk5JWBcrMbJg+ptaGgrGAV1RDmaqu
	Zqv8788/b0SyhgBHSsG63aqjODJhwrvrc6FUxj48Wpvkp8nMvNecFWrecjK7gzYVwFIRpmaMtLF
	DQQZoI1QogMyJ4RvJZSc37E3UPvNWFiGEAXhfqE3b4V3s+yXByMuUUeW8s8hy/zyr/auq/RjZjf
	vUmHczdDoIc=
X-Received: by 2002:a5d:64c4:0:b0:48b:9ed:b81f with SMTP id ffacd0b85a97d-48e6e2e768fmr26733322f8f.10.1793657794653;
        Mon, 02 Nov 2026 14:16:34 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e77409821sm17917202f8f.0.2026.11.02.14.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 14:16:34 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless] wifi: libertas_tf: use timer_delete_sync() in lbtf_remove_card()
Date: Mon,  2 Nov 2026 22:16:33 +0000
Message-ID: <20261102221633.3483437-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
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

lbtf_remove_card() uses timer_delete() for the command_timer.
timer_delete() only dequeues a pending timer without waiting for a
currently executing callback to finish.  If command_timer_fn() is
running on another CPU during card removal, it accesses priv->cur_cmd
and queues work on lbtf_wq while lbtf_remove_card() proceeds to free
the adapter, leading to a stale reference.

A prior fix addressed the same timer access issue in
lbtf_free_adapter() but missed the call in lbtf_remove_card().
Use timer_delete_sync() here
as well to ensure any in-progress timer callback completes before
proceeding with device teardown.

Fixes: 06b16ae53192 ("libertas_tf: main.c, data paths and mac80211 handlers")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/libertas_tf/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index 411f075b6186a..f518ed48523e7 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -642,7 +642,7 @@ int lbtf_remove_card(struct lbtf_private *priv)
 	lbtf_deb_enter(LBTF_DEB_MAIN);
 
 	priv->surpriseremoved = 1;
-	timer_delete(&priv->command_timer);
+	timer_delete_sync(&priv->command_timer);
 	lbtf_free_adapter(priv);
 	priv->hw = NULL;
 	ieee80211_unregister_hw(hw);
-- 
2.47.3

