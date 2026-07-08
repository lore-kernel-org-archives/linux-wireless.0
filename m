Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF363DEAD8
	for <linux-wireless@vger.kernel.org>; Wed,  8 Jul 2026 19:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783540777; cv=none; b=uZmCNq7QZOIM3bK+wu0C6U/TjsQzFPPRi9IrVsV28PKGzC1cpSTx/c2ECs4QMZKeU4lDoro9mpz+J885eJzg17Xwi82gmJ68IEQPga/FdVqiIOjk/UcBk1HB8XsFpw9s8U4CKJsetLX8bGy0F+42uGuqSnDewQQqPYwQ1jtMph8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783540777; c=relaxed/simple;
	bh=DArdENvMvZauhzBuODBJvzWCeC7C/HSPdy/5V1YX23g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=piavc/gA0FjChkmrZ7ZMT0Hi4h/roubTiAq4yE2jgZd+f28Yio3oVlaqg/72L5jBMR4IjYO10WnByzslB7/V7jqL/Ty8w0V3dUN/xmCIDuf5yt9NR8dY5bl4V/7lFof7zJxOaZCS1g4R2Av2utmBZ+Yc5mn/Kp2r37hGu4Ov9Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mKlvhDSr; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKlvhDSr"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3811074a8c5so984534a91.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2026 12:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783540776; x=1784145576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K434/OKl2jqJkcKKF41UxdXI1B+RJY0uawUDIIMVgbk=;
        b=mKlvhDSrzW/azRWt3iDwP+6phjmVmCMzVuwlhWFsbeCV6zfQJoKozFMIaIqiQVzpUX
         9fPXbdGbBhGUO5k6UTYu+PXOSGhCXGmINBrXoxcOBvLBeG94/3IW+mp51vt8yG6phkyj
         U3B7Jac3HbgrvFWUkohv5JGKR8nYxXDQ5mKhUH5JwO6+4bE8Cot+SvodpoqCav9s356j
         59qnpuuPhNP7YsH2ifOaxdSjiLyhxTaByCWs0C4uRHWipVJu7/nkw7DjpkBK80qH+5ON
         4O4IfkkBCV3q869VF8l276+QU+RDxdGwvu1YhhlbLFX1ktIWJZxrfBoK4Cqq5M6M6xUv
         qEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783540776; x=1784145576;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K434/OKl2jqJkcKKF41UxdXI1B+RJY0uawUDIIMVgbk=;
        b=e52sr7fgVUf+aG28KmMgGBojpef5aH8ktOChT/DZPzD9SY1pFnf7gsk3ABZTD6LVu1
         0U7JuNmH5ru3NDxz4eWkFExWU77TaiTBE0JxVYA7XJg4ls4MvzHSnmVqkVHuJZCnWu04
         IaCndG9wZEcgWMLAvqyJBWQWCSTDTqKvmJRXSzLp+ZoqSHGfw1NYcuWWiZTmRxBciEyy
         ugicca/Efga94H5wABqEvZlACn7Lfz1OLejKTUgW46Y3Gc8WnWFx+p0L9W2xd/5xVraP
         cJuvcQU4ABHMupyjvf6rrlX+GYB5DcWl/M1dEFG6P47fW0WVIGW79obtSrhAub1i+Knw
         QeDA==
X-Gm-Message-State: AOJu0YwvKlpITu8283pe32t16FBPpo3hLmRT2xsVT6VwHKjAHB5P8Pis
	8Vdtu52OkKarv9jBoAIrmpqplHl2b4v00XDSk9bPm6CS/q0XWRWYo0M4zXQaKMZzR1agUw==
X-Gm-Gg: AfdE7ckRm4tB+iyvYilfhzq8ofHPcJ0+k9xEJhYUL/OPKOquV9ECT5YUkefclirKsmO
	qPAeAPkgEbU/Y5GbhPhBP8wP4tLbTMc2bmc+TGwNHIQJFKcqE7xbDDwBeXo2yDl8zzlWIdqKQ9u
	qF8ufsZhmNUjAWYAFSCBLtN8r+nLeWlmkxRq2L6QsKhrmKpkVtzAsjsR8DMjiq3OIrXgvl1/xRC
	2Dqmp5SJkYof5l2j4rndbPgORFiNoabj7ocxrOUromI7YDqNFjy8lPANPbBdHt6kUv8h+7163Cj
	Mc18IsAJPbAtluon3PbnfbYc1RapbwLXmQG2vtuI2WlovmVCtAEPdoFbAqlgjAPlVwaSU4bqRNc
	2GLHlJjFA5ZWubzOHfUpUQ4x0+JrdsztoOjctjdRRm2/9mR6Y0BSvl2bbSVWcatOYufT3KTjVEO
	E3JltIVY5wDmrjq2SDMPimGGLOGaRByppdyjv82LyURscKD4WOmXZl
X-Received: by 2002:a05:6a20:12d0:b0:3b5:52b4:87a7 with SMTP id adf61e73a8af0-3c0bc8ac06bmr4890359637.6.1783540775513;
        Wed, 08 Jul 2026 12:59:35 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([139.177.225.228])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a8f521sm22585395eec.22.2026.07.08.12.59.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 12:59:35 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jaewan Kim <jaewan@google.com>,
	Daniel Gabay <daniel.gabay@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Benjamin Berg <benjamin.berg@intel.com>,
	Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	John Crispin <john@phrozen.org>,
	Avinash Patil <patila@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Aloka Dixit <quic_alokad@quicinc.com>,
	Zhao Li <enderaoelyther@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/8] wifi: mac80211_hwsim: clear PMSR request state on abort
Date: Thu,  9 Jul 2026 03:59:04 +0800
Message-ID: <20260708195911.84365-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260708195911.84365-1-enderaoelyther@gmail.com>
References: <20260708195911.84365-1-enderaoelyther@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mac80211_hwsim saves the in-flight cfg80211 PMSR request and its wdev
in data->pmsr_request / data->pmsr_request_wdev when a measurement
starts, and clears them only when it reports completion.

mac80211_hwsim_abort_pmsr() never cleared that saved state. cfg80211
owns the request and frees it once the abort callback returns
(cfg80211_pmsr_process_abort() calls rdev_abort_pmsr() then
kfree(req)), so after an abort data->pmsr_request dangles. A later
hwsim PMSR report then dereferences the freed request in
hwsim_pmsr_report_nl() and completes it; a use-after-free.

Clear data->pmsr_request and data->pmsr_request_wdev once the abort
matches the active request. Move the wmediumd/virtio notification check
below the clear so the saved state is dropped even when no notification
is sent.

Fixes: 5530c04c87c5 ("mac80211_hwsim: add PMSR request support via virtio")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Assisted-by: Claude:opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
---
 drivers/net/wireless/virtual/mac80211_hwsim_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim_main.c b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
index 956ff9b94526d..bc0818b525224 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim_main.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim_main.c
@@ -3841,9 +3841,6 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 	int err = 0;
 
 	data = hw->priv;
-	_portid = READ_ONCE(data->wmediumd);
-	if (!_portid && !hwsim_virtio_enabled)
-		return;
 
 	mutex_lock(&data->mutex);
 
@@ -3852,6 +3849,13 @@ static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
 		goto out;
 	}
 
+	data->pmsr_request = NULL;
+	data->pmsr_request_wdev = NULL;
+
+	_portid = READ_ONCE(data->wmediumd);
+	if (!_portid && !hwsim_virtio_enabled)
+		goto out;
+
 	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb) {
 		err = -ENOMEM;
-- 
2.50.1 (Apple Git-155)
