Received: from gmmr-2.centrum.cz (gmmr-2.centrum.cz [46.255.227.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864E7243956;
	Sat,  3 Oct 2026 19:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.227.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791055894; cv=none; b=Z7K2VH6HmAq/+3KHBxf8KaeNL9pfti67y/iKWp5C7RHoerq4XioxJzPFGfHj+AKkjC29hTlg2twrajYctNgbHtF1Fu34RrcRc7M/bGwDfGnwKBegn6I6trWNPtgJ1pD3B0g/3NguHW/bEAGxIT+s5+RFb0EBe0ahAuM9ZN3nJcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791055894; c=relaxed/simple;
	bh=C8O7C4mU/2FJCQaMZkUD+IgUBJeu99FdrfkdAWBHeI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tuJQ7uShujvMKkRNCZcxb7U6AEk2O7NtPVaUMnq22+ujHUrBOyrQDu99h/Mvmgh11rVRqS9T7sLuhZ9ZwQb4Vr9fwrx1cgifGvOptSl4CxC7qN57AH84njkqPny5uc92QPuG0FCjcqyXml5xp2kg+Ux6/9cMeWEsUlN8V4gSveQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk; spf=pass smtp.mailfrom=pobox.sk; dkim=pass (1024-bit key) header.d=pobox.sk header.i=@pobox.sk header.b=M7LlcNC3; arc=none smtp.client-ip=46.255.227.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=pobox.sk header.i=@pobox.sk header.b="M7LlcNC3"
Received: from gmmr-2.centrum.cz (localhost [127.0.0.1])
	by gmmr-2.centrum.cz (Postfix) with ESMTP id 1550020134C6;
	Sat,  3 Oct 2026 21:30:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.sk; s=mail;
	t=1791055812; bh=tMnLU9EVM3DULBNW62ELlMHdk3OwyhiBJKi1ZFqcJAE=;
	h=From:To:Cc:Subject:Date:From;
	b=M7LlcNC3R3z+x5oK1sUzhsDccrUX/4I6QeE9Nm9aK0eOZ4XllIx1risZjzqI9EA6H
	 IVSzwY+hg7Nmt3mxE37qKqOWvDxfuS+fcV2u3jtRdOczV5VJ/OG8NgNzFZxtXH5Gdn
	 /+0A5FGLkwELDU7QBWVO0a2z/gTsdYiS915/fy6U=
Received: from antispam61.centrum.cz (antispam61.cent [10.30.208.61])
	by gmmr-2.centrum.cz (Postfix) with ESMTP id 133432012696;
	Sat,  3 Oct 2026 21:30:12 +0200 (CEST)
X-CSE-ConnectionGUID: zn3PPNedQAyIuaSXji+y4g==
X-CSE-MsgGUID: 3fnxrRwIS7O5qkzFUfy1Cw==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2FgAgCaVsFq/0vj/y5agRKBR4JXgmGWS4EWimSSN4FqD?=
 =?us-ascii?q?wEBAQEBAQEBAQlRBAEBPgGBU4Jzjg0nNwYOAQIEAwIDAQEBAQEBAQEBAQELA?=
 =?us-ascii?q?QEGAQEBAQEBBgYBAoEdhglTjBoBhC0LAUYogSiDAoI6AQM3ul0zGgJl3H4WN?=
 =?us-ascii?q?RlmgWgBCxQBgTiNY3aDXYMqRIEVgTuBOHaECh+GXwSDLpVGSIEeA1ksAVUTD?=
 =?us-ascii?q?QoLBwWBZgM1EioVbjIdgSM+F4EHGwYFgR2BIIIWIxk2eoEJXoErKWABEBcnY?=
 =?us-ascii?q?oIHAoJUggACAUlBDgdFUwklRRJHJiIIEgkBExowC4EbODwJKEQXDBAYDUgRL?=
 =?us-ascii?q?DcVGQQ+bgeQUB6CXwFaNHwHOk1cQJJgk32fWgeEIYRznGkaM4FKljQDkm0Bm?=
 =?us-ascii?q?QikWoRpgX6CAE2DWlMZjj0Wz3t3PwcCBw8CkXM0gUwBAQ?=
IronPort-PHdr: A9a23:vflTrBIRWW/nh1oEVNmcuOdhWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCEu7M11hSZDdqKo9t/yMPo8InYEVQa5piAtH1QOLdtbDQizegwoUkLLfXBN3fGKuX3ZTcxB
 sVIWQwt1Xi6NU9IBJS2PAWK8TW94jEIBxrwKxd+KPjrFY7OlcS30P2594HObwlSizewb7J/I
 A+qoQnPucUbgohvJ6Q1xxDUvnZGZuNayH9nKl6Ugxvy/Nq78oR58yRXtfIh9spAXrv/cq8lU
 7FWDykoPn4s6sHzuhfNVQSA6mICX2sZjxREGwfK4g30UZf3qSv6q/Fy2DKGMs3sTLA7Qiqt4
 qF2QxL1kigHNjo58GbKisxsia9QvRysqwBjz4PSfYqYL+R1cL/DctwGRGpBRsdRWDJHAoOgd
 IsEEu4NMf9Fo4Xhu1cCqB2zDhSuCuzy0D9Fnn/407Mk3uo8Hw/I3wsuEN0BvnnPsNn4N70fX
 fyvwaXU0TnOae5d1zfn6IjPdxAsue+CXbV1ccXL0kkkCh3LjlKWqYzlJTyVy/8NvHaB7+F9U
 u+vl3Qrqx12ojipxscjkJTJhpkLxVDe7ih52IE1Ksa/SE90e9KkC5hQujicOoBrTcwsX3tmt
 zwmyr0ap5G7Zi4KxYw5yxPeZfKLbZaF7xbhWeqMLzl0mXxodryjixu98Uat1O3yWMaw3VtJo
 SdIjtbBuH4C2RDP68WKV+Vw8Em/1DuR0Q3Y9+JKIVgsmKfUKpMt2KA8m5oTvEjZACP6hkf7g
 LWUe0gk4uSk9ufqb7b8qpOBNoJ5iBvyPrkgl8G9G+g0LwgDUmyd9O+hzrPs51f5T69PjvAul
 6nZt43VKtoDq66iBg9Vzp4j6xGiDze6yNgYnWcILFZCeB+fgIjpPkjCIOv9Dfejm1SgjStny
 +raMbL/BJXNMmLDkKrkfbpn90FdyRI/zdFZ551KFrEMOP3+V07ruNDGDhI0Mxa4z/j5BNh/z
 I8TW2KCDrecMKzIsF+I4uwvI/OLZI8QoDv9N+Ip5+LpjX8/mV8SZ7Sp3YAJZ3CiBflmO0KZb
 mHrgtYOC2sKpQk+QPTwiFKeST5Te2qyX6Uk6zE9E42pEJzORoa2j7Ocxiu7GIdZZmVYBVyUC
 3fna52EW+sQaCKVOsJhjiYIVaSmS48n1RGhrhL6y6F5IerO4SAYrZXj28Ny5+zcjx0y7j90A
 9yH026RV2F0gn8IRzgu0aBjpkx9yUmM3LNkg/xfFtxc+elFXRo5NZLE1ex1F8jyWh7dfteOU
 FumRtSmATcsTtM+2tMOYFhyG8+kjh/d2yqnGKEVl7OVC5wu6K7c3Gb+J9x7y3nY0KktlV4mQ
 tFANWG+nK5w6xDTB5LVk0Wej6uqcaUc3CjQ9GaM1GaPskBYUBRuXqXBQ38ffVDWoM/n5kPNU
 bCuE64rMghfxs6YLKtFdNnpgU9BRPf5N9TSe2SxlHyoChaS2ryMdJbqe3ka3CjFCEUIix0c/
 XWHNQg7Hiqvu23QAzJwG1zzf07i9/Fyp26+TkAu1QGFc1Vs2aKs9BANivLPA88Ui7YFvjox7
 ip1Blu50snNI8SPqhAnf6hGZ945plBd2jH3rQt4a6CnKql5zmIZdQR+oljjzV0jFsNcls4qp
 W4xwRBaMaWS10MHbDDOjsO4AaHeNmSnpEPnUKXRwFyLlY/Oos8y
IronPort-Data: A9a23:/AB/zKxGDF3JMoQQBYJ6t+cqxyrEfRIJ4+MujC+fZmUNrF6WrkVRm
 DRODGqHM/zZNGP2etskOty0oEhVvJ6AyoNlHlFqrVhgHilAwSbn6XV1DatS0we6dJCroJdPt
 p1GAjX4BJlqCCea+lH1a+aJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYx6TSCK13L4
 4yaT/H3Ygf/hWcsajlMscpvlTs21BjMkGJF1rABTa8T1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+ZZk
 4wR6MPqGW/FCYWX8AgVe0Ew/yiTpsSq8pefSZS0mZT7I0Er7xIAahihZa07FdRwxwp5PY1B3
 e4ecwg1SB2Pvsun4a+ycdluh4cycMa+aevzulk4pd3YJfkjBIvGX72TvZlT0TEsnN1LW/3MD
 yYbQWYxKk6dPlsVYAhRV89WcOSA3xETdxVE7k6So6o+/nPe1iRp17LqIJzOebRmQO0Mwx7H9
 zyYpzqR7hcyb9KZ2SC/7VOX2ciShCDpdr8cBeST6as/6LGU7ilJYPEMbnO9q/WRjESyHdRWL
 kF80jZosa809EW2VdTndwW/qnmU+AUfM/JMFO43wB2KyaeS7wXxLmwFSCNRLd8rrsk7QRQ02
 VKT2dDkHzpitPuSU3313rOVqy6ifDcUN2IGaDQfZRUK7sOlo4wpiB/LCNF5H8aIYsbdRW+2m
 W3X6nJk2PNM0KbnypmGwLwOuBr0zrChc+L/zl6/sr6Nhu+hWLOYWg==
IronPort-HdrOrdr: A9a23:dykoJ6NHxuAIZcBcTtqjsMiBIKoaSvp037Dk7SxMoHtuA66lfq
 +V8sjzuSWftN9zYgBCpTnjAsi9qBrnnPYf3WB7B9iftWfd1VdAVLsD0bff
X-Talos-CUID: =?us-ascii?q?9a23=3ACpyyrGh3M3SpwbaukftBAkPUYDJuYHuG9E/2LkO?=
 =?us-ascii?q?BIHdIVbSueV2Ru7I4nJ87?=
X-Talos-MUID: 9a23:0kFdyQqh5uVzlmhtMJsez2psMtdy2buPMx8qzIwFqee5Oz0pECjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,138,1787004000"; 
   d="scan'208";a="150796606"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.227.75])
  by antispam61.centrum.cz with ESMTP; 03 Oct 2026 21:30:11 +0200
Received: from blackbox.p10 (188-167-137-159.dynamic.chello.sk [188.167.137.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id 833031011FBE8;
	Sat,  3 Oct 2026 21:30:11 +0200 (CEST)
From: Tomas Tonhauser <t.tonhauser@pobox.sk>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org,
	Tomas Tonhauser <t.tonhauser@pobox.sk>
Subject: [RFC PATCH] wifi: ath9k: clear destination mask for non-aggregate frames
Date: Sat,  3 Oct 2026 21:29:57 +0200
Message-ID: <20261003192957.761090-1-t.tonhauser@pobox.sk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Frames to stations without an A-MPDU session (e.g. non-WMM/non-HT
clients) use the non-aggregate path. If the hardware returns such a
frame with ATH9K_TXERR_FILT, ath_tx_complete_buf() reports it to
mac80211 as IEEE80211_TX_STAT_TX_FILTERED. For a station that is not
in powersave, ieee80211_handle_filtered_frame() retries it once and
drops it if it is filtered again.

The aggregate path re-queues filtered subframes on tid->retry_q and
sets tid->clear_ps_filter, so they are retransmitted until they get
through.

The result is downlink loss to awake non-WMM stations, while WMM/HT
stations on the same radio are unaffected. On a QCA9563 AP with
ESP8266 clients this caused 20-45% ping loss, with two TXERR_FILT
completions per lost frame and no XRETRY failures.

Set CLRDMASK on every non-aggregate frame. This restores the
behaviour from before commit 5519541d5a5f ("ath9k: fix powersave
frame filtering/buffering in AP mode") for the non-aggregate path
only. The trade-off is that non-aggregate frames already queued in
hardware when a station enters powersave may be sent to the sleeping
station instead of being filtered.

Assisted-by: LLM
Signed-off-by: Tomas Tonhauser <t.tonhauser@pobox.sk>
---
RFC: is this direction acceptable, or is one of the alternatives
below preferred?

Setup: TP-Link EAP225 v3 (QCA9563, 2.4 GHz), OpenWrt 25.12.5,
backports 6.18.26. Clients: ESP8266 running Tasmota, modem sleep
disabled, associated without WMM (legacy rates).

Ping from the AP to one client, 30 packets, 14 lost:

  station "tx failed":             +14
  station "tx retries":            +2
  ath9k/xmit BE "TXERR Filtered":  +27
  ath9k/xmit BE "MPDUs XRetried":  +0

A second run: 12 lost, Filtered +28, XRetried +0.

Ruled out:
 - Client powersave: PS_STA never set in debugfs station flags, and a
   monitor capture showed no client frames with the PM bit set.
 - airtime_flags=0, aql_enable=0, nohwcrypt=1: no change.
 - RF: signal -50..-64 dBm; a WMM/HT client on the same radio has
   0 tx failed out of ~10k frames; the same ESP8266 hardware behind
   an ath10k AP has no loss.

With the patch: 500 pings to each of five ESP8266 clients, 0 lost.

Open question: what sets the destination mask for stations that are
awake and never hit XRETRY? 5519541d5a5f removed an unconditional
CLRDMASK commented "needed for crypto errors", so the hardware may
set it in other cases too.

Alternatives:
 1. Set CLRDMASK only when the station is not sleeping.
 2. Re-queue filtered non-aggregate frames in ath9k for awake
    stations, like the aggregate path does.
 3. Allow more than one software retry in
    ieee80211_handle_filtered_frame() for awake stations.

Related: 26a64259b702 ("ath9k: improve PS filter clearing and retry
counting for A-MPDU"), 315c457ff123 ("ath9k: improve powersave
filter handling").

The driver analysis and write-up were done with help from an LLM.
Tests / measurements were done by me.

 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 3413bb4906d4..913aa280ae2a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1432,7 +1432,7 @@ static void ath_tx_fill_desc(struct ath_softc *sc, struct ath_buf *bf,
 			if (!sc->tx99_state)
 				info.flags = ATH9K_TXDESC_INTREQ;
 			if ((tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT) ||
-			    txq == sc->tx.uapsdq)
+			    txq == sc->tx.uapsdq || !aggr)
 				info.flags |= ATH9K_TXDESC_CLRDMASK;
 
 			if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-- 
2.43.0

