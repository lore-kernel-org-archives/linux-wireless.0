Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2784307B0;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790343824; cv=none; b=HhMATqIE7bFfDUd5DB0yXykIwNcT3jMb7AvpgLv1Fj5fzXPWTpHz1xdGQfNbD/elrjyaVgc2RFz4422K7g43B+mJmzX5IG4UltiCzI28mxW/Ap/Ei9HKpnMNim+dhL3N6u+q0n43IfsQTU9G8a/3AjNvpQU9HHbV6kgRk6zwXQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790343824; c=relaxed/simple;
	bh=hCHNhpZCWra1r/DrLKqWKcWkonKIfvGCszV9uibmQrY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FiAFoBBre9FU8yOi0blibf1C5cZf8uxqe3RP7P42S5pT2k0hV/FrsmieyzgQGMWCoJfuDrbxkKDo2ivoTiW6J1xM5T1f1Ov7haun/1CnD75PSUd/L8voItacqYtGyySRIVQFr9vgUXtvgFXZLqDZ7cauVSLAFBMjcRfVldmnC08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HF5ddClk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HF5ddClk"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1437EC2BCF7;
	Fri, 25 Sep 2026 13:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790343824;
	bh=hCHNhpZCWra1r/DrLKqWKcWkonKIfvGCszV9uibmQrY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HF5ddClkoqSQUKiKsEASQxT5wjJIrok33raFxwXkH6oESL85N4yOtkjtrmBMLgSIh
	 nFVK4HCRRyX7bHP9OFbiMksLylibYZ6JxMHhCXV8WxQYnnLOqRqnevFlxWWsZBUJk1
	 IbybUjH5zfaAnyzYI7IKfg/g43PvMlAvM4atqY1w21XsZV32NmH+DWFQdiDZ77bIlO
	 YuSk6ATmVcFUJ7k0/7qHj+qynxmYQ8EcIcGPEb9g2FUVl1EGeShgiRxxSgThh66rc7
	 zHRdGrSGQQkXugLyqVsviKiiZ/u8oW2p1Yhx+Ioa+POjvsaRASzS+V3GQqhom/hzqK
	 uqNnIXC+hzxmw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7FB6C9830E;
	Fri, 25 Sep 2026 13:43:43 +0000 (UTC)
From: Michael Reeves via B4 Relay <devnull+michael.reeves077.gmail.com@kernel.org>
Date: Fri, 25 Sep 2026 23:43:36 +1000
Subject: [PATCH 01/13] wifi: brcmfmac: pcie: Report the detected chip ID to
 the bus
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-brcm4388-submit-v1-1-b5cbc2cde2fb@gmail.com>
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
In-Reply-To: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>, 
 Pieter-Paul Giesberts <pieterpg@broadcom.com>, 
 "Franky Lin (Zhenhui)" <frankyl@broadcom.com>, 
 Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
 brcm80211-dev-list.pdl@broadcom.com, asahi@lists.linux.dev, 
 Hector Martin <marcan@marcan.st>, Daniel Berlin <dberlin@dberlin.org>, 
 Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org, 
 Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org, 
 Michael Reeves <michael.reeves077@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790343821; l=1357;
 i=michael.reeves077@gmail.com; s=fedora-20260918;
 h=from:subject:message-id;
 bh=xo79Yb7vk30hMCoIaipAzSFT9Tjr7JBPILevEoBadDU=;
 b=SI7IoQQUeVjnhBrbBG/gkpR9+TXFKTA/GE1/rM/SO/XsXOA7LZeYRdy2pdC+o6DqLeLar+8HQ
 QM3bJxTSuorC+WRkUr3fUPqgPddJ/j6WDSn5YvrObRzBwLaS2UgIi5f
X-Developer-Key: i=michael.reeves077@gmail.com; a=ed25519;
 pk=VJ0TvyQ9TvfzYZa908YSE9kpkjFLLD5luv0bERu+boc=
X-Endpoint-Received: by B4 Relay for
 michael.reeves077@gmail.com/fedora-20260918 with auth_id=1035
X-Original-From: Michael Reeves <michael.reeves077@gmail.com>
Reply-To: michael.reeves077@gmail.com

From: Michael Reeves <michael.reeves077@gmail.com>

The devinfo->coreid field is never assigned, so bus->chip remains zero
and chip-specific feature checks cannot match. Assign bus->chip from
devinfo->ci->chip, which contains the detected chip ID.

Signed-off-by: Michael Reeves <michael.reeves077@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b970..5d84526c96 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -342,7 +342,6 @@ struct brcmf_pciedev_info {
 	u32 ram_base;
 	u32 ram_size;
 	struct brcmf_chip *ci;
-	u32 coreid;
 	struct brcmf_pcie_shared_info shared;
 	wait_queue_head_t mbdata_resp_wait;
 	bool mbdata_completed;
@@ -2518,7 +2517,7 @@ brcmf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	bus->bus_priv.pcie = pcie_bus_dev;
 	bus->ops = &brcmf_pcie_bus_ops;
 	bus->proto_type = BRCMF_PROTO_MSGBUF;
-	bus->chip = devinfo->coreid;
+	bus->chip = devinfo->ci->chip;
 	bus->wowl_supported = pci_pme_capable(pdev, PCI_D3hot);
 	bus->fwvid = drvdata[id->driver_data].vendor;
 	devinfo->fwseed = drvdata[id->driver_data].fw_seed;

-- 
2.55.0


