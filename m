Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58110315D3E;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772708857; cv=none; b=qrsQI0lgYqZtMIkgkxQzi2vtZBpVsvHIvciLzSOQ4tXUuvVnR0Xks/Lvpw4PI8l8NJm4cfAsaK3607ZPU7EkIW/9iRd2SpW8bFx4hFhYZmWyslxVST4j8hkCWxSTwQ26r0GpnckUn6OZLJ8ip0hH1K0c73Sr879UMSIY6ackF/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772708857; c=relaxed/simple;
	bh=I5RTqGWF/smyis5LMKbxrhcgEnu87Neuhp9zkbzeYso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cPmIpQ3HCR4i2XXnYSbobrBvGDrzVx9yW1mlP93FtIKfgjtrbAV4VTPIclElPMNy6elXpNoTAHikt+37DtGTF5FaJfTH7PavSX9+XUMJX9LAvcFBoHZjGJkIZpkPRg70eCqxOaLaQmgDkN/VGUUeXnQKkwYCmCfuyOk0FAC671Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0izhF7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0izhF7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B2DC2BCAF;
	Thu,  5 Mar 2026 11:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772708857;
	bh=I5RTqGWF/smyis5LMKbxrhcgEnu87Neuhp9zkbzeYso=;
	h=From:To:Cc:Subject:Date:From;
	b=m0izhF7NZIUTHemtibMTa/cTfPgcBtL4GDtsE9+iy1DrEcfyt1ENp41nxXCBo6knY
	 NK2HHympxmTODd2M1Ey1FtVATSDjVnkD40irn/uwDcjgKTm73niSY/Sh8r3XYz9J/m
	 qpmWDkVYS8pPskm8yleukOmMcSKhqDpP0bZAgYAcIY8LH6kCDLJGElqM/26G/Fwd7U
	 qcDZUdH+zg9U4oqaiOdzsrEC6Ca+sUkPeOnRoT1aO2yUXhIoyn+/NwZUFlZZnxstDT
	 jWGODikHErVsSEqA9q6tO3mubh51Qd00wi/8lbpEQavSmJjFgc8p4CbF6Yhghlr2C2
	 yohFTCLebN/Mw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vy6YI-000000004cl-2KZE;
	Thu, 05 Mar 2026 12:07:34 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 00/13] wifi: drop redundant USB device references
Date: Thu,  5 Mar 2026 12:07:00 +0100
Message-ID: <20260305110713.17725-1-johan@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

Drop redundant device references to reduce cargo culting, make it easier
to spot drivers where an extra reference is needed, and reduce the risk
of memory leaks when drivers fail to release them.

Note that I sent an ath9k patch separately here:

	https://lore.kernel.org/all/20260305105803.17011-1-johan@kernel.org/

but I guess these can all be picked up by Johannes.

Johan


Johan Hovold (13):
  wifi: at76c50x: drop redundant device reference
  wifi: libertas: drop redundant device reference
  wifi: libertas_tf: drop redundant device reference
  wifi: mwifiex: drop redundant device reference
  wifi: mt76: drop redundant device reference
  wifi: mt76x0u: drop redundant device reference
  wifi: mt76x2u: drop redundant device reference
  wifi: mt76: mt792xu: drop redundant device reference
  wifi: mt7601u: drop redundant device reference
  wifi: rt2x00: drop redundant device reference
  wifi: rtl818x: drop redundant device reference
  wifi: rtl8xxxu: drop redundant device reference
  wifi: rtlwifi: usb: drop redundant device reference

 drivers/net/wireless/atmel/at76c50x-usb.c          | 12 ++++--------
 drivers/net/wireless/marvell/libertas/if_usb.c     |  3 ---
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |  2 --
 drivers/net/wireless/marvell/mwifiex/usb.c         |  4 ----
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |  3 ---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  3 ---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |  4 ----
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |  2 --
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c    |  2 --
 drivers/net/wireless/mediatek/mt76/mt792x_usb.c    |  1 -
 drivers/net/wireless/mediatek/mt7601u/usb.c        |  3 ---
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     | 12 +-----------
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  4 ----
 drivers/net/wireless/realtek/rtl8xxxu/core.c       | 11 +++--------
 drivers/net/wireless/realtek/rtlwifi/usb.c         |  4 ----
 15 files changed, 8 insertions(+), 62 deletions(-)

-- 
2.52.0

