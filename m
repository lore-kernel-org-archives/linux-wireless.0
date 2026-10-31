Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793465511;
	b=CQXMxq2DOGcts0VreXOqK4OOeEDBrxqNGbE6b+bqYMG3zDaJCXrAUNL1n/3Ux4RqzsD6
	 D7Ui6PHZhFa5yxFBwOhlEoloyNuOOgv8WGTujOHEhT1TSR83ql5AhijhxoaLfIwyuJBQM
	 nPAj9RPxd7Tj7RuoL8xYmxQ4afQmbAUOag1Na99ELu6WF3QIf6lTDNauwRh+KAcATklcF
	 hnM1u/mUub2aV97pn2OGyQfOKV27yfBRW4YhMVxK3R6dILv/xKEjsfNzLnRoCOel3FVOf
	 J9Be0ElBQxpklct9Ue8SqRVXfbzeljQYHqy3lYr0EVedD4GBYiYf3mnfU6ZFSDfrlrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793465511;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Kv0RucCyFAkpDmpeAGSkWs1TRKT3+D/gZMXOjxlwJhE=;
	b=htGN20wTXYMGBSPBCoCECoAMrCcq4dx1KMC0BHC5S1Yv++5UHUVnr9WW5ncs74Pnlag4
	 uOp60oOnYvcsssvkk6VI1Zzkf45tyXdgCXnLb2e/ozjPWyeqBWeo30AgESoCGlmy0BveO
	 amTOfzGoWdDXAlFcTafm3dQlIo+A3P2HY6+SnKvm2r7YDDXh3I6A/a+NK57CrQ13LImu2
	 O1Rur3g4iiAzZ4Znosj+5nuN3zpwDrB+qHe2A/+YavInPnnciXrjOEHvGeHF7vH1Vq7Mp
	 csGMsjvvzve92M0U8/ByfY5twyjHJb8cx34gPvSqr2Y6r9gk7W7M8HBteJziu1sLdYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0xQJBjRf;
	arc=none smtp.remote-ip=74.125.82.54
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BEB606A325
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 16:51:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59BEB606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0xQJBjRf
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1ae18eb9b69so1028785c88.0
        for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793465510; x=1794070310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Kv0RucCyFAkpDmpeAGSkWs1TRKT3+D/gZMXOjxlwJhE=;
        b=0xQJBjRfUjlpKnn7b8ngASTIN38B1bDGuEnjyjf6Mg2ofPA9JiopEXu1mel9XWgH7F
         fSRVV9qNy8H6IdINcFBFY/+tvq4dotNZtv1uEEbt5NEGW14QrRZ1kwm0z0QIidBtfBYt
         dQBlEfQt1ZgQW8CJhTq2WJvycyYxqNDJNMTCv5PEmfZzJU41QeKvQ7lj0rvYN1VZQP3K
         JXWQpXMDXSQQMKdlbqSBgRXcoWXUUN7WKMLyZSazjCgPUQVMklnOA7jx3a4WdE73+WRE
         JKvDdReoOKrl2dYM6VXo3aYSJWZWzIDFwKA1FhPpu+D3NVczPPiAHj5zqlGJMLNSrrBC
         R07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793465510; x=1794070310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Kv0RucCyFAkpDmpeAGSkWs1TRKT3+D/gZMXOjxlwJhE=;
        b=EfLfbKkKVOVFJsPryjkNhC9FQgN50yklcw1ho7PirNFFSIF/sSFmmWiuolVOtRrUDz
         0+4nOS6W6Ys8IShBdPZGzMKGfKfxpZR5bpwUPR9dp763f0pPOCQ43jwbpKxqTbnQzcip
         YDlyOBpzQBtYIaxwuMrs3CcI4ItB6Kbcj5fzDBYU5hdn+Ac6TWpv2G5KzXAs51ywQU4x
         4Jva/evSc3wlJYFg/TuuyqWq7JjvlVNeo5VLNDSiU0rPHikEFMQEiAZ4I1ZodASlbOcx
         OiFzWDdWh4pMnOQdVrGvlt5KM4QibKiKAU4vB2s8t0FxtJ7nfU2nOb1jpMrH8mWtTj90
         NBow==
X-Gm-Message-State: AFq9FYKbG4CAMMrgABExCQS222x76uWMukTrD76NbGN9Yc3JEqfrcOA2
	FuxYohnxZUMKiI0PTGDwPMkGZ0n42sueTlfJE4FbUJ1S+hXd/5HS8HkW4Sy5KYXL
X-Gm-Gg: AYBFou3GZQXi7MzkAgEnUeVm394QRx/AOETLwcOUVJi3bAD0o/AiCL7JYVAouo4/ym9
	AlLKdeKwB28JZJlmM7RiuCnomqUKvf0FbbMHQY2RjQpJ+uLOrQ44DV2Mny/MjLwOcUm/OMbkFaM
	akd9bch0hMbmhzmUMU6zFvNwy++WIIB1vjfEV7Tm/F+Df0UzAmn+JHAew61puTa+CA0oCLkWhhW
	+XNmf2r/2jc0OpcVgUcq+TpClZRrVTQfKIPzN8KtVeaQX0bHSgjfsQhhgdc1eMsmiIZGvsHlWAM
	TBnWWHFXtKihl5OI22UVnqNskjrEGb15McuauvAPibJepxgPwvNOwQbFx11mtLee0EpTclNFvJT
	3kKs9Th3o9W1lOhlenYdbyjX124eUey1IhQGj+2/anr+Myr5KMvWoYOOqD+B84wBtkEGnRmqBTw
	enBO10ekA57AOen/qMGdZtN7bP3CatXrHrWQG/u6p1+5uyURQh9ql3hF2hE1L7lMosrp8DCpIoS
	03AZ9vDAI73FyCuwQJYFUUklfR3YIONQ+ruv5YqkUI0qBum5V0/88dGw5fg7F979Oq/NxeERx2Y
	3zIdRZxmUdbqMED9Dlql49uFjPanMWNlj+bcHNueWFz/Q+I1YBnFrYaI47XKoLbz1UEfeZjK7pp
	ExU7C1nI=
X-Received: by 2002:a05:7022:7f17:b0:168:3243:c937 with SMTP id a92af1059eb24-1ac5cb1c8b3mr9164747c88.16.1793465510304;
        Sat, 31 Oct 2026 09:51:50 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:bba7:148:3987:1383])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm17421611c88.21.2026.10.31.09.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 09:51:49 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <stf_xl@wp.pl>
Cc: Ho Jie Feng <hjf3108@gmail.com>
Subject: [PATCH wireless-next v2 1/7] wifi: rt2x00: start the link tuner when an interface is added
Date: Sun,  1 Nov 2026 00:51:08 +0800
Message-ID: <20261031165117.2868671-2-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261031165117.2868671-1-hjf3108@gmail.com>
References: <20261031165117.2868671-1-hjf3108@gmail.com>
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

rt2x00lib_start() enables the radio before mac80211 adds the first
interface, so rt2x00link_start_tuner(), called from
rt2x00lib_enable_radio(), finds no station or AP interface and returns.

Start the link tuner again when the first interface is added, and stop
it when the last interface is removed.

Fixes: d96324703ffa ("rt2x00: merge agc and vco works with link tuner")
Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index 3bc0c1c906c91..86547ce81cd2e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -264,6 +264,13 @@ int rt2x00mac_add_interface(struct ieee80211_hw *hw,
 	 */
 	rt2x00dev->packet_filter = 0;
 
+	/*
+	 * Start the link tuner again if the radio is enabled before the
+	 * first interface is added.
+	 */
+	if (rt2x00dev->intf_ap_count + rt2x00dev->intf_sta_count == 1)
+		rt2x00link_start_tuner(rt2x00dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_add_interface);
@@ -289,6 +296,12 @@ void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 	else
 		rt2x00dev->intf_sta_count--;
 
+	/*
+	 * Stop the link tuner when the last interface is removed.
+	 */
+	if (!rt2x00dev->intf_ap_count && !rt2x00dev->intf_sta_count)
+		rt2x00link_stop_tuner(rt2x00dev);
+
 	/*
 	 * Release beacon entry so it is available for
 	 * new interfaces again.
-- 
2.53.0

