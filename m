Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793684268;
	b=YhygqRpaHpIn4NMN8g8mCc4SHlk21Y9AVRzTr4QpkaOeW/HPlhSmkRH1leWct8TVDeov
	 y9jClgWnTj58xFeUQvBYSXRetTyHl+NHTo7fF9jkYqUuSfL0SrCqM+5l3i1qrCzursM1k
	 HOeyCvyN9CMjdbKAR5a2GpiFmNU9BDFtq0VM4gxob97VlVF5i2OFfVG428FBXZpqAQXZs
	 wMFum69I2BhpCoDJ5WCQWD0E5GxIwf8a95H3IygcS4i1m6IHBXZlImUQNbk4sCW8s/qIi
	 ojjn4v8vme/SlfBq4ZasVFEIVC5rbulm41s1eBDQ4bvWN4vzmKY8UpZYcfL01DGGJGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793684268;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:In-Reply-To:References:
	 Message-ID:Date:MIME-Version:Content-Type;
	bh=3Zq62FP2I9javcPuWK6fvWWsBbmMoyoRRhg1nwK+GwY=;
	b=2Bjtwhj6emWKIgRfC5ZVFg2noiqk3UhuVLPpInJpxTtheMVy5hD/GILNgSyHFh9qdG2f
	 k+Bb49oBHavHVLSw7ydGwwDYH2pfiJP/WhxoPg+nbIn1dTKFeoZ3dvPLs3RCAxFWt36DE
	 DWll55VH4pc+cg3Ye9MLU3xHG2HwnCnDIVvIGlziQKoxVL6tbGlVtrtJLlPuy/60E6xIz
	 Kz6noGLnzaVYDUbvgbmbsDdhXV5LNMyV5i4BcJcNt5bHOIlTDd/By9wgA+8pnLqCGjNL3
	 P3Lyex517eLeQA2XTJ6IUZyOSZBxcrowPbpqi5t82IW+TVgEDostGsaPQJnXIn7Nu/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=j2sRd4P8;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD38606A324;
	Tue,  3 Nov 2026 05:37:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9FD38606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=j2sRd4P8
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A35bh9H32768846, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793684263; bh=3Zq62FP2I9javcPuWK6fvWWsBbmMoyoRRhg1nwK+GwY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=j2sRd4P8jlnHzP9lintiYs2nWBwQigZ0mFE0Swwi+sT3gmQ6bdt1KwR8lQHm09Qw3
	 u4lNm/oK3lzlco6WEltRKsHxsK9BLGn7YID/jSzQ6UsDL9YTbjKOTOwMAYHCnKH+iJ
	 Rzocof19ciU68ABzSIG+5FSHFdiUPDfnnJFgqUfVDG7YAoj3RcUqFFwSqbE2HQjBN5
	 yy8OaU6gEpbOYqVhlycdvjOv/V4i6bRclwxUDbdsQg/Om8sjoOPAuB+nngo1DzVYQU
	 HCkc1IEn2hbVuUzaaCiPXWq9KFteYV1+EpsY9ncHyF8RZPcJd/TAQkyVDFw8C/zIiY
	 kv1EP5JYlgTvA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A35bh9H32768846
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 13:37:43 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:37:43 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 13:37:43 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Tue, 3 Nov 2026 13:37:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	<linux-wireless@vger.kernel.org>
CC: <pkshih@realtek.com>, <linux-kernel@vger.kernel.org>,
	<rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v5] wifi: rtw88: pci: wake the TX queues after restart_hw and interface up
In-Reply-To: <20261023104154.2755289-1-abdurrahmankaradag19@gmail.com>
References: <20261023104154.2755289-1-abdurrahmankaradag19@gmail.com>
Message-ID: <f55c3d97-e714-4f65-b861-306cc0fa8f84@RTKEXHMBS03.realtek.com.tw>
Date: Tue, 3 Nov 2026 13:37:43 +0800
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

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:

> When a TX ring fills, rtw_pci_tx_write() stops the mac80211 queue and
> records it in ring->queue_stopped. The completion loop in
> rtw_pci_tx_isr() is what clears them, and it needs a descriptor to
> complete. If the device goes down first, rtw_pci_dma_release() rewinds
> the indices and frees what was in flight, so nothing is left that
> could. ieee80211_reconfig() does not help either: it wakes only
> IEEE80211_QUEUE_STOP_REASON_SUSPEND, and an interface down/up does not
> reach it at all. TX then stays dead although the device came back.
> 
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
> 
> Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

6ac7db1cea43 wifi: rtw88: pci: wake the TX queues after restart_hw and interface up

---
https://github.com/pkshih/rtw.git

