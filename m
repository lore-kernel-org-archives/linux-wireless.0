Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382E2489866
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786647029; cv=none; b=Fg/xg286AH8CR453Vln6jJzmkMBx2fojwPT3KxEWbP71Rgm3+rxGkllVTbFpl+HH2xHPGVI9ZFjuVg2Gl1L9xQDd/A+KEo0EaHro+9zdShZLvTJEstSRBkBhcH5NG2g+IUcYwv0k9HLTWHs3z/1GS99vvF2ewWBKZOsgo4EM6aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786647029; c=relaxed/simple;
	bh=AkBKR03uCxQT0b9C6hxQnaA2qPJn7M9baAsRN+oR/ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jr0x5uNDqXhKDgYnXFGtzGRsQ7wSPcagBXqhXAzb1g+gklSViAj8CVvXHd56JASQaR1KE3HQWAKhWvYDVW+xmj14Arh8X+M5bj2gy8SgKbZbgWoRCm4bhDqUhGPLmIVodO3MK1ZQVkvDvT/0NpGBMg/XIUTB8CEzlH2U7pmV82o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PgdTXFxR; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgdTXFxR"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47fe89fb333so81252f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2026 11:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786647023; x=1787251823; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4CmqxsU45YaJX65GG/NrnTX1eKbG2HH3nIDBeKynSsg=;
        b=PgdTXFxR7JpV8T0EZL3wHKu+TJn7GXYrtCxC8nONFDnKuKGRy7qnHTLzEVFTFNVKt/
         lb4soRV5zsHugWWppl1MUzGm+sN6gufvvHfdGwEuN8bmtoOPfK0brrjNAHxqaShwilGn
         84QtXSeTjWmK1aZnoHl6lNsKi+KqgqTsFVba+3DWos6I837EYFuv4vmk3JTwztdTyQ8E
         lkMJI06Jf6F6hQS1HL/dNZmhMfGe4WqwIPLNoWejrU2jUqqVtAMtZy7WrzPPgC2sU1+A
         y5/HQH/gwaOgcD1+bONDMSDRNcOmxFpefkGNi4EA5CUe/LL2xzQmiAFshm2UTy6cZ6dt
         /O4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786647023; x=1787251823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4CmqxsU45YaJX65GG/NrnTX1eKbG2HH3nIDBeKynSsg=;
        b=E6ABqKCfEMK77HJURWnnZaHi6nSaDPpjQyPbfUUjEAdcZDsjacuLLva20EDsawzGTj
         6qgta2ddOkphfZ6G7uPkQNGD3XJEGkVDrbmbj2qVU0mUJiso5lzFk7/rjIjqVI+T/qvv
         CqSimx0aixEjTAVf0cwViAjE3ZM7/bYRs83VdBxZ+XVFbQxkvj2W3ZnKgEcHj21vrPq6
         PrwtQSw1qMUNVLNK3GNflXntxkjls9IdwfagTyuAw9tVs28orhIyQbmqQiN1WsUUeRLY
         mbR85uwWk8+gXu3wE0HHmzYsNjNyKBQ88RXmjQeFl95vTCPhDwvMpldi4EG9r/FAGDlA
         bpEQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbnYyD8prx5+dLfLSQuCI0miPYrSjxzGEHsuH3HcElsyvGPJCAJ780cFRtgFoIxOztwqU7RDeKTkvVms4eTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7mKvhWi6ur9FYPo8bckf7cskqf3r1G3YPLDCk5STrxGSUj/z5
	5Rmu3zmdCi3h8UzW2fxNYJNfX5xCLl2+2fnKfjgzQLLvo3vlF7WncWnJ
X-Gm-Gg: AR+sD12+QJp3LNPAPjZagHlxDaiPEPcplZf5NcUXY6NKs5K4DdQE8Gx2YpOkyy0fNqu
	3GJgc4aO4D41uyHyc3+9ZUObcQsm7GmI/agukppfvQLM8mLtN4HKjCLflyaIf799YFVlJubSMwN
	D+wnd9S8IqHev+OGp1UapbSxrZsjhhA/E1LbWsKySDXfBYb1kzh/aeQvC4u7pRCx/4GpT2ut4G9
	DNg51/ntEY/Ii6GmNtF+LJNZAKcbHo01XBHTo5G5tOwAANP47R7BEgTqxiDta1rX3lG4O1hqYn9
	/XYAIwGBnk1VzouPi1fVz6wELsQ7+4Ee2yFUKBrkP2lzRoNQAdfmhpKdDYTmPvh+awH6SFarpLe
	+wTy4sGMsdkLymRvrWjo0Vqz+uQdEV6c5++nJGvLxfcJ5fLPxolPovlCTe1PDK7GOYBhfRih1BH
	vFe0dNTpxyfJOlP4UBb5T+WpgfXlzQ1mUgZtIYUGjawiPeN71hNirirmM0UKrDfy2AEg==
X-Received: by 2002:a05:600c:2055:b0:499:819e:db2c with SMTP id 5b1f17b1804b1-499879ace10mr4265345e9.16.1786647023237;
        Thu, 13 Aug 2026 11:50:23 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998216d082sm83608805e9.13.2026.08.13.11.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 11:50:22 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next] wifi: rtw88: usb: send broadcast/multicast via the AC queues
Date: Thu, 13 Aug 2026 20:50:21 +0200
Message-ID: <20260813185021.2290877-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <12eaffd0-9d0f-44bd-8163-d05b6a3df611@gmail.com>
References: <12eaffd0-9d0f-44bd-8163-d05b6a3df611@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

Hello Bitterblue,

> Could you check what the official driver is doing in the same situation?
>
> https://github.com/morrownr/88x2bu-20210702

Good timing, we had already done exactly that comparison before your
mail arrived. That driver was our working reference on the same bench
throughout the investigation (5/5 reconnect cycles where in-tree fails
0/5), and we went through its AP transmit path to understand why it is
immune. It handles this quite differently, in five ways:

1. bmc frames are buffered only while a station is actually dozing
   (sta_dz_bitmap check in core/rtw_xmit.c, rtw_xmit_ap_enqueue). With
   no sleeper present they leave immediately through the normal AC
   path, which is what my patch restores for rtw88.

2. The buffering happens in software (the bmc sta's sleep_q), not in
   the hardware high queue. The hardware HIQ receives at most one DTIM
   burst at a time (chk_bmc_sleepq_hdl), so it can never accumulate
   into the page pool the way rtw88's standing high queue does.

3. Even then, a filter decides what may ride the HIQ at all. The
   default (rtw_hiq_filter=1, "allow special") lets only ARP, EAPOL and
   DHCP through; mDNS/SSDP chatter never enters the high queue. The
   rest of the buffered frames go out through the normal queues when
   the burst is released.

4. The driver owns the TIM bit itself: it sets it when it starts
   buffering, pushes the updated beacon, and clears it only after both
   the software queue and the hardware HIQ are empty, polled through
   HW_VAR_CHK_HI_QUEUE_EMPTY. It does not depend on a beacon download
   whose pages come from the same pool the backlog is exhausting.

5. MORE_DATA is set on every burst frame except the last one, which
   carries 0 and terminates the burst. rtw88 sets it on every high
   queue frame including the last. That may be part of why I measured
   the burst fetch not happening here even with BIT_TCR_UPDATE_HGQMD
   set: the hardware never sees the end marker the vendor code
   provides.

So the field-proven driver never routes bulk multicast through the high
queue either, sleeper or not; the high queue is a small, filtered,
explicitly terminated DTIM burst buffer for it, not a transport path.

Given that, I still think routing bmc through the AC queues is the
right minimal fix for rtw88 USB. If you want to keep buffered delivery
for dozing stations I am happy to work on the fuller shape, meaning PS
tracking plus a software staging queue released at DTIM, but that is a
much bigger change and the current behavior is a hard AP breakage.

Thanks,
Mehmet
