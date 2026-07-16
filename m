Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8B82F3C3E
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 03:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172141; cv=none; b=tz+1R0Z5VnHLbjbXY/yh7xJIFoFLqDdJP6yYVe9IpSFb9DuoOaMIcXNJh5HBY9p+yHREb8rzn2rABk2aCMiOLrxu3ohCdj7d0waM1mo+E/si/sYw3lSIn67EWS5KUsDP06iChyFg+s12AI/kkGIZt9DbOgEfH1dgahAWNTGdVk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172141; c=relaxed/simple;
	bh=lkvhAAS4asGFEFRStCcegM+2+0Uuq0pdKdbkfEXCgTU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=E5pzm3goxQwEsuRxQtsl2HpkOGWcFgZORi4XL5wP5b7A//ENfPKYiDLT9WkIliKKkH8ofhADzick3TO/MkGZcroY4drYneNxKldtx1aZr3EW/uEXpSA6hboDgs1Oi46b0kNzpyYLf7mlKJ0OpwrIoo9c8pHZvL3z1rdXfwVYJrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com; spf=pass smtp.mailfrom=tenstorrent.com; dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b=b2gMS7Ed; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tenstorrent.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tenstorrent.com header.i=@tenstorrent.com header.b="b2gMS7Ed"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-81e86df8987so84814747b3.3
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 20:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tenstorrent.com; s=google; t=1784172138; x=1784776938; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=32tsfE8uTtDxzdpxN/nRKCIyJZygTroSQ6UN8Ha/aFo=;
        b=b2gMS7EduzM/txmT8wVo3U8H0L+w7r0mI12qb7b2JJyu/bM4PQ0QWg4H/K5eg9MtLP
         7GYGhdUs9c82DIT2/fPKUhGUy9mn3C7D9YnEWXfqaLVgxUwng3gg6lewsWlkb6XgFlkP
         5VIIPors4kqx6RVQ+WiEVVyKbpL/YKjQWtw8DVfqOVsUdzrR+jc2Y2Zm5hHNJ0uU3pUL
         aWnqEEom8geChV5ep0dcD4m/T53HxbHu/ZIU4gF4QkCpHGoqae2gD5cZZ7pBbyjk/olT
         dZTXglljdYP/upNvTa4m4XmplD8q3AEwT3gpG23QHAWvUwAonQkn8akPfjJMINOvnxR1
         vDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784172138; x=1784776938;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=32tsfE8uTtDxzdpxN/nRKCIyJZygTroSQ6UN8Ha/aFo=;
        b=XzRPZihawVVvltunmDvSF9ktIMwJ4o28Q2nSf0XFt2UAHoYYip8HE0JEk+g0HjU61j
         At5nsuwNSM7IeK3P9acTLYXjho7iwwhR9c5ZfJ32df5YeqOUJKEwLWc+XKcB0v9PaM01
         2gQXClyq/IY8aVa0nZBPxdslEeQIwd02INlC5DbbdIS9Vr99vLjOtGT8yHPIPdqJscCz
         cwgXLWAsU9kyAHZDLsZX6IhQ4Mfxmj8RwAsPfaLfOsSwyBKHkpYoAR2G/jc179xBc9U2
         4MelGGHz+lRPcyhIh1FjFkJb0xLNSDvNnhH3HnXYBqxh2+slMtDCO3pGSy9bOuVRgEXy
         3cVg==
X-Forwarded-Encrypted: i=1; AHgh+RrE26JseQ+7lHwTJRWuzOAPukVkq5t/C0lf6V/lTHHfqR+MElEdJzBuyk7w+Aa8neE/FbCan16exWv4onjbgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQtQ1oM0KtihUFtykubfAZhGduCvG6YPEp7RnQhKYUvTje7oL6
	Z+GSuXuCQogsjoIdt4JjG5pU+StxtIRSBJja/E4egZkc6O/+3Xa19jj/76Lf2nrwdss=
X-Gm-Gg: AfdE7cmDD9zeVrodt8y7ONLEqBWqKCYy2r31C2eWhNZObixkbNbddfkYc4tjH1wuuou
	Oc913HJDd4zAyIPH488JWYiI0DFjzws4TtM0TnSZdU1b8SK06PWxWFTuyRyo7asPGRRNaJubAgA
	qIWMBqeHbmp43J75tNKfnB9b8n66gyQQza6m/RssCn82HjOmnh/7vlrsqZnL6lMxshM8w5rllyS
	OC7EjvACDQVSTMWBN70zGG4QXLwq1IoO9WhfXJyLZn8ClUkc+FC4iYckztIMMCtJuvHSxwScnto
	06HM5wXteLWBxmM3vma5i1q9q/jrW8w64xe36XPuim68tbpCdWg8nNAwR79dlglbmKxjP/u4Gcp
	YbbH6wEkFDaFSSYu1GOQtwsDERKFB0NL2DPm5nFm+M2Z/qVIiv2t26gKxJrKvd4pb78+RWkCvCW
	zEdfwUYdBq/wPivSXRtUsCYK06EZBbXY/1qSc8IU36I57Wob4ww2twB2ddjQ==
X-Received: by 2002:a05:690c:22c5:b0:80c:85e5:8751 with SMTP id 00721157ae682-81ecfa9075amr49331957b3.58.1784172137811;
        Wed, 15 Jul 2026 20:22:17 -0700 (PDT)
Received: from [192.168.2.129] ([2600:1700:220:59e0:56e1:f9cd:8869:2218])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6befb688sm185039127b3.14.2026.07.15.20.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 20:22:17 -0700 (PDT)
From: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
Subject: [PATCH 0/2] Enable WiFi on Spacemit K3 Pico ITX
Date: Wed, 15 Jul 2026 22:21:53 -0500
Message-Id: <20260715-rtw89-spacemit-k3-v1-0-e577bc63706b@oss.tenstorrent.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFJOWGoC/y2OQQ6CMBBFr0K6dkhbxAoxxnsYFqWOMGoBW0ATw
 t0t4G5e8v/7MzGPjtCzPJqYw5E8tU0AsYuYqXVTIdAtMJNcHrgSKbj+c8zAd9qgpR6eCehEmUw
 pUSYmYaHXObzTd3Vei439UD7Q9Ivon3D4HsJYv8WYRe/1OpZHp22LZ3zPuVRxlh7DAQKoaU1N2
 upLZTW9YtPa86IrtUcIEP7Jo1HFEpwRrJjnH09nhv3eAAAA
X-Change-ID: 20260715-rtw89-spacemit-k3-a37c9771b3c3
To: Bjorn Helgaas <bhelgaas@google.com>, Yixun Lan <dlan@kernel.org>, 
 Ping-Ke Shih <pkshih@realtek.com>, 
 Lorenzo Pieralisi <lpieralisi@kernel.org>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Inochi Amaoto <inochiama@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, spacemit@lists.linux.dev, 
 linux-wireless@vger.kernel.org, 
 Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
X-Mailer: b4 0.15.1

The Spacemit K3 Pico ITX has a RTL8852BE Wifi card attached via PCIe.
The probe for the rtw89 driver currently fails because driver tries to
allocate a kernel page with GFP_DMA32, and this board has memory only
above the 32 bit range. The rtw89 driver has the ability to use 36 bit
DMA addresses, but this is only enabled for certain PCIe bridge/rootport
that have been validated to work on. Enable this ability for the PCIe
root port. A similar patch seems to exist in the vendor kernel tree.

To test this, you'll need the 3 patch series adding the K3 PCIe RC
Driver[1], K3 PCIe Phy[2] and K3 PCIe DTS[3].I have marked only [1] as
a depedency in b4 because this series doesn't depend on [2] or [3] to be
applied cleanly.

Inochi, Patch 1 could be potentially be merged in with your series [1],
any thougts on this?

One question I had was about whether the IOMMU on the K3 could be used
to do DMA mappings and allow the wifi card to work with a 32 bit virtual
address. The K3's IOMMU isn't supported currently in the kernel DT. It
seems to not be enabled in the vendor kernel too. Even if the IOMMU was
enabled, I'm not sure if it would help with this exact problem. The fix
proposed in this patch works to solve this problem, so I've sent it to
the list.

[1] https://lore.kernel.org/spacemit/20260709040027.958400-1-inochiama@gmail.com/
[2] https://lore.kernel.org/spacemit/20260703021024.495433-1-inochiama@gmail.com/
[3] https://lore.kernel.org/spacemit/20260709040415.977784-1-inochiama@gmail.com/ 

Signed-off-by: Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>
---
Anirudh Srinivasan (2):
      PCI: Move Spacemit vendor and device ID to linux/pci_Ids.h
      wifi: rtw89: pci: enable 36-bit DMA on spacemit K3

 drivers/net/wireless/realtek/rtw89/pci.c      | 4 ++++
 drivers/pci/controller/dwc/pcie-spacemit-k1.c | 4 ----
 include/linux/pci_ids.h                       | 4 ++++
 3 files changed, 8 insertions(+), 4 deletions(-)
---
base-commit: 728e68a889bcf257b1e67298b12c360e5c3a13e0
change-id: 20260715-rtw89-spacemit-k3-a37c9771b3c3
prerequisite-message-id: <20260709040027.958400-1-inochiama@gmail.com>
prerequisite-patch-id: ab02c35a752a1e8f0fff9bc06ebcf8961afef933
prerequisite-patch-id: e7cececa9950600cfeee3dc6d73d6c3a7cc16f32
prerequisite-patch-id: 49ba2fa5aa2d2069b8d857bbda6cc4813bfc015f
prerequisite-patch-id: f33c229b37442babb1289af29a33fd2a222304f0
prerequisite-patch-id: c91a780415fe64f11fe921761d213634d042fac7
prerequisite-patch-id: b2bbf0fe6a7d90be354bb266d311982ead5a0e6d

Best regards,
--  
Anirudh Srinivasan <asrinivasan@oss.tenstorrent.com>

