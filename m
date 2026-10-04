Received: from mail-pz2-f37.google.com (mail-pz2-f37.google.com [74.125.228.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E0941A919
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 09:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791106506; cv=none; b=WQXP8MqR7z4GtMVCou7mwOWENpBo9G2OeFA5hrHGoxPLuXGEHMAUhS9fa3pE/PSutoWZqoEJGP15COxbyA23cWhg+T0i7yWvKbMHV+p5wO6LlaZXA6s2kQxJwm+DJ4o4wZQAYAgOGnR28nq+VweQ856ywkqmagyNiOaphhxPq+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791106506; c=relaxed/simple;
	bh=aikge5rqCh9fEXUUNbYnhGiyZw4dNYu0LEjTmf6nS38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuGUm5qJpD/IJuaEBqEo3jEjBV0HGZy6mB92iVFrrSrVXgEDNaNLV94OLn4nmdLxMg3/g9MFKaDrUclgEcuRmUCuBLQDOJYVROm7swx/QhNRAjnL6GHApNL52Q48OOZTbgrpDkhhSGBKp4yJDKihdsPnlaJ3DkpGZjTLQfhsI0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j/qAEUle; arc=none smtp.client-ip=74.125.228.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j/qAEUle"
Received: by mail-pz2-f37.google.com with SMTP id 41be03b00d2f7-cc7c9c2df74so174673a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791106497; x=1791711297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XWhCgVGXv8fnJdT9/T5h6M5vyvD9nlGok0X53QPksxs=;
        b=j/qAEUleCZeodlPh5H8NNkGv3f9mKAzMX9oQWYCd1hCkL94FdVqJsru4Hl01S1yj5E
         hnQ2zxZ3ui1tSXvo4+JJ5n3NSX/vIIr4XGlWY1C776UKQvUcsjad/6qHntacptKpYwlS
         s2CxHerarPoacQbMH/xiWYyymiEH1uvcnY0PnDXTTuWQmmvOjGFqn54WxTwMvcwchyYv
         877y94dc1OH3OsPps5t3CwPu0i5HoecdTYp/4pCjS7Db3aYaYokc3WRZDCDW/z+sLaI/
         LAgRsgQG+W/otiLxHj15NFTBvYQEs+wtd0eN24LCqVDOGLpUuLuYDBKryWQQ9NSAqQ1v
         8E8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791106497; x=1791711297;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XWhCgVGXv8fnJdT9/T5h6M5vyvD9nlGok0X53QPksxs=;
        b=V0eTiZANVWOG+Eol644bNdBxot2J23G7Ahd6/knq+yO0mTR7vBd2tPJGs53LiIGwCP
         Spi+HHGg2X5kXLFiV/SBDHsy7qWCJIrVvHKfdZRvE4GxH7S0jnngBBANYZHcn9ooyZvd
         Vy7rYzLoRImDUWGwgnqPmzaWDgxDUGeSXKGm0thcWJlBKtxPF6VCRGiNq1WLiceBCD64
         DbbeXNRIH/uhqUMhzgCyw9JYA+2M/gSImawQP8kWWQH4VgWomFbEa4nEGqXYKcbDprcL
         khqtMGKOjROklCcDvtynzFKSCzbSCouePapHDQEu++m2nPvfW/TjgMcwFFh2ojcjKzfo
         C6/w==
X-Forwarded-Encrypted: i=1; AKwUvBwBsiNUXTqEu/DAp7a2WF3dPKI92ZeqtAapHXaXB9M/qvEdwdAQYaq9PUENO3167UoZtkDdsuCWoAxuP50Gdg==@vger.kernel.org
X-Gm-Message-State: AFuF++mtY8mbX5zKDS9X+k7hQ0HCicdOxVJwfrCv8ShM3U8g1n8Wdbp5
	isSEEWDOOFWpKuAc0fcHfTziVknnue0vGqp5tdSs2GeCJ4pxjEWx9x/R
X-Gm-Gg: AYBFou0dVWGHcN3Jc1+lXOG3WkWdPziq/VFA/dtumKs0+PyCw1sJS2lEt9eCetvm+2q
	m8yABAhYWQSC9eQZR2vgLLz0a6zVAHB/tvGaa2euyEG0nC+uhD/Bw86hNNxPcnxSxoD4EQ4f3nG
	ABnQRuvS1bcuNAGrbnekaIEA7w2FIA/WOyTGAWVQ4lMBNgQi7dP0zTYx+INcZc1r1ErAc74+/SB
	MJ1QAwOQa5GMd5LmFUMGkA0RiFHdS+rudVdj3CZMNrusP85H/gAO2Lm4LEl6zmyB8A+cFZcILXy
	gF0PQ2WqWVSzB6Sm+fAweSEDLLUF+B6PU25CVhogt7kzphyExdzGfHt7fGrvYNnavCXzjSTIcaq
	guzfJjTNBu03JCvYHVPbvtlaswZMf0SsxVQmXEguv12K3F81rgeWikvZVWjIJ2Ro3sZaeHMnFaI
	NLq9cXjw7dkRJjxQ7NIF59bblp5IwqgIdqpu/TFd23pEbYHibqatcWoAGw0kkiLssMJwNjYRre9
	nKjn9ZUAF6+Rg==
X-Received: by 2002:a05:6a00:4303:b0:886:95df:c50c with SMTP id d2e1a72fcca58-88af6c2b913mr4662570b3a.26.1791106497501;
        Sun, 04 Oct 2026 02:34:57 -0700 (PDT)
Received: from DESKTOP-NM9EKIA ([125.134.240.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0c980833sm2384121b3a.43.2026.10.04.02.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:34:57 -0700 (PDT)
From: Joonhoe Kim <26rote@gmail.com>
To: Yingying Tang <yingying.tang@oss.qualcomm.com>
Cc: Joonhoe Kim <26rote@gmail.com>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	yintang@qti.qualcomm.com,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>
Subject: Re: [PATCH ath-next] Revert "wifi: ath12k: add panic handler"
Date: Sun,  4 Oct 2026 18:34:56 +0900
Message-ID: <20261004093456.74263-1-26rote@gmail.com>
X-Mailer: git-send-email 2.55.0.windows.5
In-Reply-To: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
References: <20260612032332.2278338-1-yingying.tang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Jun 11, 2026 at 08:23:32PM -0700, Yingying Tang wrote:
> ath12k_core_panic_handler() is invoked via atomic_notifier_call_chain(),
> which runs inside an RCU read-side critical section.

I hit this on a WCN7860 (hw2.0, PCI) in a Lenovo Legion Tab Y700 Gen 5
(Kaanapali), v7.3-rc4 plus board patches. Here the panic never got past
the notifier:

  SMP: stopping secondary CPUs
  Voluntary context switch within RCU read-side critical section!
   schedule_timeout
   __mhi_device_get_sync
   ath12k_wifi7_pci_bus_wake_up
   ath12k_pci_read32
   ath12k_pci_sw_reset
   ath12k_pci_panic_handler
   atomic_notifier_call_chain
   vpanic

A hung_task panic stayed hung until a forced restart, and a sysrq crash
only ended in a reset after about 50 s.

With the handler removed, a sysrq crash reboots normally, and after the
reboot WCN7860 is enumerated again (PCIe Gen3 x2 link up) and Wi-Fi
works.

Tested-by: Joonhoe Kim <26rote@gmail.com>

On Baochen's question, the handler came in with 809055628bce, so:
Fixes: 809055628bce ("wifi: ath12k: add panic handler")
