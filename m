Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214384;
	b=FNVzVpp3K8akgMwMy55t3H6SPqStiiAlRAfdRg7yPQg1NK0eix+h16uNOi7qYrrCzojA
	 pQ+SE3UQvlivnRdyoa39Yzc+VNOToWu7NDOvksJF/KJecbdUMUbaSlw3BtkAjL9CZY2hY
	 X9V0gvzlh9zFsZHqve1Q3RS3GWl8yVD4b4bLye7/2bfBBHwycM90dQK1Cga8L1l3H934g
	 RCYA4aj0bctNDl2fBGddM9FzyPGgyE3sAg3YrBI33hI1m4uMs31RTmNozrBNJsCHF9lMF
	 co61c1CbfWu9zGOAZFe6CG/O+6ICEm770w3oZ6XQFLWb0OW1tXuz29dCEOoRX3tBwEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214384;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=a3Qi+G0JuRyVKt2+dHOX75qxyqvs1hiwMlJx9ufdRtc=;
	b=DtwQoAy0yRmYKw9qlPlMUS3njV3l2hFv+SoWcLXzZGvxbQoAes5JaqDtHOuFuMf38gGM
	 3QcVt7ESN8VYNOZeMmeH7oNojiiXxrECSoHvrZjcEfuYneCEFP3pSZHAy34FtV90vKPhX
	 XsVMMMqydh7UpLc/wFdo1gjUM0CYLF/r8Bd5+iwuNevDwcUsrY2Ygm8bbsSU0/1H8tSRH
	 MC/ALzxevO8SywZ/A/KhzJlWJKkPM+/htE/tp8SbOeIyKS8hwIjbI+v2KHhgyOIxDGxtE
	 LqQN0tH9VUNL66+PAOoYXmEaRlbHQnGJO5PXFmgjBbJTbr8fRlY7MJlw7CIdwmHSKRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="ut+REY/1";
	arc=none smtp.remote-ip=74.125.82.175
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E8C60A2601
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 19:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70E8C60A2601
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ut+REY/1
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a315ed211so4554eec.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 12:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793214383; x=1793819183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a3Qi+G0JuRyVKt2+dHOX75qxyqvs1hiwMlJx9ufdRtc=;
        b=ut+REY/1uXOs0SQYKtZmKOZAoDiX18DIJESIfqy0LczZMXzJGXfUTqRuemfdth0JKv
         9/XbuestJiqI0ALSqi3/y/TC8BYOMDwIek45Ms1m6j2feVgD4PO+mwfIMtQIPQ2MrwkP
         NEOWWkazP636CMbyYjdneCiPl/o+8cDn3WbLCe3B+IY6fZ0BUzQbdoXJtr8GxzlT+MCX
         jafB1ikae1qqQ1QiEfkgHYdi7EXgJcMNYbnopgA+MlISQkZlN2s5/9c6VSb4ZhpLJhbo
         4qTbzpLjo+uh0fAlWoSr/C8fr44IlRlf39ql3W/4tW7ZIPm+xUI7+lQLMKOpMIjU6CmO
         Qeng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214383; x=1793819183;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a3Qi+G0JuRyVKt2+dHOX75qxyqvs1hiwMlJx9ufdRtc=;
        b=D8edlt0xW7XPIgG8Az+GvxempgL0Evpi4Kmnn020hYQsW4uCPJozF+HlU1bzX+BCB3
         Mj3GoTouX4OxdxMrbWewCrwOwWPZDHVuy8UwiqPDvyTVtAcUPu5sxAscvhSZNg2YUb5n
         tgbjyGOf0OVxzkTLE9QhlVcyyn+HpBpOMZAikEPZPWEFyqEkDWa44+yc2XhTNrXUDV0o
         0M3MWRO1xygdn4c3RtpgzNRR/Pume3tXDjUgXaAziezrWNqo6MuQvF8ztyob6kpfM/UO
         ETE56+ql3cLeVTZkCfyXSKHkrVz89zeFgcSDyW6n0iGtM+CqLw6qeFJWUdDJTJV4hukw
         XYwg==
X-Gm-Message-State: AFq9FYJUgU3eKLqtlxePsRS/6uWM8E5WnEOj2KbXlAf0FDQ2zIy8+EcR
	3Jf1+6uEGIssHu6QsPHP1KTBVRgfzhZXTpES4VZN+sM6uqKpXv+gh3baI54ZrLW0
X-Gm-Gg: AYBFou19AOAUi9jw62O3P0N7JBzX1D1uw+qmYsldhDp6Aiev9yHsbo/EIJld/FbHJFq
	K7Q6LNVp30dWgTZQ3qaOWtoSbSLjKBLSIv2ytKM9KUMsFUkL1xQ6Zi46w1AjAO10RD6v9Q3k3ou
	yBK/6ct32wrXezifvz8GTmyUx0rvBSJc1FtRw8U799OuPvTJpCW2DZDEtf2Zcgj3dB1w/jf3SOK
	Q6F9LiM9Hb1HLm82jO9SqGxiO71wMCh35+GQ9oSdeexIoyIjmstvfq+i1DUgjSMLTGy3X40ocn3
	M2BeEvcBPVYgpqzgvevLLfpZPIT9HTIHVgQoIT48xpmDS86rfTuQvaAs8ZZO+YXrSeZnmPc/kgx
	77kaBnDeU3PiloALEBiOKZUizCPlZYK3aa3QDUdw1aoiHzN1UD9QEe61nAcdSfNQVLmQwjdLEca
	horiOVkK98AcK3pAN4lJwIAGHtwyKRYQzONgFnMQYpKeXv4M6fwunMdUlV2s88Hz7GDc50H8aRG
	jK2QAzDMestV+eZUvDWx26yyzsA110IXnHYMBd0ooA8IblKr+2v3/S8MvgeZ7m0UEijoHO+SeyC
	HwuilU6nxxIc9wRj5N+ac5IiTpe5cYjY+zOZa1MXUPCDLRWXpc0RyUKX41rPgn9+WUyJ3n6eRVz
	V
X-Received: by 2002:a05:7301:6908:b0:361:cd8f:7422 with SMTP id 5a478bee46e88-36a2fd7466dmr477849eec.9.1793214382948;
        Wed, 28 Oct 2026 12:06:22 -0700 (PDT)
Received: from samniyama.tailbcd61.ts.net ([76.20.4.3])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a2398fa4csm10576943eec.24.2026.10.28.12.06.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 12:06:22 -0700 (PDT)
From: Koral Ilgun <koralilgun@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	nbd@nbd.name,
	linux-kernel@vger.kernel.org,
	Koral Ilgun <koral.ilgun@adtran.com>
Subject: [PATCH wireless] wifi: mac80211: keep the radio index of a replaced chanctx
Date: Wed, 28 Oct 2026 12:06:13 -0700
Message-ID: <20261028190613.497063-1-koralilgun@gmail.com>
X-Mailer: git-send-email 2.43.0
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

From: Koral Ilgun <koral.ilgun@adtran.com>

ieee80211_replace_chanctx() gives the replacing context radio index
-1. After the swap, the radio of the replaced context counts one
context less. If the wiphy has room for one more channel, the next
reservation on that radio creates a second context there, beyond
the channel limit of the radio.

On an mt7996 with three radios and no interface on one of them,
every second channel switch that a station follows then moves the
station alone to a new context. The driver retunes the radio while
the APs on the old context still count down their own switch.

The replacing context now takes the radio of the context that it
replaces, if the new channel is valid on that radio.

Fixes: 27d4c03441eb ("wifi: mac80211: add wiphy radio assignment and validation")
Signed-off-by: Koral Ilgun <koral.ilgun@adtran.com>
---
Tested with Linux 6.18 and the mac80211 of backports-7.2 on an MT7996
device with three radios, one of them without an interface. The station
followed 16 channel switches of its uplink, 50 s apart. Without this
change, every second switch added a second context on the 5 GHz radio,
and the station moved alone. With it, all 16 switches swapped the
context, and the station and its APs moved together.

 net/mac80211/chan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 9cba79507767..b814619e6701 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1457,6 +1457,7 @@ ieee80211_replace_chanctx(struct ieee80211_local *local,
 	struct ieee80211_chanctx *new_ctx, *ctx;
 	struct wiphy *wiphy = local->hw.wiphy;
 	const struct wiphy_radio *radio;
+	int radio_idx;
 
 	if (!curr_ctx ||
 	    curr_ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED ||
@@ -1506,7 +1507,20 @@ ieee80211_replace_chanctx(struct ieee80211_local *local,
 	    ieee80211_chanctx_num_reserved(local, curr_ctx) != 0)
 		return ERR_PTR(-EBUSY);
 
-	new_ctx = ieee80211_alloc_chanctx(local, chanreq, mode, -1);
+	/*
+	 * The new context takes the place of curr_ctx on its radio. Without
+	 * a radio index, ieee80211_num_chanctx() counts one context less on
+	 * that radio, and the next reservation can add a context beyond the
+	 * channel limit of the radio.
+	 */
+	radio_idx = curr_ctx->conf.radio_idx;
+	if (radio_idx >= 0) {
+		radio = &wiphy->radio[radio_idx];
+		if (!cfg80211_radio_chandef_valid(radio, &chanreq->oper))
+			radio_idx = -1;
+	}
+
+	new_ctx = ieee80211_alloc_chanctx(local, chanreq, mode, radio_idx);
 	if (!new_ctx)
 		return ERR_PTR(-ENOMEM);
 

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.43.0

