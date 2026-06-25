Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B11C3DDDA8;
	Thu, 25 Jun 2026 12:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389427; cv=none; b=pqjngWpotIaBCfjCPK6W3P4ZT94R63RQpbGXP7PEzThnqRA9olX8CoIc19tjRv5Mg+SE+CnBW5/q0GSdKD2fsR7SVLDkW17gMYwzK7Oe7IXS64nBcy4CMuVVpClND1UJWDSyyu9hUCOqT8DAttvOF186gigmrPMawSyV54w8TvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389427; c=relaxed/simple;
	bh=aEqGl/t2oeE3z5GCNLJYJ3vk5L2f28hG2tdsN4d5BLI=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=klJbIGnNZOzjkP2VE5/xFeWixqXYsDq/OCuB9W8J+B2h23SGFFqvABKYZbLdiAt/EaVYGZgao92OOXj9bxM6EgtPVQfHuhpR52j7u6IVyVEO5+vxELCAgd34NQ/3tOy7DLawT26aaqzAR6lPaOyTyjG2RNH9OEalP9ikv3SPOMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qS4jsola; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qS4jsola"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 150BCC2BCB4;
	Thu, 25 Jun 2026 12:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1782389427;
	bh=aEqGl/t2oeE3z5GCNLJYJ3vk5L2f28hG2tdsN4d5BLI=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=qS4jsolariue/Qa5Yhu/dzHltsP3icGVPnQ4OcO2wQdkYLCDeC0SrPcTo/OawaO3u
	 qFC5xGZVAsARGHikM+dk528euNhbeLaMwgoO4bOWLVN4VBzWp6KCI6faaFRSPtP7ML
	 3zfN1q2i1E5RIZiRsvVOqd9CW5JK4syGKlMnuO92FuKDy/6P23cwF0xGoMPwjKw3BK
	 8+mo+Z9vui1DDdbGuoa8P84GOWrva4CECt8pJo8VS06Uurkmf/gNY3i2YoBv7r/EOm
	 5TrEZjd01D23FkSr9PfEhoXXPTpdRgBrq5UsUZMA+ajYSrm/fpBDslVnFWIbZmyG8O
	 qNgaUp7O13KSw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED9BCDB479;
	Thu, 25 Jun 2026 12:10:26 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH 0/2] wifi: mt76: bound the device-reported EEPROM address
Date: Thu, 25 Jun 2026 07:10:25 -0500
Message-Id: <20260625-b4-disp-16f99062-v1-0-aee52ecf61b9@proton.me>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALEaPWoC/x2MQQqAMAzAviI9W9iGVuZXxIOzVXuZsoEIsr87P
 CaQvJAlqWQYmxeS3Jr1jBVs28B6LHEXVK4Mzjgy5HoMHbLmCy1t3leDhpkseQ5+CFCzK8mmz7+
 c5lI+pfRdiGIAAAA=
To: Lorenzo Bianconi <lorenzo@kernel.org>, 
 Ryder Lee <ryder.lee@mediatek.com>, Felix Fietkau <nbd@nbd.name>
Cc: Sean Wang <sean.wang@mediatek.com>, linux-mediatek@lists.infradead.org, 
 Shayne Chen <shayne.chen@mediatek.com>, linux-wireless@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782389425; l=1450;
 i=hexlabsecurity@proton.me; s=proton; h=from:subject:message-id;
 bh=aEqGl/t2oeE3z5GCNLJYJ3vk5L2f28hG2tdsN4d5BLI=;
 b=WbuVeuUOSSAzABLV05jlMQnSZpj/raKBFDPyhwD8be073heZMHbwiVoYI6fAQpTaqNsazavWJ
 23UyCJqyU2hAq4LnYOQK+5yYicaiaORXEMLHfn0uQiomcyovRq4UWmY
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=dmppBMZNLLoPzxHi9l8tZDzEZUunPbgsYqIZYXeUrL0=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/proton with
 auth_id=814
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

Both mt76 get_eeprom handlers copy a device-reported EFUSE block into
dev->mt76.eeprom.data at an offset taken from the MCU response (res->addr /
event->addr, a device-controlled __le32). They clamp the copy length but
never the destination offset, so an adapter that reports an out-of-range
address drives an out-of-bounds write past eeprom.data -- 16 bytes on mt7915,
up to 1024 on mt7996. Both patches reject such an address before deriving the
pointer; a device that echoes the requested in-bounds offset is unaffected.

It is adapter-side only -- there is no unprivileged user path -- so this
hardens against a malicious or compromised device, not a remote attacker.

An out-of-tree KASAN module that reproduces each handler's destination
arithmetic faults the unpatched path (slab-out-of-bounds write past
eeprom.data) and runs clean both with the bound and on an in-range control.

---
Bryam Vargas (2):
      wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
      wifi: mt76: mt7996: bound the device EEPROM address before the EFUSE copy

 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 11 +++++++++--
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c |  9 ++++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)
---
base-commit: 502d801f0ab03e4f32f9a33d203154ce84887921
change-id: 20260625-b4-disp-16f99062-0dd6169db97b

Best regards,
-- 
Bryam Vargas <hexlabsecurity@proton.me>


