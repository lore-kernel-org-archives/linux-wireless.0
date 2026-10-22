Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792672346;
	b=Oz64U6qTzhbC1FK+WrgTA9VAIxO0QrMKTicBOZyTDYBAt1ABZM2Ff9HNU7aXGUJ7Y9D4
	 wgyb9+fBeVEnQ/kxaWnlNjcGDOBF3ivd2ggH/J8cEkRv3QBOUD+HlChM4FgSMWsIj6rjU
	 dpbx3uO4gF+r30dIg6FdetS3GNepIXKgoGCN4MPHaJ28AdqlqSA2g9Kyb0eNtKa2tq0bP
	 3amZqLifn/JcQ5TpPj6CW3yuSUezHY0DiMi8vp1PoYOas6Dw7YgMNAkcJ9F4bAGkYDpOL
	 He2UI2/RyyWo3X7skWslsVb13XARJ8PYES1aLQ8W/lBzsUR44zfeRBcvuCBI8CcXp+Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792672346;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Message-ID:
	 In-Reply-To:References:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Importance:User-Agent:X-Mailer;
	bh=4gx2jPXdIrdFpHzAKE5D8atLl0fsl6cBZZ/jZdCstKI=;
	b=eWz/MEBnAFaPHg3tdalmCrnDRrdFDdThwP2f1JscRyPSRQOSX9u7eQ+yJCsLuDoXRJRY
	 87zPFNVy4K9ZoFtmJxZ4Nb1b3ShKilC3fqojzYAoABYLpHS65EulxWZO/QltLD8+pJxyj
	 6D1WG8VZ2dqwGh4t6l/wfS9hrZSYdYsE4i2KwlLJ3pGjvFthIBZF1dmx4mJfvv38xP5K/
	 7e7blnWHALc9xjkwOqpnKeRWBwOz3AHhktmkha2Y+rOVTsQ3Ae3xS51c4CaD/TUTtEBEi
	 RvGl/Xaec7K395sO6N9bisXLpvsGK5Df1ePBRTPLTU5itl3/qWhOc0WKag8fBdq08uQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=bob.beckett@collabora.com header.a=rsa-sha256 header.s=zohomail header.b=FHa7Yxra;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.182.11
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34F5606A31A
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 12:32:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F34F5606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=collabora.com header.i=bob.beckett@collabora.com header.a=rsa-sha256 header.s=zohomail header.b=FHa7Yxra
ARC-Seal: i=1; a=rsa-sha256; t=1792672319; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=X4UivBfCO5Dnl1PVXJ8GeLGLsCQMMg5jnLzdJZ7gwjw9ZPcB1/fsWJjGdPHMj3TBtvP2bpLrGE7TBy16Yg268xk+pncdxEWFkG10sA1ekssMefOtaYQyrrBYUB1GinoB0+6Si6UZzRMwV/uJnq+JiLyQ+WIpmt3GoDB7xYocy4g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792672319; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=4gx2jPXdIrdFpHzAKE5D8atLl0fsl6cBZZ/jZdCstKI=; 
	b=YmqG3Zqo9Zzs5rTmkHoYllRsx1CcZUOcg7/pUkzCkMsB0jpA3dtZ3Mse4SEAMN8Mi2pRIsOxciuyFTBkF3yYMPHqAgZgivpl/I6rBGmRRXerY07ujN0QP1Xm2zIteIhLRWoAIOt7XSzkF9LzXmUHSozUdF05CGSc1FMUjzwR9KA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=bob.beckett@collabora.com;
	dmarc=pass header.from=<bob.beckett@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792672319;
	s=zohomail; d=collabora.com; i=bob.beckett@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=4gx2jPXdIrdFpHzAKE5D8atLl0fsl6cBZZ/jZdCstKI=;
	b=FHa7YxrafIhd9mU/as8yRhozaoI4BTGxxkeWImOZm4PyLTShxuaZwtp/QePhoNEb
	gspS17r8cUz35eQqCqXfXNmwCIftc8nla5LbXllQH2bbVw1e2S8MduJV2X9uJg/aQqe
	0dXBGdl0cLXbmjOFWqb8k0qI/FLycmJX6z2oj76U=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1792672286378385.1993692716154; Thu, 22 Oct 2026 05:31:26 -0700 (PDT)
Date: Thu, 22 Oct 2026 13:31:26 +0100
From: Robert Beckett <bob.beckett@collabora.com>
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luka Gejak" <luka.gejak@linux.dev>,
	"Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
	"Timlee" <timlee@realtek.com>,
	"matthew.leach@collabora.com" <matthew.leach@collabora.com>,
	"kernel@collabora.com" <kernel@collabora.com>
Message-ID: <1a163984687.46e4c9841111898.2085291868591283475@collabora.com>
In-Reply-To: <90c40c3223c34562b2c171c52d987c2e@realtek.com>
References: <a615f09bb6f54128b792a13ebcbf8970@realtek.com> <20261021190529.3893821-1-bob.beckett@collabora.com> <90c40c3223c34562b2c171c52d987c2e@realtek.com>
Subject: RE: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted,
 poisoning CCMP replay counter
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail






From: Ping-Ke Shih <pkshih@realtek.com>
To: "Bob Beckett"<bob.beckett@collabora.com>
Cc: "linux-wireless@vger.kernel.org"<linux-wireless@vger.kernel.org>, "Luka Gejak"<luka.gejak@linux.dev>, "Bitterblue Smith"<rtl8821cerfe2@gmail.com>, "Timlee"<timlee@realtek.com>, "matthew.leach@collabora.com"<matthew.leach@collabora.com>, "kernel@collabora.com"<kernel@collabora.com>
Date: Thu, 22 Oct 2026 06:39:55 +0100
Subject: RE: rtw88: 8822CE passes corrupted A-MSDUs as hw-decrypted, poisoning CCMP replay counter

 > Bob Beckett <bob.beckett@collabora.com> wrote:
 > > On Wed, 21 Oct 2026 07:30:58 +0000, Ping-Ke Shih <pkshih@realtek.com> wrote:
 > > > Bob Beckett <bob.beckett@collabora.com> wrote:
 > > > >
 > > > > The AP's own PN sequence is consistent before and after the bad frame,
 > > > > so the corruption happens on the receive side.
 > > >
 > > > Maybe this is a hint to make a patch to defer (drop) reporting weird packet,
 > > > as Luka has fixed 3 of 4 problems.
 > 
 > I quickly checked the debug patches, which seem not detect if PN sequence is
 > correct after the bad frame, for example
 >   seq     PN
 >    1      101
 >    2      99999   // bad frame. should be 102.
 >    3      103     // not detect this
 > 
 > Or I missed something?

if pn jumps, rtw_rx_pn_guard returns early before latching pn, so the next corrected
pn would just be a regular increase and not get dropped.

 > 
 > > > > 4. For completeness: on these chips can RXBD_IDX or the
 > > > >    buffer-descriptor RX tag ever be updated before the packet data DMA
 > > > >    has completed, as described for WiFi 7 in rtw89 0bc7d1d4e63c?
 > > >
 > > > The RX tag in rtw88 located on memory allocated by dma_alloc_coherent(), and
 > > > the RX tag must be set after packet data MAC completed.
 > 
 > (fix typo:                          ... data DMA completed.)
 > 
 > > 
 > > Understood that this is the design intent. My question was whether the host can
 > > ever observe the tag before the data. dma_alloc_coherent() only makes the tag
 > > visible to the CPU without cache maintenance; the payload is in a separate
 > > streaming mapping (a SWIOTLB bounce buffer on this platform), so the order in
 > > which the host sees them depends on the order of the device's PCIe writes.
 > > Relaxed Ordering is enabled on the 8822CE here (DevCtl RlxdOrd+).
 > > Does the 8822CE set the RO attribute on RX DMA writes, in particular the
 > > buffer-descriptor/tag update? If it does, the tag write may pass the payload
 > > writes.
 > > 
 > > We are hoping to test this directly with the next round of tests. the rx_debug
 > > option re-syncs a suspect buffer 100 us later, so late payload writes might
 > > show up as changed bytes, and we can repeat the test with Relaxed Ordering
 > > disabled.
 > 
 > I'll check the behavior internally and get back to you. 
 > 
 > 
 > 


