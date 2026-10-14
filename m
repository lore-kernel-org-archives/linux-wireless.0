Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5E2EB5B8;
	Wed, 14 Oct 2026 01:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791942754; cv=none; b=Dp0INZB3eEKbfatVrAE6aTNv9q1SpZEgWnIAnZ9qhllBbfCHuLPNVdpbXfzk0/arcvPsMYKDQskRkVUDppCu3PHseMOuGiENlGc3leQHrWioKTzc1YGKA7NvN9tNG5E9YFx0Ojq2nGEaeyc8q9IfntlYlA/m9ZA4jyxhDSSMrsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791942754; c=relaxed/simple;
	bh=5+MsJQXbAeKJj33FjbkZ9YHFqOeF9BJmJUF2H4kJ6eA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=K3Cf+C/jwZCViZFxschm8vrK4wm6++CmIM7wyxHWvwYF5qByVxoMiNsvyUgZpiufBgktEno/DXn3rIK6GgjmN4ovbhIGJaClSXtVM4wScqIbJG0jvtQr98pvF5kRo/raRv3iNRHPb9qx22PFNsY6JgzGshqdLm8RxcoFigNr7DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tfSw98zu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tfSw98zu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69E1qPEK11182857, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791942746; bh=LRwYYEuk3EfpjDIL8wyGO8ywDYnlmQSQbc7TDOHmZRo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tfSw98zutn/sM+WDQfiDfNbHsb9HEpBJYtlrSP3dZias0yIouqIYV6C6OfNmg6AKG
	 FxLb8PpbWFS79xbh8L2zWvzZYRW4NuxJymAUpeeLW/rwd9ruMegJJOy4lLFEhbUjVP
	 hqOxM/BTYhcMmvydJVL2No9yAguH0UWjDLbRLSDE9WR2ViM6LR1hvUuEHNk4c1/3D3
	 kALxceWbN1IKY9Vy1kXbBsuphs0ku/IWuPiwvqu7SF5r0AwWIOarIK941hA3oS3ItL
	 o06RHSS4giDmexxvFzbjnVm4c+TFgA6w0yFzysTYVDva59oXS2nMtpskoGqmLtEasV
	 BEN05STUjbv3w==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69E1qPEK11182857
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 14 Oct 2026 09:52:26 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 09:52:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 09:52:26 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 14 Oct 2026 09:52:26 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when the
 rings are reset
Thread-Topic: [PATCH rtw-next v2] wifi: rtw88: pci: wake the TX queues when
 the rings are reset
Thread-Index: AQHdWO4MPV0dG/pKrEyzZWvhd4YBNrb5eb7AgAINFoCAAMEoQA==
Date: Wed, 14 Oct 2026 01:52:25 +0000
Message-ID: <c15cbcb38aed477ab8d4c06ce30b174d@realtek.com>
References: <02b86ed0d0814f009cb5ca83bae343c7@realtek.com>
 <20261013220839.39149-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261013220839.39149-1-abdurrahmankaradag19@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> I also left ring->queue_stopped alone. It stays set until the first
> completion after the restart, which clears it, and rtw_pci_tx_write()
> does not read it before stopping a queue, so a stale value costs nothing.
> I can clear it in rtw_pci_reset_trx_ring() if you would rather the driver
> state did not claim a stop that is gone.

I re-think ring->queue_stopped and restart work. I feel the flow should be

1. fw/hw asked to restart -> rtw_fw_recovery_work() -> __fw_recovery_work()
2. __fw_recovery_work()
2.1. I think here should call ieee80211_stop_queues() to stop all TX queues
2.2. __fw_recovery_work() resets most driver states, but doesn't reset ring=
->queue_stopped.
     I think we can reset it (but not call ieee80211_wake_queues() if resta=
rting) by
     rtw_pci_stop() -> rtw_pci_dma_release()
3. rtw_reconfig_complete()
   call ieee80211_wake_queues() as you did in v3.

I'll discuss above flow internally, and give back to you.=20

Ping-Ke

