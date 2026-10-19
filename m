Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792421961;
	b=opqtDEbha7kPDhYZ4kVv7w2SWL9xg6EGUyPtKPn5d+E9YOl5q4GIelb/IqLxuTb4Uz9l
	 Y0zgtpwleQkQv3oVEjqMw0ytSVHS4LhyLwZr2I1wSzKVhzUEujXi4Y4szhyMG8PPf2rqD
	 wkwzBD33vTcymD/9s6YCwV1RUN2VF0bU0y4rifuqB9uodBS1n1LcziAVg/R9pheh8FEwI
	 1jmIy7PkBbG107louB5DhqwzOUs2BMZAmDXa76mmPkIKbwSV2ZBU0u+5cBaq5WH8UdQQh
	 YTiJk1B6KZTuFQqM0ZNHo3FDZcZDomRDpJz8txXOVAtDfXmT7DqwbaEeHC7PV5gUHyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792421961;
	h=Received:Received:DKIM-Signature:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:
	 X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To;
	bh=aTLcmve12A0xWHTBVlp1TWGmYbd2AnRfbgViLySS8r0=;
	b=pM8jyhugcvtvy3ji9B7HpMZ8XRZuN/M6fMgGYOy6eZ0j9mHSNrznRjjTPyB2vaEsJuxA
	 GzSDC2l0ca6psUxjMRg/7GSyb0oCVXo5vjcEnWcuWpIcM1OBqXHmW1qQWXljX+DDXtl/x
	 Bk4c3NbgKK8nyp/BS4ut6RnBXTmfePPrrGTM5yeccxQuqUixZaPChTZgQgp1/bGp/MsIG
	 +u1ILbChlc+s8DdvvV7uFxrj0mAmNlII3HXAPUSRxqM3k+GEEj66ML6XBRfq1tjvTrf1D
	 G2sL5pW0sMzzg17b8X6c8NFdji8YDC4PdzLU+1ISjaLTiILDRMwZ2F/mTUYlzrWZYpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IQzrSwTc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=10.30.226.211
Received: from aws-us-west-2-korg-listserv-1.web.codeaurora.org (ip-10-30-226-211.us-west-2.compute.internal [10.30.226.211])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D0260774F1;
	Mon, 19 Oct 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20201202 header.b=IQzrSwTc
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19FA6513C1;
	Mon, 19 Oct 2026 14:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792421960; cv=none; b=g6kGJb7OxSYfKYO4JN0qrIr0yB1rsv2GrUh480rRWLpvMQf/yqvvMS1fu0buNigT4pc5k8LVdS0DrnEdevLLClO9Zsejp8GbjVKdwJ8IrPdyT1H8rnqo0cuuqVFBSXTmO6+hv19KXMwwlZgRkSmYrBlJxBkGE/KhIAJnP3Ix1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792421960; c=relaxed/simple;
	bh=Mjj1V8YaPv0BA+ANQpQhqJlAhXDMyEE/QQwGJZP0Hg8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=m3QS5VIIAi/+9QFpgrp0m9s+h6OIBLq9XAXP84c45ZUhzTciSSRUNqlDNthEDzGNWhAm+Zpr/c7wpxb5AglqtSNEfCkQg+S7H5c34pdrmKb9GcbQoH8CVozH8sufuI552EtzNzoqK/Y1RACpsURPTgbp/vnjAKba5oLnWStEANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQzrSwTc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPS id 646B0C2BCF4;
	Mon, 19 Oct 2026 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792421960;
	bh=Mjj1V8YaPv0BA+ANQpQhqJlAhXDMyEE/QQwGJZP0Hg8=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=IQzrSwTcZJCnKoQLCJr/7j5ncE1FDx0arynzyy8wRTbLZOEudIlPyLGcQq2TakLrn
	 fUpTBqzQVz3+2LrmRoA5XlY+KH5PwFhv8yT15mYh87kJCTUimUqDVyCzKlNwscdmva
	 TTHfNcmoEkqh+ETxpkp+ggGUvQaFqH96YX5a/LV/s8woLWVT4nUcKNeUmHh037YItI
	 pE6GQ+3K379/qMwYBEqWpU2agVQAS9pbX1Jpbc+tlsnykiMuyAL+BJT4vQrAPf0L4J
	 ocgLiBLfPlLRYm129xFlUQTnuhy6HKQW5MWBkYZAv5EMbeVCzwX8NzBOcP0b1qKi9z
	 QP44By9exoxXA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F80DCCF2DE;
	Mon, 19 Oct 2026 14:59:20 +0000 (UTC)
From: Zhaoyang Li via B4 Relay <devnull+heliolee0118.gmail.com@kernel.org>
Date: Mon, 19 Oct 2026 22:59:19 +0800
Subject: [PATCH wireless] wifi: wcn36xx: validate band and frequency in
 survey updates
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-codex-wcn36xx-survey-upstream-v1-1-7c7babc007c1@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEYw1moC/yWMSw6CQBAFr0J6bccZUKJehbgYhgbayEC6+Ywh3
 F3QZb1XqRWUhEnhkawgNLNyH3awpwR860JDyNXOkJo0t8be0PcVRVx8yPIYUSeZ6YPToKOQ69B
 l19xcTFr7u4W9MQjVHH/9AhYWepMqPP+PTuWL/HjkD7d0SliKC749pl644XDuHAfYti/SYmkdq
 QAAAA==
X-Change-ID: 20261018-codex-wcn36xx-survey-upstream-a3560402fc91
To: linux-wireless@vger.kernel.org
Cc: loic.poulain@oss.qualcomm.com, kvalo@kernel.org, 
 bryan.odonoghue@linaro.org, wcn36xx@lists.infradead.org, 
 linux-kernel@vger.kernel.org, heliolee0118@gmail.com
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792421960; l=3270;
 i=heliolee0118@gmail.com; s=20261019; h=from:subject:message-id;
 bh=fjp9lLKvfDuTUpNB3hs+MBg5G86RlOJ8i6sh6ABw66g=;
 b=GxdIcTIQ+TqsO27OKrNCGs1UZcm9sYZkUXE73dACi14oz+4yxNUNXLQ92nQsJFcKUDgI3Rag6
 TUbr0tjbwmMAO4WGvPYbRsF/ubuf2cGgbTUbq1i0mVjOWNg4WBM/tSM
X-Developer-Key: i=heliolee0118@gmail.com; a=ed25519;
 pk=syMlenivwkqT00HeAmT4htw8EZeZVwsvh6UhTZcqANE=
X-Endpoint-Received: by B4 Relay for heliolee0118@gmail.com/20261019 with
 auth_id=1241
X-Original-From: Zhaoyang Li <heliolee0118@gmail.com>
Reply-To: heliolee0118@gmail.com

From: Zhaoyang Li <heliolee0118@gmail.com>

WCN3620 only registers the 2.4 GHz band. When scan RX metadata selects
the 5 GHz band, wcn36xx_update_survey() dereferences a NULL supported
band pointer while accessing its channels. This can crash the device
during scanning.

Skip survey updates when the selected band is not registered. Also
return when the frequency does not match any channel in the band,
otherwise the update overwrites the first survey entry for that band.

A retained MSM8916/WCN3620 diagnostic log reports a NULL read at
wcn36xx_rx_skb+0x178/0x720, consistent with accessing sband->channels.
The log lacks a runtime module hash and the raw RX descriptor, so the
exact crash path cannot be independently verified.

Fixes: 29696e0aa413 ("wcn36xx: Track SNR and RSSI for each RX frame")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Zhaoyang Li <heliolee0118@gmail.com>
---
Testing:
- Built the baseline, this fix, and the two-patch RFC series on
  wireless/main af32da41b032 with ARM64 GCC 14.2.0 and W=1.
  The baseline full build had 1067 whole-tree warnings; incremental
  builds reported none (these counts are not directly comparable).
- Rebuilt complete WCN36xx driver objects from clean for all three
  configurations: no warnings or errors; linking and modpost passed.
- Extracted-source ASan/UBSan tests reproduced the unfixed NULL access
  and unmatched-frequency overwrite. The fix passed 90 survey cases,
  256 synthetic scans, and two ordinary RX selections. Kernel APIs
  were stubbed; full RX and skb lifetimes were not exercised.
- Downstream 7.2.9-ufi-stable: 99/100 scans succeeded, one timed out,
  no survey NULL Oops was observed, and 16 pre-existing mac80211
  invalid-band WARNs remained.
- No native upstream kernel boot or dual-band hardware test was done.

Historical crash evidence:
An MSM8916/WCN3620 6.12.111-ufi-diag log reports a NULL read at
wcn36xx_rx_skb+0x178/0x720 with x0=0. In the retained diagnostic
module this is ldr x2, [x0], accessing sband->channels. Symbol spans
and caller return offsets match. The log lacks a runtime module hash
and the raw RX descriptor, so those cannot be independently verified.
---
 drivers/net/wireless/ath/wcn36xx/txrx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
index 8826998797d6..fc371963510f 100644
--- a/drivers/net/wireless/ath/wcn36xx/txrx.c
+++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
@@ -286,6 +286,9 @@ static void wcn36xx_update_survey(struct wcn36xx *wcn, int rssi, int snr,
 		idx = wcn->hw->wiphy->bands[NL80211_BAND_2GHZ]->n_channels;
 
 	sband = wcn->hw->wiphy->bands[band];
+	if (!sband)
+		return;
+
 	channel = sband->channels;
 
 	for (i = 0; i < sband->n_channels; i++, channel++) {
@@ -295,6 +298,9 @@ static void wcn36xx_update_survey(struct wcn36xx *wcn, int rssi, int snr,
 		}
 	}
 
+	if (i == sband->n_channels)
+		return;
+
 	spin_lock(&wcn->survey_lock);
 	wcn->chan_survey[idx].rssi = rssi;
 	wcn->chan_survey[idx].snr = snr;

---
base-commit: af32da41b0327b9c6a37856ba82b6760d6c8d10e
change-id: 20261018-codex-wcn36xx-survey-upstream-a3560402fc91

Best regards,
--  
Zhaoyang Li <heliolee0118@gmail.com>


