Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793166118;
	b=g50PZ7YEFeJpGkE3hHTaKobPnz38PHR3WLSsRdxOXXBrfwhbBSsxpi++IcBjcsgUl7MM
	 eOhzMLbD2FLTGql8sbW0mmjBi7P7x2QyaLpyEpfWcwA2AomqKE6LfDMKrnSB4aF0ottiH
	 e1YvMIOqS/72+XKt25B60/8DozUrZz9X/3MspDx22kBiSXGd3m4ZtLeAETskV4NO+F49O
	 76wkcvYmCANJtzoSDRsoUs0urpRauQTEMLZq5DH77ybL3MhTPSBsojYthlJ4LrAZpLYnY
	 dfkepYcZahfCUoEi9deGfSdZGhC/FpZbp4wdea6uJwK3oCewoGzFFlJekx8aYDwk7eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793166118;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=4Tt7DPMN2jjHR/Knkht0X77hzqG0cdAPxU/YpNye/GM=;
	b=fyoBkbDj2vbBooN14Cog9k67nP7wen2vT5WZRT5nVCc/iKkj0WN7d83E1rCnJhFoXcqd
	 9T5wBhb8Rzxe9EkBtz9rIGwZ+v2Bc1ahnKOjdiw7hX25+MJC3mZvAUXtSX/HDtxu3Sjlp
	 EaMEN8mlTvBGSO/hsDtYw9bHggXL/BCRp5iZ9XTrvQDtPY3+MXqhHdBK/rqG4fgER+EOc
	 RJMNjIw9CiyiTgCIaktEwLzpeX4cHWDpVGXzD3Mg4xthM/8Av50qT0h/g+dHRhLCkBjX1
	 +6car0MStG1PHVtJmhVG3oUOFui8EbRDFlGJFD4l8vw4GDhab5a5FDJBHCOpKFh65vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="i/BA1tGv";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E2606A31F;
	Wed, 28 Oct 2026 05:41:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C60E2606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=i/BA1tGv
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69S5fqjJ71542548, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793166112; bh=4Tt7DPMN2jjHR/Knkht0X77hzqG0cdAPxU/YpNye/GM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=i/BA1tGvaj33zRY+KQpppqpq2J2W6FS0MvMIjdw3UFxBmaL43ukHM9DhVkJBL7x32
	 pBx2kIJlYBJ8TDsEqRsVWCSw14QKogyTV/ZkvdzmI29tyumhOnzC7pw2LzEqAGsX2r
	 UxF6yMlgi20DVKms314fjIPdTybDHwUv2RklGjxlFWfe4/rKE63vKbjLlAgWta4Wfk
	 QByWLo9U0mnCIgWABpQsCpMpuY7jSrpXs48B9U0NG8Xm8yZlCCaRONP7aOcZeTcxxY
	 x7N47YBb83qDkCqrxfo09b3YfpEeGhlGXzpMk8uWdduv6enw6BcUFv5CbYQkLgeBzT
	 s0uLTtFx5FCtg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69S5fqjJ71542548
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 28 Oct 2026 13:41:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 28 Oct 2026 13:41:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 28 Oct 2026 13:41:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next v5] wifi: rtw88: pci: wake the TX queues after
 restart_hw and interface up
Thread-Topic: [PATCH rtw-next v5] wifi: rtw88: pci: wake the TX queues after
 restart_hw and interface up
Thread-Index: AQHdYtso8j1Y8YSlsUur541W2jCI1bcSeEEQ
Date: Wed, 28 Oct 2026 05:41:52 +0000
Message-ID: <daa596fc5d0e4ab59c15b085d12f050b@realtek.com>
References: <20261023104154.2755289-1-abdurrahmankaradag19@gmail.com>
In-Reply-To: <20261023104154.2755289-1-abdurrahmankaradag19@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:
> When a TX ring fills, rtw_pci_tx_write() stops the mac80211 queue and
> records it in ring->queue_stopped. The completion loop in
> rtw_pci_tx_isr() is what clears them, and it needs a descriptor to
> complete. If the device goes down first, rtw_pci_dma_release() rewinds
> the indices and frees what was in flight, so nothing is left that
> could. ieee80211_reconfig() does not help either: it wakes only
> IEEE80211_QUEUE_STOP_REASON_SUSPEND, and an interface down/up does not
> reach it at all. TX then stays dead although the device came back.
>=20
> Reset that state where the device starts, which both
> ieee80211_restart_hw() and an interface down/up reach through
> rtw_core_start(). Gate the wake on ring->queue_stopped so that a
> start which stopped nothing leaves the queues alone. The wake cannot be
> narrowed to the queue the ring-full path stopped: the flag sits on the
> ring, and rtw_tx_queue_mapping() puts management frames and multicast on
> rings of their own whatever queue they came from, so a flag there does
> not name a queue. mac80211 also keeps a single non-refcounted DRIVER
> stop per queue, shared with the scan paths in fw.c, so
> ieee80211_wake_queues() releases whatever holds that slot.
>=20
> Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



