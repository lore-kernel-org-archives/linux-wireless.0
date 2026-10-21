Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571780;
	b=VvfM5MBtQ07X2XAiU0ZjXrRsijElLDM3GOoxLvaSiZbQWPMeCcDsQHowtHbv5LPWMsg0
	 pBcdmod4pEPFP5QiPtSE9dvH/CyD011ji9JPBl6e6YPjy5DquicffikreoN9cJGNVBfe6
	 e2DDtarCSAXNtV98l0w6xkUS08mrDOgR2m6Ynn4f/MGkVvV4X1WwRd77V5D8RevZ5EApa
	 LaTzRT86/JuDhUbVKhTKMRgViTCssm+u9KItHFun2CVyCRV37ssVTUMrbqUgRQDp1jH1N
	 rX6ujkZx6BowS+7CHYUaHJOCY0B13DdVhFEQTTna3MbARB6UgTFGvpwdNXKP6wnGy9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571780;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=vVtK8FpzlHGMqGZhWfo5vyAATdQeqWgl8pchEILsMaw=;
	b=ruK6gZ94Qn8STnD2hQdvMrMf2oRlx/cWNnAdExjXvs7i16DqhxPg1C4WXBWzni+NRgs4
	 8P/htT8lmyy2p7e6vJw5DyKhqAd9eOXDeDeBmdd2OFtAj2bIAyBeRRQXbQA/9BMqdnTLH
	 H/tTRVBWxe7kdBFViUoTDrJCg00Woo2EsErcdHhW7zCtpoA7lxV4YYh7FWqIsq/uygEMP
	 /EZGWSLkrTiZPXdzNQSM/7S6EabeUdV8/Cr8iLjJRXkSqi/Yb1SvgdhLjHVrFA3AhtVIv
	 BOhW7HaO43XVTWWZljGQk7+Tg+g4rnGY+mrEfMxaHBAluAzIxHnyK/NaLbtE2iGYvcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04930606A319;
	Wed, 21 Oct 2026 08:36:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 04930606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Deepanshu Kartikey
 <kartikey406@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+e91dc13b1b37759b3d9f@syzkaller.appspotmail.com
Subject: Re: [PATCH] wifi: ath9k: stop WMI event tasklet from rescheduling
 itself on probe failure
In-Reply-To: <1e1238a6-399d-4cb5-a5ab-756ccac64169@oss.qualcomm.com>
References: <20261003021147.7461-1-kartikey406@gmail.com>
 <1e1238a6-399d-4cb5-a5ab-756ccac64169@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 10:36:09 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a4o7tpqe.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

> Fix: mirror ath9k_wmi_event_drain's pattern in the tasklet early-exit:
> if (READ_ONCE(wmi->stopped)) {
>     spin_lock_irqsave(&wmi->wmi_lock, flags);
>     __skb_queue_purge(&wmi->wmi_event_queue);
>     spin_unlock_irqrestore(&wmi->wmi_lock, flags);
>     return;
> }

I think this fix is overly verbose; we don't actually need to drain the
queue twice; if we just bail out of ath9k_wmi_event_tasklet() when the
stopped flag is set, we can drain the queue from ath9k_stop_wmi().
There's already a helper (ath9k_wmi_event_drain()) that takes the right
lock, so we can use that.

I'll send an updated patch, please drop this one.

-Toke
