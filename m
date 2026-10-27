Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.203
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793131090;
	b=Q0FGwDg92/LjyTrf+/5mb09zd/D6asbF5S7dIm8vj4iinuBdb5ehWP2z/TrHi5x4nfPO
	 1M3sqjGteraTAkEN48YuEHKG58KyR8ZPkY0mwqOoNkUMiovaulROcstpgJYl5fWqzK4WY
	 4wNViXk7IEYufqW0axT1NdnaUGphHTkwm9dz6xBiCZ9k9RrnuT+4hPiQUgS7tOfm1GzUp
	 FlXkA9iTlUUPZcrDnpvB9oxdNs+HSfd6GdKZ+98wQc74PcHsWILpkxD0VRFYwNuN2KKoo
	 BOIlBewOHoJrj1i8uOtI7GbwoWNyMVDb8n4ZxwcLt7yAGEKIJnMoAyFdRhtRgKcNfXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793131090;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=cJlwniNIJ0xDoWOsli3cb6MLnfn7HwEBdaBmsbX5UP4=;
	b=R6htaQmnByLk0tXLw1rwoMFGtsMfBVVCCBrSG8SDKB1xjuqoxDWEZQnQdUk3rlnEjreu
	 iW7zEnuqrJUZ+x/TVeMqC4QG0XQfvYSyXbo+ty/ON7v9wo72LN9O8ynovSbVMW4f0DqMg
	 WUfEYpPHOcOwXvalGFxcTvQmYpOHaOvR5WXYqSyJgLNi7n6NWBtM85uU3Q2f56CO54ygb
	 PoJpAcx8KWsWuL/c9ayhjsNy4FKPSkqUSJilmilOzR+XVBnQpa1LOlykdQ8YQQ2V7hJRy
	 5ErfcOQgdi3sCtbPflwgA605d5lggHfQ6SStwWh7Jky2rZWTtetPfcjdrid5O7filcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=justthetip.ca;
	spf=pass smtp.mailfrom=justthetip.ca;
	dkim=pass header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=VoKI9kGO;
	arc=none smtp.remote-ip=91.218.175.203
Received: from mta0.migadu.com (out-203.mta0.migadu.com [91.218.175.203])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDAB1606A31A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 19:58:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDAB1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=justthetip.ca header.i=@justthetip.ca header.a=rsa-sha256 header.s=key1 header.b=VoKI9kGO
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6ZXRmxti2ps4BKs1nT0dZJAbH3VLUW48J2CzoUJpFrU=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793131086; v=1; x=1793735886;
 b=VoKI9kGOLKUgH3r4mJg5XJR2IwRqtY1D0510c0CenSUhc+bwzMIAriNQX6cruHVeJdTPgt0A
 cQ/gG/fjqdk7EZOJO1ggRJcB7w/klUaxljtYTjPvmivQ8DXcI/6MU+e84iNZeoux4hEa0vYwmCi
 RTYrC3t3kzX80tGkTt0zEX/pThlrdwh50eHS8bpXN0eKTHQ8JJt4OBIDCrBx02SKoMR8GWv7+dW
 mC2P+L1Ed8HZTcGdHvRpgV4/KhqapKz36lPjywoBDv20Omz1Bo2FhImxZYqYUb2Glp1wKxQtYOk
 qct1Ct+762v0a6HQ57bw6yuMkYHP+50ZO8QE4SCcD6UzA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c273b73cd2621e85;
	Tue, 27 Oct 2026 19:58:06 +0000
X-Mizu-Trace-ID: c273b73cd2621e85
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>
Cc: Deren Wu <deren.wu@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Mark Anthony Agarro <markanthonyagarro@gmail.com>,
	Alex Gavin <a_gavin@icloud.com>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH wireless 0/4] wifi: mt76: mt792x: make active monitor work
Date: Tue, 27 Oct 2026 12:57:59 -0700
Message-ID: <20261027195803.711995-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
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

Active monitor on MT7921, MT7922 and MT7925 never gets a channel, and
since 7.3 every mt792x refuses it.

Patch 3, Mark's change from the morrownr/mt76 tree, passes every mt792x
monitor to the driver as its own vif, as MT7927 already does. Patches 1
and 2 keep the sniffer armed for such a monitor, and patch 4 offers
active monitor again. This replaces the revert I sent in September [1].

	active otherbss monitor, channel 6    stock      with the series
	MT7921AU (USB)                        refused    87 beacons, passive 87
	MT7922 (PCIe)                         refused    88 beacons, passive 86
	MT7925 (USB)                          refused    87 beacons, passive 87
	MT7925 (PCIe)                         refused    88 beacons, passive 88
	MT7927 (PCIe)                         refused    86 beacons, passive 88

Passive capture is unchanged, and on MT7927 it now survives a scan.

Patch 1 needs 180b57e3a455 ("wifi: mt76: bypass DPD on a scan channel
while a monitor is active") from mt76, not yet in mt76-fixes.

[1] https://lore.kernel.org/linux-wireless/20260903200947.27051-1-lucid_duck@justthetip.ca/

Devin Wittmayer (3):
  wifi: mt76: mt7921: keep the sniffer on for real monitor vifs
  wifi: mt76: mt7925: keep the sniffer on for real monitor vifs
  Revert "wifi: mt76: mt792x: do not advertise active monitor"

Mark Anthony Agarro (1):
  wifi: mt76: mt792x: pass monitors to the driver as real vifs

 drivers/net/wireless/mediatek/mt76/mac80211.c |  5 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 -
 .../wireless/mediatek/mt76/mt7921/debugfs.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7921/main.c  | 82 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7921/mcu.c   |  5 +-
 .../wireless/mediatek/mt76/mt7921/testmode.c  |  4 +-
 .../wireless/mediatek/mt76/mt7925/debugfs.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt7925/main.c  | 70 +++++++++++++++-
 .../wireless/mediatek/mt76/mt7925/testmode.c  |  4 +-
 drivers/net/wireless/mediatek/mt76/mt792x.h   | 10 +++
 .../net/wireless/mediatek/mt76/mt792x_core.c  |  6 +-
 11 files changed, 167 insertions(+), 24 deletions(-)

-- 
2.56.0

