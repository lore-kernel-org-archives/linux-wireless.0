Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757DA314D13
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 04:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865090; cv=none; b=MzXcOqUm/rlOX0Bv2uXl6CHxdZnVY1k8NUV4wZF4oGbv94IBe9ThOiUHpb/WezFfoiDHy0skZTFhb128L1Ek0hN0lOBcdE2f7Maz8HN6NnlsV7ZXGXHUxws/UujIJp0rZ7cH24qqUC+yibDJqI0vRG0pQKLQ9HW8nlEinrbOiy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865090; c=relaxed/simple;
	bh=D2/0lUVxr1EU7IvTNII6oaXLpTOYspl0xBukRl/a6dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV/Fkz6OTbrlqpctewl/oP3HWzFlJaCIHYv33dgp31CWHS9JxB7Z6R4frktxK/FqOOAKjsMdk0mppfKjdMD+sX90nUuKVJ5g2VylSFfV7lhj7okofd9IIiaw2lC4Y3A+b6S3pFt2h+V9yKGcy3ZVXd3rLSzJbvcQZPeVljeB9K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=SpVBdDrK; arc=none smtp.client-ip=91.218.175.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="SpVBdDrK"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=D2/0lUVxr1EU7IvTNII6oaXLpTOYspl0xBukRl/a6dk=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791865085; v=1; x=1792469885;
 b=SpVBdDrKRqwocXfuZ9R/Nuto5Egl/rin4C+ZqdRk3hvzcgP5XxQ1c2p1md+BelA1lveiCFZz
 RsJzrj4FkGKg5Kf/qjOz4kPa/JMC6DHjYEGPL7RU8+owIL+x798K9w33RIvifAx7pC+ZAWB/2xe
 S9Eyngpn4kXnAyb5sCUvZVRdWyKYvOCijyF63C3WXpixOmvnMQucNz7JKC++EPvb9+vclCU1yHy
 NTQksU9D9cPa4wTJ6yH99irsN8eM5s1s3PZymFl9nyi5On0Ev2VQTABbNsfKCKwu1yTlwBXGlB8
 z/FWsT1Fc+ZuQpAB5q7ECoEw6zPnLHPSrG/akKs7HM4tg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id cafda22c2f51ead9;
	Tue, 13 Oct 2026 04:18:04 +0000
X-Mizu-Trace-ID: cafda22c2f51ead9
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Eason Lai <eason.lai@mediatek.com>
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	kun.wu@mediatek.com,
	deren.wu@mediatek.com,
	Sean Wang <sean.wang@mediatek.com>,
	quan.zhou@mediatek.com,
	Ryder Lee <ryder.lee@mediatek.com>,
	leon.yen@mediatek.com,
	litien.chang@mediatek.com,
	jb.tsai@mediatek.com,
	Jeff Hsu <Jeff.Hsu@mediatek.com>
Subject: Re: [PATCH] SER: mt7925: race condition in mt7925e_mac_reset allows compromised WiFi firmware to trigger host sk_buff use-after-free
Date: Mon, 12 Oct 2026 21:18:01 -0700
Message-ID: <20261013041801.268294-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261012032657.58631-1-eason.lai@mediatek.com>
References: <20261012032657.58631-1-eason.lai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 12 Oct 2026 11:26:57 +0800, Eason Lai wrote:
> -	mt792xe_mcu_drv_pmctrl(dev);
> +	__mt792xe_mcu_drv_pmctrl(dev);
> +	clear_bit(MT76_STATE_PM, &mphy->state);

Eason,

A heads-up, since this one is on me: my d12a54be2604 in mt76 changed
the line this patch replaces, so it won't apply there or on
wireless-next as is. That commit makes the reset return early if the
driver can't take ownership back. If you want to keep that, it would
look something like:

	err = __mt792xe_mcu_drv_pmctrl(dev);
	if (err)
		return err;

	clear_bit(MT76_STATE_PM, &mphy->state);

Devin
