Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC8937882A
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 07:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791184936; cv=none; b=GkI62eaitqkhgLVw0bjgkWamZruXysba9vouBoBq32oiwhMPo0AdMkmUnHc4vYGUZGlxNUyHQp0XYojgik8gcAVb7U4zdallJn5AcPw77GfJmRILwHuzDZ3Yh14Y55fyYOptUN5Oct0EILFkBhiPBkaxYMX9oIj3gyE6FeS1s6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791184936; c=relaxed/simple;
	bh=Pb9pP7DCmWh8PRBTVTFxpapJkTRbJ69H744kGtzqF8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOYjEetx+ETTRpyQShd69paoHngRXoJv6ODjLKY8cutIxqhgCMFSqpS4H3qzCDGFh94/Ns8mvxjtETiACcVt5iSsMLkQcE4kxKOtJaDKiVVRKSQU36VGu6tf/yUpLGr/O4m1fKh3eIURH964AXdXRCdCek515Bp2lgJ6WVDg/hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=djwEgbCR; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="djwEgbCR"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-48b03eb33b2so527874f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 00:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791184933; x=1791789733; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yWSA/QTkYQRPkO7iv6tttaOq45N/puN7vAoxmF26+iA=;
        b=djwEgbCRICudKPvHU0Bl2FI/Gyhxwn7s38nDNeeJ8FZCuaOqpEazFnI/xq2MbLWCDb
         zXqGruTIapVhca2US6tLWwDXBICzkdZeHB5n8Mtx7UDDm+V99EhiZCzOt3N1mluOSnWf
         QRdB5UWiC0yMhqwaCKjQcZnbQYsX9o+ZnrHPwW6h7ChDc4wclMLa21FmXX2gcCxOOUL1
         i2G8btEqC4Rpoa6LitgpmJtVQTXg8gza+YdEGb/jYoUPCg4LUanhRZGXi5kr0w91NTSx
         CdB1jFzvwdQqiaUb+ZSPAmHn/KXaT0+VynmtNInVseRJXORMFESdsM3uDZc1GWi7el2j
         sDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791184933; x=1791789733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yWSA/QTkYQRPkO7iv6tttaOq45N/puN7vAoxmF26+iA=;
        b=T4H2z5oAliPpSr6tePAlBEHS2+IjSSdWNwxeOkKzfY+Y1yxWorcF3Xkm3EqL/oSyko
         lgJgo6et1tXaxASphrsE0RCF/fUThtJc0D1PCTTvuCwuPkjkpf7Zf40+zqSTb5bnS6T+
         HS2Hx+9/X0jgEfPYSyt3vfjlGNLW+6GZE8zxfKkVm5G793TYF4ZOMj51Fgke0nOAuKV4
         ddSd0W+/4XJoR3XOsD4J/pd4+g+HRiLM7VKSAfV3VuGLcAcRumxbuCRJZFVB/mc9C5cL
         E1khUSsZaL3Pij70nNJ29NsqtVvira4MFDcqyzrfolgfZFgSs2IfeBUkZ4c6kH7FxCsW
         V1OQ==
X-Forwarded-Encrypted: i=1; AKwUvBw7fBJhL6ViatTWX/li7hvq83dkvGagBxVIDrP5/+ei+vuvnWuDxEAnq31AZev4ckZlaW+oKQdVEOL01UnB3Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYLJsUWk2o9beTcjs/uurjOY2tevsNsUOiGQ8SD92eKv40BIYxAM
	rWR+rZiKm3qooxinMcWP3HOFjyr6Pg6SUBXGuHaOhKM+gldNsD5WQ3/Q
X-Gm-Gg: AYBFou3FCmje2T5/uZmkiXLuCiICkLGvEmFGm9eRCMPFR39OfQcAeMiPBjHv5PGMj47
	iw+uZaSHfkBrxing+2eAU+X9aF47PjB2sxdOBv5mYwkqzCbbOkGjAcORIl6uImbHy6kvZzXxUv1
	Mv5ShCsTHBoSVdO/j/biuNVX5Esqx0N4VvXikik/bdWDuKMqehZhg4e1ywwTLL0rzjXfKTCe1SS
	rgZ7txwNmLXDeC3uAYwwl5CVLgRO1PeE8ESQDOwP0SsRpduEPljIHsqFrFa+giG02TI0i5MD6gC
	JRT6eibRed2+1u2W+og50SscSYgJX5JlKEdni3PNVICYWc2I5WR66tk6h0CLY4SZ5ucxFVmXlVa
	8QjfxKPcdLvy/2TzQuNUK4SixmzzgoogEd7uUwZgYbJPi4sWXCFjiqubENtTv7dLHPkdc6Bvq9Q
	wdBDIA+Ue6kxIV11JPIflgMDqOhrMbiuQZC7h2ME9TIJmltvRTIC+D1+M0WpCa7s6URMiMtOdJV
	DkZ
X-Received: by 2002:a5d:5e0f:0:b0:488:8347:a110 with SMTP id ffacd0b85a97d-48b1272892cmr11686252f8f.7.1791184932933;
        Mon, 05 Oct 2026 00:22:12 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622affadsm1642847f8f.40.2026.10.05.00.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 00:22:12 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH ath-current 2/2] wifi: ath9k_htc: start ANI when an AP interface begins to beacon
Date: Mon,  5 Oct 2026 09:22:09 +0200
Message-ID: <20261005072209.4101009-3-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005072209.4101009-1-mehmet.fide@gmail.com>
References: <20261005072209.4101009-1-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

ath9k_htc_vif_reconfig() re-arms ANI after a channel change when an AP
interface beacons. mac80211 configures the channel before it enables
the beacon, so during a normal AP start that never triggers, and the
start from add_interface that the previous patch removed was cancelled
by the same channel configuration: with hostapd, ANI and the periodic
calibration it drives did not run in AP mode until a later channel
change.

Start ANI when the beacon is enabled. The channel and its calibration
data are in place by then, which is the state vif_reconfig() re-arms
it in, and remove_interface() already stops it with the last AP
interface.

Fixes: a236254c35f0 ("ath9k_htc: Add ANI for AP mode")
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a86dd28b0ab7..6578114a4019 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1551,6 +1551,9 @@ static void ath9k_htc_bss_info_changed(struct ieee80211_hw *hw,
 		ath9k_htc_set_tsfadjust(priv, vif);
 		priv->cur_beacon_conf.enable_beacon = 1;
 		ath9k_htc_beacon_config(priv, vif);
+		if (priv->ah->opmode == NL80211_IFTYPE_AP &&
+		    !test_bit(ATH_OP_ANI_RUN, &common->op_flags))
+			ath9k_htc_start_ani(priv);
 	}
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED) && !bss_conf->enable_beacon) {
-- 
2.55.0

